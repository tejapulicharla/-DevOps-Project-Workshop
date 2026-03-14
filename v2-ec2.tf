provider "aws" {
    region = "ap-south-2"

  
}

resource "aws_instance" "hi" {
    ami = "ami-02774d409be696d81"
    instance_type = "t3.micro"
    key_name = "teja"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
  
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"

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