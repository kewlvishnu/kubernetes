resource "aws_iam_policy" "pods_iam_policy" {
  name        = "${var.project}-${var.pod-name}-${var.environment}"
  path        = "${var.path}"
  description = "Policy applied to ${var.pod-name} in ${var.project}-${var.environment}"
  policy = <<EOF
${var.policy}
EOF
}