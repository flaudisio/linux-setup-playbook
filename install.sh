#!/usr/bin/env bash

set -e
set -o pipefail

: "${REPO_URL:="https://github.com/flaudisio/linux-setup-playbook.git"}"
: "${BRANCH:="main"}"
: "${INSTALL_DIR:="${HOME}/.local/share/linux-setup-playbook"}"
: "${MISE_INSTALL_PATH:="/tmp/mise"}"

function _run()
{
    echo "+ $*"
    "$@"
}

function main()
{
    echo "==> Installing dependencies"

    _run sudo apt-get update -q
    _run sudo apt-get install -q -y curl git python3-pip python3-venv

    echo "==> Installing mise-en-place"

    curl -f -sSL https://mise.run | MISE_INSTALL_PATH="$MISE_INSTALL_PATH" sh

    if [[ ! -d "$INSTALL_DIR" ]] ; then
        echo "==> Cloning repository"

        _run git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
    else
        echo "==> Directory '$INSTALL_DIR' already exists, skipping 'git clone'"
    fi

    echo "==> Installing Ansible"

    _run "$MISE_INSTALL_PATH" -C "$INSTALL_DIR" run install

    echo

    cat << EOM
--------------------------------------------------
Ansible successfully installed!

Use the following commands to run the playbook:

cd $INSTALL_DIR

./run.sh main.yml --list-tasks
--------------------------------------------------
EOM
}

main "$@"
