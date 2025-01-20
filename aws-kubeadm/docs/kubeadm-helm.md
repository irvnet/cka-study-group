
Kubernetes deployments can be complex requiring various resources (e.g. storage, services, deployments) to be deployed. This can become a bit overwhelming managing a large number of manifest files. 

Helm helps to simplify deployments by acting as a package manager Kubernetes handling packaging, configuration and deployment of application components. By reducing manual management of assets, Helm simplifies managing Kubernetes applications. 

---

Lets install and validate Helm.
Releases can be found on their [release page](https://github.com/helm/helm/releases), but we'll install using apt-get.
```
{
 ## add the helm repo
 curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

 echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

 ## install
 sudo apt-get update
 sudo apt-get install helm

 ## validate helm installation
 helm version
}
```



