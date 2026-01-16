#!/bin/bash
# ===========================================
# Environment Configuration
# Auto-generated from terraform.tfvars
# ===========================================

# AWS Configuration
export AWS_REGION="ap-northeast-1"
export AWS_PROFILE="evonne"

# Project Tagging
export PROJECT_NAME="project"
export PROJECT_TAG="njc201-04"
export ENVIRONMENT="development"

# Secrets Manager
export SECRETS_PREFIX="project"

# CloudWatch Log Group
export LOG_GROUP_NAME="/ecs/${PROJECT_NAME}-wordpress"

# Resource Naming Convention (Matches Terraform)
export ECS_CLUSTER_NAME="${PROJECT_NAME}-ECS"
export ECS_SERVICE_NAME="${PROJECT_NAME}-ECS-Service"
export ECR_REPO_NAME="project-wordpress-repo"
export WAF_NAME="${PROJECT_NAME}-WAF"
export TASK_EXECUTION_ROLE_NAME="${PROJECT_NAME}-ecsTaskExecutionRole"
export TASK_ROLE_NAME="${PROJECT_NAME}-ecsTaskRole"
