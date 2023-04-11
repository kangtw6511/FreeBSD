#!/bin/bash

# Arch Linux GNOME 최적화 스크립트
# 최신 기술을 활용한 경량화와 성능 향상을 목표로 합니다.

# 기본적인 시스템 업데이트 및 업그레이드
sudo pacman -Syu

# GNOME 최적화 패키지 설치
sudo pacman -S gnome-tweaks xorg-server xorg-xinit mesa xf86-video-intel

# 필수 응용 프로그램 설치
sudo pacman -S firefox vlc gnome-system-monitor gedit gnome-calculator gnome-terminal gnome-control-center

# Swap 설정 변경
sudo sysctl vm.swappiness=10
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-sysctl.conf

# CPU 성능 모드 변경
sudo systemctl enable --now cpupower.service
sudo cpupower frequency-set -g performance
echo 'ACTION=="add", SUBSYSTEM=="module", KERNEL=="intel_rapl", ATTR{parameters}=="restrict_performance=0", RUN+="/usr/bin/sh -c '\''echo 1 > /sys/module/intel_rapl/parameters/restrict_performance'\''"' | sudo tee /etc/udev/rules.d/99-restrict-performance.rules

# Bluetooth 데몬 비활성화
sudo systemctl disable --now bluetooth.service

# GNOME 알림 비활성화
gsettings set org.gnome.desktop.notifications show-banners false

# GDM 테마 변경
sudo sed -i 's/^#background=/background=/' /etc/gdm/custom.conf

# 불필요한 응용 프로그램 제거
sudo pacman -R epiphany gnome-contacts gnome-maps gnome-weather gnome-photos gnome-music gnome-games gnome-recipes

# 로그인 화면 배경화면 변경
sudo cp /path/to/background.png /usr/share/backgrounds/gnome/

# 파일 시스템 최적화
sudo systemctl enable --now fstrim.timer

# 스프래드시트 기본 프로그램 변경
xdg-mime default org.gnome.gnumeric.desktop application/vnd.ms-excel

# 한글 입력기 설치 및 설정
sudo pacman -S --noconfirm ibus ibus-hangul noto-fonts-cjk
gsettings set org.gnome.desktop.input-sources sources "[('ibus', 'hangul')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul', 'korean:rctrl_hanja']"

# 스크린샷 저장 위치 변경
mkdir -p ~/Pictures/Screenshots
gsettings set org.gnome.gnome-screenshot auto-save-directory "file:///home/USERNAME/Pictures/Screenshots"

# 폰트 설정 변경
gsettings set org.gnome.desktop.interface font-name "Noto Sans CJK KR 10"
gsettings set org.gnome.desktop.interface document-font-name "Noto Sans CJK KR 10"
gsettings set org.gnome.desktop.interface monospace-font-name "Noto Sans Mono CJK KR 10"

# 추가 설정
echo "alias ls='ls --color=auto'" >> ~/.bashrc
echo "alias ll='ls -alF'" >> ~/.bashrc

# 종료 메시지
echo "설정이 완료되었습니다. 컴퓨터를 재부팅하세요."
