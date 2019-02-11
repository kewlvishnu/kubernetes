resource "aws_security_group" "eks-cluster-sg" {
  name        = "eks-${var.project}-${var.environment}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc-id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "eks-${var.project}-${var.environment}-cluster-sg"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
  cidr_blocks       = "${var.api-access}"
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks-cluster-sg.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-cluster-sg.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-node-sg.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster-https" {
  description              = "Allow master/cluster to communicate with the nodes on 443"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-cluster-node-sg.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-sg.id}"
  to_port                  = 443
  type                     = "ingress"
}

# NODES
resource "aws_security_group" "eks-cluster-node-sg" {
  name        = "eks-${var.project}-${var.environment}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${var.vpc-id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "eks-${var.project}-${var.environment}-node-sg",
     "kubernetes.io/cluster/eks-${var.project}-${var.environment}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "eks-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks-cluster-node-sg.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-node-sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-cluster-node-sg.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-sg.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-workstation-ssh" {
  cidr_blocks       = "${var.api-access}"
  description       = "Allow workstation to ssh into nodes"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks-cluster-node-sg.id}"
  to_port           = 22
  type              = "ingress"
}
