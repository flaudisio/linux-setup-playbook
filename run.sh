#!/usr/bin/env bash

AnsibleOpts=()

[[ -z "$NO_SUDO" ]] && AnsibleOpts+=( --become --ask-become-pass )

set -e
set -o pipefail

if ! command -v ansible > /dev/null ; then
    eval "$( make venv-activate )"
fi

set -x

ansible-playbook "${AnsibleOpts[@]}" "$@"
