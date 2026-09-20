resource "vsphere_virtual_machine" "node" {
  for_each = local.nodes

  name             = each.key
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  datacenter_id    = data.vsphere_datacenter.dc.id

  num_cpus = each.value.cpu
  memory   = each.value.memory

  # Attached explicitly rather than via ovf_network_map, which doesn't
  # reliably translate its synthetic "HaNetwork-..." ID into a real
  # network reference during OVF import on a standalone ESXi host.
  network_interface {
    network_id = data.vsphere_network.network.id
  }

  # Don't wait on guest tools to report an IP - cloud-init sets the
  # static IP itself and the ordering can otherwise cause apply to hang.
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  # NOTE: clone{} requires vCenter and does not work against a standalone
  # ESXi host. ovf_deploy re-imports the OVA fresh for each VM instead -
  # slower than a true clone, but this is the same import mechanism that
  # already worked manually through the Host Client, so it works here too.
  ovf_deploy {
    local_ovf_path    = var.ovf_path
    disk_provisioning = "thin"
  }

  # No vsphere "customize" block - that path uses VMware Tools guest
  # customization, which is fussier to get working on a bare ESXi host.
  # Instead we hand cloud-init its config directly via GuestInfo, which
  # any cloud-init image (Ubuntu cloud images, etc.) reads on first boot.
  extra_config = {
    "guestinfo.userdata" = base64encode(templatefile("${path.module}/cloud-init/user-data.yaml.tpl", {
      hostname = each.key
      domain   = var.domain
      ssh_key  = var.ssh_public_key
    }))
    "guestinfo.userdata.encoding" = "base64"
    "guestinfo.metadata" = base64encode(templatefile("${path.module}/cloud-init/meta-data.yaml.tpl", {
      hostname   = each.key
      interface  = var.node_interface
      ip_address = each.value.ip
      netmask    = "24"
      gateway    = var.gateway
      dns        = var.dns_server
    }))
    "guestinfo.metadata.encoding" = "base64"
  }
}
