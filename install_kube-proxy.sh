# Version needs to match that of the cluster
KUBE_VERSION="v1.20.11"
KUBE-PROXY_INSTALL_DIR="/opt/bluedata/bin"

curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kube-proxy
mv kube-proxy ${KUBE-PROXY_INSTALL_DIR}
chmod 0755 ${KUBE-PROXY_INSTALL_DIR}/kube-proxy
#dnf -y install conntrack-tools

