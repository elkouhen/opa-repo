package main                                           

violation[{ "msg": msg }] {
    input.review.kind.kind == "Pod"
    image := input.review.object.spec.containers[_].image
    not startswith(image, input.parameters.repo)
    msg := sprintf("container '%v' has an invalid image repo %v", [image, input.parameters.repo])
}