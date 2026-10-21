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
- `prek` is pinned in `mise.toml` `[tools]`.

## Running playbooks

- Always use `./run playbooks/<name>.yml [--tags <tag>]`, not raw `ansible-playbook`. The wrapper
  adds `--become --ask-become-pass` (set `NO_SUDO=1` to skip) and falls back to `mise exec`.
  Running `./run` with no args (or `shell`) opens a shell inside the mise env.
- `playbooks/default.yml` is standalone: loads only `config.default.yml` + `config.yml`.
  `playbooks/common.yml` is the shared base imported by `personal.yml` and `work.yml`; those also
  load `config.flaudisio.yml`.
- Ansible log: `/tmp/ansible.linux-setup-playbook.log`.

## Layout and config

- `roles/local/<name>/`: roles maintained here. Add new roles here.
- `collections/` and `roles/public/`: vendored, installed by `mise run install`, gitignored (only
  `.gitkeep`/`README.md` are tracked). Do not edit or commit into them.
- Roles are referenced by bare name; resolution order is `roles_path = roles/public:roles/local`
  (see `ansible.cfg`).
- Variable precedence: `config.default.yml` -> `config.yml` (local overrides) ->
  `config.flaudisio.yml` (this author's personal machine) -> `host_vars/localhost/vault.sops.yml`
  (SOPS-encrypted secrets). Per-role examples live in each role's `defaults/main.yml`.

## Secrets

- `host_vars/localhost/vault.sops.yml` holds the secrets, encrypted with SOPS and loaded by the
  `community.sops.sops` vars plugin (see `ansible.cfg`). It is committed; plaintext never is.
- The age private key lives in Doppler project `linux-setup-playbook` as `SOPS_AGE_KEY`. Install
  it with `mise run sops:key`, which writes
  `~/.config/sops/age/linux-setup-playbook.keys.txt`; `sops` finds it through
  `SOPS_AGE_KEY_FILE` (set in `mise.toml`). Every machine that runs `personal.yml` or `work.yml`
  needs it.
- Edit secrets with `sops host_vars/localhost/vault.sops.yml`. CI has no key, so `mise run
  lint:ansible` sets `SOPS_ANSIBLE_AWX_DISABLE_VARS_PLUGIN_TEMPORARILY=1`.

## Conventions

- YAML: 2-space indent, wrapping/lint via `yamllint --strict`. Max line length is **140** (not
  100); `roles/*/*/defaults/**` and `roles/*/*/vars/**` are exempt from the length rule.
- Markdown wraps at 100 (`.editorconfig`).
- Commits follow Conventional Commits (see `git log`).
