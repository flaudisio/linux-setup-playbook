# Ansible Role: Spotify

Ansible role that installs the Spotify client from Spotify's own APT repository.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Ref: https://www.spotify.com/br-en/download/linux/

spotify_apt_repo_name: spotify

spotify_apt_repo_key_url: https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc
spotify_apt_repo_key_file: /etc/apt/trusted.gpg.d/spotify.asc

spotify_apt_repo_uri: https://repository.spotify.com
spotify_apt_repo_suite: stable
spotify_apt_repo_component: non-free
```

The package's `postinst` recreates `/etc/apt/sources.list.d/spotify.list`, so the role writes that
file as a comment-only stub and keeps the real repository definition in the deb822 `spotify.sources`
entry next to it.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: spotify
```

## License

MIT
