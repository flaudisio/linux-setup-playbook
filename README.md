# Linux Setup Playbook

Ansible playbooks and roles that I use to provision my Linux-based machines.

## Compatibility

This repository is currently tested against **Xubuntu 24.04** (x86_64), but most roles should work with any Ubuntu flavor
running the same version.

## Prerequisites

- Git
- Python [venv](https://docs.python.org/3/library/venv.html) module

The installation steps below take care of bootstrapping a default (X)Ubuntu installation.

## Installation

Run the [installation script](install.sh) and follow its instructions:

```bash
wget -q -O - https://raw.githubusercontent.com/flaudisio/linux-setup-playbook/refs/heads/main/install.sh | bash
```

> Notice that `curl` may not be available in vanilla Ubuntu installations.

The script will:

- Install Git and Python's [venv](https://docs.python.org/3/library/venv.html) module package (`python3-venv`)
- Clone this repository
- Install Ansible in a virtualenv and download the required collections/roles to the cloned folder

## Overriding defaults

You can override variables defined in `config.default.yml` (or define new ones) by creating a `config.yml` file.

Example:

```yaml
# Do not remove Snap support
base_remove_snapd: false

# Customize the list of installed packages
packages_extra:
  - foo
  - bar

# Clear the custom Docker daemon options by setting an empty object
docker_daemon_options: {}
```

For all available options, see the roles' variable files in the [roles](roles) folder.

## Running the playbook

Run the `setup` playbook:

```bash
cd ~/.local/share/linux-setup-playbook

./run.sh setup.yml
```

The [run.sh](run.sh) script is a tiny wrapper for the `ansible-playbook` command. By default it uses the `--become --ask-become-pass`
arguments, so your user must be able to run commands using `sudo` (which is default in standard Ubuntu installations).

## Running specific tasks

Use `ansible-playbook`'s flags like `--tags` to run only specific tasks, enable check mode and so on.

Example:

```bash
./run.sh setup.yml --list-tasks
./run.sh setup.yml --tags backup,spotify
./run.sh setup.yml -t packages:dev -t restic
./run.sh setup.yml -t spotify --diff -C
```

## Thanks

This project is heavily inspired by Jeff Geerling's great [Mac Development Ansible Playbook](https://github.com/geerlingguy/mac-dev-playbook).

## License

[MIT](LICENSE)
