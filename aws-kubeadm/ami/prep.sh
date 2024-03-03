#!/bin/bash

echo 'prepping environment:  kubeadm v1.27 / ubuntu 22.04 LTS... '

## config for unattended install
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

## install prep
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get -y install socat conntrack ipset apt-transport-https ca-certificates curl gpg

## turn off swap
swapoff -a

## load required modules
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

## configure to load on boot
sudo modprobe overlay
sudo modprobe br_netfilter

## config sysctl updates to persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

## Apply sysctl params without reboot
sudo sysctl --system

## setup docker repos
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## install containerd
sudo apt-get update && sudo apt-get install containerd.io -y
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml
sudo systemctl restart containerd

## install kubeadm
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl

## add controller public ip to hosts file for kubeadm commands
CTRL_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
CONTROLLER_HOST_ENTRY="$CTRL_PUBLIC_IP ctrl"
sudo sed -i $CONTROLLER_HOST_ENTRY /etc/hosts
sudo head /etc/hosts

## create kubeadm config file
cat << EOF | tee ~/kubeadm-config.yaml
## kubeadm-config.yaml (match cluster cidr and pod cidr)
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "ctrl:6443"
networking:
  podSubnet: 10.244.0.0/16
EOF

## create cluster-init.sh
cat <<EOF | sudo tee ~/cluster-init.sh
sudo kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out
EOF
sudo chmod +x ~/cluster-init.sh
sudo chown ubuntu:ubuntu ~/cluster-init.sh

## download flannel config
wget https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

