#!/bin/bash -e

install -v -d					"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d"
install -v -m 644 files/wait.conf "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/"

install -v -d					"${ROOTFS_DIR}/etc/systemd/network"
