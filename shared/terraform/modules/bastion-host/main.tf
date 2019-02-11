resource "aws_security_group" "bastion-sg" {
  name   = "${var.bastion-host-name}-sg"
  vpc_id = "${var.vpc-id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = "${var.whitelisted-cidr-blocks}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.bastion-host-name}-sg"
  }
}

resource "aws_security_group_rule" "ssh" {
  count = "${var.num-sgs}"
  security_group_id = "${var.instance-sg-ids[count.index]}"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.bastion-sg.id}"
}

resource "aws_instance" "bastion" {
  subnet_id                   = "${var.public-subnet-id}"
  vpc_security_group_ids      = ["${aws_security_group.bastion-sg.id}"]
  associate_public_ip_address = true
  key_name = "${var.ssh-key-name}"
  instance_type = "t2.micro"
  ami = "${var.ami-id}"

  tags {
    Name = "${var.bastion-host-name}"
  }
}