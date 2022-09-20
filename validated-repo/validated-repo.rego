package ensurevalidatedrepos                                           

violation[{ "msg": msg }] {
    input.review.kind.kind == "Pod"
    image := input.review.object.spec.containers[_].image
    startswith(image, input.parameters.repo)
    msg := sprintf("image '%v' origin is not %v", [image, input.parameters.repo])
    # msg := sprintf("REVIEW OBJECT: %v", [input])
}