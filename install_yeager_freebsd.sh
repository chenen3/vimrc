#!/bin/bash
# tested on FreeBSD 13.2, root permission required

# basic tuning (https://fasterdata.es.net/host-tuning/freebsd)
sysctl kern.ipc.maxsockbuf=16777216
sysctl net.inet.tcp.sendbuf_max=16777216  
sysctl net.inet.tcp.recvbuf_max=16777216
sysctl net.inet.tcp.sendbuf_auto=1
sysctl net.inet.tcp.recvbuf_auto=1
sysctl net.inet.tcp.sendbuf_inc=16384 
#sysctl net.inet.tcp.recvbuf_inc=524288
sysctl net.inet.tcp.hostcache.expire=1
# set congestion control algorithm
kldload cc_htcp
sysctl net.inet.tcp.cc.algorithm=htcp

# define a variable for multiple lines
# https://stackoverflow.com/questions/40562595/how-to-define-a-variable-with-multiple-lines


# install yeager
cd /tmp
fetch -o yeager-freebsd-amd64.tar.gz https://github.com/chenen3/yeager/releases/latest/download/yeager-freebsd-amd64.tar.gz
tar -xzvf yeager-freebsd-amd64.tar.gz
mv yeager /usr/local/bin/yeager
mkdir -p /usr/local/etc/yeager
if [ -f /usr/local/etc/yeager/config.json ]; then
  echo "found /usr/local/etc/yeager/config.json"
else
  /usr/local/bin/yeager -genconf -srvconf /usr/local/etc/yeager/config.json \
	  -cliconf /usr/local/etc/yeager/client.json
fi

echo "====="
echo "NOTICE:"
echo ""
echo "1. allows TCP port 57175"
echo "2. use /usr/local/etc/yeager/client.json to config the client"
echo "3. config rc script /usr/local/etc/rc.d/yeager, run:"
echo "     chmod +x /usr/local/etc/rc.d/yeager"
echo "     service yeager enable"
echo "     service yeager start"

