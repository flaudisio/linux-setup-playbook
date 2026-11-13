# Playbooks

Entry points, one per target machine kind. Variables come from `config/` (see its README).

- `common.yml`: shared base imported by the personal and work playbooks; not run alone.
- `personal.yml`: the desktop machine (brave, megasync, syncthing, kvm).
- `work.yml`: the work machine (cinc-workstation, slack).
- `wsl.yml`: CLI-only subset for WSL.

Run them with `./run playbooks/<name>.yml [--tags <tag>]`.
