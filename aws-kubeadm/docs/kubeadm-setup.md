
Hit the AWS console and provision 3 ec2 images... 
- size: t2.medium or t2.large 
- storage: 20gb 
- OS: This exercise uses Ubuntu 22.04 LTS 

This should fit in the free tier without being too resource constrained, but adjust up or down to your liking.


Start with getting the machine prepped with the basics
```
{
## prevent interactive prompts 
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
 echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

## install some pre-reqs
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get -y install socat conntrack ipset apt-transport-https ca-certificates gpg
}
```


```
{
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
}
```


Configure a few sysctl updates to ensure forwarding, the config is applied now, and it persists across reboots
```
{
## config sysctl updates to persist across reboots
 cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
 net.bridge.bridge-nf-call-iptables  = 1
 net.bridge.bridge-nf-call-ip6tables = 1
 net.ipv4.ip_forward                 = 1
 EOF

 ## Apply sysctl params without reboot
 sudo sysctl --system
}
```

Install Containerd as the container runtime
```
{
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
}
```

Install kubeadm... the current iteration tests with kubeadm 1.28, but we'll install 1.27 so we can do the upgrade

```
{
## install kubeadm
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-get update

## what versions of kubeadm are available in this repo?
sudo apt list -a kubeadm

sudo apt-get install -y kubelet=1.27.6-00 kubeadm=1.27.6-00 kubectl=1.27.6-00
sudo apt-mark hold kubelet kubeadm kubectl
}
```


Give the controller a name /etc/hosts (and propogate it to /etc/hosts on the worker nodes too)
```
{
CTRL_PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
CONTROLLER_HOST_ENTRY="$CTRL_PUBLIC_IP ctrl"
sudo sed -i $CONTROLLER_HOST_ENTRY /etc/hosts
sudo head /etc/hosts
}
```

Create a config file for kubeadm to keep things simple (and to better document our config). There's a few things to be aware of here:
- controlPlaneEndpoint: includes the host name 'ctrl' instead of the public ip.
- podSubnet: its important that this doesn't overlap the vpc CIDR block or the subnets.
- its also important that the CNI config matches this CIDR block

```
{
cat << EOF | tee ~/kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: stable 
controlPlaneEndpoint: "ctrl:6443" 
networking:
  podSubnet: 10.244.0.0/16
EOF
}
```

Now we should be ready to use kubeadm to initialize the cluster. This should give us the controller node and we can expand the cluster from there if desired.
```
sudo  kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out
```


With the controller node up, we'll need kubectl to have access to the node. For this we'll grab a copy of the config file that we can use on the node or on the local machine for remote access to the node.

```
{
## setup kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
}
```

## untaint control node
kubectl taint nodes --all node-role.kubernetes.io/control-plane-


{
## deploy flannel: update flannel config for same CIDR block as kubadm init
## or... tell kubeadm to use 10.244.0.0/16 as the cluster CIDR block
## https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy
## https://github.com/flannel-io/flannel#deploying-flannel-manually
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
}


{
## join other nodes to the cluster
kubeadm join ctrl:6443 --token <token> \
	--discovery-token-ca-cert-hash <hash>
}









