#!/bin/sh

# 没有wifi不操作
wlan_if=$(ip route get 1.2.3.4 | awk '{print $5;exit}')
[ -n "$wifi_if" ] || exit 1
wifi_ssid=$(iw $wlan_if info | grep ssid | cut -d' ' -f2-)
[ -n "$wifi_ssid" ] || exit 1

# 当前wifi不重新生成
[ -n "$(grep "WIFI $wifi_ssid" /etc/hosts)" ] && exit 0

cp /etc/hosts{.bak,}
echo -e "\n#WIFI $wifi_ssid\n# github 加速" >> /etc/hosts
echo "请稍等，正在给github访问加速..."
node /root/bin/githubIp >> /etc/hosts
