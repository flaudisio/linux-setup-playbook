# Ansible Role: Dotfiles

Ansible role that clones a dotfiles repository and symlinks its contents into a home directory, then
adds Vim plugins, literal files and post-install commands.

## Requirements

- A Git repository whose `dotfiles_repo_src_dir` (default `src`) holds the files and directories to
  symlink. Entries directly under `src/` land in `$HOME`; for each directory under `src/`, its own
  subdirectories are linked into `$HOME` keeping their path, so `src/.config/htop/rc` becomes
  `~/.config/htop`.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
dotfiles_home: "~"

dotfiles_repo_url: https://github.com/flaudisio/dotfiles.git
dotfiles_repo_version: main
dotfiles_repo_update: true
dotfiles_repo_local_dest: "{{ dotfiles_home }}/.files"
dotfiles_repo_src_dir: src

dotfiles_vim_plugins_dir: "{{ dotfiles_home }}/.vim/pack/plugins/start"

# dotfiles_vim_plugins:
#   - https://github.com/editorconfig/editorconfig-vim.git
#   - repo: https://github.com/preservim/nerdtree.git
#     version: 7.1.3
#     update_repo: false
dotfiles_vim_plugins: []

# dotfiles_extra_files:
#   - path: ~/.config/example/config.ini
#     content: |
#       [config]
#       foo=bar
#       example=true
dotfiles_extra_files: []

# dotfiles_post_commands:
#   - mkdir /etc/example
#   - cmd: prek util init-template-dir ~/.git-template
#     creates: ~/.git-template
dotfiles_post_commands: []
```

Each `dotfiles_extra_files` item accepts `path`, `content`, and the optional `owner`, `group`,
`mode` and `become`; `become` defaults to `true` outside `/home`. Each `dotfiles_post_commands` item
is either a command string or a dict with `cmd`, `creates` and `become`.

The clone, the Vim plugins, the extra files and the post commands run without privilege escalation
by default, so point `dotfiles_home` at the user whose session Ansible runs as.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: dotfiles
      vars:
        dotfiles_repo_url: https://github.com/example/dotfiles.git
        dotfiles_extra_files:
          - path: ~/.config/htop/htoprc
            content: |
              hide_kernel_threads=1
```

## License

MIT
