#!/bin/sh
# This script hosted on Github https://raw.githubusercontent.com/chenen3/vimrc/master/install_outline_ss_ubuntu.sh
# Tested on Ubuntu 20.04 LTS, root permission required.

echo "----------------------------------------------------"
echo "| Enable BBR congestion control                    |"
echo "----------------------------------------------------"
has_bbr=$(lsmod | grep bbr)
if [ -z "$has_bbr" ] ;then
	echo net.core.default_qdisc=fq >> /etc/sysctl.conf
	echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
	echo net.core.rmem_max=2500000 >> /etc/sysctl.conf
	sysctl -p
fi

echo "----------------------------------------------------"
echo "| install outline-ss-server                        |"
echo "----------------------------------------------------"
ss_port=9000
ss_method=chacha20-ietf-poly1305
ss_secret=$(openssl rand -hex 8)

cd /tmp
curl -sL https://github.com/Jigsaw-Code/outline-ss-server/releases/latest/download/outline-ss-server_1.4.0_linux_x86_64.tar.gz -o outline-ss-server.tar.gz
tar -xzvf outline-ss-server.tar.gz
cp outline-ss-server /usr/local/bin/outline-ss-server
cat >> /usr/local/etc/outline-ss-server.yml << EOF
keys:
  - id: user-0
    port: ${ss_port}
    cipher: ${ss_method}
    secret: ${ss_secret}
EOF

apt update
apt install -y supervisor
cat >> /etc/supervisor/supervisord.conf << EOF
[program:outline-ss-server]
command=/usr/local/bin/outline-ss-server -config /usr/local/etc/outline-ss-server.yml --replay_history 10000
redirect_stderr=true
EOF
supervisorctl reload
supervisorctl status

echo "----------------------------------------------------"
echo "| Generate shadowsocks URL                         |"
echo "----------------------------------------------------"
ip=`curl --silent https://checkip.amazonaws.com`
userinfo=$(echo -n ${ss_method}:${ss_secret} |openssl enc -base64 -A | tr -d '=')
echo ss://$userinfo@$ip:${ss_port}

echo "-----------------------------------------------------------"
echo "| Ensure that the firewall allows TCP/UDP port ${ss_port} |"
echo "-----------------------------------------------------------"
