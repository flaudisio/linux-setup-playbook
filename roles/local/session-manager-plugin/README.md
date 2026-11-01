# Ansible Role: Session Manager Plugin

Ansible role that installs the AWS Session Manager plugin, which adds `session-manager-plugin` for
the AWS CLI's `ssm start-session`.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
session_manager_plugin_version: latest

session_manager_plugin_dl_arch: "{{ 'arm64' if ansible_facts['architecture'] == 'aarch64' else '64bit' }}"

session_manager_plugin_package_url: >-
  https://s3.amazonaws.com/session-manager-downloads/plugin/{{ session_manager_plugin_version }}/ubuntu_{{ session_manager_plugin_dl_arch }}/session-manager-plugin.deb
```

The role installs the `.deb` straight from the AWS download bucket and does not check the version
already present, so a pinned `session_manager_plugin_version` is only applied when APT considers the
package newer.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: session-manager-plugin
      vars:
        session_manager_plugin_version: 1.2.707.0
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
