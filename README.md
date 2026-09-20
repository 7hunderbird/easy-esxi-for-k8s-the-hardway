# Kubernetes the Hard Way - ESXi/Terraform lab

Provisions 6 VMs (3 controllers, 3 workers) on a standalone ESXi host for
Kelsey Hightower's "Kubernetes the Hard Way" course.

## Prerequisites (do these once, before `terraform apply`)

1. **A dedicated port group / VLAN on the ESXi host** for the lab, isolated
   from your other VMs. This is what gives you the routable 10.240.0.0/24
   subnet the course expects, instead of fighting Hyper-V/NAT semantics.
   Create it in the vSphere client under Networking, or via `esxcli
   network vswitch`.

2. **A cloud-init-enabled Ubuntu template already on the host.** This config
   clones a template rather than installing from ISO. To build one:
   - Download the official Ubuntu 22.04 cloud image (the `.ova` or convert
     the `.img` with `qemu-img` / `govc import.ova`)
   - Import it to the ESXi host as a VM, convert to template (or just leave
     it powered off - `vsphere_virtual_machine` can clone a regular VM too)
   - Ubuntu cloud images ship with cloud-init already configured to read
     the VMware GuestInfo datasource, which is what `extra_config` in
     `main.tf` writes to - no ISO attachment needed

3. **Terraform >= 1.5** and the credentials for the ESXi host's root (or a
   service account with enough privilege to create/clone VMs).

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your actual host, datastore, network, template, SSH key

terraform init
terraform plan
terraform apply
```

`terraform output node_ips` gives you the full IP map when it's done.

## Things you'll likely need to adjust

- **Network interface name** in `cloud-init/user-data.yaml.tpl` - it
  assumes `ens192` (typical for VMXNET3 + predictable naming). Check your
  template with `ip link` and change it if needed.
- **`datastore` name** - find it in the vSphere client under Storage, or
  `esxcli storage filesystem list` on the host.
- **`network` name** - must match the port group name exactly.
- Disk/CPU/RAM per node live in `locals.tf` - given the R710's headroom
  there's no need to trim these down; bump them up if you want room to
  actually run workloads after finishing the course.

## What this does NOT do

This only stands up the VMs with networking and SSH access - it does not
run the Kubernetes the Hard Way steps themselves (cert generation, kubeconfig
generation, control plane binaries, etc.). That part is manual by design;
that's the whole point of the course. Once `terraform apply` finishes you
should be able to `ssh ubuntu@10.240.0.10` etc. and pick up the course from
its "Provisioning Compute Resources" step, treating these as already done.
