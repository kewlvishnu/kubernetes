module "influx-chronograf" {
  source = "../../../../shared/terraform/modules/influx-chronograf"
  project = "${var.project}"
  environment = "${var.environment}"
  public_subnet_ids = "${var.public-subnet-ids}"
  private_subnet_id = "${var.private-subnet-id}"
  vpc_id = "${var.vpc-id}"
  office_ips = "${var.office-ips}"
  nat_gw_ips = "${var.eks-nat-gws}"
  ssl_certificate_id = "${var.chronograf-ssl-cert-id}"
}

output "influx-chronograf-instance-sg" {
  value = "${module.influx-chronograf.instance-sg-name}"
}

output "influx-chronograf-elb-id" {
  value = "${module.influx-chronograf.elb-id}"
}

output "influx-efs-dns-name" {
  value = "${module.influx-chronograf.influx-efs-dns-name}"
}

output "chronograf-efs-dns-name" {
  value = "${module.influx-chronograf.chronograf-efs-dns-name}"
}
