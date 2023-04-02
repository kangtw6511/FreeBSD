#!/bin/sh

# Update FreeBSD system
freebsd-update fetch install
pkg update -f
pkg upgrade -y

# Install necessary packages
pkg install -y sudo nano xorg xfce4 firefox fcitx5 fcitx5-configtool ko-fcitx5-hangul lightdm wifimgr dsbmixer

# Configure system settings
echo 'kern.vty="vt"' >> /etc/sysctl.conf
echo 'background_dhclient="YES"' >> /etc/rc.conf
echo 'dbus_enable="YES"' >> /etc/rc.conf
echo 'lightdm_enable="YES"' >> /etc/rc.conf

# Configure sudo access for the wheel group
sed -i '' 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /usr/local/etc/sudoers

# Add user to wheel and video groups
pw groupmod video -m kang
pw groupmod wheel -m kang

# Configure network settings
echo 'ifconfig_DEFAULT="DHCP"' >> /etc/rc.conf

# Set audio settings
mixer mic 50:50
mixer vol 95:95

# Configure input method
echo 'export GTK_IM_MODULE=fcitx5' >> /etc/profile
echo 'export QT_IM_MODULE=fcitx5' >> /etc/profile
echo 'export XMODIFIERS="@im=fcitx5"' >> /etc/profile

# Configure locale
echo 'ko_KR.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=ko_KR.UTF-8' > /etc/locale.conf

# Set up graphical drivers for Intel graphics
echo 'kld_list="/boot/modules/i915kms.ko"' >> /etc/rc.conf

# Reboot the system
echo "The system will now reboot..."
sleep 5
shutdown -r now

