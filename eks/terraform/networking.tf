# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_availability_zones" "available" {}

resource "aws_vpc" "eks-vpc" {
  cidr_block = "${var.vpc-cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = "${
    map(
     "Name", "eks-${var.project}-${var.environment}-vpc",
     "kubernetes.io/cluster/eks-${var.project}-${var.environment}", "shared",
    )
  }"
}

resource "aws_subnet" "eks-public-subnets" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidrsubnet(var.vpc-cidr, var.newbits, count.index)}"
  vpc_id            = "${aws_vpc.eks-vpc.id}"

  tags = "${
    map(
     "Name", "eks-${var.project}-${var.environment}.public.${data.aws_availability_zones.available.names[count.index]}",
     "kubernetes.io/cluster/eks-${var.project}-${var.environment}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = "${aws_vpc.eks-vpc.id}"

  tags {
    Name = "eks-${var.project}-${var.environment}-igw"
  }
}

resource "aws_route_table" "eks-public-rt" {
  vpc_id = "${aws_vpc.eks-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks-igw.id}"
  }
  tags {
    Name = "eks-${var.project}-${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "eks-public-rta" {
  count = 2

  subnet_id      = "${aws_subnet.eks-public-subnets.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-public-rt.id}"
}

# Private subnets
resource "aws_subnet" "eks-private-subnets" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidrsubnet(var.vpc-cidr, var.newbits, count.index+2)}"
  vpc_id            = "${aws_vpc.eks-vpc.id}"

  tags = "${
    map(
     "Name", "eks-${var.project}-${var.environment}.private.${data.aws_availability_zones.available.names[count.index]}",
     "kubernetes.io/cluster/eks-${var.project}-${var.environment}", "shared",
    )
  }"
}

resource "aws_eip" "nat_gw_eip" {
  count = 2

  vpc      = true
  tags = {
      "Name" = "eks-${var.project}-${var.environment}-nat-gw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = 2

  allocation_id = "${aws_eip.nat_gw_eip.*.id[count.index]}"
  subnet_id     = "${aws_subnet.eks-public-subnets.*.id[count.index]}"

  tags {
    Name = "eks-${var.project}-${var.environment}-nat-gw"
  }

  depends_on = ["aws_internet_gateway.eks-igw"]
}

resource "aws_route_table" "eks-private-rt" {
  count = 2

  vpc_id = "${aws_vpc.eks-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.*.id[count.index]}"
  }

  tags {
    Name = "eks-${var.project}-${var.environment}-private-rt"
  }
}

resource "aws_route_table_association" "demo-private" {
  count = 2

  subnet_id      = "${aws_subnet.eks-private-subnets.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-private-rt.*.id[count.index]}"
}
