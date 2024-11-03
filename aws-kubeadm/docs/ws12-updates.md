## Deploying a Deployment 

### Objective:
Deploy an nginx webserver with a Kubernetes Deployment, with both imperative and declarative approaches.

---

### 1. **Imperative Deployment**

The imperative approach allows you to quickly create and manage Deployments directly from the command line without needing a YAML manifest. This is useful for quick experiments and prototyping.

#### Steps:

1. **Use an imperative statement to create a Deployment**:

   ```bash
   kubectl create deployment nginx-deployment --image=nginx --replicas=3
   kubectl get deployments
   ```

   - **Explanation**:
     - `kubectl create deployment`: Directly creates a Deployment.
     - `--image=nginx`: Specifies the container image for the Deployment.
     - `--replicas=3`: Sets the initial number of replicas.

2. **Verify and inspect the Deployment**:

   ```bash
   kubectl get deployments
   kubectl describe deployment nginx-deployment
   ```

3. **Scale the Deployment**:

   ```bash
   kubectl scale deployment nginx-deployment --replicas=5
   ```

   - **Explanation**: The `scale` command adjusts the number of replicas dynamically.

4. **Update the image to a different version of Nginx**:

   ```bash
   kubectl set image deployment/nginx-deployment nginx=nginx:1.19
   ```

5. **Rollback the Deployment**:

   ```bash
   kubectl rollout undo deployment nginx-deployment
   ```

   - **Explanation**: This rolls back the Deployment to the previous stable version.

---

### 2. **Declarative Deployment**

It's helpful to have bookmarks pointing to the manifests that are handy to copy. To speed things up, copy/paste is helpful for questions that require a manifest, or to create objects that don't have imperative commands (like DaemonSet or a NetworkPolicy). Try `kubectl create -h ` to see which objects can be created with imperative commands.

#### Deployment YAML

```yaml
# nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

#### Steps:

1. **Apply the Deployment**:

   ```bash
   kubectl apply -f nginx-deployment.yaml
   ```

2. **Scale the Deployment**:

   ```bash
   kubectl scale -f nginx-deployment.yaml --replicas=5
   ```

3. **Update and Rollback**:

   Edit `nginx-deployment.yaml` and update the image from `nginx` to `nginx:1.19` and reapply:

   ```bash
   kubectl apply -f nginx-deployment.yaml
   kubectl describe deployment/nginx-deployment | grep -i image
   ```

3. **Rollback**:

   Rollback and validate the change has taken effect:

   ```bash
   kubectl rollout undo deployment nginx-deployment
   kubectl describe deployment/nginx-deployment | grep -i image
   ```

---

### Summary

We've worked with deployments using both imperative and declarative approaches. The imperative approach is great for quick changes while the declarative approach allows for version controlled deployments. For the certification test its helpful to have context for both and choose the one that seems best for the situation. 

Also be aware you can create manifests for some objects using kubectl. 
```bash
kubectl create deployment nginx-deployment --image=nginx --dry-run=client -o yaml > nginx-deployment.yaml
```

Explanation:
kubectl create deployment: Creates a Deployment resource.
- `--image=nginx`: Specifies the container image.
- `--dry-run=client`: Checks the command without making changes to the cluster.
- `-o yaml`: Outputs the resource definition in YAML format.
- `> nginx-deployment.yaml`: Saves the output to a file.


You can also grab the manifest of an existing resource from the cluster and use it as a template for more customization.

```bash
kubectl get deployment nginx-deployment -o yaml > exported-deployment.yaml
```

Explanation:
- `kubectl get deployment`: Retrieves the specified Deployment.
- `-o yaml`: Outputs the resource definition in YAML format.
- `> exported-deployment.yaml`: Saves the output to a file.
