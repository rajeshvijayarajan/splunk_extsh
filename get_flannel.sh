# Install Flannel - Download and extract the right version of the flanneld binary 

FLANNEL_VERSION="v0.14.0"
FLANNEL_INSTALL_DIR="/opt/bluedata/bin"

curl -LO https://github.com/flannel-io/flannel/releases/download/v0.14.0/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz
tar zxf flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz
mkdir -p ${FLANNEL_INSTALL_DIR}
mv flanneld ${FLANNEL_INSTALL_DIR}
chmod 755 ${FLANNEL_INSTALL_DIR}/flanneld

