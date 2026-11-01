# Ansible Role: resticprofile

Ansible role that installs [resticprofile](https://creativeprojects.github.io/resticprofile/) and
renders its profiles, log rotation and systemd schedules.

## Requirements

- The `restic` binary in `PATH`, or `restic-binary` in the global profile settings: the role
  schedules restic jobs but does not install restic.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Version to install.
resticprofile_version: 0.33.1
resticprofile_dl_arch: "{{ 'arm64' if ansible_facts['architecture'] == 'aarch64' else 'amd64' }}"

# Binary location, and an optional extra name to symlink to it.
resticprofile_bin_path: /usr/local/bin/resticprofile
resticprofile_symlink_name: ""

# Log directory and logrotate ownership.
resticprofile_log_dir: /var/log/resticprofile
resticprofile_log_owner: root
resticprofile_log_group: "{{ resticprofile_log_owner }}"

# Config directory and file; set sensitive to render them 0640/0750 instead of 0644/0755.
resticprofile_config_dir: /etc/resticprofile
resticprofile_config_file: "{{ resticprofile_config_dir }}/profiles.yaml"
resticprofile_config_owner: root
resticprofile_config_group: "{{ resticprofile_config_owner }}"
resticprofile_config_sensitive: false

# Profiles rendered by the role's profiles.yaml.j2, and extra templates to render
# (each item is a template name or a dict with src, dest and sensitive).
resticprofile_config: {}
resticprofile_config_inline: {}
resticprofile_config_templates: []

# Profiles whose systemd schedules should be installed or removed.
resticprofile_enable_schedules: []
resticprofile_disable_schedules: []
```

The role downloads `resticprofile_<version>_linux_<arch>.tar.gz` from the project's GitHub
releases; set `resticprofile_dl_url` to use a mirror.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: resticprofile
      vars:
        resticprofile_config:
          default:
            repository: /srv/backups/restic
            password-file: /etc/resticprofile/password
            backup:
              stdin: false
              schedule: "03:00"
        resticprofile_config_templates:
          - profiles.yaml.j2
        resticprofile_enable_schedules:
          - default
```

## Testing

The role ships a molecule scenario using the Docker driver; its verify step runs
[goss](https://github.com/goss-org/goss) against the converged container, including the installed
systemd timer.

```bash
molecule test
```

## License

MIT
