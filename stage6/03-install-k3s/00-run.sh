#!/bin/bash -e

curl -sfL https://get.k3s.io > k3s_installer.sh
install -m 644 k3s_installer.sh "${ROOTFS_DIR}/usr/bin/k3s_installer.sh"
sed -i "s#-d /run/systemd#true#g" "${ROOTFS_DIR}/usr/bin/k3s_installer.sh"
sed -i "s#curl -w#curl --insecure -w#g" "${ROOTFS_DIR}/usr/bin/k3s_installer.sh"
sed -i "s#curl -o#curl --insecure -o#g" "${ROOTFS_DIR}/usr/bin/k3s_installer.sh"


INSTALL_K3S_ARGS="${INSTALL_K3S_ARGS} --docker --kubelet-arg='feature-gates=DevicePlugins=true'"

on_chroot << EOF
chmod +x /usr/bin/k3s_installer.sh
INSTALL_K3S_SKIP_START=true INSTALL_K3S_SYMLINK=force /usr/bin/k3s_installer.sh ${INSTALL_K3S_ARGS}
EOF

# Fixes for Buster
on_chroot << EOF
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
EOF
