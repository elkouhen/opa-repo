# Policies in Kubernetes

This document explains how to use OPA policies on a Kubernetes cluster.

On Kubernetes, we use [Gatekeeper](./GATEKEEPER-SETUP.md) as the OPA Policy Controller.

As a Policy Controller, Gatekeeper can :
* Refuse the deployment of resources that do not respect the policies
* Audit the deployed resources and report existing resources that do not respect the policies

## Implementing and using a Policy

The definition and use of a policy is achieved with the following steps
* Define a policy template (called ContraintTemplate in Gatekeeper's vocabulary)
* Deploy it to Kubernetes
* Apply the policy template (called Constraint) to Kubernetes resources


## Policy Template

Each policy template is composed of two parts. 

The first part is the rego file. 

Here is a rego rule that denies deployment of all Pods.
```
package denyallpods                                           

violation[{ "msg": msg }] {
    input.review.kind.kind == "Pod"
    msg := sprintf("DEBUG %v", [image])
}
```

The second part is the CRD (Custom Resource Definition) that embeds the rego file to permit its deployment to Kubernetes.

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

### Policy Use

The use of a policy is achieved by creating and deploying a Gatekeeper constraint
* The constraint apply the constraint template to a set of Kubernetes resources and apis. 


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

If the deployed resource does not respect the policy, the deployment is rejected.

```bash 
kubectl create -f pod.yaml 
Error from server (Forbidden): error when creating "k8s/helloworld-root-user.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [denyallpods] DEBUG ***
```
