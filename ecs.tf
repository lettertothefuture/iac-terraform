resource "aws_ecs_cluster" "node_cluster" {
  name = "node-cluster"
}

resource "aws_ecs_task_definition" "node_task" {
  family             = "node-task"
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  network_mode       = "awsvpc"
  container_definitions = jsonencode([{
    name      = "node-container"
    image     = "${aws_ecr_repository.node_repo.repository_url}:latest"
    essential = true
    memory    = 512
    cpu       = 256
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])

  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "node_service" {
  name            = "node-service"
  cluster         = aws_ecs_cluster.node_cluster.id
  task_definition = aws_ecs_task_definition.node_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [var.subnet_id]
    assign_public_ip = true
  }
}
