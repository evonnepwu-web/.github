#!/bin/bash
# ===========================================
# restore-from-backup.sh
# 從備份完整還原 WordPress 網站
# 包含版型、設定、圖片位置
# ===========================================
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

source ./env-config.sh

# 檢查參數
if [ -z "$1" ]; then
    echo "用法: ./restore-from-backup.sh <BACKUP_DATE>"
    echo "例如: ./restore-from-backup.sh 20260115-143000"
    echo ""
    echo "可用的備份:"
    aws s3 ls s3://${PROJECT_NAME}-backups-${AWS_ACCOUNT_ID}/ --profile ${AWS_PROFILE} 2>/dev/null | grep backup-info | awk '{print $4}' | sed 's/backup-info-//g' | sed 's/.json//g'
    exit 1
fi

BACKUP_DATE=$1
BACKUP_BUCKET="${PROJECT_NAME}-backups-${AWS_ACCOUNT_ID}"

echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}🔄 WordPress 完整還原${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo "還原備份: ${BACKUP_DATE}"
echo ""

# ===========================================
# 0. 下載備份資訊
# ===========================================
echo -e "${YELLOW}[0/6] 讀取備份資訊...${NC}"
aws s3 cp s3://${BACKUP_BUCKET}/backup-info-${BACKUP_DATE}.json /tmp/backup-info.json \
    --profile ${AWS_PROFILE}

RDS_SNAPSHOT_ID=$(cat /tmp/backup-info.json | python3 -c "import sys, json; print(json.load(sys.stdin)['rds_snapshot_id'])")
S3_MEDIA_BACKUP=$(cat /tmp/backup-info.json | python3 -c "import sys, json; print(json.load(sys.stdin)['s3_media_backup'])")

echo "  RDS Snapshot: ${RDS_SNAPSHOT_ID}"
echo "  S3 媒體備份: ${S3_MEDIA_BACKUP}"
echo -e "${GREEN}✓ 備份資訊讀取完成${NC}"

# ===========================================
# 1. 執行 Terraform 建立基礎設施
# ===========================================
echo ""
echo -e "${YELLOW}[1/6] 建立基礎設施 (Terraform)...${NC}"
echo "  ⚠️ 這會建立新的 VPC、ALB、ECS 等資源"
read -p "  確定要繼續? (y/N) " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "已取消"
    exit 1
fi

# Terraform files are in parent directory
cd "$SCRIPT_DIR/.."

# 設定使用備份的 RDS Snapshot
echo ""
echo "  使用 RDS Snapshot 還原資料庫..."
terraform apply -var="db_snapshot_identifier=${RDS_SNAPSHOT_ID}" -auto-approve

cd "$SCRIPT_DIR"

echo -e "${GREEN}✓ 基礎設施建立完成${NC}"

# ===========================================
# 2. 重新讀取新的資源資訊
# ===========================================
echo ""
echo -e "${YELLOW}[2/6] 讀取新資源資訊...${NC}"
source ./env-config.sh
echo -e "${GREEN}✓ 資源資訊已更新${NC}"

# ===========================================
# 3. 還原 S3 媒體檔案
# ===========================================
echo ""
echo -e "${YELLOW}[3/6] 還原 S3 媒體檔案...${NC}"
if [ -n "${S3_BUCKET_NAME}" ]; then
    aws s3 sync ${S3_MEDIA_BACKUP} s3://${S3_BUCKET_NAME}/ \
        --profile ${AWS_PROFILE}
    echo -e "${GREEN}✓ 媒體檔案還原完成${NC}"
else
    echo "  ⚠️ 找不到新的 S3 Bucket"
fi

# ===========================================
# 4. 部署 Docker Image
# ===========================================
echo ""
echo -e "${YELLOW}[4/6] 部署 WordPress Image...${NC}"

# 檢查 ECR 是否有 Image
IMAGE_COUNT=$(aws ecr describe-images --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --repository-name ${ECR_REPO_NAME} --query 'length(imageDetails)' --output text 2>/dev/null) || IMAGE_COUNT=0

if [ "$IMAGE_COUNT" -eq "0" ]; then
    echo "  ECR 沒有 Image，需要重新建置..."
    ./manual-deploy-image.sh
else
    echo "  使用現有 Image 部署..."
    ./redeploy.sh
fi

echo -e "${GREEN}✓ WordPress 部署完成${NC}"

# ===========================================
# 5. 等待服務穩定
# ===========================================
echo ""
echo -e "${YELLOW}[5/6] 等待服務穩定...${NC}"
aws ecs wait services-stable --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cluster ${ECS_CLUSTER_NAME} --services ${ECS_SERVICE_NAME}
echo -e "${GREEN}✓ 服務已穩定${NC}"

# ===========================================
# 6. 清除 CloudFront 快取
# ===========================================
echo ""
echo -e "${YELLOW}[6/6] 清除 CloudFront 快取...${NC}"
if [ -n "${CLOUDFRONT_DISTRIBUTION_ID}" ]; then
    aws cloudfront create-invalidation --profile ${AWS_PROFILE} \
        --distribution-id ${CLOUDFRONT_DISTRIBUTION_ID} \
        --paths "/*"
    echo -e "${GREEN}✓ 快取已清除${NC}"
fi

# ===========================================
# 完成
# ===========================================
echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${GREEN}✅ 還原完成！${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo "網站已還原，包含:"
echo "  ✅ 資料庫 (文章、頁面、設定、版型配置)"
echo "  ✅ 媒體檔案 (圖片、影片)"
echo "  ✅ WordPress 佈景主題"
echo "  ✅ 所有外掛設定"
echo ""
echo "請訪問: https://${DOMAIN_NAME}"
echo ""
echo -e "${YELLOW}⚠️ 注意事項:${NC}"
echo "  1. DNS 可能需要幾分鐘更新"
echo "  2. CloudFront 快取清除可能需要 5-10 分鐘"
echo "  3. 如有問題，檢查 CloudWatch Logs"
echo ""

rm -f /tmp/backup-info.json
