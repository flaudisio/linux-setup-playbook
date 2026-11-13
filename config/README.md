# Config

Variables loaded by the playbooks through `vars_files`, in ascending precedence (later wins):

- `default.yml`: baseline, machine-agnostic.
- `flaudisio.common.yml`: this author's settings, shared by every machine.
- `flaudisio.wsl.yml`: WSL-only overrides, loaded by `playbooks/flaudisio.wsl.yml`.
- `local.yml`: per-machine overrides, gitignored.

`resticprofile/templates/` holds the resticprofile config templates referenced from
`flaudisio.common.yml`.
