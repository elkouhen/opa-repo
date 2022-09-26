package main


test_when_run_as_root_should_fail {

  input :=   {
        "parameters": {},
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
            ],
            "securityContext": { "runAsUser": 0 }
          }
          }
        }
      }  

  count(violation) != 0 with input as input
}

test_when_not_run_as_root_should_not_fail {

  input :=   {
        "parameters": {},
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
            ],
            "securityContext": { "runAsUser": 1 }
          }
          }
        }
      }  

  count(violation) == 0 with input as input
}

