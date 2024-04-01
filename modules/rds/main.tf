resource "aws_db_parameter_group" "main" {
  name   = "${var.env}-msql-rds"
  family = "mysql5.7"
  tags   = merge(var.tags, { Name = "${var.env}-msql-rds" })
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-msql-rds"
  subnet_ids = var.subnets
  tags       = merge(var.tags, { Name = "${var.env}-msql-rds" })
}

resource "aws_security_group" "main" {
  name        = "${var.env}-msql-rds"
  description = "${var.env}-msql-rds"
  vpc_id      = var.vpc_id

  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.sg_cidrs
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags       = merge(var.tags, { Name = "${var.env}-msql-rds" })
}

resource "aws_db_instance" "main" {
  allocated_storage     = var.rds_allocated_storage
  db_name                = "mydb"
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  username               = data.aws_ssm_parameter.username.value
  password               = data.aws_ssm_parameter.password.value
  parameter_group_name   = aws_db_parameter_group.main.name
  tags                   = merge(var.tags, { Name = "${var.env}-msql-rds" })
  skip_final_snapshot    = true
  multi_az               = true
  identifier             = "${var.env}-msql-rds"
  storage_type           = "gp3"
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]
  kms_key_id             = var.kms_key
  storage_encrypted      = true
}
