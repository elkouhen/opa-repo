package main                                           

test_when_deploy_pod_from_not_validated_repo_must_fail {

  input :=   {
        "parameters": {
                    "repo": "k3d-registry"
                },
        "review": {
          "dryRun": false,
          "kind": { "group": "", "kind": "Pod", "version": "v1" },
          "name": "helloworld-root-user",
          "object": {
          "apiVersion": "v1",
          "kind": "Pod",
          "spec": {
            "containers": [
            {
              "image": "xxx-registry:36091/helloworld-go:v0.1",
              "name": "helloworld-go"
            }
            ]
          }
          }
        }
      }  

  count(violation) != 0 with input as input
}

test_when_deploy_pod_from_not_validated_repo_must_not_fail {

  input :=   {
        "parameters": {
                    "repo": "k3d-registry"
                },
        "review": {
          "dryRun": false,
          "kind": { "group": "", "kind": "Pod", "version": "v1" },
          "name": "helloworld-root-user",
          "object": {
          "apiVersion": "v1",
          "kind": "Pod",
          "spec": {
            "containers": [
            {
              "image": "k3d-registry:36091/helloworld-go:v0.1",
              "name": "helloworld-go"
            }
            ]
          }
          }
        }
      }  

  count(violation) == 0 with input as input
}