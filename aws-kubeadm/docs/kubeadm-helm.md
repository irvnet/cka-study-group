
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



Override Default Values with `values.yaml`. Customize the deployment by overriding the default values. Create a `values.yaml` file to modify the replica count and service type.

```yaml
{
cat << EOF | tee ~/values.yaml
replicaCount: 3
service:
  type: NodePort
EOF
}
```

Redeploy or upgrade the Helm release with the custom values:

```bash
helm upgrade my-nginx bitnami/nginx -f values.yaml
```

Validate the updates to the deployment

```bash
{
  kubectl get svc
  kubectl get pods
}
```


Let's update the web server and change the index page with a configmap. First, lets create a new custom homepage. 

```html
cat << EOF | tee ~/index.html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to the tutorial deployment!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to My Favorite Webpage!</h1>
<p>If you see this page, you've completed the updates to the web server successfully! </p>

<p><em>Thank you for using this tutorial.</em></p>
</body>
</html>
EOF
```

And create a configmap from the html file we just created.

```bash
kubectl create configmap custom-homepage --from-file=index.html
```

Next, lets update the `values.yaml` file with additional details for the new configmap. 

```yaml
{
cat << EOF | tee ~/values.yaml
replicaCount: 3
service:
  type: NodePort

extraVolumeMounts:
  - name: custom-homepage
    mountPath: /opt/bitnami/nginx/html

extraVolumes:
  - name: custom-homepage
    configMap:
      name: custom-homepage
EOF
}
```

And deploy the updates to the cluster.
```bash
helm upgrade my-nginx bitnami/nginx -f values.yaml
```

Validate the Deployment After deploying the updates, verify the ConfigMap is mounted correctly and the custom homepage is being served.

Check the running pods:

```bash
  kubectl get pods
```

Inspect the pod to confirm the ConfigMap is mounted:

```bash
kubectl describe pod <nginx-pod-name>  | grep  custom-homepage
```

Get the NGINX URL
```bash
{
 export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services my-nginx)
 export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
 curl "http://${NODE_IP}:${NODE_PORT}"
}
```


---