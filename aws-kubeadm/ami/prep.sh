#!/bin/bash

echo 'prepping environment:  kubeadm v1.27 / ubuntu 22.04 LTS... '

## config for unattended install
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

## install prep
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get -y install socat conntrack ipset apt-transport-https ca-certificates curl gpg

## update hosts with a better name
sudo sed -i '127.0.0.1 ctrl' /etc/hosts

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

# add apt sources for docker
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## install containerd
sudo apt-get update
sudo apt-get install -y containerd.io

## setup containerd config
sudo mkdir -p /etc/containerd
cat <<EOF | sudo tee /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
      SystemdCgroup = true
EOF
sudo systemctl restart containerd

## install kubeadm starter v1.27 (to prepare for upgrade)
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
#sudo apt-get install -y kubeadm kubelet kubectl
#sudo apt-mark hold kubelet kubeadm kubectl
 