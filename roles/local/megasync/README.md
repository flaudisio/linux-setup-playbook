# Ansible Role: MEGAsync

Ansible role that installs the [MEGAsync](https://mega.io/desktop) desktop client from MEGA's own
`.deb` package.

## Requirements

- An Ubuntu release MEGA publishes a package for: the URL embeds the host's
  `ansible_facts['distribution_version']`.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Ref: https://mega.io/desktop#download

megasync_package_arch: "{{ 'arm64' if ansible_facts['architecture'] == 'aarch64' else 'amd64' }}"

megasync_package_url: >-
  https://mega.nz/linux/repo/xUbuntu_{{ ansible_facts['distribution_version'] }}/{{ megasync_package_arch }}/megasync-xUbuntu_{{ ansible_facts['distribution_version'] }}_{{ megasync_package_arch }}.deb
```

The role only installs the package when `megasync` is missing from the package facts; it does not
upgrade an older installed release.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: megasync
```

## License

MIT
