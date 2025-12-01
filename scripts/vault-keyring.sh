#!/usr/bin/env bash
#
# vault-keyring.sh
#
# A simple wrapper for the 'keyring' Python CLI to store, get or delete the Ansible Vault
# password from the operating system's keyring.
#
# Dependencies:
#   - 'keyring' Python package
#
# Usage:
#   echo 'password' | vault-keyring.sh
#   vault-keyring.sh
#   vault-keyring.sh del
#
##

set -e
set -o pipefail

: "${DEBUG:=""}"

: "${VAULT_DUMMY:=""}"
: "${VAULT_PASSWORD:=""}"

: "${KEYRING_SERVICE:="linux-setup-playbook"}"
: "${KEYRING_USERNAME:="ansible-vault-password"}"

function _msg()
{
    echo "$*" >&2
}

function _run()
{
    [[ -z "$DEBUG" ]] || _msg "+ $*"
    "$@"
}

function use_keyring()
{
    local password

    if [[ ! -t 0 ]] ; then
        _msg "Saving password provided via stdin"
        password="$( < /dev/stdin )"
        echo "$password" | _run keyring set "$KEYRING_SERVICE" "$KEYRING_USERNAME"
        exit $?
    fi

    case "$1" in
        ""|get)
            if ! _run keyring get "$KEYRING_SERVICE" "$KEYRING_USERNAME" ; then
                _msg "Error: Vault password was not found on keyring or could not be fetched from it"
                exit 1
            fi
        ;;
        set)
            password="$2"
            [[ -n "$password" ]] || password="$VAULT_PASSWORD"

            if [[ -z "$password" ]] ; then
                _msg "Error: no password defined"
                exit 2
            fi

            echo "$password" | _run keyring set "$KEYRING_SERVICE" "$KEYRING_USERNAME"
        ;;
        del|delete)
            _run keyring del "$KEYRING_SERVICE" "$KEYRING_USERNAME"
        ;;
        *)
            echo "Error: unknown option: $1" >&2
            exit 2
        ;;
    esac
}

function main()
{
    if [[ -n "$VAULT_DUMMY" ]] ; then
        _msg "[vault-keyring] VAULT_DUMMY variable is defined, printing dummy string to stdout"
        echo "dummy"
        exit 0
    fi

    case "$1" in
        -D|--debug)
            DEBUG=1
            shift
        ;;
    esac

    use_keyring "$@"
}

main "$@"
