import os
import urllib.request as request
import socket
import string
import secrets

# TODO: testing
def install(domain, user, password):
    os.chdir("/tmp")
    os.system("wget https://github.com/klzgrad/forwardproxy/releases/latest/download/caddy-forwardproxy-naive.tar.xz")
    os.system("tar -xvf caddy-forwardproxy-naive.tar.xz")
    os.system("mv caddy-forwardproxy-naive/caddy /usr/bin/caddy")
    os.system("mkdir /etc/caddy")
    with open("/etc/caddy/Caddyfile", "w") as f:
        cfg = """
        {
            order forward_proxy before file_server
        }
        :443, {domain} {
            tls me@$domain
            forward_proxy {
                basic_auth {user} {pass}
                hide_ip
                hide_via
                probe_resistance
            }
            file_server {
                root /var/www/html
            }
        }
        """.format(domain=domain,user=user, password=password)
        f.write(cfg)

serviceConfig = '''
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
'''

def run():
    os.system("groupadd --system caddy")
    os.system("""useradd --system \
        --gid caddy \
        --create-home \
        --home-dir /var/lib/caddy \
        --shell /usr/sbin/nologin \
        --comment "Caddy web server" \
        caddy
    """)
    with open("/etc/systemd/system/caddy.service", "w") as f:
        f.write(serviceConfig)
    os.system("systemctl daemon-reload")
    os.system("systemctl enable caddy")
    os.system("systemctl start caddy")

def enable_bbr():
    os.system("sysctl -w net.core.default_qdisc=fq")
    os.system("sysctl -w net.ipv4.tcp_congestion_control=bbr")

if __name__ == "__main__":
    if os.geteuid() != 0:
        print("Please run as root")
        exit(1)
    
    domain = input("Please input your domain name: ")
    if domain == "":
        print("Domain name cannot be empty")
        exit(1)
    host = socket.gethostbyname(domain)
    resp = request.urlopen("https://ipinfo.io/ip")
    if resp.getcode() != 200:
        print("failed to get public IP:", resp.getcode())
        exit(1)
    ip = resp.read().decode('utf-8')
    if host != ip:
        print("Domain name does not point to this server")
        exit(1)

    alphabet = string.ascii_letters + string.digits
    user = ''.join(secrets.choice(alphabet) for _ in range(8))
    password = ''.join(secrets.choice(alphabet) for _ in range(16))

    install(domain, user, password)
    run()
    enable_bbr()
    print(f"Installation completed, the proxy URL is https://{user}:{password}@{domain}")
