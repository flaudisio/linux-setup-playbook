# Ansible Role: restic

Ansible role that installs [restic](https://restic.net) and configures its bash completion.

## Requirements

- The `community.general` collection, for the file capabilities module.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Version to install, and the release archive and checksums it is downloaded from.
restic_version: 0.19.1
restic_dl_arch: "{{ 'arm64' if ansible_facts['architecture'] == 'aarch64' else 'amd64' }}"
restic_archive_url: >-
  https://github.com/restic/restic/releases/download/v{{ restic_version }}/restic_{{ restic_version }}_linux_{{ restic_dl_arch }}.bz2
restic_sha256sums_url: >-
  https://github.com/restic/restic/releases/download/v{{ restic_version }}/SHA256SUMS

# Grants the binary cap_dac_read_search, so a non-root restic can read files only root can.
restic_configure_non_root_capabilities: false

# Binary location and ownership.
restic_bin_path: /usr/local/bin/restic
restic_bin_owner: root
restic_bin_group: "{{ restic_bin_owner }}"
restic_bin_mode: "0755"

restic_configure_bash_completion: true
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: restic
      vars:
        restic_version: 0.19.1
```

## Testing

The role ships a molecule scenario using the Docker driver; its verify step runs
[goss](https://github.com/goss-org/goss) against the converged container.

```bash
molecule test
```

## License

MIT
