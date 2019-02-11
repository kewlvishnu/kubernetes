resource "aws_eks_cluster" "eks-cluster" {
  name = "eks-${var.project}-${var.environment}"
  role_arn = "${aws_iam_role.eks-cluster-role.arn}"
  version = "${var.eks-version}"

  vpc_config {
    security_group_ids = ["${aws_security_group.eks-cluster-sg.id}"]
    subnet_ids = ["${var.public-subnet-ids}", "${var.private-subnet-ids}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy",
  ]
}
