# ===========================================
# Monitoring Layer (CloudWatch + AutoScaling)
# Step 10, 18, 19
# ===========================================

# 1. SNS Topic
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-ECS-Alerts"
  tags = { Name = "${var.project_name}-ECS-Alerts" }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# 2. Auto Scaling Target
resource "aws_appautoscaling_target" "ecs" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = local.task_min_count
  max_capacity       = local.task_max_count
}

# ===========================================
# Auto Scaling Policies - Target Tracking (所有環境)
# ===========================================

# CPU Target Tracking
resource "aws_appautoscaling_policy" "cpu_target_tracking" {
  name               = "${var.project_name}-cpu-target-tracking"
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = local.scaling_cpu_target
    scale_in_cooldown  = local.scaling_cooldown_in
    scale_out_cooldown = local.scaling_cooldown_out

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

# Memory Target Tracking
resource "aws_appautoscaling_policy" "memory_target_tracking" {
  name               = "${var.project_name}-memory-target-tracking"
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = 70  # Memory 70%
    scale_in_cooldown  = local.scaling_cooldown_in
    scale_out_cooldown = local.scaling_cooldown_out

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

# ALB Request Count Target Tracking (生產環境)
resource "aws_appautoscaling_policy" "alb_request_target_tracking" {
  count = local.is_production ? 1 : 0

  name               = "${var.project_name}-alb-request-target-tracking"
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = 1000  # 每個 Task 處理 1000 requests/min
    scale_in_cooldown  = local.scaling_cooldown_in
    scale_out_cooldown = local.scaling_cooldown_out

    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.main.arn_suffix}/${aws_lb_target_group.main.arn_suffix}"
    }
  }
}

# 3. CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-ECS-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.is_production ? 1 : 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = local.scaling_cpu_target + 10  # 比 target 高 10%
  
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project_name}-ECS-CPU-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 20
  
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

# 生產環境額外警報
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  count = local.is_production ? 1 : 0

  alarm_name          = "${var.project_name}-ECS-Memory-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  count = local.is_production ? 1 : 0

  alarm_name          = "${var.project_name}-ALB-5XX-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_latency" {
  count = local.is_production ? 1 : 0

  alarm_name          = "${var.project_name}-ALB-Latency-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  extended_statistic  = "p99"
  threshold           = 3  # P99 > 3 秒
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

# Note: Dashboard is defined in dashboard.tf
