# Ansible Role: Git

Ansible role that installs Git and a set of companion packages, installs
[git-open](https://github.com/paulirish/git-open), writes gitconfig files and clones repositories.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
git_extra_packages:
  - git-doc
  - git-gui
  - gitk
  - qgit
  - tig

git_open_version: 41ebfceb

git_open_dl_url: https://raw.githubusercontent.com/paulirish/git-open/{{ git_open_version }}/git-open

git_open_bin_path: /usr/local/bin/git-open

# git_config: |
#   [user]
#     name = Example User
#     email = example.user@domain.com
#   [color]
#     ui = always
#   [init]
#     defaultBranch = main
git_config_content: ""

# git_config_files:
#   - /etc/gitconfig
#   - path: /home/{{ ansible_user }}/.gitconfig
#     owner: "{{ ansible_user }}"
#   - path: /root/.gitconfig
#     owner: root
git_config_files: []

# git_repos:
#   - repo: https://github.com/example/my-repo.git
#     dest: ~/my-repo
#     version: main
#     update_dest: true
#     scripts:
#       - ./install.sh
git_repos: []
```

`git_config_content` is written to every path in `git_config_files`, either as a string or as a dict
with `path` and `owner`. Each `git_repos` item accepts the `git` module's `repo`, `dest`, `version`
and `update_dest`, plus `become` and a list of `scripts`; a script item is a command string or a
dict with `cmd`, `chdir`, `creates`, `become`, `changed_stdout` and `changed_stderr`.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: git
      vars:
        git_config_content: |
          [user]
            name = Example User
            email = example.user@domain.com
        git_config_files:
          - path: /home/{{ ansible_user }}/.gitconfig
            owner: "{{ ansible_user }}"
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
