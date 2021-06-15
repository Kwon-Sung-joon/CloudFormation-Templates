#module 
module "tf_vpc" {
  source = "../vpc"
}

#AWS Resource 


#need PrivateSubnet for subnet group Id 1, 2

#need public subnet1 , private 1,2, cidr ip 
#vpc id
#for rds sg

resource "aws_db_subnet_group" "tf_rds_subnet_group" {
  name = "tf_rds_test"
  subnet_ids = [ module.tf_vpc.pri_subnet1.id , module.tf_vpc.pri_subnet2.id]
  tags = {
    Name = "tf db subnet group"
  }
}



resource "aws_db_instance" "tf_db_instance" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  name = "tfdb"
  username = "admin"
  password = "123456789"
  availability_zone = "ap-northeast-2a" 
  skip_final_snapshot = true
  storage_type = "gp2"
  identifier = "tf-rds"
  db_subnet_group_name = aws_db_subnet_group.tf_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  vpc_id = module.tf_vpc.vpc.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [module.tf_vpc.pri_subnet1.cidr_block, module.tf_vpc.pri_subnet2.cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  
  tags = {
    Name = "rds_sg"
  }
}



