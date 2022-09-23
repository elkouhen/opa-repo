package main

violation[{"msg": msg}] {
	input.review.kind.kind == "Pod"

	input.review.object.spec.securityContext.runAsUser == 0

	# msg := sprintf("pod not authorized to run as root user", [])
	msg := sprintf("DEBUG '%v' ", [input])
}
