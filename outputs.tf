output "node_ips" {
  value = { for k, v in local.nodes : k => v.ip }
}

output "controller_ips" {
  value = [for k, v in local.nodes : v.ip if strcontains(k, "controller")]
}

output "worker_ips" {
  value = [for k, v in local.nodes : v.ip if strcontains(k, "worker")]
}
