# Ansible Role: rclone

Ansible role that installs [rclone](https://rclone.org) from its GitHub release and configures bash
completion.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
rclone_version: 1.75.1

rclone_package_arch: "{{ 'arm64' if ansible_facts['architecture'] == 'aarch64' else 'amd64' }}"

rclone_package_url: >-
  https://github.com/rclone/rclone/releases/download/v{{ rclone_version }}/rclone-v{{ rclone_version }}-linux-{{ rclone_package_arch }}.deb

rclone_enable_bash_completion: true
```

The role skips the download when the installed `rclone` version already matches `rclone_version`.
The completion script is written to `/etc/bash_completion.d/rclone`, which bash-completion sources
on Ubuntu.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: rclone
      vars:
        rclone_version: 1.75.1
```

## License

MIT
