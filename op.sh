#!/bin/sh

# ZFS ARC 최적화
sudo sysctl vfs.zfs.arc_max=$((4*1024*1024*1024))
sudo sysctl vfs.zfs.arc_min=$((2*1024*1024*1024))

# Swap Space 최적화
sudo mdconfig -a -t swap -s 8g -u 1
sudo swapon /dev/md1

# TCP 설정 변경
sudo sysrc net.inet.tcp.sendbuf_max="16777216"
sudo sysrc net.inet.tcp.recvbuf_max="16777216"
sudo sysrc net.inet.tcp.sendbuf_inc="8192"
sudo sysrc net.inet.tcp.recvbuf_inc="16384"
sudo sysrc net.inet.tcp.sendspace="65536"
sudo sysrc net.inet.tcp.recvspace="65536"
sudo sysrc net.inet.tcp.cc.algorithm="cubic"
sudo sysrc net.inet.tcp.mssdflt="1460"
sudo sysctl net.inet.tcp.tso=0
sudo sysctl net.inet.tcp.tso6=0

# PF 패킷 필터링 최적화
sudo sysrc pf_enable="YES"
sudo sysrc pf_flags="-e"
sudo sysrc pf_rules="/etc/pf.conf"
sudo touch /etc/pf.conf
sudo chmod 644 /etc/pf.conf

# Swap Space 자동 마운트 설정
echo '/dev/md1 none swap sw 0 0' | sudo tee -a /etc/fstab

# Swap Space 압축
sudo sysrc zfs_compress=lz4
sudo zfs set compression=lz4 swap

# TCP 튜닝
sudo sysctl net.inet.tcp.delayed_ack=0
sudo sysctl net.inet.tcp.blackhole=2
sudo sysctl net.inet.tcp.mssdflt=1460
sudo sysctl net.inet.tcp.minmss=536
sudo sysctl net.inet.tcp.sack.enable=1
sudo sysctl net.inet.tcp.sack.maxholes=128
sudo sysctl net.inet.tcp.sack.globalmaxholes=65536
sudo sysctl net.inet.tcp.always_keepalive=1
sudo sysctl net.inet.tcp.fast_finwait2_recycle=1
sudo sysctl net.inet.tcp.msl=500
sudo sysctl net.inet.tcp.v6mssdflt=1420

# TCP Keepalive 설정
sudo sysctl net.inet.tcp.keepidle=30000
sudo sysctl net.inet.tcp.keepintvl=2000
sudo sysctl net.inet.tcp.keepcnt=5

# IPFW 패킷 필터링 최적화
sudo sysrc firewall_enable="YES"
sudo sysrc firewall_type="open"
sudo sysrc firewall_quiet="YES"
sudo sysrc firewall_logging="NO"

# 재부팅
sudo reboot
