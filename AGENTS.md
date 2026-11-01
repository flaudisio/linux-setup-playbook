# AGENTS.md

Ansible playbooks that provision this machine (Xubuntu 24.04). Inventory uses
`ansible_connection=local`; everything targets `localhost`, never a remote host.

## Tooling

- `mise` manages tools and is the task runner. Python venv `.venv` is auto-created by mise.
- `mise run install` (alias `i`): install Ansible + Galaxy deps. Re-run after editing
  `requirements.txt` or `requirements.yml`.
- `mise run lint`: runs `prek` (the pre-commit successor) against all files. Config stays in
  `.pre-commit-config.yaml`. A `prek` git hook also runs on every commit.
- `mise run test:role`: runs `molecule test` for the role in the current directory, and fails
  immediately when it has no `molecule/default/molecule.yml`. `molecule` and
  `molecule-plugins[docker]` come from `requirements.txt`, so `mise run install` provides them;
  Docker must be running.
- `mise run bump-version`: `bump-my-version` CalVer `YYYY.0M.patch`. `VERSION` is the source of
  truth; tags are `v<version>`.
- `prek` is pinned in `mise.toml` `[tools]`.

## Role tests

- Every `roles/local` role that can converge in a container ships `molecule/default/`:
  `molecule.yml` (Docker driver, `ANSIBLE_ROLES_PATH` pointing at `roles/local`), `converge.yml`
  (apt cache and systemd wait pre-tasks, then the role) and `verify.yml` (assertions against the
  role's own defaults, loaded with `vars_files`). `collections.yml` is required when the role
  imports a collection.
- Platform names carry the role prefix: `name: ${MOLECULE_PLATFORM_PREFIX:-<role>-}ubuntu2404` and
  the same for `ubuntu2604`. The platform name is also the Docker container and inventory host name,
  so a bare `ubuntu2404` makes scenarios collide, and concurrent runs of one role destroy each
  other's container. `MOLECULE_PLATFORM_PREFIX=zz-` runs parallel copies; the default must not be
  empty, because molecule rejects `${MOLECULE_PLATFORM_PREFIX:-}`.
- The platform name is the key for `molecule test -p <role>-ubuntu2404`.
- `.github/workflows/molecule.yml` runs `mise run test:role` in one matrix job per role whose
  scenario can be affected: a change under `roles/local/<role>/` tests that role, while a change
  to `ansible.cfg`, `requirements.txt`, `requirements.yml` or `mise.toml` tests every role.
  `workflow_dispatch` runs the whole matrix.
- Running the scenarios locally in parallel costs two containers per role (`molecule test` creates
  both platforms up front). This host holds about 7 systemd containers next to the semaphore stack,
  so three roles at a time is the safe ceiling; above it containers die at boot with exit 255 and
  Ansible reports the host as unreachable.
- Container-only setup the role must not carry belongs in `converge.yml` pre-tasks, for example
  `python3-debian` for `deb822_repository` or `libasound2t64` for a vendor `.deb`.
- Tasks that cannot work in a container are tagged `molecule-notest`; molecule passes
  `--skip-tags molecule-notest,notest`. Say in the role README which tasks those are.
- Assert observed state (the binary runs, dpkg reports the version, the file is a symlink), never a
  re-rendered template or a variable compared with itself.
- No scenario for `xubuntu-desktop` (needs the user's D-Bus session) or `ubuntu-pro` (needs a Pro
  token); `cinc-workstation` covers 24.04 only, because Omnitruck publishes no 26.04 build.

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
  `config.flaudisio.yml` (this author's personal machine) -> `host_vars/localhost/secrets.sops.yml`
  (SOPS-encrypted secrets). Per-role examples live in each role's `defaults/main.yml`.

## Secrets

- `host_vars/localhost/secrets.sops.yml` holds the secrets, encrypted with SOPS and loaded by the
  `community.sops.sops` vars plugin (see `ansible.cfg`). It is committed; plaintext never is.
- The age private key lives in Doppler project `linux-setup-playbook` as `SOPS_AGE_KEY`. Install
  it with `mise run sops:key`, which writes
  `~/.config/sops/age/linux-setup-playbook.keys.txt`; `sops` finds it through
  `SOPS_AGE_KEY_FILE` (set in `mise.toml`). Every machine that runs `personal.yml` or `work.yml`
  needs it.
- Edit secrets with `sops host_vars/localhost/secrets.sops.yml`. CI has no key, so `mise run
  lint:ansible` sets `SOPS_ANSIBLE_AWX_DISABLE_VARS_PLUGIN_TEMPORARILY=1`.
- Secrets that must not be committed go in `host_vars/localhost/local.sops.yml` (gitignored); the
  same plugin loads it.

## Conventions

- YAML: 2-space indent, wrapping/lint via `yamllint --strict`. Max line length is **140** (not
  100); `roles/*/*/defaults/**` and `roles/*/*/vars/**` are exempt from the length rule.
- Markdown wraps at 100 (`.editorconfig`).
- Commits follow Conventional Commits (see `git log`).
