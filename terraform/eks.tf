module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "ramji-atm-cluster" # Hamari Jenkinsfile ka absolute cluster identification name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true # Jenkins container dynamic command handling access ke liye true

  eks_managed_node_groups = {
    ramji_atm_nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2 # At least 2 servers hamesha replication ke liye ready rahenge

      instance_types = ["t3.medium"] # ATM logic processing aur stability ke liye right buffer capacity
    }
  }
}
