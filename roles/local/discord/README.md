# Ansible Role: Discord

Ansible role that installs the [Discord](https://discord.com) desktop client, either the latest
release or a pinned version.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
discord_version: latest  # or specific version, e.g. '0.0.81'
```

The role resolves the download URL through Discord's platform redirect, so the package always comes
from the vendor CDN. It reads the installed version with `dpkg-query` and only downloads when the
target version differs.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: discord
      vars:
        discord_version: 0.0.81
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
