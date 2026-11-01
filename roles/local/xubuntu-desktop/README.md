# Ansible Role: Xubuntu Desktop

Ansible role that configures an Xfce desktop for a user: fonts, theme, cursor, autostart entries,
XDG user directories, Thunar bookmarks, keyboard shortcuts, Xfconf settings and default
applications.

## Requirements

- A running Xfce session for the target user: the role talks to `xfconf` over the session bus and
  runs every desktop task with `become: false`, so it must run as that user from inside the session.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Global

xubuntu_home_dir: "{{ '~' | expanduser }}"
xubuntu_config_dir: "{{ xubuntu_home_dir }}/.config"
xubuntu_local_fonts_dir: "{{ xubuntu_home_dir }}/.local/share/fonts"

# Fonts

xubuntu_fonts_packages: []

# xubuntu_fonts_archives:
#   - name: ExampleFont
#     url: https://github.com/example/example-font/releases/download/v1.0/ExampleFont-1.0.zip
#     include_files:
#       - fonts/*
xubuntu_fonts_archives: []

xubuntu_system_default_font: ""
xubuntu_system_monospace_font: ""
xubuntu_window_title_font: ""

# Theme

xubuntu_theme_packages: []

xubuntu_system_theme: ""
xubuntu_cursor_theme: ""

# Autostart

xubuntu_autostart_dir: "{{ xubuntu_config_dir }}/autostart"

xubuntu_autostart_disable_apps: []

# XDG user dirs
# Refs: 'man user-dirs.dirs', 'man xdg-user-dir', 'man xdg-user-dirs-update'

xubuntu_xdg_user_dirs_file: "{{ xubuntu_config_dir }}/user-dirs.dirs"

# Ref: /etc/xdg/user-dirs.defaults
xubuntu_xdg_documents_dir: Documents
xubuntu_xdg_download_dir: Downloads
xubuntu_xdg_music_dir: Music
xubuntu_xdg_pictures_dir: Pictures
xubuntu_xdg_publicshare_dir: Public
xubuntu_xdg_templates_dir: Templates
xubuntu_xdg_videos_dir: Videos

# NOTE: you should logout and re-login *before* removing the folders
xubuntu_remove_default_xdg_user_dirs: false

# Bookmarks

xubuntu_bookmarks_file: "{{ xubuntu_config_dir }}/gtk-3.0/bookmarks"

xubuntu_bookmarks: []

# Keyboard shortcuts

xubuntu_keyboard_shortcuts: []
xubuntu_extra_keyboard_shortcuts: []
xubuntu_window_manager_shortcuts: []
xubuntu_remove_keyboard_shortcuts: []
xubuntu_remove_window_manager_shortcuts: []

# Thunar

xubuntu_thunar_settings: []

# xfce4-terminal

xubuntu_xfce4_terminal_settings: []

# Xfconf

xubuntu_xfconf_settings: []

# Default applications

xubuntu_default_web_browser: ""
xubuntu_default_file_manager: ""
xubuntu_default_mail_reader: ""
xubuntu_default_terminal_emulator: ""
```

Empty strings and lists leave the corresponding Xfconf property, file entry or setting untouched, so
only what is set diverges from the desktop defaults. Shortcut lists hold `shortcut` and `cmd` pairs,
Xfconf and terminal lists hold `channel`, `property`, `value` and `value_type`, and
`xubuntu_autostart_disable_apps` holds desktop file basenames to hide. Every task carries a
`xubuntu:*` tag for running one area at a time.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: xubuntu-desktop
      vars:
        xubuntu_system_default_font: Noto Sans 11
        xubuntu_system_theme: Greybird-dark
        xubuntu_bookmarks:
          - ~/Documents
          - ~/Downloads
        xubuntu_keyboard_shortcuts:
          - shortcut: <Super>e
            cmd: thunar
```

## License

MIT
