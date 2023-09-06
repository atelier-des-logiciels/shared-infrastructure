# Infrastructure of Atelier des logiciels

## Folder structure

- `live`: All environments defined with terraform + terragrunt
  - `_envcommon`: Common configuration for all environments
    - `ovh`: OVH common configuration
  - `prod`: Production environments
    - `ovh`: OVH cloud infrastructure provider
      - `mussoconsulting`:
        - `ovh-eu`:
          - `region.hcl`: Region dependent configuration (container registry host, restart cron schedule, ...)
          - `atelierdeslogiciels`:
            - `env.hcl`: Terragrunt configuration file for environment (subnet CIDRs, regions, compute resource settings, ...)
            - `cloud`: Terragrunt files to instantiate cloud infrastructure (vpc, k8s cluster, global K8s resources)
    
- `modules`: Terraform modules (like components) used in live folders
- `test` Unit and integration tests for modules

## Common tasks

### Unit tests

[Unit test prerequisites](#terraform-and-unit-tests-prerequisites)

```sh
# Run environment unit tests
make test-cloud

# Run client unit tests
make test-k8s
```

### Run a single test

[Unit test prerequisites](#terraform-and-unit-tests-prerequisites)

```sh
# Run a single test, it will execute deploy, validate and cleanup steps
# TEST_NAME is the name of the test or the first part ot the test name
make test-one t=<TEST_NAME>

# Skip clean up step
SKIP_cleanup=1 make test-one t=<TEST_NAME>

# Skip deploy step
SKIP_deploy=1 make test-one t=<TEST_NAME>

# Skip valiate step
SKIP_validate=1 make test-one t=<TEST_NAME>
```

### Plan, deploy and destroy existing environment 

[Terraform prerequisites](#terraform-and-unit-tests-prerequisites)

For each environment, 6 commands are availables ([terraform commands](https://developer.hashicorp.com/terraform/cli/run))
- [plan](https://developer.hashicorp.com/terraform/cli/commands/plan): Create execution plan
- [plan-all](https://terragrunt.gruntwork.io/docs/reference/cli-options/#run-all): Create execution plan for all sub modules
- [apply](https://developer.hashicorp.com/terraform/cli/commands/apply): Deploy infrastructure
- [apply-all](https://terragrunt.gruntwork.io/docs/reference/cli-options/#run-all): Deploy infrastructure for all sub modules
- [destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy): Destroy infrastruture
- [destroy-all](https://terragrunt.gruntwork.io/docs/reference/cli-options/#run-all): Destroy infrastruture for all sub modules

Command examples:
```sh
export ENVIRONMENT=<environment>

# Create execution plan for integration environment
make tf-plan-all env=$ENVIRONMENT module=cloud

# Apply execution plan for integration environment
make tf-apply-all env=$ENVIRONMENT module=cloud

# Destroy resources for integration environment
make tf-destroy-all env=$ENVIRONMENT module=cloud
```

### Linting test code

Prerequisites:
- [Install tflint](https://github.com/terraform-linters/tflint#installation) to lint terraform code

```sh
make tf-lint
```

## Terraform and unit tests prerequisites

- [Install terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Go](https://go.dev/doc/install)
- Install go dependencies: `cd test && go mod tidy` 
- [Install terratest_log_parser](https://terratest.gruntwork.io/docs/testing-best-practices/debugging-interleaved-test-output/#installing-the-utility-binaries)


```sh
# Install go dependencies
make test-install
pushd test
go mod tidy
popd
```

## Procedure to install a environment

Steps to execute manually:
- Create a public cloud project
- Create a s3 bucket
- Create a vrack