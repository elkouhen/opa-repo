# Policies in Kubernetes

This document explains how to use OPA policies on a Kubernetes cluster.

As a Policy Controller, Gatekeeper can :
* Refuse the deployment of resources that do not respect the policies
* Audit deployed resources and report existing resources that do not respect deployed policies

## Implementing and using a Policy

The definition and use of a policy is achieved with the following steps
* Define a policy template (ContraintTemplate Custom Resource Definition (CRD))
  * Deploy the ContraintTemplate to Kubernetes
* Define how the policy template (Constraint CRD) applies to Kubernetes resources
  * Deploy the Contraint to Kubernetes


### Policy Template

Each policy template is composed of two parts. 

The first part is the rego file. Here is a rego rule that denies deployment of all Pods.

```
package denyallpods                                           

violation[{ "msg": msg }] {
    input.review.kind.kind == "Pod"
    msg := sprintf("DEBUG %v", [image])
}
```

The second part is the ContraintTemplate CRD (Custom Resource Definition) that embeds the rego file to permit its deployment to Kubernetes.

```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: denyallpods
spec:
  crd:
    spec:
      names:
        kind: DenyAllPods

  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
[[ REGO CODE ]]
```


```yaml
# execute following command at project root folder
gomplate -f ./ensure-only-validated-repo/ensure-only-validated-repo.tmpl | kubectl apply -f -
```

### Policy Usage

The use of a Rego policy is achieved by creating and deploying a Gatekeeper constraint. The constraint apply the constraint template to a set of Kubernetes resources and apis. 

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: DenyAllPods
metadata:
  name: denyallpods
spec:
  enforcementAction: deny
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
```

Iif the description of a resource does not respect the deployed Constraints, its deployment is rejected by Gatekeeper.

```bash 
kubectl create -f pod.yaml 
Error from server (Forbidden): error when creating "k8s/helloworld.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [denyallpods] DEBUG ***
```

## Gatekeeper Deployment

On Kubernetes, we use [Gatekeeper](./GATEKEEPER-SETUP.md) as the OPA Policy Controller.

This [linked document](https://open-policy-agent.github.io/gatekeeper/website/docs/install/) explains how to deploy gatekeeper on a Kubernetes cluster.

For development needs, it is possible to deploy Gatekeeper as following. 

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml