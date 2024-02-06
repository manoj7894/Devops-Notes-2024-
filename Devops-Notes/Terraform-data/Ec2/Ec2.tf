# To create the Ec2 instance
resource "aws_instance" "example_instance" {
  ami                         = var.ami           # Change to your desired AMI ID
  instance_type               = var.instance_type # Change to your desired instance type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true         # Enable a public IP
  key_name                    = var.key_name # Change to your key pair name
  availability_zone           = var.availability_zone
  count                       = var.instance_count
  user_data                   = filebase64("/home/ec2-user/file.sh")
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
    Name = "Example-Instance-${count.index}"
  }
}