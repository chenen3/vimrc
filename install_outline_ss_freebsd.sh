#!/bin/sh
# tested on FreeBSD 12.3, root permission required

echo "------------------------------------------------------------------"
echo "| FreeBSD tuning (https://fasterdata.es.net/host-tuning/freebsd) |"
echo "------------------------------------------------------------------"
kldload cc_htcp
echo cc_htcp_load="YES" >> /boot/loader.conf
# enable htcp congestion algorithm
cat >> /etc/sysctl.conf << EOF
# set to at least 16MB for 10GE hosts
kern.ipc.maxsockbuf=16777216
# set autotuning maximum to at least 16MB too
net.inet.tcp.sendbuf_max=16777216  
net.inet.tcp.recvbuf_max=16777216
# enable send/recv autotuning
net.inet.tcp.sendbuf_auto=1
net.inet.tcp.recvbuf_auto=1
# increase autotuning step size 
net.inet.tcp.sendbuf_inc=16384 
net.inet.tcp.recvbuf_inc=524288 
# set this on test/measurement hosts
# net.inet.tcp.hostcache.expire=1
# Set congestion control algorithm to Cubic or HTCP
# Make sure the module is loaded at boot time - check loader.conf
# net.inet.tcp.cc.algorithm=cubic  
net.inet.tcp.cc.algorithm=htcp
# increase UDP receive buffer size for quic-go
kern.ipc.maxsockbuf=3014656
EOF
sysctl -f /etc/sysctl.conf

echo "----------------------------------------------------"
echo "| install outline-ss-server                        |"
echo "----------------------------------------------------"
pkg install -y go py39-supervisor
go install github.com/Jigsaw-Code/outline-ss-server@latest

ss_port=9000
ss_method=chacha20-ietf-poly1305
ss_secret=`openssl rand -hex 8`
cat >> /usr/local/etc/outline-ss-server.yml << EOF
keys:
  - id: user-0
    port: ${ss_port}
    cipher: ${ss_method}
    secret: ${ss_secret}
EOF

gopath=`go env GOPATH`
cat >> /usr/local/etc/supervisord.conf << EOF
[program:outline-ss-server]
command=${gopath}/bin/outline-ss-server -config /usr/local/etc/outline-ss-server.yml --replay_history 10000
redirect_stderr=true
EOF

service supervisord enable
service supervisord start
supervisorctl status

echo "----------------------------------------------------"
echo "| Generate shadowsocks URL                         |"
echo "----------------------------------------------------"
ip=`fetch --quiet -o - https://checkip.amazonaws.com`
userinfo=$(echo -n ${ss_method}:${ss_secret} |openssl enc -base64 -A | tr -d '=')
echo ss://${userinfo}@${ip}:${ss_port}

echo "-----------------------------------------------------------"
echo "| Ensure that the firewall allows TCP/UDP port ${ss_port} |"
echo "-----------------------------------------------------------"
