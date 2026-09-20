instance-id: ${hostname}
local-hostname: ${hostname}
network:
  version: 2
  ethernets:
    ${interface}:
      addresses: [${ip_address}/${netmask}]
      gateway4: ${gateway}
      nameservers:
        addresses: [${dns}]
