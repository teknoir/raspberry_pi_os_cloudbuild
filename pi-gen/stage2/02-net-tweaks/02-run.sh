#!/bin/bash -e
install -v -m 644 files/20-ethernet.network "${ROOTFS_DIR}/etc/systemd/network"

if [[ ! -z "${ETH0_STATIC_IP}" ]] && [[ "${ETH0_DHCP_SERVER}" == "1" ]]; then
  cat <<EOL > "${ROOTFS_DIR}/etc/systemd/network/20-ethernet.network"
[Match]
Name=eth0

[Network]
Address=${ETH0_STATIC_IP}
MulticastDNS=yes
DHCPServer=yes

[DHCPServer]
DNS=8.8.8.8 8.8.4.4
EOL
elif [[ ! -z "${ETH0_STATIC_IP}" ]]; then
  cat <<EOL > "${ROOTFS_DIR}/etc/systemd/network/20-ethernet.network"
[Match]
Name=eth0

[Network]
Address=${ETH0_STATIC_IP}
EOL
fi