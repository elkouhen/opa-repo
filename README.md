# Policy Management

This document lists all implemented policies.

The policies are 
* Implemented via the [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/) query and assertion language 
* And managed with OPA ([Open Policy Agent](https://www.openpolicyagent.org/)) : OPA can validate JSON resource descriptions regarding a policy implemented in Rego.

## Policy List 

List of implemented policies.

| Policy  | File  |
|---|---|
| Ensure use of images from validated repos  | [link to policy](ensure-only-validated-repo/ensure-only-validated-repo.rego)  |
| Forbid run as root  | [link to policy](forbid-run-as-root-user/forbid-run-as-root-user.rego)  |


## Kubernetes & OPA

This [linked document](./POLICIES-K8S.md) describes the use of OPA on Kubernetes.