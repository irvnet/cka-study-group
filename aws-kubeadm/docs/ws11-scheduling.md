## Deploying a Pod (Basic Workload)

### Objective:
- Work with somee of the basic types of workloads by deploying an `nginx` Pod. This example covers both imperative and declarative deployments.
- Review both imperative and declarative approaches for deploying workloads.

---

### 1. **Imperative Deployment**

First we'll take an imperative approach... this is important to get comfortable with since it helps with quick responses for the test. 

#### Steps:
1. Run the following command to create an `nginx` pod:

   ```bash
   kubectl run nginx-pod --image=nginx --restart=Never
   ```

   - **Explanation**: 
     - `kubectl run`: This command creates a Pod or Deployment.
     - `--image=nginx`: Specifies the image to use.
     - `--restart=Never`: Ensures that the object created is a Pod rather than a Deployment (which is the default for `kubectl run`).

2. **Verify the Pod Creation**:
   
   ```bash
   kubectl get pods
   ```
   
3. **Check the Pod Details**:
   
   ```bash
   kubectl describe pod nginx-pod
   ```

   - Use `describe` to review the Pod’s configurations, status, and events, which helps in understanding the Pod's lifecycle.

4. **Check the Logs**:

   ```bash
   kubectl logs nginx-pod
   ```

   - Verify that the container is running and serving as expected.

5. **Clean Up** (optional):
   
   ```bash
   kubectl delete pod nginx-pod
   ```

---

### 2. **Declarative Deployment**

With the declarative approach, users create a YAML manifest for the Pod, which provides a persistent and reusable configuration. This is the recommended approach for production as it supports version control.

#### Steps:

1. **Create a YAML Manifest**:
   
   ```yaml
   # nginx-pod.yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: nginx-pod
     labels:
       app: nginx
   spec:
     containers:
     - name: nginx
       image: nginx:latest
       ports:
       - containerPort: 80
   ```

   - **Explanation**:
     - `apiVersion: v1`: Specifies the API version for the Pod resource.
     - `kind: Pod`: Defines the resource type.
     - `metadata`: Includes `name` (identifier) and `labels` (to organize and filter Pods).
     - `spec`: Configures the container to use the `nginx:latest` image and exposes port 80.

2. **Apply the Manifest**:

   ```bash
   kubectl apply -f nginx-pod.yaml
   ```

   - **Explanation**:
     - The `apply` command enables you to maintain the resource’s configuration over time.

3. **Verify the Pod Creation**:

   ```bash
   kubectl get pods
   ```

4. **Inspect Pod Details**:

   ```bash
   kubectl describe pod nginx-pod
   ```

5. **Check the Logs**:

   ```bash
   kubectl logs nginx-pod
   ```

6. **Clean Up**:

   ```bash
   kubectl delete -f nginx-pod.yaml
   ```

   - **Explanation**: Deleting the manifest file removes the resource in a controlled, reproducible way.

---

### Summary

This section provides a basic overview of deploying a simple workload using both imperative and declarative approaches. It also provides a quick overfview of creating, managing and removing a basic resource. 