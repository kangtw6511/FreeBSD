#!/bin/sh

# Update FreeBSD system
freebsd-update fetch install
pkg update -f
pkg upgrade -y

# Install necessary packages
pkg install -y sudo nano drm-kmod xorg firefox noto-kr lightdm-gtk-greeter xfce xfce4-goodies dbus fcitx5-gtk fcitx5-configtool ko-fcitx5-hangul wifimgr

# Configure system settings
echo 'i915kms_load="YES"' >> /boot/loader.conf
sysrc -f /etc/rc.conf kld_list+="i915kms"
sysrc -f /etc/rc.conf background_dhclient="YES"
sysrc -f /etc/rc.conf lightdm_enable="YES"
sysrc -f /etc/rc.conf dbus_enable="YES"
sysrc -f /etc/rc.conf fcitx_enable="YES"
sysrc -f /etc/rc.conf fcitx_program_variable="FCITX5"
sysrc -f /etc/rc.conf fcitx_flags="-d"

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
sysrc -f /etc/rc.conf kern.vty="vt"

# Add /proc filesystem to /etc/fstab
echo 'proc /proc procfs rw 0 0' >> /etc/fstab

# Firefox optimization
# Set the following sysctl values to optimize Firefox performance
sysctl kern.ipc.shm_allow_removed=1
sysctl kern.ipc.shmmax=67108864
sysctl kern.ipc.shmall=32768
sysctl kern.ipc.maxsockbuf=2097152
sysctl net.local.stream.recvspace=16384
sysctl net.local.stream.sendspace=16384
sysctl net.inet.tcp.sendbuf_max=16777216
sysctl net.inet.tcp.recvbuf_max=16777216

# Increase the maximum number of open files
sysctl kern.maxfiles=65536

# Set ZFS ARC limit
sysctl vfs.zfs.arc_max=5368709120

# Enable TRIM support for SSDs
sysctl kern.geom.trim.enabled=1

# Disable debugging symbols
rm -f /usr/lib/debug/*

# Reboot the system
reboot

