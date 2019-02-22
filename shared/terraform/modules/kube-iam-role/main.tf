resource "aws_iam_role" "iam_role" {
  name = "${var.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.eks-node-role-arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

output "arn" {
  value = "${aws_iam_role.iam_role.arn}"
}

output "name" {
  value = "${aws_iam_role.iam_role.name}"
}
