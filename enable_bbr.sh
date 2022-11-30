#!/bin/bash
# Tested on Ubuntu 20.04 LTS, root permission required.

echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr