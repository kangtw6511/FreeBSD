#!/bin/sh

# Check if running as root
if [ $(id -u) -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Update package repository and upgrade installed packages
pkg update -f
pkg upgrade -y

# Install necessary packages
pkg install -y sudo xorg lightdm-gtk-greeter xfce xfce4-goodies dbus wifimgr drm-kmod firefox

# Configure sudo access for wheel group
sed -i '' 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /usr/local/etc/sudoers

# Add user to wheel and video groups
pw groupmod wheel -m "$(whoami)"
pw groupmod video -m "$(whoami)"

# Configure boot settings
sysrc autoboot_delay="2"
sysrc background_dhclient="YES"
sysrc kld_list+="i915kms"
sysrc lightdm_enable="YES"
sysrc dbus_enable="YES"
sysrc kern.vty="vt"

# Configure network settings
if ifconfig | grep -q 'wlan0'; then
  sysrc wlans_iwn0="wlan0"
  sysrc ifconfig_wlan0="WPA SYNCDHCP"
elif ifconfig | grep -q 'iwm0'; then
  sysrc wlans_iwm0="iwm0"
  sysrc ifconfig_iwm0="WPA SYNCDHCP"
else
  echo "Wi-Fi interface not found"
fi

# Set audio settings
mixer mic 50:50
mixer vol 95:95

# Add /proc filesystem to /etc/fstab
if ! grep -q 'proc /proc procfs rw 0 0' /etc/fstab; then
  echo 'proc /proc procfs rw 0 0' >> /etc/fstab
fi

# Reboot the system
shutdown -r now

