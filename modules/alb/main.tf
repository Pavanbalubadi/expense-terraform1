resource "aws_launch_template" "main" {
  name          = "${var.env}-${var.component}"
  image_id      = "ami-1a2b3c"
  instance_type = var.instance_type
}

resource "aws_autoscaling_group" "main" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
}
data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = "955993398443"
}
#