### Deploy monitoring stacks for Ubuntu

### Install local K8s cluster

1. Download & install `minikube`

```shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
```

2. Make `Docker` no-root available

```shell
# https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
sudo usermod -aG docker $USER && newgrp docker
```

3. Verify minikube: launch a cluster

```shell
minikube start
k cluster-info
```

### Install monitoring stacks (kube-prometheus)

1. Update manifests from `kube-prometheus`
   Download the manifests to `./kube-prometheus` and following cmds by [Deploy kube-prometheus](https://prometheus-operator.dev/docs/prologue/quick-start/#deploy-kube-prometheus)

2. Wait for monitoring stacks running, then check functionality

```shell
k port-forward -n monitoring svc/grafana 3000
k port-forward -n monitoring svc/prometheus-k8s 9090
```

### TODO: Provision monitoring stacks by `tanka`

1. Install tanka

```shell
go install github.com/grafana/tanka/cmd/tk@latest
```

### Install memcached-opeartor

## Monitoring Stacks for K8s

### Quick stark by yaml files

```
# Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
kubectl apply --server-side -f kube-prometheus/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl apply -f kube-prometheus/
```

```
# Delete resources
kubectl delete --ignore-not-found=true -f kube-prometheus/ -f kube-prometheus/setup
```

### Pragmatic ways through tanka

```shell
cd tanka
tk show # View the generated yaml specs
tk diff # Compare the specified resources with the running ones on cluster
th apply # Apply the specified resources to the cluster
```

### Issues

Installation may failed due to errors like "too long fields", try install CR manually:

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.57.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.57.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.57.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.57.0/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.57.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.57.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.57.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.57.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
```
