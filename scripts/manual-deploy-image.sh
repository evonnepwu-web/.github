#!/bin/bash
# ===========================================
# Manual Deployment Script
# Usage: ./manual-deploy-image.sh
# description: Builds Docker image, pushes to ECR, and forces ECS deployment.
# ===========================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

# Load configuration (Account ID, Region, Repo Name, etc.)
source ./env-config.sh

echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}Manual Deployment: Docker -> ECR -> ECS${NC}"
echo -e "${CYAN}==========================================${NC}"

# 1. ECR Login
echo -e "${YELLOW}Logging in to ECR...${NC}"
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URI}

# 2. Build
echo -e "${YELLOW}Building Docker image...${NC}"
# Navigate to project root to capture docker context correctly
# Navigate to Project Root (parent of terraform-ecs-fargate-cicd-full)
cd "$SCRIPT_DIR/../../"
docker build -t ${ECR_REPO_URI}:latest -f src/docker/Dockerfile .

# 3. Push
echo -e "${YELLOW}Pushing image to ECR...${NC}"
docker push ${ECR_REPO_URI}:latest

# 4. Update ECS Service
echo -e "${YELLOW}Updating ECS Service (Force New Deployment)...${NC}"
aws ecs update-service --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cluster ${ECS_CLUSTER_NAME} \
    --service ${ECS_SERVICE_NAME} \
    --force-new-deployment > /dev/null

echo -e "${GREEN}✅ Deployment triggered! check ECS console for progress.${NC}"
