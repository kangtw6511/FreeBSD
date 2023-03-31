#!/bin/sh

# Update FreeBSD system
freebsd-update fetch install
pkg update -f
pkg upgrade -y

# Install necessary packages
pkg install -y sudo nano drm-kmod xorg noto-fonts lightdm-gtk-greeter xfce xfce4-goodies dbus fcitx5-gtk fcitx5-configtool ko-fcitx5-hangul wifimgr

# Configure system settings
echo 'kld_list="i915kms"' >> /boot/loader.conf.local
sysrc kld_list+="i915kms"
sysrc background_dhclient="YES"
sysrc lightdm_enable="YES"
sysrc dbus_enable="YES"
sysrc fcitx_enable="YES"
sysrc fcitx_program_variable="FCITX5"
sysrc fcitx_flags="-d"

# Configure sudo access for the wheel group
sed -i '' 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /usr/local/etc/sudoers

# Add user to wheel and video groups
pw groupmod video -m kang
pw groupmod wheel -m kang

# Configure network settings
sysrc wlans_iwn0="wlan0"
sysrc ifconfig_wlan0="WPA SYNCDHCP"

# Set audio settings
mixer mic 50:50
mixer vol 95:95

# Configure input method
echo 'export GTK_IM_MODULE=fcitx' >> /etc/profile
echo 'export QT_IM_MODULE=fcitx' >> /etc/profile
echo 'export XMODIFIERS="@im=fcitx"' >> /etc/profile

# Configure locale
echo 'ko_KR.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=ko_KR.UTF-8' > /etc/locale.conf

# Configure virtual terminal type
sysrc kern.vty="vt"

# Add /proc filesystem to /etc/fstab
echo 'proc /proc procfs rw 0 0' >> /etc/fstab

# Increase the maximum number of open files
sysctl kern.maxfiles=65536

# Disable debugging symbols
rm -f /usr/lib/debug/*

# Reboot the system
reboot
