## Monitoring Stacks for K8s

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

