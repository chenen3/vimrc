#!/bin/bash
# This script hosted on Github https://raw.githubusercontent.com/chenen3/vimrc/master/install_naiveproxy.sh
# Tested on Ubuntu 22.04 LTS

# check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root!"
    exit 1
fi

# prompt user to input domain name
read -p "Please input your domain name: " domain
if [ -z "$domain" ]; then
    echo "Domain name cannot be empty!"
    exit 1
fi
ip=$(curl -s https://ipinfo.io/ip)
if ! host $domain | grep -q "$ip"; then
    echo "Domain name is not point to this server!"
    exit 1
fi
# promt user to ensure TCP port 443 is open
read -p "Please ensure TCP port 443 is open, continue? [y/n] " confirm
if [ "$confirm" != "y" ]; then
    echo "Installation aborted!"
    exit 1
fi

# generate random username and password
user=$(openssl rand -hex 4)
pass=$(openssl rand -hex 8)

# install caddy-forwardproxy-naive
cd /tmp
wget https://github.com/klzgrad/forwardproxy/releases/latest/download/caddy-forwardproxy-naive.tar.xz
tar -xvf caddy-forwardproxy-naive.tar.xz
mv caddy-forwardproxy-naive/caddy /usr/bin/caddy
mkdir /etc/caddy
cat >> /etc/caddy/Caddyfile << EOF
{
  order forward_proxy before file_server
}
:443, $domain {
  tls me@$domain
  forward_proxy {
    basic_auth $user $pass
    hide_ip
    hide_via
    probe_resistance
  }
  file_server {
    root /var/www/html
  }
}
EOF

mkdir -p /var/www/html
cat >> /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
EOF

groupadd --system caddy
useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy

cat >> /etc/systemd/system/caddy.service << EOF
[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
User=caddy
Group=caddy
ExecStart=/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable caddy
systemctl start caddy

# enable BBR congestion control
sudo sysctl -w net.ipv4.tcp_congestion_control=bbr
sudo sysctl -w net.core.default_qdisc=fq

echo ""
echo "Installation completed, please use the following info to configure your client:"
echo "  Username: $user"
echo "  Password: $pass"
echo "  Domain: $domain"
echo "  Port: 443"
echo "  Proxy URL: https://$user:$pass@$domain"
