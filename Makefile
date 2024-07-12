#################################################
#                                               #
#     Makefile for Template Project             #
#                                               #
#################################################

PROJECT_NAME = template-project
PYTHON_INTERPRETER = python
WD=$(shell pwd)
PYTHONPATH=${WD}
SHELL := /bin/bash
PROFILE = default
PIP:=pip

## Create python interpreter environment.
create-environment:
	@echo ">>> About to create environment: $(PROJECT_NAME)..."
	@echo ">>> check python3 version"
	( \
		$(PYTHON_INTERPRETER) --version; \
	)
	@echo ">>> Setting up VirtualEnv."
	( \
		$(PIP) install -q virtualenv virtualenvwrapper; \
		virtualenv venv --python=$(PYTHON_INTERPRETER); \
	)

# Define utility variable to help calling Python from the virtual environment
ACTIVATE_ENV := source venv/bin/activate

# Execute python related functionalities from within the project's environment
define execute_in_env
	$(ACTIVATE_ENV) && $1
endef

## Build the environment requirements
requirements: create-environment
	$(call execute_in_env, $(PIP) install pip-tools)
	$(call execute_in_env, pip-compile requirements.in)
	$(call execute_in_env, $(PIP) install -r ./requirements.txt)

#################################################
## Set up dev requirements (pytest, coverage, bandit, safety, black, flake8)
dev-setup:
	$(call execute_in_env, pip-compile requirements-dev.in)
	$(call execute_in_env, $(PIP) install -r ./requirements-dev.txt)

#################################################
# Tests & Checks

## Run the security test (bandit + safety)
security-test:
	$(call execute_in_env, safety check -r ./requirements.txt)
	$(call execute_in_env, bandit -r . -f custom -c bandit.yaml)

## Run the black code formatter
run-black:
	$(call execute_in_env, black ./ --line-length 100)

## Run the flake8 code check
run-flake8:
	$(call execute_in_env, flake8 --config .flake8)

## Run the unit tests
unit-test:
	$(call execute_in_env, PYTHONPATH=${PYTHONPATH} pytest)

## Run the coverage check
check-coverage:
	$(call execute_in_env, PYTHONPATH=${PYTHONPATH} pytest --cov=src tests --cov-report term-missing)

## Run all checks
run-checks: security-test run-black run-flake8 check-coverage ## Unit test is run by coverage
