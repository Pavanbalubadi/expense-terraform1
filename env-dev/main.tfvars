vpc_cidr_block = "10.10.0.0/16"
env            = "dev"
tags           ={
  company= "HclTech"
  project="expense"
  group="balubadi"
}
public_subnets =["10.10.0.0/24","10.10.1.0/24"]
web_subnets =["10.10.2.0/24","10.10.3.0/24"]
app_subnets =["10.10.4.0/24","10.10.5.0/24"]
db_subnets =["10.10.6.0/24","10.10.7.0/24"]

azs =["us-east-1a","us-east-1b"]
account_id= "955993398443"
default_vpc_id="vpc-0c4258e1140be342c"
default_route_table_id="rtb-076a9674861345f0d"
default_vpc_cidr="172.31.0.0/16"


##rds
rds_allocated_storage = 20
rds_engine            = "mysql"
rds_engine_version    = "5.7.44"
rds_instance_class    = "db.t3.micro"

##app
backend = {
  app_port       = 8080
  component ="backend"
  instance_count = 1
  instance_type  = "t3.small"

}
frontend = {
  app_port       = 80
  instance_count = 1
  instance_type  = "t3.small"
  component ="frontend"
}

bastion_cidrs = ["172.31.2.164/32"]


route53_zone_id  ="Z0884885ZSESFET2B3ZQ"
kms_key            = "arn:aws:kms:us-east-1:955993398443:key/a0d0f53d-84ee-402a-9294-2b56af39a9d5"
certificate_arn  = "arn:aws:acm:us-east-1:955993398443:certificate/0752a7d4-f672-4af5-990a-c25494c91cda"
#