resource "aws_security_group" "main" {
  name        = "${var.env}-${var.component}"
  description = "${var.env}-${var.component}"
  vpc_id      = var.vpc_id

  ingress {
    description = "APP"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.sg_cidrs
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidrs
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags       = merge(var.tags, { Name = "${var.env}-${var.component}" })
}

resource "aws_launch_template" "main" {
  name   = "${var.env}-${var.component}"
  image_id      = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  tags       = merge(var.tags, { Name = "${var.env}-${var.component}" })
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    role_name = var.component
    env       = var.env
  }))
  iam_instance_profile {
    name = aws_iam_instance_profile.main.name
  }
}

resource "aws_autoscaling_group" "main" {
  name               = "${var.env}-${var.component}"
  desired_capacity   = var.instance_count
  max_size           = var.instance_count +1
  min_size           = var.instance_count
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.env}-${var.component}"
    propagate_at_launch = true
  }
}



resource "aws_iam_role" "main" {
  name = "${var.env}-${var.component}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags                   = merge(var.tags, { Name = "${var.env}-${var.component}" })


  inline_policy {
    name = "SSM-Read-Access"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {

          "Sid": "GetParameters",
          "Effect": "Allow",
          "Action": [
            "ssm:GetParameterHistory",
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource":[
            "arn:aws:ssm:us-east-1:955993398443:parameter/${var.env}.${var.component}.*",
            "arn:aws:ssm:us-east-1:955993398443:parameter/NEW_RELIC_API_KEY",
            "arn:aws:ssm:us-east-1:955993398443:parameter/NEWRELIC_LICENSE_KEY",
            "arn:aws:ssm:us-east-1:955993398443:parameter/newrelic.licence_key",
            "arn:aws:ssm:us-east-1:955993398443:parameter/grafana_api_key",
            "arn:aws:ssm:us-east-1:955993398443:parameter/${var.env}.rds.*",
            "arn:aws:ssm:us-east-1:955993398443:parameter/${var.env}.rds.password",
            "arn:aws:ssm:us-east-1:955993398443:parameter/jenkins.*",
          ]
        },
        {
          "Sid" : "ListResources",
          "Effect" : "Allow",
          "Action" : "ssm:DescribeParameters",
          "Resource" : "*"
        },
        {
          "Sid": "S3Uploadtoprometheusalerts",
          "Effect": "Allow",
          "Action": [
            "s3:PutObject",
            "s3:GetObjectAcl",
            "s3:GetObject",
            "s3:DeleteObjectVersion",
            "s3:PutObjectVersionAcl",
            "s3:GetObjectAttributes",
            "s3:ListBucket",
            "s3:DeleteObject",
            "s3:PutObjectAcl"
          ],
          "Resource": [
            "arn:aws:s3:::bpk-prometheus-alerts",
            "arn:aws:s3:::bpk-prometheus-alerts/*"
          ]
        }
      ]
    })
  }
}
resource "aws_iam_instance_profile" "main" {
  name = "${var.env}-${var.component}"
  role = aws_iam_role.main.name
}