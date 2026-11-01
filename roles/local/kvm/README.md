# Ansible Role: KVM

Ansible role that installs KVM/QEMU and libvirt, adds users to the virtualization groups and can
switch off the libvirt QEMU security driver.

## Requirements

- A CPU with hardware virtualization enabled. The role asserts this before installing anything.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
kvm_install_server_packages: true

kvm_server_packages:
  - bridge-utils
  - libvirt-clients
  - libvirt-daemon-system
  - qemu-system-x86

kvm_install_virt_manager: false

kvm_virt_manager_packages:
  - virt-manager
  - gir1.2-spiceclientgtk-3.0
  - ssh-askpass-gnome

kvm_install_client_utilities: false

kvm_client_utilities_packages:
  # Provides 'cloud-localds'[1], which is useful to create a disk to use cloud-init + nocloud datasource
  # Ref: https://github.com/canonical/cloud-utils?tab=readme-ov-file#usage
  - cloud-image-utils
  # Provides 'mkisofs', which is used by e.g. the 'libvirt_cloudinit_disk' Terraform resource
  # Ref: https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit
  - genisoimage

kvm_system_groups:
  # Allow using Packer's QEMU builder as a regular user
  # Ref: https://developer.hashicorp.com/packer/integrations/hashicorp/qemu/latest/components/builder/qemu
  - kvm
  # Allow using 'virsh' as a regular user
  - libvirt

kvm_users: []

kvm_disable_libvirt_qemu_security_driver: false
```

`kvm_users` only appends the listed users to `kvm_system_groups`; it never removes the groups they
already belong to. Turning on `kvm_disable_libvirt_qemu_security_driver` sets
`security_driver = "none"` in `/etc/libvirt/qemu.conf` and restarts libvirtd, which avoids
permission errors on `/var/lib/libvirt/images` for the Terraform libvirt provider.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: kvm
      vars:
        kvm_install_virt_manager: true
        kvm_users:
          - ubuntu
```

## Testing

The role ships a molecule scenario using the Docker driver:

```bash
molecule test
```

## License

MIT
