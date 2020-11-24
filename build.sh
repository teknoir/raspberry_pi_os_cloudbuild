#!/bin/bash -e

# Start by copying a new default config file
cp config ./pi-gen/config

[[ -z "$_RSA_PRIVATE" ]] && { echo "Error: _RSA_PRIVATE not found set"; exit 1; }
echo "${_RSA_PRIVATE}" > pi-gen/stage3/04-install-toe-and-devstudio/files/rsa_private.pem
chmod 600 pi-gen/stage6/04-install-toe-and-devstudio/files/rsa_private.pem
openssl rsa -in pi-gen/stage6/04-install-toe-and-devstudio/files/rsa_private.pem -out pi-gen/stage2/01-sys-tweaks/files/id_rsa

[[ -z "$_RSA_PUBLIC" ]] && { echo "Error: _RSA_PUBLIC not found set"; exit 1; }
echo "${_RSA_PUBLIC}" > pi-gen/stage6/04-install-toe-and-devstudio/files/rsa_public.pem
ssh-keygen -yf pi-gen/stage6/04-install-toe-and-devstudio/files/rsa_private.pem > pi-gen/stage2/01-sys-tweaks/files/id_rsa.pub

[[ -z "${_GCP_PROJECT}" ]] && { echo "Error: _GCP_PROJECT not found set"; exit 1; }
echo "GCP_PROJECT=\"${_GCP_PROJECT}\"" >> ./pi-gen/config

[[ -z "${_IOT_REGISTRY}" ]] && { echo "Error: _IOT_REGISTRY not found set"; exit 1; }
echo "IOT_REGISTRY=\"${_IOT_REGISTRY}\"" >> ./pi-gen/config

[[ -z "$_DEVICE_ID" ]] && { echo "Error: _DEVICE_ID not found set"; exit 1; }
echo "DEVICE_ID=\"${_DEVICE_ID}\"" >> ./pi-gen/config
echo "IMG_NAME=\"${_DEVICE_ID}\"" >> ./pi-gen/config

[[ -z "$_TARGET_HOSTNAME" ]] && { echo "Error: _TARGET_HOSTNAME not found set"; exit 1; }
echo "TARGET_HOSTNAME=\"${_TARGET_HOSTNAME}\"" >> ./pi-gen/config

# Wifi section

if [[ -z "${_WIFI_MODE}" ]]; then
  echo "Error: _WIFI_MODE not found set"
  exit 1
else
  echo "WIFI_MODE=\"${_WIFI_MODE}\"" >> ./pi-gen/config

  if [[ "${_WIFI_MODE}" == "connect" ]] || [[ "${_WIFI_MODE}" == "ap" ]]; then
    if [[ -z "${_WIFI_ESSID}" ]]; then
      echo "Warning: _WIFI_ESSID not found set"
    else
      echo "WPA_ESSID=\"${_WIFI_ESSID}\"" >> ./pi-gen/config
    fi

    if [[ -z "${_WIFI_PASSWORD}" ]]; then
      echo "Warning: _WIFI_PASSWORD not found set"
    else
      echo "WPA_PASSWORD=\"${_WIFI_PASSWORD}\"" >> ./pi-gen/config
    fi

    if [[ -z "${_WIFI_COUNTRY}" ]]; then
      echo "Warning: _WIFI_COUNTRY not found set"
    else
      echo "WPA_COUNTRY=\"${_WIFI_COUNTRY}\"" >> ./pi-gen/config
    fi
  fi

  if [[ "${_WIFI_MODE}" == "ap" ]]; then
    echo "WLAN0_DHCP_SERVER=1" >> ./pi-gen/config
    if [[ -z "${_WIFI_IP}" ]] || [[ -z "${_WIFI_SUBNET}" ]]; then
      echo "Warning: _WIFI_IP or _WIFI_SUBNET not found set"
    else
      echo "WLAN0_STATIC_IP=\"${_WIFI_IP}/${_WIFI_SUBNET}\"" >> ./pi-gen/config
    fi
  fi
fi

# Ethernet section

if [[ -z "${_ETH_MODE}" ]]; then
  echo "Error: _ETH_MODE not found set"
  exit 1
else
  echo "ETH_MODE=\"${_ETH_MODE}\"" >> ./pi-gen/config

  if [[ "${_ETH_MODE}" == "static" ]] || [[ "${_ETH_MODE}" == "dhcp" ]]; then
    if [[ -z "${_ETH_IP}" ]] || [[ -z "${_ETH_SUBNET}" ]]; then
      echo "Warning: _ETH_IP or _ETH_SUBNET not found set"
    else
      echo "ETH0_STATIC_IP=\"${_ETH_IP}/${_ETH_SUBNET}\"" >> ./pi-gen/config
    fi
  fi

  if [[ "${_ETH_MODE}" == "dhcp" ]]; then
    echo "ETH0_DHCP_SERVER=1" >> ./pi-gen/config
  fi
fi

# User and SSH section

if [[ -z "${_ENABLE_SSH}" ]]; then
  echo "Error: _ENABLE_SSH not found set"
  exit 1
else
  echo "ENABLE_SSH=\"${_ENABLE_SSH}\"" >> ./pi-gen/config
fi

if [[ -z "${_USER_MODE}" ]]; then
  echo "Error: _USER_MODE not found set"
  exit 1
else
  echo "USER_MODE=\"${_USER_MODE}\"" >> ./pi-gen/config

  [[ -z "${_FIRST_USER_NAME}" ]] && { echo "Error: _FIRST_USER_NAME not found set"; exit 1; }
  echo "FIRST_USER_NAME=\"${_FIRST_USER_NAME}\"" >> ./pi-gen/config

  [[ -z "${_FIRST_USER_PASS}" ]] && { echo "Error: _FIRST_USER_PASS not found set"; exit 1; }
  echo "FIRST_USER_PASS=\"${_FIRST_USER_PASS}\"" >> ./pi-gen/config

  if [[ "${_USER_MODE}" == "key" ]]; then
    echo "SSH_DISABLE_PASSWORD_LOGIN=1" >> ./pi-gen/config

    if [[ -z "${_FIRST_USER_KEY}" ]]; then
      echo "Warning: _FIRST_USER_KEY not found set"
    else
      echo "SSH_AUTHORIZED_KEYS=\"${_FIRST_USER_KEY}\"" >> ./pi-gen/config
    fi
  fi
fi

pushd pi-gen
./build-docker.sh
popd