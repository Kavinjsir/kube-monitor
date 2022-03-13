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

