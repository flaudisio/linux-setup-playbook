# Ansible Role: bat

Ansible role that installs [bat](https://github.com/sharkdp/bat) from its GitHub release and renders
an optional system-wide configuration.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
bat_version: 0.26.1

bat_package_arch: "{{ 'arm64' if ansible_facts['architecture'] == 'aarch64' else 'amd64' }}"

bat_package_url: >-
  https://github.com/sharkdp/bat/releases/download/v{{ bat_version }}/bat_{{ bat_version }}_{{ bat_package_arch }}.deb

bat_config_file: /etc/bat/config
bat_config_owner: root
bat_config_group: "{{ bat_config_owner }}"
bat_config_mode: "0644"

bat_config_content: ""
# bat_config_content: |
#   --map-syntax "**/.aws/{config,credentials}*:INI"
#   --map-syntax "**/.kube/config:YAML"
#   --map-syntax "*.bats:Bourne Again Shell (bash)"
#   --map-syntax ".terraformrc:Terraform"
```

The role pins the Ubuntu package to `-1` so an `apt upgrade` never replaces the installed release
with the older one shipped in the distribution. The configuration file is only written when
`bat_config_content` is not empty.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: bat
      vars:
        bat_version: 0.26.1
        bat_config_content: |
          --map-syntax "**/.kube/config:YAML"
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
