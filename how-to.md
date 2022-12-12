# HOW-TO

## Start Minikube

Start Minikube in a version prior to 1.25, as it fails to be compatible with Loki's latest version

```sh
minikube start --kubernetes-version=v1.24.8
```

## Install Loki

Using Helm, you can easily install Loki using the following commands:

```sh
helm repo add loki https://grafana.github.io/loki/charts
helm repo update

helm upgrade --install loki loki/loki-stack -n kube-system
```

## Install testing Micro Service

To test the behaviour of our logging and monitoring solution, we are going to install a testing Micro Service.

For that, we are going to deploy [PodInfo](https://stefanprodan.github.io/podinfo) in our Minikube Kubernetes Cluster.

```sh
helm repo add podinfo https://stefanprodan.github.io/podinfo

kubectl create ns test

echo 'Installing PodInfo FrontEnd...'
helm upgrade --install --wait frontend \
    --namespace test \
    --set replicaCount=2 \
    --set backend=http://backend-podinfo:9898/echo \
    podinfo/podinfo

echo 'Testing the frontend installation...'
helm test frontend --namespace test
echo 'Success!'

echo 'Installing PodInfo BackEnd...'
helm upgrade --install --wait backend \
    --namespace test \
    --set redis.enabled=true \
    podinfo/podinfo
echo 'Success!'
```

ADMIN SECRET:2
kubectl get secret --namespace kube-system my-release-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

export POD_NAME=$(kubectl get pods --namespace kube-system -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=my-release" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace kube-system port-forward $POD_NAME 3000

DONE :)

Add Prometheus as a DataSource to Grafana:
<svc-name>.<namespace>.svc.cluster.local:9090

brew install fluxcd/tap/flux

export GITHUB_USERNAME=14ZOli \
export GITHUB_TOKEN=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

flux bootstrap github --owner=$GITHUB_USERNAME --repository=playgound_kluster --branch=main --path=./releases/clusters/staging --personal

## Create a Secret to access the client repository

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

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: myapps-repo
  namespace: demo-domain
spec:
  interval: 10s
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
  interval: 20s
  path: ./manifests
  prune: true
  sourceRef:
    kind: GitRepository
    name: myapps-repo
```
