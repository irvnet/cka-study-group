#!/bin/bash

echo 'prepping test environment image... '

## install prep
sudo apt-get update && sudo apt upgrade -y
sudo apt-get -y install socat conntrack ipset

## turn off swap
swapoff -a

## load required modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

## configure to load on boot
sudo modprobe overlay
sudo modprobe br_netfilter

## config sysctl updates to persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

## Apply sysctl params without reboot
sudo sysctl --system

# Add Docker's GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# add apt sources and install container runtime
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## install containerd for minikube
sudo apt-get update
sudo apt-get install -y containerd.io

## install docker daemon and client for local container dev
sudo apt-get install -y docker-ce docker-ce-cli

## setup containerd config
sudo mkdir -p /etc/containerd
cat <<EOF | sudo tee /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
EOF

## add to docker group
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

## restart containerd
sudo systemctl restart containerd

## install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
mv ~/minikube_latest_amd64.deb /tmp

## install kubeadm starter
# sudo apt-get install -y apt-transport-https ca-certificates curl gpg
# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# sudo apt-get update
# sudo apt-get install -y kubeadm kubectl kubelet
# sudo apt-mark hold kubelet kubeadm kubectl

