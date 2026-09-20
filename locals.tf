locals {
  # "Kubernetes the Hard Way" node layout. IPs follow the course's own
  # convention (10.240.0.0/24) so its docs/scripts need minimal edits.
  nodes = {
    controller-0 = { ip = "10.240.0.10", cpu = 2, memory = 2048, disk = 40, pod_cidr = null }
    controller-1 = { ip = "10.240.0.11", cpu = 2, memory = 2048, disk = 40, pod_cidr = null }
    controller-2 = { ip = "10.240.0.12", cpu = 2, memory = 2048, disk = 40, pod_cidr = null }
    worker-0     = { ip = "10.240.0.20", cpu = 2, memory = 2048, disk = 40, pod_cidr = "10.200.0.0/24" }
    worker-1     = { ip = "10.240.0.21", cpu = 2, memory = 2048, disk = 40, pod_cidr = "10.200.1.0/24" }
    worker-2     = { ip = "10.240.0.22", cpu = 2, memory = 2048, disk = 40, pod_cidr = "10.200.2.0/24" }
  }
}
