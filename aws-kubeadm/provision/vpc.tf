
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cka-kubeadm-vpc"

  cidr = "192.168.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["192.168.1.0/24"]


  enable_ipv6             = false
  enable_nat_gateway      = false
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    Name = "kubeadm public subnet"
  }

  tags = {
    Owner       = "irvnet"
    Environment = "cka-kubeadm-test"
  }

  vpc_tags = {
    Name = "CKA kubeadm test env"
  }
}
