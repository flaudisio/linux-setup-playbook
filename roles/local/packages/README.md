# Ansible Role: Packages

Ansible role that installs, removes and pins APT, Snap and pipx packages, then runs post-install
commands.

## Requirements

- `python3` with the `venv` module: the pipx CLI is installed into a dedicated virtual environment.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# APT

packages_apt_install: []
packages_apt_remove: []
packages_apt_purge: true
packages_apt_autoremove: false

# packages_apt_pin_versions:
#   - package: alloy
#     version: 1.16.1
#   - package: nginx
#     version: 1.24.0-*
packages_apt_pin_versions: []

# Snap

packages_snap_remove_snapd: false
packages_snap_install: []

# pipx

packages_pipx_cli_venv: /var/local/pipx
packages_pipx_cli_version: ">= 1.14.0"
packages_pipx_install: []

# Common

# packages_post_commands:
#   - mkdir /etc/example
#   - cmd: prek util init-template-dir ~/.git-template
#     creates: ~/.git-template
packages_post_commands: []
```

Each `packages_snap_install` item is a package name or a dict with `name`, `channel`, `classic`,
`dangerous`, `options` and `state`; each `packages_pipx_install` item is a package name or a dict
with `name`, `source`, `global` and `state`. Each `packages_post_commands` item is a command string
or a dict with `cmd`, `creates` and `become`.

`packages_snap_remove_snapd: true` purges snapd and pins the package to `-1`, so APT cannot pull it
back in. The pin file is removed again when snapd management is re-enabled. Version pinnings are
rendered to `/etc/apt/preferences.d/ansible-version-pinning`, or deleted when the list is empty.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: packages
      vars:
        packages_apt_install:
          - htop
          - tree
        packages_apt_pin_versions:
          - package: nginx
            version: 1.24.0-*
        packages_pipx_install:
          - name: prek
            state: upgrade
```

## License

MIT
