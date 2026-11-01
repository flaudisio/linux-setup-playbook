# Ansible Role: Ghostty

Ansible role that installs [Ghostty](https://ghostty.org) from the third-party Ubuntu packages
published by `mkasberg/ghostty-ubuntu` and renders an optional configuration file.

## Requirements

- An Ubuntu release covered by the `ghostty-ubuntu` release, which publishes one `.deb` per
  distribution version.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
ghostty_pkg_version: 1.3.1-0~ppa2

ghostty_pkg_arch: "{{ 'arm64' if ansible_facts['architecture'] == 'aarch64' else 'amd64' }}"

ghostty_pkg_url: >-
  https://github.com/mkasberg/ghostty-ubuntu/releases/download/{{ ghostty_pkg_version | replace('~', '-') }}/ghostty_{{ ghostty_pkg_version | replace('~', '.') }}_{{ ghostty_pkg_arch }}_{{ ansible_facts['distribution_version'] }}.deb

ghostty_config_file: ~/.config/ghostty/config
ghostty_config_mode: "0644"

ghostty_config_content: ""
# ghostty_config_content: |
#   font-size = 11
#   bell-features = no-title
#   background = #000000

ghostty_config_become: false
```

The package URL embeds the host's `ansible_facts['distribution_version']`, so a release without a
matching build fails at download. The configuration file is only written when
`ghostty_config_content` is not empty.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: ghostty
      vars:
        ghostty_config_content: |
          font-size = 11
          background = #000000
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
