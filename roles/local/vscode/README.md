# Ansible Role: Visual Studio Code

Ansible role that installs Visual Studio Code from the Microsoft APT repository.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Ref: https://code.visualstudio.com/docs/setup/linux#_install-vs-code-on-linux

vscode_apt_repo_name: vscode

vscode_apt_repo_key_url: https://packages.microsoft.com/keys/microsoft.asc
vscode_apt_repo_key_file: /usr/share/keyrings/microsoft.asc

vscode_apt_repo_uri: https://packages.microsoft.com/repos/code
vscode_apt_repo_suite: stable
vscode_apt_repo_component: main
vscode_apt_repo_architectures:
  - amd64
  - arm64
  - armhf
```

The role answers the package's `code/add-microsoft-repo` debconf question with `false`, so the
post-install script leaves the repository the role configured untouched, and removes the legacy
`vscode.list` source and `/etc/apt/keyrings/microsoft.asc` key first.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: vscode
```

## License

MIT
