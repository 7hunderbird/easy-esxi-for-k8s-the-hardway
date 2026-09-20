variable "vsphere_server" {
  description = "IP or hostname of the ESXi host"
  type        = string
}

variable "vsphere_user" {
  type    = string
  default = "root"
}

variable "vsphere_password" {
  type      = string
  sensitive = true
}

variable "allow_unverified_ssl" {
  type    = bool
  default = true # standalone ESXi usually has a self-signed cert
}

variable "datacenter" {
  description = "Standalone ESXi always calls its implicit datacenter this"
  type        = string
  default     = "ha-datacenter"
}

variable "esxi_host" {
  description = "Name of the host as it appears in vSphere (often same as vsphere_server)"
  type        = string
}

variable "datastore" {
  type = string
}

variable "network" {
  description = "Port group name for the lab network"
  type        = string
}

variable "ovf_path" {
  description = "Path to the Ubuntu cloud OVA file - deployed fresh for each node since clone{} needs vCenter"
  type        = string
}

variable "gateway" {
  type    = string
  default = "10.240.0.1"
}

variable "dns_server" {
  type    = string
  default = "1.1.1.1"
}

variable "domain" {
  type    = string
  default = "k8s.local"
}

variable "node_interface" {
  description = "Interface name inside the guest OS - confirm with `ip -brief link` on a running node"
  type        = string
  default     = "ens192"
}

variable "ssh_public_key" {
  description = "Your public key, injected into the ubuntu user via cloud-init"
  type        = string
}
