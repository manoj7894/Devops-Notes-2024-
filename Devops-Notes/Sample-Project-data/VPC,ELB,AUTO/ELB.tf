# To create Load balancer
resource "aws_lb" "example" {
  name                       = "example-alb"
  load_balancer_type         = "application"
  internal                   = false                                            # Set to true for an internal ALB
  subnets                    = [aws_subnet.public-1.id, aws_subnet.public-2.id] # Replace with your subnet IDs
  enable_deletion_protection = false
  security_groups            = [aws_security_group.example_security_group.id]

}

# To create the target group-1
resource "aws_lb_target_group" "example_target_group" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id # Replace with your VPC ID
  target_type = "instance"

  health_check {
    path                = "/app1/index.html" # Modify this to match your application's health check path
    protocol            = "HTTP"
    port                = 80
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# To create Load balancer listener
resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }

}

# To create the load balance listener rule for target group-1
resource "aws_lb_listener_rule" "example_rule_1" {
  listener_arn = aws_lb_listener.example.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/app1"]
    }
  }
}

# To create the target group-2
resource "aws_lb_target_group" "example_target_group1" {
  name     = "example-target-group1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id # Replace with your VPC ID
  target_type = "instance"

  health_check {
    path                = "/app2/index.html" # Modify this to match your application's health check path
    protocol            = "HTTP"
    port                = 80
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# To create the load balance listener rule for target group-1
resource "aws_lb_listener_rule" "example_rule_2" {
  listener_arn = aws_lb_listener.example.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_target_group1.arn
  }

  condition {
    path_pattern {
      values = ["/app2"]
    }
  }
}

