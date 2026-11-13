# Playbooks

Entry points, one per target machine kind. Variables come from `config/` (see its README).

- `default.yml`: standalone baseline for any host (packages, git, mise, chrome, docker, vscode).
- `flaudisio.common.yml`: shared base imported by the personal and work playbooks; not run alone.
- `flaudisio.personal.yml`: the desktop machine (brave, megasync, syncthing, kvm).
- `flaudisio.work.yml`: the work machine (cinc-workstation, slack).
- `flaudisio.wsl.yml`: CLI-only subset for WSL.

Run them with `./run playbooks/<name>.yml [--tags <tag>]`.
