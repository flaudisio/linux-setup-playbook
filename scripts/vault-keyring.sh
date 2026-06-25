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

: "${VAULT_DISABLE_KEYRING:=""}"
: "${VAULT_KEYRING_SERVICE:="linux-setup-playbook"}"
: "${VAULT_KEYRING_USERNAME:="ansible-vault-password"}"

: "${VAULT_PASSWORD:=""}"

function _msg()
{
    echo "[vault-keyring] $*" >&2
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
        echo "$password" | _run keyring set "$VAULT_KEYRING_SERVICE" "$VAULT_KEYRING_USERNAME"
        exit $?
    fi

    case "$1" in
        ""|get)
            if ! _run keyring get "$VAULT_KEYRING_SERVICE" "$VAULT_KEYRING_USERNAME" ; then
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

            echo "$password" | _run keyring set "$VAULT_KEYRING_SERVICE" "$VAULT_KEYRING_USERNAME"
        ;;
        del|delete)
            _run keyring del "$VAULT_KEYRING_SERVICE" "$VAULT_KEYRING_USERNAME"
        ;;
        *)
            echo "Error: unknown option: $1" >&2
            exit 2
        ;;
    esac
}

function main()
{
    case "$1" in
        -D|--debug)
            DEBUG=1
            shift
        ;;
    esac

    if [[ -n "$VAULT_DISABLE_KEYRING" ]] ; then
        if [[ -n "$VAULT_PASSWORD" ]] ; then
            _msg "VAULT_DISABLE_KEYRING variable is defined, printing VAULT_PASSWORD to stdout"
            echo "$VAULT_PASSWORD"
        else
            _msg "Warning: VAULT_DISABLE_KEYRING is defined but VAULT_PASSWORD is empty, printing dummy value"
            echo "dummy-value"
        fi

        exit 0
    fi

    use_keyring "$@"
}

main "$@"
