# Ansible Role: Brave Browser

Ansible role that installs the [Brave](https://brave.com/linux/) browser from its own APT
repository.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Ref: https://brave.com/linux/

brave_apt_repo_name: brave-browser

brave_apt_repo_key_url: https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
brave_apt_repo_key_file: /usr/share/keyrings/brave-browser-archive-keyring.gpg

# Ref: https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
brave_apt_repo_uri: https://brave-browser-apt-release.s3.brave.com
brave_apt_repo_suite: stable
brave_apt_repo_component: main
brave_apt_repo_architectures:
  - amd64
  - arm64
```

The role removes the previously deployed `brave-browser-*` source list files before it writes the
deb822 `.sources` entry, so a host that used the older one-line format does not end up with the
repository configured twice.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: brave
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
