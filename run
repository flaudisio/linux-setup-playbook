#!/usr/bin/env bash

set -o pipefail

function _run()
{
    echo "+ $*" >&2
    exec "$@"
}

function main()
{
    if [[ -z "$1" || "$1" =~ ^sh(ell)?$ ]] ; then
        grep -q '/mise/installs/' <<< "$PATH" && exit 0

        _run mise exec -- "$SHELL"
    fi

    local cmd=( "$@" )

    if [[ "$1" != ansible* ]] ; then
        cmd=( ansible-playbook "$@" )

        if [[ -z "$NO_SUDO" ]] ; then
            cmd+=( --become --ask-become-pass )
        fi
    fi

    command -v ansible &> /dev/null || cmd=( mise exec -- "${cmd[@]}" )

    _run "${cmd[@]}"
}

main "$@"
