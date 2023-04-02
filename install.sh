#!/bin/sh

# Update FreeBSD system
freebsd-update install
pkg upgrade -y

# Install necessary packages
pkg install -y sudo nano xorg xfce4 firefox fcitx5 fcitx5-configtool ko-fcitx5-hangul lightdm lightdm-gtk-greeter wifimgr dsbmixer

# Configure system settings
sysrc background_dhclient=YES
sysrc dbus_enable=YES
sysrc lightdm_enable=YES

# Configure sudo access for the wheel group
sed -i '' 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /usr/local/etc/sudoers

# Add user to wheel and video groups
pw groupmod video -m kang
pw groupmod wheel -m kang

# Configure network settings
sysrc ifconfig_DEFAULT=DHCP

# Set audio settings
mixer mic 50:50
mixer vol 95:95

# Configure input method
echo 'export GTK_IM_MODULE=fcitx5 QT_IM_MODULE=fcitx5 XMODIFIERS="@im=fcitx5"' >> /etc/profile

# Configure locale
echo 'ko_KR.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=ko_KR.UTF-8' > /etc/locale.conf

# Set up graphical drivers for Intel graphics
sysrc kld_list="/boot/modules/i915kms.ko"

# Reboot the system
echo "The system will now reboot..."
sleep 5
shutdown -r now

