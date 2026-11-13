# Generalizing this playbook

This repository is tuned for the author's machines. The baseline, the secrets and the playbooks
all assume one setup, so a plain fork does not run anywhere else. This guide lists what is
personal and how to replace it, in an order that keeps the repository runnable at every step.

## What is personal

| Piece | Why it is yours |
|---|---|
| `config/flaudisio.common.yml` | All of the author's machine settings. |
| `config/flaudisio.wsl.yml` | Package subset for the author's WSL instance. |
| `playbooks/flaudisio.*.yml` | Entry points for the author's personal and work machines. |
| `host_vars/localhost/*.sops.yml` | Encrypted secrets, exposed as `secret_*` variables. |
| `.sops.yaml` | The author's age public key, as the encryption recipient. |
| `ansible.cfg` | `vars_plugins_enabled` includes `community.sops.sops`. |
| `mise.toml` | `SOPS_AGE_KEY_FILE` and `sops:key`, scoped to a Doppler project. |
| `config/resticprofile/templates/` | The author's restic repositories and credentials. |
| `install.sh` | Clones the author's repository. |

Already generic: every role under `roles/local/`, their molecule scenarios, `./run`, and
`.github/workflows/`.

## 1. Fork and trim

1. Fork the repository and clone your fork.
2. Delete what you do not want: `config/flaudisio.*.yml`, `playbooks/flaudisio.*.yml`,
   `host_vars/`, `.sops.yaml` and `config/resticprofile/`.
3. Build your own baseline from `playbooks/flaudisio.common.yml` and
   `config/flaudisio.common.yml`: rename them, then keep only the roles and settings you want.
   `flaudisio.personal.yml` and `flaudisio.wsl.yml` are the per-machine entry points.
4. Point `install.sh` at your fork, or leave it alone and use its environment overrides:
   `REPO_URL=... BRANCH=... INSTALL_DIR=... wget -q -O - ... | bash`.

`config/local.yml` stays the per-machine escape hatch: it is gitignored, so copy the example in
the [README](../README.md#overriding-defaults) into it.

## 2. Decide how secrets work

Path A, drop SOPS entirely:

1. Remove `community.sops.sops` from `vars_plugins_enabled` in `ansible.cfg`.
2. Remove the `sops-encrypted` hook from `.pre-commit-config.yaml`.
3. Remove the `SOPS_AGE_KEY_FILE` entry, the `age`, `doppler` and `sops` tools, and the
   `sops:key` task from `mise.toml`.
4. Define your `secret_*` variables in `config/local.yml`, or in a plain
   `host_vars/localhost/secrets.yml`.

Path B, keep SOPS with your own key:

1. Generate a key: `age-keygen -o ~/.config/sops/age/<project>.keys.txt`.
2. Replace the `age:` recipient in `.sops.yaml` with the new public key.
3. Point `SOPS_AGE_KEY_FILE` in `mise.toml` at your key file.
4. Re-encrypt every `*.sops.yml` with `sops updatekeys -y <file>`, decrypting and re-encrypting
   by hand if the recipients changed.
5. Replace the `sops:key` task with whatever stores your key, or delete it and install the key
   by hand.

The Doppler project name derives from `PROJECT_NAME = "{{ config_root | basename }}"`, so cloning
into a directory with a different name also changes the project `sops:key` looks up.

## 3. Verify

```bash
mise run install
./run playbooks/flaudisio.common.yml --list-tasks
mise run lint
cd roles/local/<role> && mise run test:role
```

`mise run lint:ansible` sets `SOPS_ANSIBLE_AWX_DISABLE_VARS_PLUGIN_TEMPORARILY=1`, so lint runs
without a key; a real one does not.

## 4. What stays yours

There is no machine-agnostic baseline, and `flaudisio.common.yml` is not a minimal one: it
installs Chrome, VS Code and Docker on every host. Treat it as an example to rewrite, not as a
distribution default.
