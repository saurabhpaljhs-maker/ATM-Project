module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "atm-project-vpc"
  cidr = "10.0.0.0/16"

  # High availability ke liye 2 alag availability zones
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"] # Pods yahan chalenge (Super Safe)
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"] # LoadBalancer yahan khada hoga

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1" # AWS LoadBalancer automatic fetch karne ke liye label
  }
}
