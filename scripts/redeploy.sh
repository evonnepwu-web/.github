#!/bin/bash
# ===========================================
# Redeploy Script - 重新部署 WordPress
# 功能：建置映像 -> 推送 -> 更新 ECS -> 自動回滾
# ===========================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

source ./env-config.sh

IMAGE_TAG="$(date +%Y%m%d-%H%M%S)"

echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}🔄 重新部署 WordPress${NC}"
echo -e "${CYAN}==========================================${NC}"
echo "版本: ${IMAGE_TAG}"
echo ""

# ===========================================
# Step 1: 建置並推送 Docker Image
# ===========================================
echo -e "${YELLOW}Step 1: 建置 Docker Image...${NC}"

aws ecr get-login-password --profile ${AWS_PROFILE} --region ${AWS_REGION} | \
    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Docker context is in project root
cd "${SCRIPT_DIR}/.."
docker build --platform linux/amd64 --no-cache -t ${ECR_REPO_NAME}:${IMAGE_TAG} -t ${ECR_REPO_NAME}:latest -f src/docker/Dockerfile .

docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ECR_REPO_URI}:${IMAGE_TAG}
docker tag ${ECR_REPO_NAME}:latest ${ECR_REPO_URI}:latest
docker push ${ECR_REPO_URI}:${IMAGE_TAG}
docker push ${ECR_REPO_URI}:latest

echo -e "${GREEN}✓ Docker Image 推送完成${NC}"

# ===========================================
# Step 2: 更新 Task Definition
# ===========================================
echo ""
echo -e "${YELLOW}Step 2: 更新 Task Definition...${NC}"

cd "$SCRIPT_DIR"

export TMP_TASK_DEF="/tmp/new-task-def-${IMAGE_TAG}.json"
export NEW_IMAGE_URI="${ECR_REPO_URI}:${IMAGE_TAG}"

# 記錄舊版本 (用於回滾)
OLD_TASK_DEFINITION=$(aws ecs describe-services \
    --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cluster ${ECS_CLUSTER_NAME} \
    --services ${ECS_SERVICE_NAME} \
    --query 'services[0].taskDefinition' --output text)

echo "⏮️  舊版本: ${OLD_TASK_DEFINITION}"

# 取得當前 Task Definition
aws ecs describe-task-definition \
    --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --task-definition ${ECS_TASK_FAMILY} \
    --query 'taskDefinition' --output json > /tmp/current-task-def.json

# 修改 Image URI
python3 << 'EOF'
import json
import os

with open('/tmp/current-task-def.json', 'r') as f:
    data = json.load(f)

# 移除唯讀欄位
for key in ['taskDefinitionArn', 'revision', 'status', 'requiresAttributes', 
            'compatibilities', 'registeredAt', 'registeredBy']:
    data.pop(key, None)

# 更新映像檔
data['containerDefinitions'][0]['image'] = os.environ.get('NEW_IMAGE_URI')

with open(os.environ.get('TMP_TASK_DEF'), 'w') as f:
    json.dump(data, f, indent=2)
EOF

# 註冊新版本
NEW_TASK_ARN=$(aws ecs register-task-definition \
    --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cli-input-json file://${TMP_TASK_DEF} \
    --query 'taskDefinition.taskDefinitionArn' --output text)

NEW_REVISION=$(echo $NEW_TASK_ARN | awk -F: '{print $NF}')
echo -e "${GREEN}✓ 新版本: Revision ${NEW_REVISION}${NC}"

# ===========================================
# Step 3: 更新 ECS Service
# ===========================================
echo ""
echo -e "${YELLOW}Step 3: 更新 ECS Service...${NC}"

aws ecs update-service \
    --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cluster ${ECS_CLUSTER_NAME} \
    --service ${ECS_SERVICE_NAME} \
    --task-definition ${ECS_TASK_FAMILY}:${NEW_REVISION} \
    --deployment-configuration "deploymentCircuitBreaker={enable=true,rollback=true}" \
    --no-cli-pager > /dev/null

# ===========================================
# Step 4: 等待驗證
# ===========================================
echo ""
echo -e "${YELLOW}Step 4: 等待部署完成...${NC}"

if aws ecs wait services-stable \
    --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cluster ${ECS_CLUSTER_NAME} \
    --services ${ECS_SERVICE_NAME}; then
    
    echo ""
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${GREEN}✅ 部署成功！${NC}"
    echo -e "${CYAN}==========================================${NC}"
    echo ""
    echo "🖼️  版本: ${IMAGE_TAG}"
    echo "📦  Task: ${ECS_TASK_FAMILY}:${NEW_REVISION}"
else
    echo ""
    echo -e "${RED}==========================================${NC}"
    echo -e "${RED}❌ 部署失敗！AWS 正在自動回滾${NC}"
    echo -e "${RED}==========================================${NC}"
    echo "回滾到: ${OLD_TASK_DEFINITION}"
    exit 1
fi

# 清理
rm -f /tmp/current-task-def.json ${TMP_TASK_DEF}
