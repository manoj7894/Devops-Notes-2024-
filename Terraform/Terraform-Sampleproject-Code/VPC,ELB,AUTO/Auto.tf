# To create IAM ec2 policy role
resource "aws_iam_role" "example" {
  name = "example-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# To create instance profile
resource "aws_iam_instance_profile" "example" {
  name = "example-instance-profile"
  role = aws_iam_role.example.name
}

# To launch the template-1
resource "aws_launch_template" "example" {
  name_prefix            = "template"
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  user_data              = filebase64("/home/ec2-user/ELB/file.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.example.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Application-1"
    }
  }
}

# To create the Autoscaling group-1
resource "aws_autoscaling_group" "example" {
  vpc_zone_identifier       = [aws_subnet.public-3.id]
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.example_target_group.arn]

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Scale"
    value               = true
    propagate_at_launch = true
  }
}

# To attach target group-1 to autoscaling group-1
resource "aws_autoscaling_attachment" "example_attachment" {
  autoscaling_group_name = aws_autoscaling_group.example.name
  lb_target_group_arn    = aws_lb_target_group.example_target_group.arn
}

# To launch the template-2
resource "aws_launch_template" "example1" {
  name_prefix            = "template"
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  user_data              = filebase64("/home/ec2-user/ELB/file1.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.example.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Application-2"
    }
  }
}

# To create the Autoscaling group-2
resource "aws_autoscaling_group" "example1" {
  vpc_zone_identifier       = [aws_subnet.public-4.id]
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.example_target_group1.arn]

  launch_template {
    id      = aws_launch_template.example1.id
    version = "$Latest"
  }

  tag {
    key                 = "Scale"
    value               = true
    propagate_at_launch = true
  }
}

# To attach target group-2 to autoscaling group-2
resource "aws_autoscaling_attachment" "example_attachment1" {
  autoscaling_group_name = aws_autoscaling_group.example1.name
  lb_target_group_arn    = aws_lb_target_group.example_target_group1.arn
}
