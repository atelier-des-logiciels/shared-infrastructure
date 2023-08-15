//go:build !CI
// +build !CI

package test_cloud

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"golang.org/x/exp/maps"
)

func TestOVHCloudProject(t *testing.T) {
	t.Parallel()

	workingDir := test_structure.CopyTerraformFolderToTemp(t, "../../modules/ovh", "ovh-cloud-project")

	defer test_structure.RunTestStage(t, "cleanup", func() {
		cleanup_ovh_cloud_project(t, workingDir)
	})

	test_structure.RunTestStage(t, "deploy", func() {
		deploy_ovh_cloud_project(t, workingDir, map[string]interface{}{})
	})

	test_structure.RunTestStage(t, "validate", func() {
		validate_ovh_cloud_project(t, workingDir)
	})
}

func deploy_ovh_cloud_project(t *testing.T, workingDir string, vars map[string]interface{}) {
	tfVars := map[string]interface{}{
		"plan_code":                 "project.2018",
		"cloud_project_description": "test",
	}

	maps.Copy(tfVars, vars)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: workingDir,
		Vars:         tfVars,
	})

	test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}

func cleanup_ovh_cloud_project(t *testing.T, workingDir string) {
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
	terraform.Destroy(t, terraformOptions)
}

func validate_ovh_cloud_project(t *testing.T, workingDir string) {
	// terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

	// assert := assert.New(t)

}
