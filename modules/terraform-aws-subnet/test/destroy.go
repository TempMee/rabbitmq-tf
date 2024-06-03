package test

import (
	"log"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func destroy(t *testing.T, terraformTempDir string) {
	var terraformDestroyOptions = &terraform.Options{
		TerraformDir: terraformTempDir,
		VarFiles:     []string{"test/terratest.tfvars"},
		Vars:         map[string]interface{}{},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "ap-southeast-1",
			//"TF_LOG":             "TRACE",
		},
		Reconfigure: true,
	}
	log.Println("Destroying resources...")
	terraform.Destroy(t, terraformDestroyOptions)
}
