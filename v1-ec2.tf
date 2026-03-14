provider "aws" {
    region = "ap-south-2"

  
}

resource "aws_instance" "hi" {
    ami = "ami-02774d409be696d81"
    instance_type = "t3.micro"
    key_name = "teja"
  
}