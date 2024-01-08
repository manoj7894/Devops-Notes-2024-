# To create providers
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# To create VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc01"
  }
}

# To create public subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id # Replace with your VPC ID
  cidr_block        = "10.0.0.0/24"  # Replace with your desired CIDR block
  availability_zone = "ap-south-1a"  # Replace with your desired Availability Zone

  # Optional: Assign tags to your subnets
  tags = {
    Name = "Public Subnet"
  }
}

# To create private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id # Replace with your VPC ID
  cidr_block        = "10.0.1.0/24"  # Replace with your desired CIDR block
  availability_zone = "ap-south-1b"  # Replace with your desired Availability Zone

  # Optional: Assign tags to your subnets
  tags = {
    Name = "Private Subnet"
  }
}

# To create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  # Optional: Assign tags to your Internet Gateway
  tags = {
    Name = "My Internet Gateway"
  }
}

# To create elastic Ip
resource "aws_eip" "eip" {
  vpc = true

  # Optional: Associate tags with the Elastic IP
  tags = {
    Name = "MyElasticIP"
  }
}

# To create nat gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id

  # Optional: Associate tags with the Elastic IP
  tags = {
    Name = "net-gateway"
  }
}

# To create the route table-1
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

# To create route table-2
resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  # Optional: Assign tags to your route table
  tags = {
    Name = "MyRouteTable2"
  }
}

# To assign route table-1 to public subnet
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt1.id
}

# To assign route table-2 to private subnet
resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt2.id
}

# Create a security group
resource "aws_security_group" "example_security_group" {
  name_prefix = "example-security-group"
  description = "Example security group"
  vpc_id      = aws_vpc.vpc.id

  # Define your security group rules as needed to you
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

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
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

# To get the AMI id 
data "aws_caller_identity" "current" {}

# To create the KMS key
resource "aws_kms_key" "my_kms_key" {
  description              = "My KMS Keys for Data Encryption"
  customer_master_key_spec = var.key_spec         #SYMMETRIC_DEFAULT
  is_enabled               = var.enabled          # true
  enable_key_rotation      = var.rotation_enabled # true
  deletion_window_in_days  = 7

  tags = {
    Name = "my_kms_key"
  }

  policy = <<POLICY
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform-2"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform-2"
                ]
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
POLICY
}

# To create the alias for KMS
resource "aws_kms_alias" "my_kms_alias" {
  target_key_id = aws_kms_key.my_kms_key.key_id
  name          = "alias/${var.kms_alias}"
}
