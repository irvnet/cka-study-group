
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
minikube start --driver=docker --nodes=1 --memory 11192 --cpus 4
kubectl get nodes
}
```

---


Install minikube ingress controller and update /etc/hosts with minikube.local domain
referencing the ingress controllers external ip
```
{
minikube addons enable ingress

MINIKUBE_IP=$(minikube ip)
echo "$MINIKUBE_IP minikube.local" | sudo tee -a /etc/hosts
}
```

Test the ingress configuration with a simple ingress resource
```bash
{
cat <<EOF | sudo tee ingress-test.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: hashicorp/http-echo
        args:
        - "-text=Hello from Ingress"
        ports:
        - containerPort: 5678

---

apiVersion: v1
kind: Service
metadata:
  name: hello-service
spec:
  selector:
    app: hello
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 5678

---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host:  minikube.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello-service
            port:
              number: 8080
EOF
}
```

Test the ingress resource with curl
```bash
curl http://minikube.local
```

---

Let's make the ingress resource support external access using the EC2 public DNS name.

From a machine external to the EC2 instance, use `curl` to send a request to the EC2 instance's public DNS while including the `minikube.local` host header. With the the `minikube.local` host header the result should be the same as accessing the ingress resource from the ec2 instance

Setup port forwarding to make services accessible externally
```bash
sudo kubectl port-forward --kubeconfig /home/ubuntu/.kube/config --namespace ingress-nginx svc/ingress-nginx-controller 80:80 --address=0.0.0.0 &

ps aux | grep "kubectl port-forward"
```

Retrieve the EC2 instance's public DNS name
```bash
{
VM_FQDN=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
echo $VM_FQDN

curl -H "Host: minikube.local" http://$VM_FQDN/
}

```


Update the `rules` section of the ingress resource to include the EC2 public DNS name and service port... either use `kubectl edit ingress test-ingress` or update and reapply the manifest as necessary.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host:  minikube.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello-service
            port:
              number: 8080
  - host:  <ADD THE PUBLIC DNS NAME HERE...>
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello-service
            port:
              number: 8080
```

From an external machine, send a request using the EC2 public DNS as the host header. 
```bash
EC2_DNSNAME=<add your public dns name here>
echo "Host: $EC2_DNSNAME" http://$EC2_DNSNAME/
curl -H "Host: $EC2_DNSNAME" http://$EC2_DNSNAME/
```

The updated ingress resource should recognize the request and route it to the back end service.

Expected output:
```plaintext
Hello from Ingress
```

The URL should now be accessible from the browser. From the command line, print the url and copy to the browser
```bash
echo http://$EC2_DNSNAME/
```
Expected output:
```plaintext
Hello from Ingress
```
---

Summary

With this in place we've completed a few things... 
- installed and configured and started minikube with more resources than the default configuration provides
- installed the minikube ingress controller
- configured and tested an ingress resource
- made the ingress resource accessible from the public dns name of the ec2 instance
