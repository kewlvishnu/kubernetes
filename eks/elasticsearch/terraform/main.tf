data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "monitoring-es" {
  domain_name = "eks-${var.project}-${var.environment}"
  elasticsearch_version = "5.3"
  cluster_config {
    instance_type = "${var.elasticsearch-instance-size}"
  }
  ebs_options {
    ebs_enabled = true
    volume_size = "${var.elasticsearch-ebs-volume-size}"
  }
  access_policies = <<CONFIG
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Sid": "",
     "Effect": "Allow",
     "Principal": {
       "AWS": "*"
     },
     "Action": [
       "es:*"
     ],
     "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/monitoring-eks-${var.project}-${var.environment}/*",
     "Condition": {
       "IpAddress": {
         "aws:SourceIp": ${jsonencode(concat(var.office-ips, var.eks-nat-gws))}
       }
     }
   }
 ]
}
CONFIG

}
