# Create an ECS cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-Cluster1" # Specify your cluster name
}

# Define an ECS task definition
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.example.arn

  cpu    = "256" # Specify the CPU units for the task (e.g., "256")
  memory = "512" # Specify the memory for the task in MiB (e.g., "512")

  container_definitions = jsonencode([
    {
      "name" : "my-container",
      "image" : "docker.io/${var.DOCKER_USERNAME}/${var.IMAGE_NAME}:latest",
      "essential"     : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ]
      #"mount_points" : [
        #{
         # "container_path" : "home/ec2-user/var/lib/docker/volumes",
        #  "source_volume" : "/appse"
       # }
      #]
    }
  ])
}


# Define the ECS service
resource "aws_ecs_service" "example" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2 # Specify the desired number of tasks

  network_configuration {
    subnets          = [aws_subnet.public.id, aws_subnet.private.id]
    security_groups  = [aws_security_group.example_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.example.arn
    container_name   = "my-container"
    container_port   = 80
  }
  depends_on = [aws_alb_listener.example, data.aws_iam_policy_document.assume_role]
}

# To launch the cofiguration
resource "aws_launch_configuration" "example" {
  name_prefix     = "example-launch-config-"
  image_id        = var.ami           # Change to your desired AMI ID
  instance_type   = var.instance_type # Change to your desired instance type
  key_name        = var.key_name      # Change to your key pair name
  security_groups = [aws_security_group.example_security_group.id]
}

# create autoscaling
resource "aws_autoscaling_group" "example" {
  name                      = "my-ecs-auto-scaling-group"
  launch_configuration      = aws_launch_configuration.example.name
  min_size                  = 1
  max_size                  = 10
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [aws_subnet.public.id, aws_subnet.private.id]
}

# To create autoscaling target group
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.my_cluster.name}/${aws_ecs_service.example.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# To create autoscaling policy
resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "ecs-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
