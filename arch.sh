#!/bin/bash

# 패키지 목록 정의
packages=(
  gnome-tweaks 
  xorg-server 
  xorg-xinit 
  mesa 
  xf86-video-intel 
  firefox 
  vlc 
  gnome-system-monitor 
  gedit 
  gnome-calculator 
  gnome-terminal 
  gnome-control-center 
  cpupower 
  gnumeric 
  ibus 
  ibus-hangul 
  noto-fonts-cjk
)

# 패키지 업데이트 및 업그레이드
sudo pacman -Syu

# 필요한 패키지 설치
sudo pacman -S "${packages[@]}"

# Swap 설정 변경
sudo tee /etc/sysctl.d/99-swappiness.conf >/dev/null <<EOF
vm.swappiness=10
EOF
sudo sysctl -p

# CPU 성능 모드 변경
if grep -q 'model name.*Intel(R) Core(TM)' /proc/cpuinfo; then
  sudo systemctl enable --now cpupower.service
  sudo cpupower frequency-set -g performance
  echo 'ACTION=="add", SUBSYSTEM=="module", KERNEL=="intel_rapl", ATTR{parameters}=="restrict_performance=0", RUN+="/usr/bin/sh -c '\''echo 1 > /sys/module/intel_rapl/parameters/restrict_performance'\''"' | sudo tee /etc/udev/rules.d/99-restrict-performance.rules >/dev/null
else
  echo "This script is intended for Intel CPUs only. Skipping CPU power management optimization."
fi

# Bluetooth 데몬 선택적으로 비활성화
read -p "블루투스 데몬을 비활성화 하시겠습니까? (y/n) " disable_bluetooth
if [[ $disable_bluetooth =~ ^[Yy]$ ]]; then
  sudo systemctl disable --now bluetooth.service
fi

# GDM 설정 변경
sudo sed -i 's/^#background=/background=/' /etc/gdm/custom.conf

# 불필요한 응용 프로그램 제거
sudo pacman -R epiphany gnome-contacts gnome-maps gnome-weather gnome-photos gnome-music gnome-games gnome-recipes

# 로그인 화면 배경화면 변경
sudo cp /path/to/background.png /usr/share/backgrounds/gnome/

# 불필요한 패키지 제거
sudo pacman -Rcns $(pacman -Qtdq)

# 파일 시스템 최적화
sudo systemctl enable --now fstrim.timer

# 한글 입력기 설정
gsettings set org.gnome.desktop.input-sources sources "[('ibus', 'hangul')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul', 'korean:rctrl_hanja']"

# 스크린샷 저장 위치 변경
mkdir -p ~/Pictures/Screenshots
gsettings set org.gnome.gnome-screenshot auto-save-directory "file:///home/$(whoami)/Pictures/Screenshots"

# 종료 메시지
echo "설정이 완료되었습니다. 컴퓨터를 재부팅하세요."
