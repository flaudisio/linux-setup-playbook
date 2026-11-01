# Ansible Role: Cinc Workstation

Ansible role that installs [Cinc Workstation](https://cinc.sh) (the community build of Chef
Workstation) from the Omnitruck package service.

## Requirements

- Outbound access to `https://omnitruck.cinc.sh`, unless `cinc_workstation_package_url` points to a
  mirror.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Ref: curl -sSL 'https://omnitruck.cinc.sh/stable/cinc-workstation/packages'

cinc_workstation_version: 24.12.1073

# cinc_workstation_package_url: https://example.com/cinc-workstation_24.12.1073-1_amd64.deb
cinc_workstation_package_url: ""
```

With an empty `cinc_workstation_package_url` the role asks the Omnitruck API for the package URL and
SHA-256 checksum of the requested version on the current distribution; with a URL set it downloads
that file and skips the checksum. Both `.deb` and `.rpm` packages are supported.

The role reads the installed version from `cinc --version` and skips the download when it already
matches `cinc_workstation_version`.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: cinc-workstation
      vars:
        cinc_workstation_version: 24.12.1073
```

## License

MIT
