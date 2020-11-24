#!/bin/bash -e

install -m 755 files/rfkill_unblock_once	"${ROOTFS_DIR}/etc/init.d/"

# Fix for Raspberry Pi OS
on_chroot << EOF
systemctl enable rfkill_unblock_once
EOF
