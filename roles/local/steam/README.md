# Ansible Role: Steam

Ansible role that installs the [Steam](https://store.steampowered.com) client from Valve's `.deb`
installer.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
steam_package_url: https://cdn.fastly.steamstatic.com/client/installer/steam.deb
```

The role only downloads the installer while `steam-launcher` is missing from the package facts, so
an installed client is left untouched.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: steam
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
