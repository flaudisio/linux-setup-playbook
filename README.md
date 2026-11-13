# Linux Setup Playbook

Ansible playbooks and roles that I use to provision my Linux-based machines.

This repository provisions my machines: the `flaudisio.*` files carry my settings and `host_vars/`
holds my secrets. There is no machine-agnostic baseline. To reuse it, follow
[docs/generalizing.md](docs/generalizing.md).

## Compatibility

This repository is currently tested against **Xubuntu 24.04**, but most roles should work with any Ubuntu
flavor running the same version.

## Prerequisites

- [mise-en-place](https://mise.jdx.dev/installing-mise.html)
- Git

The installation steps below take care of bootstrapping a vanilla (X)Ubuntu installation.

## Installation

Run the [installation script](install.sh) and follow its instructions:

```bash
wget -q -O - https://raw.githubusercontent.com/flaudisio/linux-setup-playbook/refs/heads/main/install.sh | bash
```

> Notice that `curl` may not be available in vanilla Ubuntu installations.

The script will:

- Install Git
- Clone this repository
- Install Ansible (in a virtualenv) and collections/roles used by this repository

## Secrets

Every playbook loads `host_vars/localhost/secrets.sops.yml` through the `community.sops.sops` vars
plugin, so every machine needs the SOPS age key. The file is encrypted with
[SOPS](https://getsops.io). Install the key before running any playbook:

```bash
doppler login
mise run sops:key
```

## Overriding defaults

You can override variables defined in `config/flaudisio.common.yml` (or define new ones) by creating a
`config/local.yml` file.

Example:

```yaml
# Customize the list of installed packages
packages_apt_install:
  - htop
  - jq
  - vim

packages_pipx_install:
  - pre-commit
  - name: ps-mem
    global: true

# Customize Docker daemon options
docker_daemon_options:
  bip: 192.168.243.1/24
  default-address-pools:
    - base: 192.168.244.0/22
      size: 27
```

For all available options, see roles' variable files in the [local](roles/local) folder.

## Running the playbook

```bash
cd ~/.local/share/linux-setup-playbook

./run playbooks/flaudisio.personal.yml
```

The [run](run) helper is a tiny wrapper for the `ansible-playbook` command. By default it uses the
`--become --ask-become-pass` arguments, so your user must be able to use `sudo` (which is default on
clean Ubuntu installations).

## Running specific tasks

Use `ansible-playbook`'s flags like `--tags` (shorthand: `-t`) to run only specific tasks, enable check
mode and so on.

Example:

```bash
./run --help
./run playbooks/flaudisio.personal.yml --list-tasks
./run playbooks/flaudisio.personal.yml -t packages
./run playbooks/flaudisio.personal.yml -t packages --diff --check
./run playbooks/flaudisio.personal.yml -t git -t chrome
```

## Thanks

This project is heavily inspired by Jeff Geerling's great [Mac Development Ansible Playbook](https://github.com/geerlingguy/mac-dev-playbook).

## License

[MIT](LICENSE)
