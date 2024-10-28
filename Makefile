COLLECTIONS_PATH := collections
ROLES_PATH := roles/public

VENV_DIR ?= $(HOME)/.virtualenvs/linux-setup-playbook

export PATH := $(VENV_DIR)/bin:$(PATH)

.PHONY: help
help:  ## Show available commands
	@echo "Available commands:"
	@echo
	@sed -n -E -e 's|^([A-Za-z0-9/_-]+):.+## (.+)|\1@\2|p' $(MAKEFILE_LIST) | column -s '@' -t

.PHONY: pre-commit
pre-commit:  ## Run pre-commit (optional: HOOK=example)
	pre-commit run --all-files --verbose --show-diff-on-failure --color always $(HOOK)

.PHONY: install
install: install/ansible install/galaxy  ## Run all installation tasks

.PHONY: install/ansible
install/ansible:  ## Install Ansible and dependencies in a virtualenv
	@if [ ! -d '$(VENV_DIR)' ] ; then \
		( \
			set -x ; \
			python3 -m venv --clear --upgrade-deps '$(VENV_DIR)' ; \
		) \
	fi
	@[ -d '$(VENV_DIR)' ] && echo "\nVirtualenv is ready on '$(VENV_DIR)' directory!\n" || true
	pip install --upgrade pip -r requirements.txt
	@echo
	@echo 'Done! Run "make install/galaxy" to install Galaxy dependencies.'
	@echo

.PHONY: install/galaxy
install/galaxy:  ## Install Galaxy dependencies from requirements files
	ansible-galaxy collection install --upgrade --requirements-file requirements.yml --collections-path '$(COLLECTIONS_PATH)'
	@echo
	ansible-galaxy role install --role-file requirements.yml --roles-path '$(ROLES_PATH)'
	@echo
	@echo 'Done! Run "eval $$( make venv-activate )" to use Ansible in the current shell.'
	@echo

.PHONY: venv-activate
venv-activate:  ## Print the virtualenv activation command. Usage: eval $( make venv-activate )
	@echo source $(VENV_DIR)/bin/activate

.PHONY: show-env
show-env:  ## Print information about the environment
	ansible --version
	ansible-galaxy collection list
	ansible-galaxy role list

.PHONY: clean
clean:  ## Remove Ansible installation artifacts (virtualenv, external collections, external roles, etc)
	rm -rf -- '$(VENV_DIR)'
	git clean -fdx -- '$(COLLECTIONS_PATH)' '$(ROLES_PATH)'
