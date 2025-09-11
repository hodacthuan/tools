
##############################################################################################################################

sudo apt install -y conntrack

##############################################################################################################################

# Pick a crictl version that matches Kubernetes (you’re on K8s v1.34.0)
CRICTL_VERSION="v1.34.0"

# Download and install
curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-amd64.tar.gz

sudo tar zxvf crictl-$CRICTL_VERSION-linux-amd64.tar.gz -C /usr/local/bin

# Cleanup
rm crictl-$CRICTL_VERSION-linux-amd64.tar.gz


##############################################################################################################################


#!/usr/bin/env bash
set -euo pipefail

# Install dependencies
sudo apt update
sudo apt install -y git golang-go make

# Clone or update cri-dockerd
if [ -d "cri-dockerd" ]; then
  echo "Updating existing cri-dockerd repo..."
  cd cri-dockerd
  git fetch --all
  git reset --hard origin/master
else
  echo "Cloning cri-dockerd repo..."
  git clone https://github.com/Mirantis/cri-dockerd.git
  cd cri-dockerd
fi

# Clean old builds
make clean || true

# Build
make cri-dockerd

# Install binary (new builds output ./cri-dockerd instead of bin/cri-dockerd)
if [ -f "cri-dockerd" ]; then
  sudo install -o root -g root -m 0755 cri-dockerd /usr/local/bin/cri-dockerd
elif [ -f "bin/cri-dockerd" ]; then
  sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
else
  echo "❌ Build failed: cri-dockerd binary not found"
  exit 1
fi

# Install/Update systemd units
sudo cp -a packaging/systemd/* /etc/systemd/system

# Adjust service file to use /usr/local/bin
sudo sed -i 's:/usr/bin/cri-dockerd:/usr/local/bin/cri-dockerd:' /etc/systemd/system/cri-docker.service

# Reload systemd and enable services
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket

echo "✅ cri-dockerd installed and running"

##############################################################################################################################

# Create target directory
sudo mkdir -p /opt/cni/bin
# Download latest CNI plugins release
CNI_VERSION="v1.4.0"   # latest stable as of now
curl -LO https://github.com/containernetworking/plugins/releases/download/$CNI_VERSION/cni-plugins-linux-amd64-$CNI_VERSION.tgz
# Extract into /opt/cni/bin
sudo tar -C /opt/cni/bin -xzvf cni-plugins-linux-amd64-$CNI_VERSION.tgz
# Clean up
rm cni-plugins-linux-amd64-$CNI_VERSION.tgz

##############################################################################################################################

sudo mkdir -p /etc/cni/net.d
