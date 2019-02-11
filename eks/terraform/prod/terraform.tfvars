project = "k8"
environment = "prod"

ssh-key-name = "eks-k8-prod"

api-access = [
    "192.5.106.0/24", # Woburn Office CIDR
    "52.45.169.27/32" # Jenkins NAT
]

vpc-cidr = "10.66.0.0/19"
newbits = "2"
