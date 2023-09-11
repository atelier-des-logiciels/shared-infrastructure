TIMEOUT = 30m
SHELL := /bin/bash

cmd=plan
t=any

include environments.mk

define check-env
	@if [ -z "$($(env))" ]; then \
		echo "Environment is not defined"; \
		exit 1; \
	fi
endef

path = $(if $(value $(env)),$(value $(env)),)/${module}

TEST_PARAMS := -count=1 -timeout $(TIMEOUT) -p 1
TEST_LOGS := tests.log
TEST_SUMMARY_AND_LOGS := | tee $(TEST_LOGS)
TEST_REPORT_DIR := report
TEST_REPORT_CMD :=  if [ -z "$(NO_TEST_REPORT)" ]; then \
											rm -rf $(TEST_REPORT_DIR); \
											terratest_log_parser -testlog $(TEST_LOGS) -outputdir $(TEST_REPORT_DIR); \
											cat $(TEST_REPORT_DIR)/summary.log; \
										fi

.PHONY: all devenv test test-ci test-one test-install test-format test-lint tf-lint tf-plan tf-plan-all tf-apply tf-apply-all tf-apply-all-auto-approve tf-destroy tf-destroy-all tf-output tf-force-unlock

all:

devenv:
	devenv shell

test-ovh:
	set -o pipefail; cd test && go test $(TEST_PARAMS) -v -tags CI ./ovh $(TEST_SUMMARY_AND_LOGS); \
	go_test_exit_code=$$?; \
	$(TEST_REPORT_CMD); \
	exit $$go_test_exit_code 

test-k8s:
	set -o pipefail; cd test && go test $(TEST_PARAMS) -v -tags CI ./k8s $(TEST_SUMMARY_AND_LOGS); \
	go_test_exit_code=$$?; \
	$(TEST_REPORT_CMD); \
	exit $$go_test_exit_code 

test-one:
	cd test && go test $(TEST_PARAMS) -v ./... -run ${t}

test-install:
	cd test && go mod download

test-lint:
	cd test && go vet ./...

test-format:
	cd test && go fmt ./...

tf-lint:
	tflint --recursive

tf-plan tf-apply tf-destroy tf-show tf-init:
	$(call check-env)
	cd ${path} && terragrunt $(subst tf-,,$@)

tf-import:
	cd ${path} && terragrunt import ${r} ${id}

tf-init-migrate-state:
	cd ${path} && terragrunt init -migrate-state	

tf-plan-all tf-apply-all tf-destroy-all:
	$(call check-env)
	$(eval CMD := $(subst tf-,,$@))
	$(eval ARG := $(subst -all,,$(CMD)))
	cd ${path} && terragrunt run-all $(ARG)

tf-apply-all-auto-approve:
	$(call check-env)
	cd ${path} && terragrunt run-all apply --terragrunt-non-interactive

tf-destroy-all-auto-approve:
	$(call check-env)
	cd ${path} && terragrunt run-all destroy --terragrunt-non-interactive

tf-pull:
	$(call check-env)
	@cd ${path} && terragrunt state pull 

tf-state-list:
	$(call check-env)
	cd ${path} && terragrunt state list

tf-state-rm:
	$(call check-env)
	cd ${path} && terragrunt state rm ${t}

tf-push:
	$(call check-env)
	cd ${path} && terragrunt state push ${s}

tf-graph:
	$(call check-env)
	cd ${path} && terragrunt graph | dot -Tsvg > graph.svg

tf-output:
	$(call check-env)
	@cd ${path} && terragrunt output ${o} | sed -e 's/"//g'

tf-force-unlock:
	cd ${path} && terragrunt force-unlock ${l}
