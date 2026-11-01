# Ansible Role: Syncthing

Ansible role that installs [Syncthing](https://syncthing.net) from its own APT repository and
enables its systemd user service.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Ref: https://apt.syncthing.net/

syncthing_apt_repo_name: syncthing

syncthing_apt_repo_key_url: https://syncthing.net/release-key.gpg
syncthing_apt_repo_key_file: /etc/apt/keyrings/syncthing-archive-keyring.gpg

syncthing_apt_repo_uri: https://apt.syncthing.net/
syncthing_apt_repo_suite: syncthing
syncthing_apt_repo_component: stable-v2

syncthing_enable_user_service: true
```

The service task runs as the connecting user with `become: false`, and is skipped for root:
Syncthing is meant to run inside the user's systemd session, not as a system-wide service. The role
also removes the legacy `syncthing.list` source file.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: syncthing
      vars:
        syncthing_enable_user_service: false
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
