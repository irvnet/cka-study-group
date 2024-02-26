
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cka-minikube-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_ipv6             = false
  enable_nat_gateway      = false
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    Name = "minikube public subnet"
  }

  private_subnet_tags = {
    Name = "minikube private subnet"
  }

  tags = {
    Owner       = "irvnet"
    Environment = "cka-minikube-test"
  }

  vpc_tags = {
    Name = "CKA minikube test env"
  }
}
