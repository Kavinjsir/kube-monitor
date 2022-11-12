# K8s Observability Practices

This repo includes multiple directories. Each directory contains certain practices of observability on k8s.

- jaeger-ops: Quick start of Jaeger operator
- kops-config: Handson K8s setup on Google Cloud(Without GKE)
- kube-prometheus: A copy of `manifests/` from [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus#quickstart)
- kubebuilder-backup: Grafana manifests backup for kubebuilder grafana plugin
- kubebuilder-grafana-plugin: Draft manifests kubebuilder grafana plugin
- tanka: A pragmatic approach to customize observability stacks on K8s

## Monitoring Stacks for K8s

### Quick stark by yaml files

Go to `kube-prometheus` directory and follow the steps below.

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
