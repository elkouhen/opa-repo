# Kubernetes Policies

The policies are implemented via the [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/) query and assertion language and managed with OPA ([Open Policy Agent](https://www.openpolicyagent.org/)) : OPA can validate JSON resource descriptions regarding a policy implemented in Rego.

On Kubernetes, [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) is the Policy Controller we use; it is based on OPA.

## Policy List 

List of implemented policies.

| Policy  | File  |
|---|---|
| Ensure use of images from validated repos  | [link to policy](ensure-only-validated-repo/ensure-only-validated-repo.rego)  |
| Forbid run as root  | [link to policy](forbid-run-as-root-user/forbid-run-as-root-user.rego)  |

## Policies in Kubernetes 

### Policy Definition

Each policy is composed of two parts. 

The first part is the rego file. 

Here is a rego rule that denies all deployment of Pods.
```
package denyallpods                                           

violation[{ "msg": msg }] {
    input.review.kind.kind == "Pod"
    msg := sprintf("DEBUG %v", [image])
}
```

The second part is the CRD (Custom Resource Definition) that permits deploying the rego file.

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
{{file.Read "./denyallpods/denyallpods.rego" | indent 8 }}

```

### Policy Deployment

### Policy Application

