#!/bin/sh

# Update FreeBSD system
freebsd-update fetch install
pkg update -f
pkg upgrade -y

# Install necessary packages
pkg install -y sudo nano drm-kmod xorg firefox noto-kr lightdm-gtk-greeter xfce xfce4-goodies dbus fcitx5-gtk fcitx5-configtool ko-fcitx5-hangul wifimgr

# Configure system settings
echo 'kld_list="i915kms"' >> /boot/loader.conf
sysrc -f /etc/rc.conf lightdm_enable="YES"
sysrc -f /etc/rc.conf dbus_enable="YES"
sysrc -f /etc/rc.conf fcitx_enable="YES"
sysrc -f /etc/rc.conf fcitx_program_variable="FCITX5"
sysrc -f /etc/rc.conf fcitx_flags="-d"

# Configure sudo access for the wheel group
pw groupmod wheel -m kang
echo '%wheel ALL=(ALL) ALL' > /usr/local/etc/sudoers.d/wheel

# Add user to video group
pw groupmod video -m kang

# Configure network settings
sysrc -f /etc/rc.conf wlans_iwm0="wlan0"
sysrc -f /etc/rc.conf ifconfig_wlan0="WPA DHCP"

# Set audio settings
mixer mic 50:50
mixer vol 95:95

# Configure input method
echo 'GTK_IM_MODULE=fcitx5' >> /etc/env.d/99fcitx5
echo 'QT_IM_MODULE=fcitx5' >> /etc/env.d/99fcitx5
echo 'XMODIFIERS="@im=fcitx5"' >> /etc/env.d/99fcitx5
echo 'export GTK_IM_MODULE QT_IM_MODULE XMODIFIERS' >> /etc/profile

# Configure locale
echo 'ko_KR.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=ko_KR.UTF-8' > /etc/locale.conf

# Configure virtual terminal type
sysrc -f /etc/rc.conf kern.vty="vt"

# Add /proc filesystem to /etc/fstab
echo 'proc /proc procfs rw 0 0' >> /etc/fstab

# Firefox optimization
# Set the following sysctl values to optimize Firefox performance
sysctl net.inet.tcp.sendbuf_max=2097152
sysctl net.inet.tcp.recvbuf_max=2097152
sysctl kern.ipc.shm_allow_removed=1
sysctl kern.ipc.shmmax=1073741824
sysctl kern.ipc.shmall=32768
sysctl net.local.stream.recvspace=8192
sysctl net.local.stream.sendspace=8192
sysctl kern.maxfiles=65536
sysctl vfs.zfs.arc_max=1073741824
sysctl kern.geom.trim.enabled=1

# Disable debugging symbols
rm -rf /usr/lib/debug/*

# Reboot the system
reboot

