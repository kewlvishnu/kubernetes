project = "k8"
environment = "pp"

ssh-key-name = "devops-dev"

api-access = [
    "192.5.106.0/24", # Woburn Office CIDR
    "52.45.169.27/32" # Jenkins NAT
]

vpc-cidr = "10.64.92.0/22"
newbits = "2"
