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

opencode_home_dir: "{{ '~' | expanduser }}"
opencode_install_path: "{{ opencode_home_dir }}/.opencode/bin/opencode"
opencode_install_become: false

opencode_symlink_path: "{{ opencode_home_dir }}/.local/bin/opencode"
```

With `opencode_version: latest` the role asks the update API which release to install. It compares
the reported version of the binary at `opencode_install_path` with the target and only unpacks the
archive when they differ. Set `opencode_symlink_path: ""` to skip the symlink.

`opencode_home_dir` expands `~` to the user running Ansible. Do not use
`ansible_facts['user_dir']` here: it is `/root` whenever the playbook runs with `--become`.

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

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
