# Providers
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create an vpc
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc01"
  }
}

# Create Public-subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id # Replace with your VPC ID
  cidr_block        = "10.0.0.0/24"  # Replace with your desired CIDR block
  availability_zone = "ap-south-1a"  # Replace with your desired Availability Zone

  # Optional: Assign tags to your subnets
  tags = {
    Name = "Public Subnet"
  }
}

# Create Private-subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id # Replace with your VPC ID
  cidr_block        = "10.0.1.0/24"  # Replace with your desired CIDR block
  availability_zone = "ap-south-1b"  # Replace with your desired Availability Zone

  # Optional: Assign tags to your subnets
  tags = {
    Name = "Private Subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  # Optional: Assign tags to your Internet Gateway
  tags = {
    Name = "My Internet Gateway"
  }
}

# create RouteTable-1
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

# create RouteTable-2
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

# Attach Public Subnet to routetable-1
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt1.id
}

# Attach Private Subnet to routetable-2
resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt2.id
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

# Define a null_resource to trigger local-exec provisioners
resource "null_resource" "build_and_push" {
  triggers = {
    # Trigger the provisioners whenever the build script changes
    script_version = filebase64("/home/ec2-user/ecs/build.sh") #in linux
    # script_version = filebase64("./build.sh")     # in visual sudio code
  }

  # Use local-exec provisioners to build and push the Docker image
  provisioner "local-exec" {
    command = "docker build -t ${var.DOCKER_USERNAME}/${var.IMAGE_NAME}:latest ."
  }

  # To login the docker hub
  provisioner "local-exec" {
    command = "docker login -u ${var.DOCKER_USERNAME} -p ${var.DOCKER_PASSWORD}"
    # Note: Providing the password directly in the command might not be secure.
    # Consider using other secure methods for credentials.
  }

  # To push image into docker hub
  provisioner "local-exec" {
    command = "docker push ${var.DOCKER_USERNAME}/${var.IMAGE_NAME}:latest"
  }
}

# To create policy documenent1
data "aws_iam_policy_document" "assume_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# To create the IAM role1
resource "aws_iam_role" "example" {
  name               = var.ecs_task_execution_role
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.example.name
}

# To create Load Balancer
resource "aws_alb" "example" {
  name            = "example-alb"
  internal        = false # Set to true if you want an internal ALB
  subnets         = [aws_subnet.public.id, aws_subnet.private.id]
  security_groups = [aws_security_group.example_security_group.id]
}

# To create Target Group
resource "aws_alb_target_group" "example" {
  name        = "example-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id # Replace with your VPC ID

  # Set the health check configuration
  health_check {
    path                = var.health_check_path # Specify the path for the health check
    interval            = 30                    # Health check interval in seconds
    timeout             = 3                     # Health check timeout in seconds
    healthy_threshold   = 2                     # Number of consecutive successful health checks
    unhealthy_threshold = 2                     # Number of consecutive failed health checks
    protocol            = "HTTP"
    matcher             = "200"
  }
}

# To create load balancer listener
resource "aws_alb_listener" "example" {
  load_balancer_arn = aws_alb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.example.arn
  }
}
