//go:build !CI
// +build !CI

package test_cloud

import (
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"golang.org/x/exp/maps"
)

func TestOVHObjectStorage(t *testing.T) {
	t.Parallel()

	workingDir := test_structure.CopyTerraformFolderToTemp(t, "../../modules/ovh", "ovh-object-storage")

	defer test_structure.RunTestStage(t, "cleanup", func() {
		cleanup_ovh_object_storage(t, workingDir)
	})

	test_structure.RunTestStage(t, "deploy", func() {
		deploy_ovh_object_storage(t, workingDir, map[string]interface{}{})
	})

	test_structure.RunTestStage(t, "validate", func() {
		validate_ovh_object_storage(t, workingDir)
	})
}

func deploy_ovh_object_storage(t *testing.T, workingDir string, vars map[string]interface{}) {
	container_name := strings.ToLower(fmt.Sprintf("test%s", random.UniqueId()))

	tfVars := map[string]interface{}{
		"container_name": container_name,
		"user_id":        os.Getenv("OS_USERID"),
		"service_name":   os.Getenv("OS_TENANT_ID"),
	}

	maps.Copy(tfVars, vars)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: workingDir,
		Vars:         tfVars,
	})

	test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}

func cleanup_ovh_object_storage(t *testing.T, workingDir string) {
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
	terraform.Destroy(t, terraformOptions)
}

func validate_ovh_object_storage(t *testing.T, workingDir string) {
	// terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)

	// assert := assert.New(t)

}
