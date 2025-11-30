#!/usr/bin/env bash

set -eo pipefail

CMD=( "$@" )

if [[ "$1" != ansible* ]] ; then
    CMD=( ansible-playbook "$@" )

    if [[ -z "$NO_SUDO" ]] ; then
        CMD+=( --become --ask-become-pass )
    fi
fi

if ! command -v ansible > /dev/null ; then
    eval "$( make venv-activate )"
fi

echo "+ ${CMD[*]}" >&2

exec "${CMD[@]}"
