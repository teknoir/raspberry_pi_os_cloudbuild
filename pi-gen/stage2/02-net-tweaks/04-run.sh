#!/bin/bash -e
ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"

on_chroot << EOF
systemctl enable systemd-resolved.service
systemctl enable systemd-networkd.service
systemctl enable wpa_supplicant@wlan0.service
EOF
