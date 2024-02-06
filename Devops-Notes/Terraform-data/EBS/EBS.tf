# To attch the existing ec2 instance volume to Another instance
# To create snap chat with existing Ec2 volume
resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_instance.first.root_block_device[0].volume_id

  tags = {
    Name = "example-snapshot"
  }
}

# Copy the snapchat form one region to another region
#resource "aws_ebs_snapshot_copy" "example_copy" {
#  source_snapshot_id = aws_ebs_snapshot.example_snapshot.id
#  source_region      = "us-west-1"

#  tags = {
#    Name = "HelloWorld_copy_snap"
#  }
#}


# Create an EBS volume from a snapshot
resource "aws_ebs_volume" "example" {
  availability_zone = var.availability_zone                # Specify the availability zone
  size              = 10                                   # Specify the size of the EBS volume in GiB
  snapshot_id       = aws_ebs_snapshot.example_snapshot.id # Replace with the snapshot ID you want to use

  tags = {
    Name = "example-volume2"
  }
}

# Crating Second Ec2 instance
resource "aws_instance" "second" {
  ami                         = var.ami           # Change to your desired AMI ID
  instance_type               = var.instance_type # Change to your desired instance type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true         # Enable a public IP
  key_name                    = var.key_name # Change to your key pair name
  availability_zone           = var.availability_zone
  vpc_security_group_ids      = [aws_security_group.example_security_group.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    #delete_on_termination = true        # Set to true if you want the volume to be deleted when the instance is terminated
  }

  tags = {
    Name = "EBS-2"
  }
}


# To attach the EBS vloume to EC2 instance
resource "aws_volume_attachment" "ebs_att" {
  volume_id    = aws_ebs_volume.example.id
  instance_id  = aws_instance.second.id
  device_name  = "/dev/sdf"
  force_detach = true
}






# If you want to delete existing instance-2 root volume and attach above existing instance-1 root volume to second instance you have follow below steps 
# Stop the instance before detaching the volume
resource "aws_instance" "stop_instance" {
  count         = var.stop_instance ? 1 : 0 # Conditionally stop the instance based on a variable
  ami           = aws_instance.second.ami
  instance_type = aws_instance.second.instance_type

  lifecycle {
    prevent_destroy = false # Prevent Terraform from destroying the stopped instance
  }

  depends_on = [aws_instance.second]
}

# Detach the root volume from the instance
resource "aws_volume_attachment" "detach_root_volume" {
  count       = length(aws_instance.stop_instance) > 0 ? 1 : 0
  device_name = "/dev/xvda" # Specify the root device name
  instance_id = aws_instance.stop_instance[0].id
  volume_id   = aws_instance.second.root_block_device[0].volume_id # Use the ID of the created EBS volume

  depends_on = [aws_instance.stop_instance]
}

# Null resource for deleting the EBS volume
resource "null_resource" "delete_example_ebs_volume" {
  count = length(aws_instance.stop_instance) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "aws ec2 delete-volume --volume-id ${aws_instance.second.root_block_device[0].volume_id}"
  }
}

# Note: Detach and delete it is not working particually. it is working in terrform

# To attach the EBS vloume to EC2 instance
resource "aws_volume_attachment" "ebs_att" {
  volume_id    = aws_ebs_volume.example.id
  instance_id  = aws_instance.second.id
  device_name  = "/dev/xvdf"
  force_detach = true
}







# How to attach EBS volume to Ec2 instance and that EBS volume attach to second instance
# To create EBS volume
resource "aws_ebs_volume" "example" {
  availability_zone = var.availability_zone # Specify the availability zone
  size              = 10                    # Specify the size of the EBS volume in GiB
  # Other volume configuration settings go here

  tags = {
    Name = "example-volume"
  }
}

# To attach the volume to EC2 instance 
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.first.id
  force_detach = true
}


# To create snap chat to New create  EBS volume
resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.example.id

  tags = {
    Name = "HelloWorld_snap"
  }
}

# Snap chat Copy from one region to another region
#resource "aws_ebs_snapshot_copy" "example_copy" {
#  source_snapshot_id = aws_ebs_snapshot.example_snapshot.id
#  source_region      = "us-west-1"

#  tags = {
#    Name = "HelloWorld_copy_snap"
#  }
#}

# Create an EBS volume from a snapshot
resource "aws_ebs_volume" "example1" {
  availability_zone = var.availability_zone  # Specify the availability zone
  size             = 10  # Specify the size of the EBS volume in GiB
  snapshot_id      = aws_ebs_snapshot.example_snapshot.id  # Replace with the snapshot ID you want to use

  tags = {
    Name = "example-volume2"
  }
}

# Crating Second Ec2 instance
resource "aws_instance" "second" {
  ami                         = var.ami           # Change to your desired AMI ID
  instance_type               = var.instance_type # Change to your desired instance type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true         # Enable a public IP
  key_name                    = var.key_name # Change to your key pair name
  availability_zone           = var.availability_zone
  vpc_security_group_ids      = [aws_security_group.example_security_group.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    #delete_on_termination = true        # Set to true if you want the volume to be deleted when the instance is terminated
  }

  tags = {
    Name = "EBS-2"
  }
}

# Volume attach to Ec2
resource "aws_volume_attachment" "ebs_att1" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.example1.id
  instance_id = aws_instance.second.id
}




