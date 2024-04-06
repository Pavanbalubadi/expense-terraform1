variable "vpc_cidr_block" {}
variable "env" {}
variable "tags" {}
variable "public_subnets" {}
variable "web_subnets" {}
variable "app_subnets" {}
variable "db_subnets" {}
variable "azs" {}
variable "default_route_table_id" {}
variable "account_id" {}
variable "default_vpc_id" {}
variable "default_vpc_cidr" {}

##rds
variable "rds_allocated_storage" {}
variable "rds_engine" {}
variable "rds_instance_class" {}
variable "rds_engine_version" {}
variable "kms_key" {}

##
variable "backend" {}