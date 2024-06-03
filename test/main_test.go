package test

import (
	"context"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/stretchr/testify/assert"
	"io/fs"
	"log"
	"os"
	"regexp"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/mq"
	test_structure "github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

const localBackend = `
terraform {
	backend "local" {}
}
`

func setupTest() (string, error) {
	terraformTempDir, errCopying := test_structure.CopyTerragruntFolderToTemp("../", "terratest-")
	if errCopying != nil {
		return "", errCopying
	}

	backendFilePath := fmt.Sprintf("%s/%s", terraformTempDir, "backend.tf")
	//errRemoving := os.Remove(backendFilePath)
	//if errRemoving != nil {
	//	return "", errRemoving
	//}

	errWritingFile := os.WriteFile(backendFilePath, []byte(localBackend), os.ModeAppend)
	if errWritingFile != nil {
		return "", errWritingFile
	}
	os.Chmod(backendFilePath, fs.FileMode(0777))
	return terraformTempDir, nil
}

func ApplyVPC(t *testing.T) (string, []string, string, string, string) {
	terraformTempDir, err := setupVPC()
	if err != nil {
		t.Fatalf("Error setting up test :%v", err)
	}
	// defer os.RemoveAll(terraformTempDir)
	log.Printf("Temp folder: %s", terraformTempDir)
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	fmt.Println(path) // for example /home/user
	terraformInitOptions := &terraform.Options{
		TerraformDir: terraformTempDir,
		//VarFiles:     []string{"test/terratest.tfvars"},
		VarFiles: []string{path + "/terratest.tfvars"},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-1",
			//"TF_LOG":             "TRACE",
		},
		Reconfigure: true,
	}
	terraform.Init(t, terraformInitOptions)
	_, _ = terraform.ApplyAndIdempotentE(t, terraformInitOptions)
	private_subnets := terraform.Output(t, terraformInitOptions, "private_subnet_ids")
	public_subnet := terraform.Output(t, terraformInitOptions, "public_subnet_id")
	private_subnet_cidrs := terraform.Output(t, terraformInitOptions, "private_subnet_cidrs")
	vpc_id := terraform.Output(t, terraformInitOptions, "vpc_id")
	fmt.Println(private_subnets)
	var re = regexp.MustCompile(`(?m)^\[(?P<inside_brackets>.+)\]$`)
	var substitution = "${inside_brackets}"
	s := re.ReplaceAllString(private_subnets, substitution)
	subnets_array := strings.Fields(s)
	fmt.Println("[" + strings.Join(subnets_array, ",") + "]")
	return terraformTempDir, subnets_array, public_subnet, vpc_id, private_subnet_cidrs
}

func setupVPC() (string, error) {
	initterraformTempDir, errCopying := test_structure.CopyTerragruntFolderToTemp("../", "terratestVPC-")
	if errCopying != nil {
		return "", errCopying
	}
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	fmt.Println(path) // for example /home/user
	terraformTempDir := initterraformTempDir + "/vpc-subnet-test-prerequisites"
	backendFilePath := fmt.Sprintf("%s/%s", terraformTempDir, "backend.tf")

	errWritingFile := os.WriteFile(backendFilePath, []byte(localBackend), os.ModeAppend)
	if errWritingFile != nil {
		return "", errWritingFile
	}
	os.Chmod(backendFilePath, fs.FileMode(0777))
	return terraformTempDir, nil
}

func TestTerraformCodeInfrastructureInitialCredentials(t *testing.T) {
	VPCTempDir, private_subnets, public_subnet, vpc_id, private_subnet_cidrs := ApplyVPC(t)
	//Region := "ap-southeast-1"
	terraformTempDir, errSettingUpTest := setupTest()
	if errSettingUpTest != nil {
		t.Fatalf("Error setting up test :%v", errSettingUpTest)
	}
	defer os.RemoveAll(terraformTempDir)
	log.Printf("Temp folder: %s", terraformTempDir)
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}

	tfvars := map[string]interface{}{
		"private_subnet_ids":   private_subnets,
		"public_subnet_id":     public_subnet,
		"private_subnet_cidrs": private_subnet_cidrs,
		"vpc_id":               vpc_id,
	}
	terraformInitOptions := &terraform.Options{
		TerraformDir: terraformTempDir,
		Vars:         tfvars,
		VarFiles:     []string{path + "/terratest.tfvars"},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-1",
			//"TF_LOG":             "TRACE",
		},
		Reconfigure: true,
	}

	defer destroy(t, VPCTempDir, nil)
	defer destroy(t, terraformTempDir, &tfvars)
	terraform.Init(t, terraformInitOptions)
	terraformValidateOptions := &terraform.Options{
		TerraformDir: terraformTempDir,
	}
	terraform.Validate(t, terraformValidateOptions)
	plan, errApplyingIdempotent := terraform.ApplyAndIdempotentE(t, terraformInitOptions)
	if errApplyingIdempotent != nil {
		t.Logf("Error applying plan: %v", errApplyingIdempotent)
		t.Fail()
	} else {
		t.Log(fmt.Sprintf("Plan worked: %s", plan))
	}

	rabbitmqId := terraform.Output(t, terraformInitOptions, "rabbitmq_id")
	rabbitmqEndpoint := terraform.Output(t, terraformInitOptions, "rabbitmq_endpoint")
	rabbitmqARN := terraform.Output(t, terraformInitOptions, "rabbitmq_arn")

	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion("us-east-1"))
	if err != nil {
		log.Fatal(err)
	}
	client := mq.NewFromConfig(cfg)
	// client := ec2.NewFromConfig(cfg)
	t.Run("Has Infra", func(t *testing.T) {
		a := assert.New(t)
		// check that rabbitmq exists as a resource
		t.Log("Checking that rabbitmq exists as a resource")
		t.Log(rabbitmqId)

		rabbitmq, err := client.DescribeBroker(context.TODO(), &mq.DescribeBrokerInput{
			BrokerId: aws.String(rabbitmqId),
		})
		t.Log(err)
		a.NoError(err)
		a.NotEmpty(rabbitmq)
		if rabbitmq == nil {
			t.Fail()
			return
		}
		t.Log(rabbitmq.BrokerInstances[0].Endpoints)
		a.Equal(rabbitmqARN, *rabbitmq.BrokerArn)
		a.Equal(rabbitmqEndpoint, rabbitmq.BrokerInstances[0].Endpoints[0])
	})

}
