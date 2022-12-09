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

flux bootstrap github --owner=$GITHUB_USERNAME --repository=playgound_kluster --branch=main --path=./releases/first-release --personal

flux create source helm starboard-operator --url https://aquasecurity.github.io/helm-charts --namespace demo-system
flux create helmrelease starboard-operator --chart starboard-operator \
 --source HelmRepository/starboard-operator \
 --chart-version 0.10.3 \
 --namespace demo-system
