#!/bin/sh
# tested on Ubuntu 20.04 LTS, root permission required

echo "----------------------------------------------------"
echo "| Enable BBR congestion control                    |"
echo "----------------------------------------------------"
has_bbr=$(lsmod | grep bbr)
if [ -z "$has_bbr" ] ;then
	echo net.core.default_qdisc=fq >> /etc/sysctl.conf
	echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
	sysctl -p
fi

echo "----------------------------------------------------"
echo "| install outline-ss-server                        |"
echo "----------------------------------------------------"
ss_port=9000
ss_method=chacha20-ietf-poly1305
base64_without_padding() {
  openssl enc -base64 -A | tr -d '='
}
ss_secret=$(head -c 16 /dev/urandom | base64_without_padding)

cd /tmp
curl -sLO https://github.com/Jigsaw-Code/outline-ss-server/releases/download/v1.3.5/outline-ss-server_1.3.5_linux_x86_64.tar.gz
tar -xzvf outline-ss-server_1.3.5_linux_x86_64.tar.gz
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
echo ss://$(echo -n ${ss_method}:${ss_secret}@$ip:${ss_port} | base64_without_padding)

echo "-----------------------------------------------------------"
echo "| Ensure that the firewall allows TCP/UDP port ${ss_port} |"
echo "-----------------------------------------------------------"
