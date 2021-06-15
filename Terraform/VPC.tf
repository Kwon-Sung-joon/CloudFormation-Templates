#https://registry.terraform.io/providers/hashicorp/aws/latest/docs

#AWS Provider
provider "aws" {
	access_key = "<YOUR ACCESS_KEY>"
	secret_key = "<YOUR SECRET_KEY>"
	region = "ap-northeast-2"
}

#AWS Resource

#Vpc
resource "aws_vpc" "tf_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "tf-vpc"
  }
}
#Public Subnet1
resource "aws_subnet" "tf_pub_subnet1" {
  vpc_id	= aws_vpc.tf_vpc.id
  cidr_block	= "192.168.10.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "tf-pub-subnet1"
  }
}
#Public Subnet2
resource "aws_subnet" "tf_pub_subnet2" {
  vpc_id	= aws_vpc.tf_vpc.id
  cidr_block	= "192.168.30.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "tf-pub-subnet2"
  }
}

#Private Subnet1
resource "aws_subnet" "tf_pri_subnet1" {
  vpc_id	= aws_vpc.tf_vpc.id
  cidr_block	= "192.168.20.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "tf-pri-subnet1"
  }
}

#Private Subnet2
resource "aws_subnet" "tf_pri_subnet2" {
  vpc_id	= aws_vpc.tf_vpc.id
  cidr_block	= "192.168.40.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "tf-pri-subnet2"
  }
}

#IGW
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf-igw"
  }
}

#Public Route Table
resource "aws_route_table" "tf_pub_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf_pub_rt"
  }
}

#Public Route
resource "aws_route" "tf_pub_route" {
  route_table_id = aws_route_table.tf_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.tf_igw.id
  depends_on = [
    aws_route_table.tf_pub_rt,
    aws_internet_gateway.tf_igw
  ]
}

#Route Table Assocation 1, 2
resource "aws_route_table_association" "tf_pub_rt_assocation1" {
  subnet_id = aws_subnet.tf_pub_subnet1.id
  route_table_id = aws_route_table.tf_pub_rt.id
}
resource "aws_route_table_association" "tf_pub_rt_assocation2" {
  subnet_id = aws_subnet.tf_pub_subnet2.id
  route_table_id = aws_route_table.tf_pub_rt.id
}


#Private Route Table
resource "aws_route_table" "tf_pri_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf_pri_rt"
  }
}
#Route Table Assocation 1, 2
resource "aws_route_table_association" "tf_pri_rt_assocation1" {
  subnet_id = aws_subnet.tf_pri_subnet1.id
  route_table_id = aws_route_table.tf_pri_rt.id
}
resource "aws_route_table_association" "tf_pri_rt_assocation2" {
  subnet_id = aws_subnet.tf_pri_subnet2.id
  route_table_id = aws_route_table.tf_pri_rt.id
}





