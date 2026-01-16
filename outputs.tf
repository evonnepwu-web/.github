# ===========================================
# Terraform Outputs
# ===========================================

# --- ECR ---
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.main.repository_url
}

# --- ALB ---
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics"
  value       = aws_lb.main.arn_suffix
}

output "target_group_arn_suffix" {
  description = "Target Group ARN suffix for CloudWatch metrics"
  value       = aws_lb_target_group.main.arn_suffix
}

# --- CloudFront ---
output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID for cache invalidation"
  value       = aws_cloudfront_distribution.main.id
}

# --- ECS ---
output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "task_definition_family" {
  description = "ECS Task Definition family name"
  value       = aws_ecs_task_definition.main.family
}

output "task_definition_revision" {
  description = "ECS Task Definition current revision"
  value       = aws_ecs_task_definition.main.revision
}

# --- S3 ---
output "s3_bucket_name" {
  description = "S3 bucket name for WordPress media"
  value       = aws_s3_bucket.main.id
}

# --- RDS ---
output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "rds_instance_class" {
  description = "RDS instance class being used"
  value       = local.rds_instance_class
}

# --- Config ---
output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

output "aws_profile" {
  description = "AWS Profile"
  value       = var.aws_profile
}

# --- Environment Info ---
output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "environment_config" {
  description = "Environment-specific configuration values"
  value = {
    environment         = var.environment
    task_cpu            = local.task_cpu
    task_memory         = local.task_memory
    task_min_count      = local.task_min_count
    task_max_count      = local.task_max_count
    rds_instance_class  = local.rds_instance_class
    rds_multi_az        = local.rds_multi_az
    efs_throughput_mode = local.efs_throughput_mode
    scaling_cpu_target  = local.scaling_cpu_target
  }
}

# --- IAM Roles ---
output "task_execution_role_arn" {
  description = "ECS Task Execution Role ARN"
  value       = aws_iam_role.execution.arn
}

output "task_role_arn" {
  description = "ECS Task Role ARN"
  value       = aws_iam_role.task.arn
}

# --- GitHub Actions OIDC (if enabled) ---
output "github_actions_role_arn" {
  description = "ARN for GitHub Actions OIDC role"
  value       = var.enable_github_oidc ? aws_iam_role.github_actions[0].arn : "Not enabled - set enable_github_oidc = true"
}
