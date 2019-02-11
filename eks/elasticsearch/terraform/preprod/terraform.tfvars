project = "es"
environment = "preprod"

elasticsearch-instance-size = "t2.small.elasticsearch"
elasticsearch-ebs-volume-size = 35

office-ips = [
    "192.5.106.0/24", # Woburn Office CIDR
    "52.45.169.27/32" # Jenkins NAT
]

eks-nat-gws = [
    "54.210.236.195/32",
    "54.175.226.51/32"
]
