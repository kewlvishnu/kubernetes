data "aws_iam_role" "node-role" {
  name = "${module.eks.eks-node-role}"
}

module "cluster-autoscaler-role" {
    source = "../../shared/terraform/modules/kube-iam-role"
    name = "eks-cluster-autoscaler-role"
    eks-node-role-arn = "${module.eks.node-role-arn}"
}

resource "aws_iam_policy" "autoscaling-policy" {
  name        = "eks-cluster-autoscaler-autoscaling-policy"
  description = "Allow cluster to autoscale itself. Used by cluster-autoscaler."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cluster-autoscaler-role-autoscaling-policy-attach" {
  policy_arn = "${aws_iam_policy.autoscaling-policy.arn}"
  role       = "${module.cluster-autoscaler-role.name}"
}
