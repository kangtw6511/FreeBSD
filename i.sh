#!/bin/sh

# Update package manager and install essential packages
echo "Installing essential packages"
echo "-----------------------------"
pkg update
pkg install -y nano git

# Configure network settings
sysrc -f /etc/rc.conf wlans_iwm0="wlan0"
sysrc -f /etc/rc.conf ifconfig_wlan0="WPA DHCP"

# Set audio settings
mixer vol 95:95
mixer mic 50:50

# Install Xfce desktop environment and related packages
echo "Installing Xfce desktop environment"
echo "-----------------------------------"
pkg install -y xorg xfce lightdm-gtk-greeter

# Configure LightDM display manager
echo "Configuring LightDM display manager"
echo "-----------------------------------"
sysrc -f /etc/rc.conf lightdm_enable="YES"
echo "[SeatDefaults]" > /usr/local/etc/lightdm/lightdm.conf
echo "greeter-session=lightdm-gtk-greeter" >> /usr/local/etc/lightdm/lightdm.conf
echo "autologin-user=kang" >> /usr/local/etc/lightdm/lightdm.conf

# Install Fcitx5 input method framework and related packages
echo "Installing Fcitx5 input method framework"
echo "---------------------------------------"
pkg install -y fcitx5-gtk fcitx5-configtool ko-fcitx5-hangul

# Configure Fcitx5 input method framework
echo "Configuring Fcitx5 input method framework"
echo "-----------------------------------------"
echo "export GTK_IM_MODULE=fcitx5" >> /usr/local/etc/profile
echo "export QT_IM_MODULE=fcitx5" >> /usr/local/etc/profile
echo "export XMODIFIERS=@im=fcitx5" >> /usr/local/etc/profile

# Install Wi-Fi manager
echo "Installing Wi-Fi manager"
echo "------------------------"
pkg install -y networkmgr

# Done!
echo "Setup completed successfully!"
