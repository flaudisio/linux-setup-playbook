# Ansible Role: Google Chrome

Ansible role that installs the Google Chrome stable package from the vendor `.deb` and optionally
selects it as the default browser.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
chrome_package_url: https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

chrome_set_as_default_browser: false
```

The default URL points at the `amd64` package; set `chrome_package_url` to the `arm64` one on
aarch64 hosts. The package is installed in place of the distribution build, which also adds
Google's own APT repository to the host.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: chrome
      vars:
        chrome_set_as_default_browser: true
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
