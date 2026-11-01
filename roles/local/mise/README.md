# Ansible Role: mise

Ansible role that installs [mise](https://mise.jdx.dev) from its APT repository and activates it in
a bashrc, with optional bash completion.

## Requirements

- An Ubuntu release the role ships variables for: `vars/Ubuntu-<version>.yml` exists for 24.04 and
  26.04, which use mise's own repository and the `jdxcode` PPA respectively.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
mise_configure_bashrc: true
mise_bashrc_file: ~/.bashrc
mise_bashrc_become: false

mise_pre_activate_commands: ""
mise_activate_command: mise activate bash

# Note: Mise completion requires the 'usage' tool (which is installed by Mise itself), so this variable
# will be ignored unless bashrc configuration is also enabled
mise_configure_bash_completion: false
```

The bashrc block is marker-delimited and removed again when `mise_configure_bashrc` is false.
Turning on `mise_configure_bash_completion` installs the `usage` tool globally with
`mise use --global usage` and writes `/etc/bash_completion.d/mise`.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: mise
      vars:
        mise_configure_bash_completion: true
```

## License

MIT
