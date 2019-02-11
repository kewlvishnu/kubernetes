# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.eks-endpoint}' --b64-cluster-ca '${var.eks-cluster-ca}' --kubelet-extra-args '${var.kubelet-extra-args}' '${var.eks-name}'
USERDATA
}

resource "aws_launch_configuration" "eks-cluster-node" {
  iam_instance_profile        = "${var.iam-instance-profile}"
  image_id                    = "${var.ami-id}"
  instance_type               = "${var.ec2-instance-type}"
  name_prefix                 = "${var.eks-name}-${var.node-group-name}-node"
  security_groups             = ["${var.node-security-groups}"]
  user_data_base64            = "${base64encode(local.node-userdata)}"
  key_name = "${var.keypair}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-nodes" {
  desired_capacity     = "${var.desired-capacity}"
  launch_configuration = "${aws_launch_configuration.eks-cluster-node.id}"
  max_size             = "${var.max-size}"
  min_size             = "${var.min-size}"
  name                 = "${var.eks-name}-${var.node-group-name}-node"
  vpc_zone_identifier  = ["${var.private-subnet-ids}"]

  tag {
    key                 = "Name"
    value               = "${var.eks-name}-${var.node-group-name}-node"
    propagate_at_launch = true
  }

  tag {
    key = "k8s.io/cluster-autoscaler/enabled"
    value = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.eks-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
