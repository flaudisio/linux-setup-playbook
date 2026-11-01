# Ansible Role: OpenCode

Ansible role that installs the [OpenCode](https://opencode.ai) CLI from its release tarball and
links it into `PATH`.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
opencode_version: latest  # or specific version, e.g. '2.0.16'

opencode_dl_arch: "{{ 'arm64' if ansible_facts['architecture'] == 'aarch64' else 'x64' }}"

opencode_install_path: ~/.opencode/bin/opencode
opencode_install_become: false

opencode_symlink_path: ~/.local/bin/opencode
```

With `opencode_version: latest` the role asks the update API which release to install. It compares
the reported version of the binary at `opencode_install_path` with the target and only unpacks the
archive when they differ. Set `opencode_symlink_path: ""` to skip the symlink.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: opencode
      vars:
        opencode_version: 2.0.16
```

## License

MIT
