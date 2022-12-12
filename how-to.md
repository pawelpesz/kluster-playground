# HOW-TO

## Start Minikube

```sh
minikube start
```

--> **YOU CAN BYPASS THE STEPS UNTIL FLUXCD BY RUNNING THE "init" SCRIPT** <--

## Install Prometheus

Using Helm:

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade -i prometheus prometheus-community/kube-prometheus-stack --set grafana.enabled=false -n demo-domain
```

## Install Loki

Using Helm:

```sh
helm repo add loki https://grafana.github.io/loki/charts
helm repo update

helm upgrade -i loki grafana/loki-stack --set grafana.enabled=true -n kube-system
```

To access the Grafana UI, you'll need the admin's password.
Fetch it from a Kubernetes Secret that the Helm chart above created:

```sh
kubectl get secret --namespace demo-system loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

To make it accessible from within the Cluster to your local Web Browser, Port-Forward its service:

```sh
kubectl port-forward --namespace demo-system service/loki-grafana 3000:80
```

## Install Metrics Server

To allow Prometheus to get full CPU and Memory metrics, you'll need to install Kubernetes' Metric Server.

You can do that with only the following command:

```sh
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

--> **MANUAL FROM HERE** <--

## Fluxcd v2

### First Steps

1. Firstly, make sure you have the Flux Cli installed. We'll be using that a few times:

```sh
brew install fluxcd/tap/flux
```

2. Create a GitHub Personal Access Token (in case of a Dev or Prod team environment, you might need a Technical User or a GitHub App). Export them as environment variables.

The Personal Access Token will need the following:

- Contents: Read
- Metadata: Read
- Administration: Read/Write (because it needs to POST into the /repos/{owner}/{repo}/keys path)

```sh
export GITHUB_USERNAME=14ZOli \
export GITHUB_TOKEN=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
```

3. Init Flux by creating Flux system resources

```sh
flux bootstrap github --owner=$GITHUB_USERNAME --repository=playgound_kluster --branch=main --path=./clusters/staging --personal
```

This will generate the following structure:

```
|-- clusters
|   |-- staging
|       |-- flux-system
|           |-- gotk-components.yaml
|           |-- gotk-sync.yaml
|           |-- kustomization.yaml
```

### Create a Secret to access the client repository

1. Firstly create a SSH Key, and create a Deploy Key in GitHub from it.

You'll need to perform the following command in your local computer.

```sh
# execute this command and follow the following steps that prompt
ssh-keygen -t rsa -b 4096

# then copy the public key that was generated under ~/.ssh/
cat ~/.ssh/id_rsa.pub
```

2. Paste it under the Deploy Keys menu of the target GitHub repository.

Open the target client repo, go to Settings (need Maintainer permissions, or higher), Deploy Keys (under Security) and add a new one.

3. Create a Kubernetes secret with its credentials

We are using Flux's CLI because it alredy generates the known-hosts. That way, we don't need to perform a keyscan ourselves.

This is a namespace scoped secret, so it needs to be in the same namespace as the GitRepository (or other) Kubernetes resource that references it.

```sh
# the Flux does not consider absolute paths
cd ~/.ssh/

flux create secret git myapps-secret \
 --url=ssh://git@github.com/14ZOli/myapps \
 --private-key-file=./myapps_rsa \
 --namespace=demo-domain
```

### Set Fluxcd to track client repo

Now that Fluxcd v2 is tracking his own Cluster folder for new Yaml files, you can set it to aim at the Client Repo for new Kubernetes resources.

Under the Cluster folder, you can create the following two resources (can be in the same file):

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: myapps-repo
  namespace: demo-domain
spec:
  interval: 20s
  ref:
    branch: main
  secretRef:
    name: myapps-secret
  url: ssh://git@github.com/14ZOli/myapps
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: demo-domain
  namespace: demo-domain
spec:
  interval: 30s
  path: ./manifests
  prune: true
  sourceRef:
    kind: GitRepository
    name: myapps-repo
```

The GitRepository targets the myapps repository every 20 seconds, on the main branch, while using the myapps-secret ssh secret.

Then, it creates a Flux Kustomization resource that tracks the ./manifests/ folder for Yaml resources, under the repository that we previsouly defined, every 30 seconds.

## Deploy a client app

Now you can deploy any app by placing its definition at the myapps repo, under the ./manifests/ folder.

Let's try, for instance, to create a nginx deployment with 2 replicas:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: demo-domain
  labels:
    app: nginx
spec:
  replicas: 2
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
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

Wait 30 seconds for the Kustomize resource to sync, and the deployment should be created.
