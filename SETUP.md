# Setup 

## Create Cluster

```
k3d registry create

k3d cluster create -p "8081:80@loadbalancer" --registry-use k3d-registry:36091 

# check cluster ok
kubectl cluster-info
```

## Delete Cluster 

```
k3d cluster delete
```

## Deploy gatekeep

```
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml

### Deploy Gatekeeper templates

```
gomplate -f ./forbid-run-as-root-user/forbid-run-as-root-user.tmpl | kubectl apply -f -
```