#!/bin/bash
# ===========================================
# One-Click Deployment Script
# Usage: ./deploy-everything.sh
# Description: Orchestrates the entire deployment (Terraform Infra + Docker App)
# ===========================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# SCRIPT_DIR is project/scripts
# PROJECT_ROOT is ..
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
# Infrastructure code is in project root
INFRA_ROOT="$PROJECT_ROOT"

echo -e "\033[0;36m==========================================\033[0m"
echo -e "\033[0;36m       AWS Deployment Orchestrator        \033[0m"
echo -e "\033[0;36m==========================================\033[0m"

# 1. Terraform - Init & Apply Infrastructure
echo -e "\033[1;33m[Step 1/3] Provisioning Infrastructure with Terraform...\033[0m"
cd "$INFRA_ROOT"

# Initialize Terraform (safe to run multiple times)
terraform init

# Apply Terraform
# Note: First run might take time. If ECS Service fails due to missing image, 
# we will catch it or let it retry while we push the image.
# We accept that ECS Service creation might time out slightly if image isn't there,
# but Terraform usually waits. To unblock specific dependencies, we can target ECR first.

echo -e "\033[0;33mCreating ECR Repository first to ensure build target exists...\033[0m"
terraform apply -target=aws_ecr_repository.main -auto-approve

# Get ECR URL and Profile
# Note: specific outputs might not be in state yet if using -target, so we use terraform console for vars
ECR_URL=$(terraform output -raw ecr_repository_url)
AWS_REGION=$(echo "var.aws_region" | terraform console | tr -d '"')
AWS_PROFILE=$(echo "var.aws_profile" | terraform console | tr -d '"')

echo -e "\033[0;32minfrastructure (ECR) ready: $ECR_URL (Profile: $AWS_PROFILE)\033[0m"

# 2. Docker - Build & Push
echo -e "\033[1;33m[Step 2/3] Building and Pushing Docker Image...\033[0m"
aws ecr get-login-password --region "$AWS_REGION" --profile "$AWS_PROFILE" | docker login --username AWS --password-stdin "$ECR_URL"

# Run build from Project Root (parent of terraform-ecs-fargate-cicd-full)
cd "$PROJECT_ROOT/.."
docker build -t "$ECR_URL:latest" -f src/docker/Dockerfile .
docker push "$ECR_URL:latest"

# 3. Terraform - Finalize (Create ECS Service)
echo -e "\033[1;33m[Step 3/3] Finalizing Infrastructure (ECS Service)...\033[0m"
cd "$INFRA_ROOT"
terraform apply -auto-approve

# Output final info
ALB_DNS=$(terraform output -raw alb_dns_name)
CF_DOMAIN=$(terraform output -raw cloudfront_domain_name)

echo -e "\033[0;36m==========================================\033[0m"
echo -e "\033[0;32m✅ Deployment Complete!\033[0m"
echo -e "\033[0;36m==========================================\033[0m"
echo -e "ALB DNS: http://$ALB_DNS"
echo -e "CloudFront: https://$CF_DOMAIN"
echo -e "\033[0;33mNote: DNS propagation (CNAME) might take a few minutes.\033[0m"
