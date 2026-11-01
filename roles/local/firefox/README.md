# Ansible Role: Firefox

Ansible role that installs Firefox from the Mozilla APT repository in place of the Snap package, and
optionally selects it as the default browser.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Ref: https://support.mozilla.org/en-US/kb/install-firefox-linux#w_install-firefox-deb-package-for-debian-based-distributions

firefox_apt_repo_name: mozilla

firefox_apt_repo_key_url: https://packages.mozilla.org/apt/repo-signing-key.gpg
firefox_apt_repo_key_file: /etc/apt/keyrings/packages.mozilla.org.asc

firefox_apt_repo_uri: https://packages.mozilla.org/apt
firefox_apt_repo_suite: mozilla
firefox_apt_repo_component: main

firefox_set_as_default_browser: false
```

The role removes the `firefox` Snap when snapd is installed, removes the legacy `mozilla.list`
source, and pins any `firefox` package whose version mentions `snap` to `-1` so APT keeps the
Mozilla build.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: firefox
      vars:
        firefox_set_as_default_browser: true
```

## License

MIT
