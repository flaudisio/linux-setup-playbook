# Config

Variables loaded by the playbooks through `vars_files`, in ascending precedence (later wins):

- `flaudisio.common.yml`: this author's settings, shared by every machine.
- `flaudisio.wsl.yml`: WSL-only overrides, loaded by `playbooks/flaudisio.wsl.yml`.
- `local.yml`: per-machine overrides, gitignored.

There is no machine-agnostic baseline: `flaudisio.common.yml` is it, and a fork is expected to
rewrite it (see [generalizing](../docs/generalizing.md)).

`resticprofile/templates/` holds the resticprofile config templates referenced from
`flaudisio.common.yml`.
