#!/bin/bash
# Hosted on Github https://raw.githubusercontent.com/chenen3/vimrc/master/bbr.sh
# Tested on Ubuntu 20.04 LTS, root permission required.

has_bbr=$(lsmod | grep bbr)
if [ -z "$has_bbr" ] ;then
	echo net.core.default_qdisc=fq >> /etc/sysctl.conf
	echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
	sysctl -p
fi
lsmod | grep bbr
