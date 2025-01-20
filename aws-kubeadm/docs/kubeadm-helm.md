
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


Now lets deploy a helm chart just to validate that helm is working and get more familiar with it. Helm charts are stored in repositories. Add a repository to fetch the required chart. For example, add the Bitnami repository:

Add a Helm Repository

```bash
{
 helm repo add bitnami https://charts.bitnami.com/bitnami
 helm repo update
}
```


Search the repository and list the available NGINX chart versions from the Bitnami repository.

```bash
helm search repo bitnami/nginx
```


Inspect the Helm Chart: Review the chart's default configuration values to understand its deployment parameters:

```bash
helm show values bitnami/nginx
```

Deploy the chart to your Kubernetes cluster. Use a unique release name to identify the deployment. For example:

```bash
helm install my-nginx bitnami/nginx
```

After deploying, list the Helm releases to confirm successful deployment:

```bash
helm list
```

Also, check the Kubernetes resources created by the chart:

```bash
kubectl get all
```

To access the deployed application, use a port-forwarding command to expose the service locally:

```bash
kubectl port-forward svc/my-nginx-nginx 8080:80
```

Visit `http://localhost:8080` in your browser to see the default NGINX home page.

---

