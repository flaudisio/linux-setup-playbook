#!/usr/bin/env bash

set -e
set -o pipefail

: "${REPO_URL:="https://github.com/flaudisio/linux-setup-playbook.git"}"
: "${BRANCH:="main"}"
: "${INSTALL_DIR:="${HOME}/.local/share/linux-setup-playbook"}"

function _msg()
{
    echo "$*" >&2
}

function _run()
{
    _msg "+ $*"
    "$@"
}

function main()
{
    _msg "==> Installing dependencies"

    _run sudo apt-get update -q
    # python3-debian is required by ansible's deb822_repository module.
    _run sudo apt-get install -q -y curl git python3-debian

    if [[ ! -d "$INSTALL_DIR" ]] ; then
        _msg "==> Cloning repository"

        _run git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
    else
        _msg "==> Directory '$INSTALL_DIR' already exists, updating repository"

        _run git -C "$INSTALL_DIR" switch "$BRANCH"
        _run git -C "$INSTALL_DIR" pull --ff-only origin "$BRANCH"
    fi

    if ! command -v mise > /dev/null ; then
        _msg "==> Installing mise-en-place"

        _run curl -f -sSL https://mise.run | bash
    fi

    _msg "==> Installing Ansible and project dependencies"

    _run export PATH="${HOME}/.local/bin:${PATH}"

    _run mise -C "$INSTALL_DIR" trust --yes
    _run mise -C "$INSTALL_DIR" install
    _run mise -C "$INSTALL_DIR" run install
    _msg

    cat << EOM
--------------------------------------------------
Ansible successfully installed!

Install the SOPS age key before running any playbook:

cd $INSTALL_DIR
mise exec -- doppler login
mise run sops:key

Use the following commands to run the playbook:

./run playbooks/flaudisio.personal.yml --list-tasks
--------------------------------------------------
EOM
}

main "$@"
