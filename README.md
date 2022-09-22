# Kubernetes Policies

The policies are implemented via the [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/) query and assertion language and managed with OPA ([Open Policy Agent](https://www.openpolicyagent.org/)) : OPA can validate JSON resource descriptions regarding a policy implemented in Rego.

## Policy List 

List of implemented policies.

| Policy  | File  |
|---|---|
| Ensure use of images from validated repos  | [link to policy](ensure-only-validated-repo/ensure-only-validated-repo.rego)  |
| Forbid run as root  | [link to policy](forbid-run-as-root-user/forbid-run-as-root-user.rego)  |

## Policies in Kubernetes

On Kubernetes, we use [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) as the OPA Policy Controller.

As a Policy Controller, Gatekeeper can :
* Refuse the deployment of resources that do not respect the policies.
* Audit the deployed resources and report existing resources that do not respect the polcies


The definition and use of a policy is achieved with the following steps
* Define a policy template (called ContraintTemplate in Gatekeeper's vocabulary)
* Deploy it to Kubernetes
* Apply the policy template (called Constraint)


### Policy Template

Each policy template is composed of two parts. 

The first part is the rego file. 

Here is a rego rule that denies all deployment of Pods.
```
package denyallpods                                           

violation[{ "msg": msg }] {
    input.review.kind.kind == "Pod"
    msg := sprintf("DEBUG %v", [image])
}
```

The second part is the CRD (Custom Resource Definition) that embeds the rego file and permits deploying it to Kubernetes.

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
