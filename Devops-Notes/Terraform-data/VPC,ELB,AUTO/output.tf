output "load_balancer_dns_name" {
  value = aws_lb.example.dns_name
}

output "target_group_arn" {
  value = [aws_lb_target_group.example_target_group.arn, aws_lb_target_group.example_target_group1.arn]
}