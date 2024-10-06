
Minikube is a lightweight Kubernetes implementation that's helpful to run for learning, experimentation, and testing. It simplifies the process of setting up a Kubernetes environment by providing a cluster that runs in a virtual machine (VM) or a container on various platforms. Minikube supports various container runtimes, such as Docker, containerd, and CRI-O, allowing users to test different configurations and runtimes in a controlled environment. With features like LoadBalancer support, multi-node configurations, and add-ons, Minikube provides a versatile platform to explore Kubernetes concepts without the complexity of running a full production cluster.

Hit the AWS console and provision 1 ec2 image... 
- size: t2.medium or t2.large 
- storage: 20gb 
- OS: This exercise uses Ubuntu 22.04 LTS 


---


Here we'll accomplish a few things: 
* The sed command updates the needrestart config to automatically restart services if required.
* debconf command sets the package installer to a non-interactive mode to streamline the process.
* update and install a few pre-req's that are necessary for managing network connections and dependencies

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


Minikube supports [a few runtimes](https://minikube.sigs.k8s.io/docs/runtimes/) including containerd, cri-o and docker. This time, we'll install docker, because its easy, and because Minikube will use docker as a default. 

```
{
## setup docker repos
 sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

 echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
 https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

 ## install docker
 sudo apt-get install docker.io -y
 sudo groupadd docker
 sudo usermod -aG docker $USER
 newgrp docker
 docker run hello-world
}
```


Download the Minikube binary and place it in a directory that is included in your system's PATH .

```
{
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo mv minikube /usr/local/bin/
}
```

Add the GPG to auth to the k8s package repo, update the repo list and update the package list. Finally, install the latest stable version of kubectl on the system.

```
{
## install kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg 
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list 

sudo apt-get update

## what versions of kubeadm are available in this repo?
sudo apt list -a kubectl

sudo apt-get install -y kubectl
}
```

Minikube will start with 1 node by default, but can be start with multiple nodes. It'll discover that docker is installed and automatically use the docker driver. Here, we'll innitialize a minikube cluster that has 2 nodes. Minikube will download the required vm, initialize the cluster, and set the proper context so kubectl will connect properly. 
```
{
## start minikube with docker driver
minikube start  --nodes=2
kubectl get nodes
}
```

Add a few extras including the ingress controller, metrics server and dashbaord
```
{
minikube addons enable ingress
minikube addons enable  metrics-server
minikube addons enable dashbaord
}
```
