project = "k8"
environment = "test"

ssh-key-name = "eks-k8-test"

api-access = [
    "192.5.106.0/24", # Woburn Office CIDR
    "52.45.169.27/32" # Jenkins NAT
  ]

elasticsearch-instance-size = "t2.small.elasticsearch"
elasticsearch-ebs-volume-size = 35
vpc-cidr = "10.64.92.0/22"
newbits = "2"

desired-capacity = 2
min-size = 1
max-size = 4