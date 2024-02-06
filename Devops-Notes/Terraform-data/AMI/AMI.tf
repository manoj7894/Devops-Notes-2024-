# To create AMI image from instance
resource "aws_ami_from_instance" "example" {
  name               = "example-ami"
  source_instance_id = aws_instance.first.id
}


# Create Ec2 instance using AMI image
resource "aws_instance" "second" {
  ami                         = aws_ami_from_instance.example.id # Change to your desired AMI ID
  instance_type               = var.instance_type                # Change to your desired instance type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true         # Enable a public IP
  key_name                    = var.key_name # Change to your key pair name
  availability_zone           = var.availability_zone
  vpc_security_group_ids      = [aws_security_group.example_security_group.id]
  #user_data = <<-EOF
  #!/bin/bash
  #sudo echo "Hello from user data!" > /tmp/file123.txt
  # You can put any shell script or commands here
  #EOF

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name = "AMI"
  }
}




