# ===========================================
# Environment-Based Configuration
# 環境變數自動設定：development 為預設值
# 切換到 production 時啟用高併發配置
# ===========================================

locals {
  # ===========================================
  # 環境判斷
  # ===========================================
  is_production  = var.environment == "production"
  is_staging     = var.environment == "staging"
  is_development = var.environment == "development"

  # ===========================================
  # 環境預設值對照表
  # ===========================================
  env_defaults = {
    development = {
      # ECS Task
      task_cpu           = 512
      task_memory        = 1024
      task_desired_count = 1
      task_min_count     = 1
      task_max_count     = 3

      # RDS
      rds_instance_class       = "db.t3.micro"
      rds_multi_az             = false
      rds_performance_insights = false  # t3.micro 不支援

      # Auto Scaling - Target Tracking
      scaling_cpu_target   = 70
      scaling_cooldown_in  = 300
      scaling_cooldown_out = 120

      # CloudFront
      cloudfront_price_class = "PriceClass_100"  # 最便宜

      # 資源保護
      force_destroy = true
    }

    staging = {
      # ECS Task
      task_cpu           = 512
      task_memory        = 1024
      task_desired_count = 1
      task_min_count     = 1
      task_max_count     = 5

      # RDS
      rds_instance_class       = "db.t3.small"
      rds_multi_az             = false
      rds_performance_insights = true

      # Auto Scaling - Target Tracking
      scaling_cpu_target   = 65
      scaling_cooldown_in  = 300
      scaling_cooldown_out = 90

      # CloudFront
      cloudfront_price_class = "PriceClass_200"

      # 資源保護
      force_destroy = true
    }

    production = {
      # ECS Task - 高併發配置
      task_cpu           = 1024
      task_memory        = 2048
      task_desired_count = 2
      task_min_count     = 2
      task_max_count     = 10

      # RDS - 高併發配置
      rds_instance_class       = "db.t3.small"  # 連線數 150
      rds_multi_az             = true
      rds_performance_insights = true

      # Auto Scaling - Target Tracking (更敏感)
      scaling_cpu_target   = 60
      scaling_cooldown_in  = 300
      scaling_cooldown_out = 60  # 快速擴展

      # CloudFront
      cloudfront_price_class = "PriceClass_200"

      # 資源保護
      force_destroy = false
    }
  }

  # ===========================================
  # 實際使用的值 (變數優先，否則用環境預設)
  # ===========================================
  
  # ECS Task 配置
  task_cpu           = coalesce(var.task_cpu, local.env_defaults[var.environment].task_cpu)
  task_memory        = coalesce(var.task_memory, local.env_defaults[var.environment].task_memory)
  task_desired_count = coalesce(var.task_desired_count, local.env_defaults[var.environment].task_desired_count)
  task_min_count     = coalesce(var.task_min_count, local.env_defaults[var.environment].task_min_count)
  task_max_count     = coalesce(var.task_max_count, local.env_defaults[var.environment].task_max_count)

  # RDS 配置
  rds_instance_class               = coalesce(var.rds_instance_class, local.env_defaults[var.environment].rds_instance_class)
  rds_multi_az                     = coalesce(var.rds_multi_az, local.env_defaults[var.environment].rds_multi_az)
  rds_performance_insights_enabled = coalesce(var.rds_performance_insights_enabled, local.env_defaults[var.environment].rds_performance_insights)

  # Auto Scaling 配置
  scaling_cpu_target   = coalesce(var.scaling_cpu_target, local.env_defaults[var.environment].scaling_cpu_target)
  scaling_cooldown_in  = coalesce(var.scaling_cooldown_in, local.env_defaults[var.environment].scaling_cooldown_in)
  scaling_cooldown_out = coalesce(var.scaling_cooldown_out, local.env_defaults[var.environment].scaling_cooldown_out)

  # EFS 配置 - 統一使用 bursting
  efs_throughput_mode = "bursting"

  # CloudFront 配置
  cloudfront_price_class = coalesce(var.cloudfront_price_class, local.env_defaults[var.environment].cloudfront_price_class)

  # 資源保護配置
  force_destroy = coalesce(var.force_destroy, local.env_defaults[var.environment].force_destroy)

  # NAT Gateway 數量 (Development: 1, Production: 2)
  nat_gateway_count = local.is_production ? 2 : 1

  # ===========================================
  # 常用標籤
  # ===========================================
  common_tags = {
    Project     = var.project_tag
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
