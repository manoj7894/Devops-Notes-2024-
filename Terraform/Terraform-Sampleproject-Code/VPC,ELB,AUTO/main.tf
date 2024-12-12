provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# To Create VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc01"
  }
}

# To Create Public Subnet
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.vpc.id # Replace with your VPC ID
  cidr_block              = "10.0.0.0/24"  # Replace with your desired CIDR block
  availability_zone       = "ap-south-1a"  # Replace with your desired Availability Zone
  map_public_ip_on_launch = true           # Enable auto-assign public IP

  # Optional: Assign tags to your subnets
  tags = {
    Name = "Public Subnet-1"
  }
}

# To Create Private Subnet
resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.vpc.id # Replace with your VPC ID
  cidr_block              = "10.0.1.0/24"  # Replace with your desired CIDR block
  availability_zone       = "ap-south-1b"  # Replace with your desired Availability Zone
  map_public_ip_on_launch = true           # Enable auto-assign public IP

  # Optional: Assign tags to your subnets
  tags = {
    Name = "Public Subnet-2"
  }
}

# To Create Private Subnet
resource "aws_subnet" "public-3" {
  vpc_id                  = aws_vpc.vpc.id # Replace with your VPC ID
  cidr_block              = "10.0.2.0/24"  # Replace with your desired CIDR block
  availability_zone       = "ap-south-1a"  # Replace with your desired Availability Zone
  map_public_ip_on_launch = true           # Enable auto-assign public IP

  # Optional: Assign tags to your subnets
  tags = {
    Name = "Public Subnet-3"
  }
}

# To Create Private Subnet
resource "aws_subnet" "public-4" {
  vpc_id                  = aws_vpc.vpc.id # Replace with your VPC ID
  cidr_block              = "10.0.3.0/24"  # Replace with your desired CIDR block
  availability_zone       = "ap-south-1b"  # Replace with your desired Availability Zone
  map_public_ip_on_launch = true           # Enable auto-assign public IP

  # Optional: Assign tags to your subnets
  tags = {
    Name = "Public Subnet-4"
  }
}

# To create the Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  # Optional: Assign tags to your Internet Gateway
  tags = {
    Name = "My Internet Gateway"
  }
}

# To create Routetable-1
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # Optional: Assign tags to your route table
  tags = {
    Name = "MyRouteTable"
  }
}

# To create Routetable-2
resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # Optional: Assign tags to your route table
  tags = {
    Name = "MyRouteTable2"
  }
}

# To create Routetable-2
resource "aws_route_table" "rt3" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # Optional: Assign tags to your route table
  tags = {
    Name = "MyRouteTable3"
  }
}

# To create Routetable-2
resource "aws_route_table" "rt4" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # Optional: Assign tags to your route table
  tags = {
    Name = "MyRouteTable4"
  }
}

# To attch Publicsubnet and routetable-1
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.rt1.id
}

# To attch Privatesubnet and routetable-2
resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.rt2.id
}

# To attch Privatesubnet and routetable-3
resource "aws_route_table_association" "subnet3_association" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.rt3.id
}

# To attch Privatesubnet and routetable-4
resource "aws_route_table_association" "subnet4_association" {
  subnet_id      = aws_subnet.public-4.id
  route_table_id = aws_route_table.rt4.id
}

# Create a security group
resource "aws_security_group" "example_security_group" {
  name_prefix = "example-security-group"
  description = "Example security group"
  vpc_id      = aws_vpc.vpc.id

  # Define your security group rules as needed
  # For example, allow SSH and HTTP traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outgoing traffic

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


