#!/bin/sh

# Update FreeBSD system
freebsd-update fetch install
pkg update -f
pkg upgrade -y

# Install necessary packages
pkg install -y sudo nano drm-kmod xorg firefox noto-kr lightdm-gtk-greeter xfce xfce4-goodies dbus fcitx5-gtk fcitx5-configtool ko-fcitx5-hangul wifimgr

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
sysrc -f /etc/rc.conf wlans_iwn0="wlan0"
sysrc -f /etc/rc.conf ifconfig_wlan0="WPA SYNCDHCP"

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

# Firefox optimization
# Set the following sysctl values to optimize Firefox performance
sysctl net.inet.tcp.delayed_ack=0
sysctl net.inet.tcp.soreceive_stream=1
sysctl net.inet.tcp.sendbuf_max=16777216
sysctl net.inet.tcp.recvbuf_max=16777216
sysctl net.inet.tcp.recvspace=4096
sysctl net.inet.tcp.sendpace=4096
sysctl kern.ipc.shm_allow_removed=1
sysctl kern.ipc.shmmax=67108864
sysctl kern.ipc.shmall=32768
sysctl vfs.zfs.arc_max=5368709120
sysctl kern.geom.trim.enabled=1

# Increase the maximum number of open files
sysctl kern.maxfiles=65536

# Disable debugging symbols
rm -f /usr/lib/debug/*

# Reboot the system
reboot
