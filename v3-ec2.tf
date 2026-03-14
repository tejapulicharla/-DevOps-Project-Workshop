provider "aws" {
    region = "ap-south-2"

  
}

resource "aws_instance" "hi" {
    ami = "ami-02774d409be696d81"
    instance_type = "t3.micro"
    key_name = "teja"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.public.id
  
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "demo-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "demo-sg" {
  security_group_id = aws_security_group.demo-sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "demo-sg" {
  security_group_id = aws_security_group.demo-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
    output "instance_public_ip" {
    value = aws_instance.hi.public_ip
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "main-vpc"
    }
}
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    name = "public-subnet"
  }
}
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    tags = { name = "private-subnet"}
  
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = { name = "main-igw"}
  
}
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}
resource "aws_route_table_association" "rta-1" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.rt.id
  
}
resource "aws_route_table_association" "rta-2" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.rt.id
  
}