# Output variables for the ALB
output "alb_dns_name" {
  value = aws_alb.example.dns_name
}

output "alb_arn" {
  value = aws_alb.example.arn
}

output "target_group_arn" {
  value = aws_alb_target_group.example.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.my_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.example.name
}

output "ecs_service_task_definition" {
  value = aws_ecs_service.example.task_definition
}