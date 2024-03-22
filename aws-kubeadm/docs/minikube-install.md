# /bin/ setup docker repos

## config for unattended install
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

sudo apt-get update && sudo apt-get upgrade -y

{
## add docker repos to install containerd
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

{
## install containerd
sudo apt-get update && sudo apt-get install containerd.io -y
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml
sudo systemctl restart containerd
}

{
## install docker along with containerd (for minikube)
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install docker-ce docker-ce-cli -y
sudo usermod -aG docker $USER
newgrp docker
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


