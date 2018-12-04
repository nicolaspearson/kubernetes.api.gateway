# Node Kubernetes

This repository contains Kubernetes files for clustering the [node.api.gateway](https://github.com/nicolaspearson/node.api.gateway) back-end, and the [react.antd.fuse](https://github.com/nicolaspearson/react.antd.fuse) front-end.

## Getting Started

The instructions below are for your local development environment.

1. Install Docker for Mac, alternatively use Minikube [Minikube](https://github.com/kubernetes/minikube)
2. Enable [Kubernetes](https://rominirani.com/tutorial-getting-started-with-kubernetes-with-docker-on-mac-7f58467203fd) via Docker for Mac. (Not required if using Minikube)
3. Install [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/): `brew install kubernetes-cli`
4. Check Kubernetes Nodes: `kubectl get nodes`
5. Install Helm: `brew install kubernetes-helm && helm init --upgrade`
6. Follow the instructions in either the Development or Production sections.

Further reading: [Learn Kubernetes in under 3 hours](https://medium.freecodecamp.org/learn-kubernetes-in-under-3-hours-a-detailed-guide-to-orchestrating-containers-114ff420e882)

## Development

Some of the instructions below are for Minikube user only, if you are not using Minikube you may ignore those sections.

### Install Kubernetes Dashboard

If you are not using Minikube you can install the Kubernetes dashboard by following the instructions below:

1. Add the dashboard as a pod: `kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml`
2. Ensure it was created: `kubectl get pods --namespace=kube-system`
3. Setup port-forwarding: `kubectl port-forward <your-kubernetes-dashboard-name> 8443:8443 --namespace=kube-system`, e.g. `kubectl port-forward kubernetes-dashboard-7b9c7bc8c9-chvng 8443:8443 --namespace=kube-system`
4. Go to the dashboard: https://localhost:8443. You can skip sign in if prompted.

### Build Local Images

Check the available docker images: `docker image ls`

If you do not have the required images for this project you will need to build them from existing repositories.

1. Clone the React project: `git clone https://github.com/nicolaspearson/react.antd.fuse.git`
2. Clone the Node API Gateway project: `git clone https://github.com/nicolaspearson/node.api.gateway.git`
3. Open and build the React project: `cd react.antd.fuse && docker-compose build`
4. Open and build the API project: `cd node.api.gateway && docker-compose build`
5. Verify the built images: `docker image ls`

### Deployment

-   Deploy All: `./dev-deploy.sh`
-   Undeploy All: `./dev-undeploy.sh`

Visit the Traefik dashboard: http://dashboard.localhost

Add the API Gateway to your hosts file:

-   `echo "127.0.0.1 gateway.localhost" | sudo tee -a /etc/hosts`

Add the React Client Frontend to your hosts file:

-   `echo "127.0.0.1 react.client.localhost" | sudo tee -a /etc/hosts`

### API Gateway

The API Gateway is created at `gateway.localhost` by the deploy script, navigate to http://gateway.localhost/api/v1/auth/authorize using your browser, and make sure you see an appropriate response to verify that the gateway is available.

### React Client Frontend

The React Client App is created at `react.client.localhost` by the deploy script, navigate to http://react.client.localhost using your browser.

## Minikube

If you are using Minikube, follow the instructions below.

### Start Minikube

If you are building the Docker images locally you need to expose it to Minikube:

-   Start Minikube: `minikube start`
-   Check Kubernetes Nodes: `kubectl get nodes`

To view the kubernetes dashboard: `minikube dashboard`

### Share Docker Environment With Minikube

Share the docker env with minikube: `eval $(minikube docker-env)`

### Build Local Images For Minikube

Check the available docker images: `docker image ls`

You will notice that it displays the images available to Minikube, but not the images that have already been created on your local machine. Minikube runs in a VM and therefore your images cannot be simply be shared, you will need to create the images within the Minikube context, e.g.

1. Open the project: `cd react-lupinemoon-client` / Open the api project: `cd node.api.gateway`
2. View local images: `docker image ls`
3. Switch to Minikube Docker Env: `eval $(minikube docker-env)`
4. View Minikube images: `docker image ls`
5. Build the image in the Minikube context: `docker-compose up --build`
6. View built images: `docker image ls`
7. Your Minikube instance now has your local images built within it's context

### Stop Minikube

-   Stop Minikube: `minikube stop`

Get a shell to the running Container: `kubectl exec -it <pod-name> -- /bin/bash`

## Production

This section will remain empty until the deployment pipeline has been built.

## Kubernetes Cheat Sheet

Below are some tips for using Kubernetes, the commands provided are **NOT** specific to this project.

[Cheat Sheet and Autocomplete](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

### Client Configuration

-   Setup autocomplete in bash; bash-completion package should be installed first

    `source <(kubectl completion bash)`

-   View Kubernetes config

    `kubectl config view`

-   View specific config items by json path

    `kubectl config view -o jsonpath='{.users[?(@.name == "k8s")].user.password}'`

### Manage Resources

-   Get documentation for pod or service

    `kubectl explain pods,svc`

-   Create resource(s) like pods, services or daemon sets

    `kubectl create -f ./my-manifest.yaml`

-   Apply a configuration to a resource

    `kubectl apply -f ./my-manifest.yaml`

-   Start a single instance of Nginx

    `kubectl run nginx --image=nginx`

-   Create a secret with several keys

        	```
        	cat <<EOF | kubectl create -f -
        	apiVersion: v1
        	kind: Secret
        	metadata:
        	  name: mysecret
        	type: Opaque
        	data:
        	  password: $(echo -n "s33msi4" | base64)
        	  username: $(echo -n "jane" | base64)
        	EOF
        	```

-   Delete a resource

    `kubectl delete -f ./my-manifest.yaml`

### Viewing, Finding Resources

-   List all services in the namespace

    `kubectl get services`

-   List all pods in all namespaces in wide format

    `kubectl get pods -o wide --all-namespaces`

-   List all pods in json (or yaml) format

    `kubectl get pods -o json`

-   Describe resource details (node, pod, svc)

    `kubectl describe nodes my-node`

-   List services sorted by name

    `kubectl get services --sort-by=.metadata.name`

-   List pods sorted by restart count

    `kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'`

-   Rolling update pods for frontend-v1

    `kubectl rolling-update frontend-v1 -f frontend-v2.json`

-   Scale a replicaset named 'foo' to 3

    `kubectl scale --replicas=3 rs/foo`

-   Scale a resource specified in "foo.yaml" to 3

    `kubectl scale --replicas=3 -f foo.yaml`

-   Execute a command in every pod / replica

    `for i in 0 1; do kubectl exec foo-$i -- sh -c 'echo $(hostname) > /usr/share/nginx/html/index.html'; done`

### Monitoring & Logging

-   Deploy Heapster from Github repository
    https://github.com/kubernetes/heapster

    `kubectl create -f deploy/kube-config/standalone/`

-   Show metrics for nodes

    `kubectl top node`

    `kubectl top node my-node-1`

-   Show metrics for pods

    `kubectl top pod`

    `kubectl top pod my-pod-1`

-   Show metrics for a given pod and its containers

    `kubectl top pod pod_name --containers`

-   Dump pod logs (stdout)

    `kubectl logs pod_name`

-   Stream pod container logs
    (stdout, multi-container case)

    `kubectl logs -f pod_name -c my-container`
