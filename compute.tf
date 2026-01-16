# ===========================================
# Compute Layer (ECS + ALB)
# Steps 11, 12, 13, 14
# ===========================================

# 1. ECR
resource "aws_ecr_repository" "main" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = local.force_destroy  # 使用環境變數

  tags = { Name = "${var.ecr_repo_name}" }
}

# 2. Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  tags = { Name = "${var.project_name}-ALB" }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-TG"
  port        = var.wp_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = local.is_production ? 30 : 60  # 生產環境更頻繁檢查
    timeout             = local.is_production ? 10 : 30
    healthy_threshold   = 2
    unhealthy_threshold = local.is_production ? 3 : 10
    matcher             = "200-399"
  }

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  tags = { Name = "${var.project_name}-TG" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# 3. ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-ECS"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = { Name = "${var.project_name}-ECS" }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = "FARGATE"
  }
}

# 4. Task Definition
# Define the log group explicitly here because it's referenced in Task Def
resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.project_name}-wordpress"
  retention_in_days = local.is_production ? 90 : 30  # 生產環境保留更久
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-wordpress-task-v2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.task_cpu       # 使用 locals
  memory                   = local.task_memory    # 使用 locals
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn

  volume {
    name = "wordpress-efs"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.main.id
      transit_encryption      = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.main.id
        iam             = "ENABLED"
      }
    }
  }

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = "${aws_ecr_repository.main.repository_url}:${var.image_tag}"  # 使用變數
      essential = true
      portMappings = [
        {
          containerPort = var.wp_port
          hostPort      = var.wp_port
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "WORDPRESS_DB_HOST", value = aws_db_instance.main.address },
        { name = "WORDPRESS_DB_NAME", value = var.db_name },
        { name = "WORDPRESS_DB_USER", value = var.db_username },
        { name = "AWS_REGION", value = var.aws_region },
        { name = "S3_BUCKET_NAME", value = aws_s3_bucket.main.id },
        { name = "WP_SITE_URL", value = var.wp_site_url },
        { name = "CLOUDFRONT_DOMAIN", value = aws_cloudfront_distribution.main.domain_name },
        { name = "WORDPRESS_DEBUG", value = local.is_production ? "false" : "true" },  # 開發環境開啟 debug
        { name = "ENVIRONMENT", value = var.environment }
      ]
      secrets = [
        { name = "WORDPRESS_DB_PASSWORD", valueFrom = "${aws_secretsmanager_secret.rds_credentials.arn}:password::" },
        { name = "WORDPRESS_AUTH_KEY", valueFrom = "${aws_secretsmanager_secret.wp_salts.arn}:AUTH_KEY::" },
        { name = "WORDPRESS_SECURE_AUTH_KEY", valueFrom = "${aws_secretsmanager_secret.wp_salts.arn}:SECURE_AUTH_KEY::" },
        { name = "WORDPRESS_LOGGED_IN_KEY", valueFrom = "${aws_secretsmanager_secret.wp_salts.arn}:LOGGED_IN_KEY::" },
        { name = "WORDPRESS_NONCE_KEY", valueFrom = "${aws_secretsmanager_secret.wp_salts.arn}:NONCE_KEY::" },
        { name = "WORDPRESS_AUTH_SALT", valueFrom = "${aws_secretsmanager_secret.wp_salts.arn}:AUTH_SALT::" },
        { name = "WORDPRESS_SECURE_AUTH_SALT", valueFrom = "${aws_secretsmanager_secret.wp_salts.arn}:SECURE_AUTH_SALT::" },
        { name = "WORDPRESS_LOGGED_IN_SALT", valueFrom = "${aws_secretsmanager_secret.wp_salts.arn}:LOGGED_IN_SALT::" },
        { name = "WORDPRESS_NONCE_SALT", valueFrom = "${aws_secretsmanager_secret.wp_salts.arn}:NONCE_SALT::" }
      ]
      mountPoints = [
        {
          sourceVolume  = "wordpress-efs"
          containerPath = "/var/www/html/wp-content/uploads"
          readOnly      = false
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.main.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "wordpress"
        }
      }
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.wp_port}/ || curl -f http://localhost:${var.wp_port}/wp-admin/install.php || exit 1"]
        interval    = 30
        timeout     = 20
        retries     = local.is_production ? 5 : 10  # 生產環境更快判定不健康
        startPeriod = local.is_production ? 120 : 300
      }
    }
  ])

  tags = {
    Name = "${var.project_name}-wordpress-task"
  }
}

# 5. ECS Service
resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-ECS-Service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = local.task_desired_count  # 使用 locals
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = aws_subnet.app[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "wordpress"
    container_port   = var.wp_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # 生產環境啟用更嚴格的部署配置
  deployment_maximum_percent         = local.is_production ? 200 : 200
  deployment_minimum_healthy_percent = local.is_production ? 100 : 50

  enable_execute_command = true

  tags = { Name = "${var.project_name}-ECS-Service" }
  
  lifecycle {
    ignore_changes = [desired_count]  # Ignore changes for Autoscaling
  }
}
