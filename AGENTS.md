# AGENTS.md

Ansible playbooks that provision this machine (Xubuntu 24.04). Inventory uses
`ansible_connection=local`; everything targets `localhost`, never a remote host.

## Tooling

- `mise` manages tools and is the task runner. Python venv `.venv` is auto-created by mise.
- `mise run install` (alias `i`): install Ansible + Galaxy deps. Re-run after editing
  `requirements.txt` or `requirements.yml`.
- `mise run lint`: runs `prek` (the pre-commit successor) against all files. Config stays in
  `.pre-commit-config.yaml`. A `prek` git hook also runs on every commit.
- `mise run bump-version`: `bump-my-version` CalVer `YYYY.0M.patch`. `VERSION` is the source of
  truth; tags are `v<version>`.
- `prek` is NOT listed in `mise.toml` `[tools]`; CI installs it with `mise use prek`.

## Running playbooks

- Always use `./run playbooks/<name>.yml [--tags <tag>]`, not raw `ansible-playbook`. The wrapper
  adds `--become --ask-become-pass` (set `NO_SUDO=1` to skip) and falls back to `mise exec`.
  Running `./run` with no args (or `shell`) opens a shell inside the mise env.
- `playbooks/default.yml` is standalone: loads only `config.default.yml` + `config.yml`.
  `playbooks/common.yml` is the shared base imported by `personal.yml` and `work.yml`; those also
  load `config.flaudisio.yml` and `vault.yml`.
- Ansible log: `/tmp/ansible.linux-setup-playbook.log`.

## Layout and config

- `roles/local/<name>/`: roles maintained here. Add new roles here.
- `collections/` and `roles/public/`: vendored, installed by `mise run install`, gitignored (only
  `.gitkeep`/`README.md` are tracked). Do not edit or commit into them.
- Roles are referenced by bare name; resolution order is `roles_path = roles/public:roles/local`
  (see `ansible.cfg`).
- Variable precedence: `config.default.yml` -> `config.yml` (local overrides) ->
  `config.flaudisio.yml` (this author's personal machine) -> `vault.yml` (secrets). Per-role
  examples live in each role's `defaults/main.yml`.

## Secrets

- `vault.yml` is gitignored; never commit it. The vault password lives in the OS keyring and is
  read by `scripts/vault-keyring.sh` (wired via `ansible.cfg` `vault_password_file`).
- Manage secrets with `mise run vault:*` (Doppler-backed). For non-interactive runs, set
  `VAULT_DISABLE_KEYRING` and `VAULT_PASSWORD` to bypass the keyring.

## Conventions

- YAML: 2-space indent, wrapping/lint via `yamllint --strict`. Max line length is **140** (not
  100); `roles/*/*/defaults/**` and `roles/*/*/vars/**` are exempt from the length rule.
- Markdown wraps at 100 (`.editorconfig`).
- Commits follow Conventional Commits (see `git log`).
