# Policies in Kubernetes

This document explains how to deploy OPA policies to a Kubernetes cluster.

On Kubernetes, we use [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) as the OPA Policy Controller.

As a Policy Controller, Gatekeeper can :
* Refuse the deployment of resources that do not respect the policies
* Audit the deployed resources and report existing resources that do not respect the policies

This [document](./GATEKEEPER-SETUP.md) explains how to deploy Gatekeeper on kubernetes.

The definition and use of a policy is achieved with the following steps
* Define a policy template (called ContraintTemplate in Gatekeeper's vocabulary)
* Deploy it to Kubernetes
* Apply the policy template (called Constraint)


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

The use of a policy is achieved by deploying a Kubernetes CRD.


```yaml
--- 

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