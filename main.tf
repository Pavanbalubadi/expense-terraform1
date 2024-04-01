module "vpc" {
  source = "./modules/vpc"
  account_id = var.account_id
  app_subnets = var.app_subnets
  azs = var.azs
  db_subnets = var.db_subnets
  default_route_table_id = var.default_route_table_id
  env = var.env
  public_subnets = var.public_subnets
  tags = var.tags
  vpc_cidr_block = var.vpc_cidr_block
  web_subnets = var.web_subnets
}
