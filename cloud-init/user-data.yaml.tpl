#cloud-config
hostname: ${hostname}
fqdn: ${hostname}.${domain}
manage_etc_hosts: true

users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_key}

package_update: true
packages:
  - conntrack
  - socat
  - open-vm-tools
