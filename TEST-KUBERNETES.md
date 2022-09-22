# Deploy a Cluster

This document explains how to deploy a Kubernetes for development needs.

[K3D](https://k3d.io) permits deploying a kubernetes cluster for development needs. 

## Installation 

This [document](https://k3d.io/v5.4.6/#installation) explains how to install K3D.

## Create K3D Cluster

```
k3d registry create

k3d cluster create -p "8081:80@loadbalancer" --registry-use k3d-registry:36091 

# check cluster ok
kubectl cluster-info
```

## Delete K3D Cluster 

```
k3d cluster delete
```