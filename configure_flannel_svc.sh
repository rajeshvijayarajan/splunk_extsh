# Build the systemd unit file for Flannel. Enable the service
# Ensure the FQDN of the host is set correctly in the env variable NODE_NAME
# Ensure the path of the flanneld binary is accurate

cat << EOF > /usr/lib/systemd/system/flannel.service
[Unit]
Description=Network fabric for containers
Documentation=https://github.com/coreos/flannel
After=network.target
After=network-online.target
Wants=network-online.target
[Service]
Type=notify
Restart=always
RestartSec=5

# This is needed because of this: https://github.com/coreos/flannel/issues/792
# Kubernetes knows the nodes by their FQDN so we have to use the FQDN
Environment=NODE_NAME=ip-10-21-0-122.ap-southeast-1.compute.internal

# Note that we don't specify any etcd option. This is because we want to talk
# to the apiserver instead. The apiserver then talks to etcd on flannel's
# behalf.
# NOTE: if ‘--iface=<interface name>’ is not defined default route interface will be set

ExecStart=/opt/bluedata/bin/flanneld \
  --kube-subnet-mgr \
  --kubeconfig-file=/etc/kube-flannel/admin.conf \
  --v=5 \
  --ip-masq=true
[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl enable flannel
systemctl daemon-reload
systemctl start flannel
