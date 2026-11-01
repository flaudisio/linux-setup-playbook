# Ansible Role: Ulauncher

Ansible role that installs [Ulauncher](https://ulauncher.io) from its GitHub release and renders its
settings file.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
ulauncher_version: 5.15.15

ulauncher_package_url: >-
  https://github.com/Ulauncher/Ulauncher/releases/download/{{ ulauncher_version }}/ulauncher_{{ ulauncher_version }}_all.deb

ulauncher_config_dir: ~/.config/ulauncher

ulauncher_default_config:
  blacklisted-desktop-dirs: /usr/share/locale:/usr/share/app-install:/usr/share/kservices5:/usr/share/fk5:/usr/share/kservicetypes5:/usr/share/applications/screensavers:/usr/share/kde4:/usr/share/mimelnk
  clear-previous-query: true
  disable-desktop-filters: false
  grab-mouse-pointer: false
  hotkey-show-app: <Primary>space
  render-on-screen: mouse-pointer-monitor
  show-indicator-icon: true
  show-recent-apps: "0"
  terminal-command: ""
  theme-name: light

ulauncher_config: {}
```

`ulauncher_config` is merged over `ulauncher_default_config`, key by key, and the result is written
to `settings.json`; the file is rewritten on every run, so remove overrides from the variable rather
than editing the file on the host. The settings belong to the connecting user and the role runs
those tasks with `become: false`.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: ulauncher
      vars:
        ulauncher_config:
          hotkey-show-app: <Primary>space
          theme-name: dark
```

## License

MIT
