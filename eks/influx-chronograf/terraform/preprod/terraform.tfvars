project = "eks-TICK"
environment = "preprod"

chronograf-ssl-cert-id = "arn:aws:acm:us-east-1:319087885992:certificate/c0d548e0-c06e-49bb-9204-10d82e65ecf2"

office-ips = [
    "192.5.106.0/24", # Woburn Office CIDR
    "52.45.169.27/32" # Jenkins NAT
]

eks-nat-gws = [
    "54.210.236.195/32",
    "54.175.226.51/32"
]

public-subnet-ids = [
    "subnet-0e4cdd91badd50cf3",
    "subnet-03015e7bb6797c8fd"
]

private-subnet-id = "subnet-0ac4a96a57e3b5774"

vpc-id = "vpc-0cb70e89bd3183f03"
