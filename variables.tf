# ===========================================
# AWS 基本設定
# ===========================================
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS CLI Profile (for local development)"
  type        = string
  default     = "default"
}

variable "project_name" {
  description = "Project Name used for resource naming"
  type        = string
}

variable "project_tag" {
  description = "Project Tag for cost allocation"
  type        = string
}

variable "environment" {
  description = "Environment (development, staging, production)"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}

# ===========================================
# VPC 網路設定
# ===========================================
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for Public Subnets"
  type        = list(string)
}

variable "public_subnet_azs" {
  description = "Availability Zones for Public Subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for Application Subnets (Private)"
  type        = list(string)
}

variable "app_subnet_azs" {
  description = "Availability Zones for Application Subnets (Private)"
  type        = list(string)
}

variable "data_subnet_cidrs" {
  description = "CIDR blocks for Data Subnets (Private)"
  type        = list(string)
}

variable "data_subnet_azs" {
  description = "Availability Zones for Data Subnets (Private)"
  type        = list(string)
}

# ===========================================
# Secrets Manager
# ===========================================
variable "secrets_prefix" {
  description = "Prefix for Secrets Manager secrets"
  type        = string
}

# ===========================================
# RDS 資料庫設定
# ===========================================
variable "rds_engine" {
  type    = string
  default = "mysql"
}

variable "rds_engine_version" {
  type    = string
  default = "8.0"
}

variable "rds_instance_class" {
  description = "RDS instance class (auto-set by environment if not specified)"
  type        = string
  default     = null  # Will use locals
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "rds_max_allocated_storage" {
  type    = number
  default = 100
}

variable "db_name" {
  type    = string
  default = "wordpress"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_snapshot_identifier" {
  description = "The ID of the snapshot to restore from. If null, creates a new database."
  type        = string
  default     = null
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ for RDS (auto-set by environment if not specified)"
  type        = bool
  default     = null  # Will use locals
}

variable "rds_performance_insights_enabled" {
  description = "Enable Performance Insights (requires db.t3.small or larger)"
  type        = bool
  default     = null  # Will use locals
}

# ===========================================
# ECS 容器設定
# ===========================================
variable "ecr_repo_name" {
  type = string
}

variable "task_cpu" {
  description = "CPU units for the task (auto-set by environment if not specified)"
  type        = number
  default     = null  # Will use locals
}

variable "task_memory" {
  description = "Memory for the task in MiB (auto-set by environment if not specified)"
  type        = number
  default     = null  # Will use locals
}

variable "task_desired_count" {
  description = "Desired number of tasks (auto-set by environment if not specified)"
  type        = number
  default     = null  # Will use locals
}

variable "task_min_count" {
  description = "Minimum number of tasks for auto-scaling (auto-set by environment if not specified)"
  type        = number
  default     = null  # Will use locals
}

variable "task_max_count" {
  description = "Maximum number of tasks for auto-scaling (auto-set by environment if not specified)"
  type        = number
  default     = null  # Will use locals
}

variable "wp_port" {
  type    = number
  default = 80
}

variable "db_port" {
  type    = number
  default = 3306
}

# ===========================================
# CI/CD 設定
# ===========================================
variable "image_tag" {
  description = "Docker image tag for ECS deployment"
  type        = string
  default     = "latest"
}

# ===========================================
# CloudFront & ACM
# ===========================================
variable "domain_name" {
  description = "Root domain name (e.g., example.com)"
  type        = string
}

variable "acm_domain_name" {
  description = "Domain name for ACM Certificate (e.g., *.example.com)"
  type        = string
}

variable "cloudfront_price_class" {
  description = "CloudFront price class (auto-set by environment if not specified)"
  type        = string
  default     = null  # Will use locals
}

# ===========================================
# Application Config
# ===========================================
variable "wp_site_url" {
  type = string
}

variable "alert_email" {
  description = "Email address for SNS alerts"
  type        = string
}

# ===========================================
# Auto Scaling 設定
# ===========================================
variable "scaling_cpu_target" {
  description = "Target CPU utilization for auto-scaling (auto-set by environment if not specified)"
  type        = number
  default     = null  # Will use locals
}

variable "scaling_cooldown_in" {
  description = "Scale-in cooldown in seconds (auto-set by environment if not specified)"
  type        = number
  default     = null  # Will use locals
}

variable "scaling_cooldown_out" {
  description = "Scale-out cooldown in seconds (auto-set by environment if not specified)"
  type        = number
  default     = null  # Will use locals
}

# ===========================================
# 資源保護設定
# ===========================================
variable "force_destroy" {
  description = "Allow force destroy of S3 bucket and ECR (auto-set by environment if not specified)"
  type        = bool
  default     = null  # Will use locals
}

# ===========================================
# GitHub Actions OIDC (CI/CD)
# ===========================================
variable "enable_github_oidc" {
  description = "Enable GitHub Actions OIDC provider for CI/CD"
  type        = bool
  default     = false
}

variable "github_repo" {
  description = "GitHub repository in format 'owner/repo' for OIDC trust"
  type        = string
  default     = ""
}
