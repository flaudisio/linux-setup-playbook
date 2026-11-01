# Ansible Role: Ubuntu Pro

Ansible role that attaches a host to Ubuntu Pro with a token and enables or disables its services.

## Requirements

- An Ubuntu Pro subscription token, passed as `ubuntu_pro_token`, and an Ubuntu LTS host.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Ref: https://documentation.ubuntu.com/pro/attach-tutorial/

ubuntu_pro_enabled: false

ubuntu_pro_token: ""

ubuntu_pro_enable_services: []
ubuntu_pro_disable_services: []

ubuntu_pro_upgrade_all_packages: false
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: ubuntu-pro
      vars:
        ubuntu_pro_enabled: true
        ubuntu_pro_token: "{{ vault_ubuntu_pro_token }}"
        ubuntu_pro_enable_services:
          - esm-infra
```

## License

MIT
