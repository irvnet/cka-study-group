
Minikube is a lightweight Kubernetes implementation that's helpful to run for learning, experimentation, and testing. It simplifies the process of setting up a Kubernetes environment by providing a cluster that runs in a virtual machine (VM) or a container on various platforms. Minikube supports various container runtimes, such as Docker, containerd, and CRI-O, allowing users to test different configurations and runtimes in a controlled environment. With features like LoadBalancer support, multi-node configurations, and add-ons, Minikube provides a versatile platform to explore Kubernetes concepts without the complexity of running a full production cluster.

Hit the AWS console and provision 1 ec2 image... 
- size: t2.medium or t2.large 
- storage: 20gb 
- OS: This exercise uses Ubuntu 22.04 LTS 


---

{
## prevent interactive prompts 
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
 echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

## install some pre-reqs
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get -y install socat conntrack ipset apt-transport-https ca-certificates gpg
}


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


{
## download / install minikube binary
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo cp minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube
}

{
## install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv ~/kubectl /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
}

{
## start minikube with docker driver
minikube start --memory 12120 --cpus 3  --driver=docker
}

{
## install ingress controller
minikube addons enable ingress
}

