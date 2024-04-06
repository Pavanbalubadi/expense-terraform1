
##
data "aws_ami" "ami" {
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["955993398443"]
}