provider "aws" {
  region  = "eu-west-1"
  #The profile section controls the credentials used. You may need to deal with this :)
  profile = "os_session"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project     = "OS_Session",
    DeleteAfter = "August"
  }
}

resource "aws_subnet" "sn" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-west-1b"
  cidr_block        = "10.0.3.0/24"
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Project     = "OS_Session",
    DeleteAfter = "August"
  }
}

resource "aws_route_table_association" "sn" {
  subnet_id      = aws_subnet.sn.id
  route_table_id = aws_route_table.pub.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "linux" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "os_session"
  subnet_id = aws_subnet.sn.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.os_session.id]

  tags = {
    Name = "OS_Session-Linux"
    Project     = "OS_Session",
    DeleteAfter = "August"
  }
}

#Hardcoding AMI - poor practice but trying to finish quickly. 
resource "aws_instance" "windows" {
  ami           = "ami-08b8bf0a2fb1864a2"
  instance_type = "t2.medium"
  key_name = "os_session"
  subnet_id = aws_subnet.sn.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.os_session.id]

  tags = {
    Name = "OS_Session-Windows"
    Project     = "OS_Session",
    DeleteAfter = "August"
  }
}

resource "aws_security_group" "os_session" {
  name        = "os_session"
  description = "Inbound for demo"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_ip
  }

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.my_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "OS_Session"
    Project     = "OS_Session",
    DeleteAfter = "August"
  }
}

#You can set this yourself by replacing 1.2.3.4 with your public IP
variable "my_ip"{
    description = "Home IP - covered in tfvars"
    #default = "1.2.3.4/32"
}