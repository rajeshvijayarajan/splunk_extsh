# K8s cluster configuration for Flannel

mkdir /etc/kube-flannel
cat << EOF > /etc/kube-flannel/net-conf.json
{
  "Network": "172.18.0.0/16", 
  "Backend": {
    "Type": "vxlan"
  }
}
EOF

# Copy the /etc/kubernetes/admin.conf file from the k8s master to the /etc/kube-flannel directory
# scp root@<k8s-master>:/etc/kubernetes/admin.conf /etc/kube-flannel/
