# Ansible Role: Slack

Ansible role that installs the [Slack](https://slack.com) desktop client from its Packagecloud
repository.

## Requirements

- Outbound access to `https://packagecloud.io`: the role scrapes the search page to find the newest
  `.deb`, because the Packagecloud API requires authentication.

## Role Variables

None.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: slack
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
