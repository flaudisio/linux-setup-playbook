# Ansible Role: Base System

Ansible role that applies the base operating system tweaks: swap usage, systemd journal size,
LightDM guest sessions, Num Lock, sudoers entries, `/etc/hosts` lines and update-alternatives.

## Requirements

- A LightDM-based desktop: the role writes `/etc/lightdm/lightdm.conf.d/50-no-guest.conf`.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
base_vm_swappiness: 10

# Max disk space the systemd journal may use
base_journald_system_max_use: 200M

# base_hosts_config: |
#   10.0.0.1   foo.example.com
#   10.0.2.20  another.example.com  another
base_hosts_config: ""

# base_hosts_file_remove:
#   - ^192\.168
#   - host\.example\.com
base_hosts_file_remove: []

# base_sudoers_config: |
#   someuser ALL=(root) NOPASSWD:/usr/bin/rsync * /var/lib/libvirt/images/*
#   someuser ALL=(root) NOPASSWD:/usr/bin/virsh
base_sudoers_config: ""

base_alternatives: []
```

Every variable is optional: the journald, sudoers, hosts and alternatives tasks write nothing when
their list or string is empty. `base_hosts_config` goes into a marker-delimited block in
`/etc/hosts`, so the role keeps it apart from the managed-by-hand entries.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: base-system
      vars:
        base_vm_swappiness: 10
        base_hosts_config: |
          10.0.0.1  router.example.com
        base_alternatives:
          - name: editor
            path: /usr/bin/vim.basic
            priority: 100
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

The scenario runs in a privileged systemd container, which has no LightDM, no
`/etc/default/numlockx` and a bind-mounted `/etc/hosts`: the tasks that write to them are tagged
`molecule-notest` and skipped there.

## License

MIT
