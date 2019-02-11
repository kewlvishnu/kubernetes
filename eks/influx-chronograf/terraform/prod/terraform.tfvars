project = "eks-TICK"
environment = "prod"

chronograf-ssl-cert-id = "arn:aws:acm:us-east-1:840432117366:certificate/d1e63fc6-7526-4136-80c6-bb3c5985558d"

office-ips = [
    "192.5.106.0/24", # Woburn Office CIDR
    "52.45.169.27/32" # Jenkins NAT
]

eks-nat-gws = [
    "35.175.16.252/32",
    "18.215.43.134/32"
]

public-subnet-ids = [
    "subnet-04214c573dd2e782f",
    "subnet-01c9ee53cebfbed95"
]

private-subnet-id = "subnet-09777267f2d58769a"

vpc-id = "vpc-0dcd8202b714326f8"
