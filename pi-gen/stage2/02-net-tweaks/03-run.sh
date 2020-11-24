#!/bin/bash -e
install -v -m 644 files/30-wifi.network "${ROOTFS_DIR}/etc/systemd/network"

if [[ ! -z "${WLAN0_STATIC_IP}" ]] && [[ "${WLAN0_DHCP_SERVER}" == "1" ]]; then
  cat <<EOL > "${ROOTFS_DIR}/etc/systemd/network/30-wifi.network"
[Match]
Name=wlan0

[Network]
Address=${WLAN0_STATIC_IP}
MulticastDNS=yes
DHCPServer=yes

[DHCPServer]
DNS=8.8.8.8 8.8.4.4
EOL
elif [[ ! -z "${WLAN0_STATIC_IP}" ]]; then
  cat <<EOL > "${ROOTFS_DIR}/etc/systemd/network/30-wifi.network"
[Match]
Name=wlan0

[Network]
Address=${WLAN0_STATIC_IP}
EOL
fi


install -v -d	"${ROOTFS_DIR}/etc/wpa_supplicant"
install -v -m 600 files/wpa_supplicant-wlan0.conf	"${ROOTFS_DIR}/etc/wpa_supplicant/"

if [[ ! -z "${WPA_COUNTRY}" ]]; then
	echo "country=${WPA_COUNTRY}" >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant-wlan0.conf"
fi

# WPA-PSK AP
if [[ ! -z "${WPA_ESSID}" ]] && [[ ! -z "${WPA_PASSWORD}" ]] && [[ "${WIFI_MODE}" == "ap" ]]; then
  cat >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant-wlan0.conf" << EOL

network={
	mode=2
	ssid="${WPA_ESSID}"
	proto=RSN WPA
	key_mgmt=WPA-PSK
	psk="${WPA_PASSWORD}"
}
EOL
# WPA-PSK
elif [[ ! -z "${WPA_ESSID}" ]] && [[ ! -z "${WPA_PASSWORD}" ]] && [[ "${WIFI_MODE}" == "connect" ]]; then
  cat >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant-wlan0.conf" << EOL
ap_scan=1
fast_reauth=1

network={
	ssid="${WPA_ESSID}"
	psk="${WPA_PASSWORD}"
}
EOL
# NO PASSWORD
elif [[ ! -z "${WPA_ESSID}" ]]; then
  cat >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant-wlan0.conf" << EOL
ap_scan=1
fast_reauth=1

network={
	ssid="${WPA_ESSID}"
	key_mgmt=NONE
}
EOL
fi
