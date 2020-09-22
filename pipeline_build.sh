#!/bin/bash -e

[[ -z "$_RSA_PRIVATE" ]] && { echo "Error: _RSA_PRIVATE not found set"; exit 1; }
[[ -z "$_RSA_PUBLIC" ]] && { echo "Error: _RSA_PUBLIC not found set"; exit 1; }
[[ -z "$_GCP_PROJECT" ]] && { echo "Error: _GCP_PROJECT not found set"; exit 1; }
[[ -z "$_IOT_REGISTRY" ]] && { echo "Error: _IOT_REGISTRY not found set"; exit 1; }
[[ -z "$_DEVICE_ID" ]] && { echo "Error: _DEVICE_ID not found set"; exit 1; }
[[ -z "$_TARGET_HOSTNAME" ]] && { echo "Error: _TARGET_HOSTNAME not found set"; exit 1; }
[[ -z "$_WPA_ESSID" ]] && { echo "Error: _WPA_ESSID not found set"; exit 1; }
[[ -z "$_WPA_PASSWORD" ]] && { echo "Error: _WPA_PASSWORD not found set"; exit 1; }
[[ -z "$_WPA_COUNTRY" ]] && { echo "Error: _WPA_COUNTRY not found set"; exit 1; }
[[ -z "$_ENABLE_SSH" ]] && { echo "Error: _ENABLE_SSH not found set"; exit 1; }
[[ -z "$_FIRST_USER_NAME" ]] && { echo "Error: _FIRST_USER_NAME not found set"; exit 1; }
[[ -z "$_FIRST_USER_PASS" ]] && { echo "Error: _FIRST_USER_PASS not found set"; exit 1; }

cp -rf stage6 pi-gen/
cp -rf config.sh pi-gen/config

echo "${_RSA_PRIVATE}" > pi-gen/stage6/04-install-toe-and-devstudio/files/rsa_private.pem
echo "${_RSA_PUBLIC}" > pi-gen/stage6/04-install-toe-and-devstudio/files/rsa_public.pem
cat toe-deployment.yaml | sed "s/{DEVICE_ID}/${_DEVICE_ID}/g" | sed "s/{GCP_PROJECT}/${_GCP_PROJECT}/g" | sed "s/{IOT_REGISTRY}/${_IOT_REGISTRY}/g" | cat - > pi-gen/stage6/04-install-toe-and-devstudio/files/toe-deployment.yaml

echo "TARGET_HOSTNAME=\"${_TARGET_HOSTNAME}\"" >> pi-gen/config
echo "WPA_ESSID=\"${_WPA_ESSID}\"" >> pi-gen/config
echo "WPA_PASSWORD=\"${_WPA_PASSWORD}\"" >> pi-gen/config
echo "WPA_COUNTRY=\"${_WPA_COUNTRY}\"" >> pi-gen/config
echo "ENABLE_SSH=\"${_ENABLE_SSH}\"" >> pi-gen/config
echo "FIRST_USER_NAME=\"${_FIRST_USER_NAME}\"" >> pi-gen/config
echo "FIRST_USER_PASS=\"${_FIRST_USER_PASS}\"" >> pi-gen/config

pushd pi-gen
./build.sh
popd