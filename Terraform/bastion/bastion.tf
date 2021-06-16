#module
module "tf_vpc" {
  source = "../vpc"
}

provider "aws" {
	region = "ap-northeast-2"
}

#AWS Resource 

resource "aws_instance" "tf-bastion" {
  ami = "ami-0ba5cd124d7a79612"
  instance_type = "t2.micro"
  key_name = "krAdmin"
  availability_zone = "ap-northeast-2a"
  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id = module.tf_vpc.pub_subnet1.id
  user_data = "${file("./install_awscli.sh")}" 
  tags = {
    Name = "tf-bastion"
  }

}

resource "aws_security_group" "bastion_sg" {
  name = "bastion_sg"
  vpc_id = module.tf_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  tags = {
    Name = "Bastion_sg"
  }
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion_profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_role" "bastion_role" {
  name = "bastion_role"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service":  "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_policy" "bastion_policy" {
  name		= "bastion-policy"
  path		= "/"
  description	= "Bastion host policy"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
	  {
	    "Action":  "ec2:*",
	    "Effect": "Allow",
	    "Resource": "*"
	  }
	]
}
EOF
}
resource "aws_iam_policy_attachment" "attach-bastion-pocliy"{
  name		= "bastion-attach"
  roles		= [aws_iam_role.bastion_role.name]
  policy_arn 	= aws_iam_policy.bastion_policy.arn
}




















