#!/bin/bash -e

#files/rsa_public.pem & files/rsa_private.pem should be copied by buildscript
curl -sfL https://pki.goog/roots.pem > files/roots.pem
mkdir -p "${ROOTFS_DIR}/toe_conf"
install -m 644 files/roots.pem "${ROOTFS_DIR}/toe_conf/roots.pem"
install -m 644 files/rsa_public.pem "${ROOTFS_DIR}/toe_conf/rsa_public.pem"
install -m 644 files/rsa_private.pem "${ROOTFS_DIR}/toe_conf/rsa_private.pem"

mkdir -p "${ROOTFS_DIR}/var/lib/rancher/k3s/server/manifests"
install -m 644 files/mqtt-broker-service.yaml "${ROOTFS_DIR}/var/lib/rancher/k3s/server/manifests/mqtt-broker-service.yaml"
install -m 644 files/service-account.yaml "${ROOTFS_DIR}/var/lib/rancher/k3s/server/manifests/service-account.yaml"
install -m 644 files/toe-deployment.yaml "${ROOTFS_DIR}/var/lib/rancher/k3s/server/manifests/toe-deployment.yaml"
cat files/toe-deployment.yaml | envsubst | tee "${ROOTFS_DIR}/var/lib/rancher/k3s/server/manifests/toe-deployment.yaml"