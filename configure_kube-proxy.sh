# Cluster CIDR matches the flannel network (Refer /etc/kube-flannel/net-conf.json)
# Ensure the path of kube-proxy (/opt/bluedata/bin) and config directory (/etc/kube-flannel) is accurate

cat > /usr/lib/systemd/system/kube-proxy.service << EOF
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes
After=network.target
[Service]
User=root
Group=root
ExecStart=/opt/bluedata/bin/kube-proxy \
  --bind-address=0.0.0.0 \
  --cluster-cidr=172.18.0.0/16 \
  --kubeconfig=/etc/kube-flannel/admin.conf \
  --nodeport-addresses=127.0.0.1/8
  --v=2
Restart=always
RestartSec=10s
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

# Enable the kube-proxy service
systemctl enable kube-proxy
systemctl daemon-reload
systemctl start kube-proxy

# Modify the /etc/resolv.conf of the host to use kube-dns for resolution
# set nameserver to 10.96.0.10
