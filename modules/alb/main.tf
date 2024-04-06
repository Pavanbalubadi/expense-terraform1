resource "aws_lb" "main" {
  name               = "${var.env}-${var.component}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets
  tags               = merge(var.tags, { Name = "${var.env}-${var.component}-alb" })

}
variable "env" {}
variable "component" {}
variable "internal" {}
variable "subnets" {}
variable "tags" {}