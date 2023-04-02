#!/bin/sh

# Update FreeBSD system
freebsd-update fetch install
pkg update -f
pkg upgrade -y

# Install necessary packages
pkg install -y sudo nano drm-kmod xorg firefox xfce xfce4-goodies fcitx5 fcitx5-configtool ko-fcitx5-hangul wifimgr dsbmixer

# Configure system settings
echo 'kld_list="/boot/modules/i915kms.ko"' >> /etc/rc.conf
echo 'background_dhclient="YES"' >> /etc/rc.conf
echo 'lightdm_enable="YES"' >> /etc/rc.conf
echo 'dbus_enable="YES"' >> /etc/rc.conf
echo 'fcitx_enable="YES"' >> /etc/rc.conf
echo 'fcitx_program_variable="FCITX5"' >> /etc/rc.conf
echo 'fcitx_flags="-d"' >> /etc/rc.conf

# Configure sudo access for the wheel group
sed -i '' 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /usr/local/etc/sudoers

# Add user to wheel and video groups
pw groupmod video -m kang
pw groupmod wheel -m kang

# Configure network settings
echo 'wlans_iwn0="wlan0"' >> /etc/rc.conf
echo 'ifconfig_wlan0="WPA SYNCDHCP"' >> /etc/rc.conf

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
echo 'kern.vty="vt"' >> /etc/sysctl.conf

# Add /proc filesystem to /etc/fstab
echo 'proc /proc procfs rw 0 0' >> /etc/fstab

# Reboot the system
echo "The system will now reboot..."
sleep 5
shutdown -r now

