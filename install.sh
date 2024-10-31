#!/usr/bin/env bash

set -e
set -o pipefail

: "${REPO_URL:="https://github.com/flaudisio/linux-setup-playbook.git"}"
: "${BRANCH:="main"}"
: "${INSTALL_DIR:="${HOME}/.local/share/linux-setup-playbook"}"

function _run()
{
    echo "+ $*"
    "$@"
}

function main()
{
    echo "==> Installing requirements"

    _run sudo apt-get update -q
    _run sudo apt-get install -q -y git python3-venv

    if [[ ! -d "$INSTALL_DIR" ]] ; then
        echo "==> Cloning repository"

        _run git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
    else
        echo "==> Directory '$INSTALL_DIR' already exists, skipping 'git clone'"
    fi

    echo "==> Installing Ansible"

    _run make -C "$INSTALL_DIR" install

    echo

    cat << EOM
--------------------------------------------------
Ansible successfully installed!

Use the following commands to run the playbook:

cd $INSTALL_DIR

eval \$( make venv-activate )

ansible-playbook setup.yml --list-tasks
--------------------------------------------------
EOM
}

main "$@"
