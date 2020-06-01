#!/bin/bash -e

docker_gpg_key="$(curl -fsSL https://download.docker.com/linux/debian/gpg)"

install -m 644 files/docker.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/docker.list"

on_chroot << EOF
echo "$docker_gpg_key" | apt-key add -
apt-get update
EOF
