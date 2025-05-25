module "vpc" {
  source = "./modules/VPC"

  vpc_cidr              = var.vpc_cidr
  cluster_name          = var.cluster_name
  private_subnet_cidrs  = var.private_subnet_cidrs
  az_for_private_subnet = var.az_for_private_subnet
  public_subnet_cidrs   = var.public_subnet_cidrs
  az_for_public_subnet  = var.az_for_public_subnet

}

module "eks" {
  source = "./modules/EKS"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  node_groups     = var.node_groups
}