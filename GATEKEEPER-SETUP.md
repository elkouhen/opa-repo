# Gatekeeper Setup 

This [link](https://open-policy-agent.github.io/gatekeeper/website/docs/install/) explains how to deploy gatekeeper on a Kubernetes cluster.

A fast way to deploy (for development needs) Gatekeeper can be achieved as following. 

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
```