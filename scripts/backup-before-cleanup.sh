#!/bin/bash
# ===========================================
# backup-before-cleanup.sh
# 在執行 cleanup.sh 前，備份所有重要資料
# ===========================================
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

source ./env-config.sh

BACKUP_DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_BUCKET="${PROJECT_NAME}-backups-${AWS_ACCOUNT_ID}"

echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}📦 WordPress 完整備份${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo "備份時間: ${BACKUP_DATE}"
echo ""

# ===========================================
# 1. 建立備份 S3 Bucket (如果不存在)
# ===========================================
echo -e "${YELLOW}[1/4] 檢查備份 Bucket...${NC}"
if ! aws s3api head-bucket --bucket ${BACKUP_BUCKET} --profile ${AWS_PROFILE} 2>/dev/null; then
    echo "  建立備份 Bucket: ${BACKUP_BUCKET}"
    aws s3api create-bucket --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --bucket ${BACKUP_BUCKET} \
        --create-bucket-configuration LocationConstraint=${AWS_REGION}
    
    # 啟用版本控制
    aws s3api put-bucket-versioning --profile ${AWS_PROFILE} \
        --bucket ${BACKUP_BUCKET} \
        --versioning-configuration Status=Enabled
fi
echo -e "${GREEN}✓ 備份 Bucket 就緒: ${BACKUP_BUCKET}${NC}"

# ===========================================
# 2. 備份 RDS (建立 Snapshot)
# ===========================================
echo ""
echo -e "${YELLOW}[2/4] 備份 RDS 資料庫...${NC}"
RDS_SNAPSHOT_ID="${PROJECT_NAME}-db-backup-${BACKUP_DATE}"

aws rds create-db-snapshot --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --db-instance-identifier ${RDS_INSTANCE_ID} \
    --db-snapshot-identifier ${RDS_SNAPSHOT_ID}

echo "  等待 Snapshot 完成 (約 5-10 分鐘)..."
aws rds wait db-snapshot-available --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --db-snapshot-identifier ${RDS_SNAPSHOT_ID}

echo -e "${GREEN}✓ RDS Snapshot 完成: ${RDS_SNAPSHOT_ID}${NC}"

# ===========================================
# 3. 備份 S3 媒體檔案
# ===========================================
echo ""
echo -e "${YELLOW}[3/4] 備份 S3 媒體檔案...${NC}"
if [ -n "${S3_BUCKET_NAME}" ]; then
    aws s3 sync s3://${S3_BUCKET_NAME} s3://${BACKUP_BUCKET}/media-backup-${BACKUP_DATE}/ \
        --profile ${AWS_PROFILE}
    echo -e "${GREEN}✓ S3 媒體備份完成: s3://${BACKUP_BUCKET}/media-backup-${BACKUP_DATE}/${NC}"
else
    echo "  ⚠️ 找不到 S3 Bucket，跳過"
fi

# ===========================================
# 4. 備份 Secrets Manager
# ===========================================
echo ""
echo -e "${YELLOW}[4/4] 備份 Secrets...${NC}"
mkdir -p /tmp/secrets-backup

for secret_name in "${SECRETS_PREFIX}/rds/credentials" "${SECRETS_PREFIX}/wordpress/salts" "${SECRETS_PREFIX}/cloudfront/origin-verify" "${SECRETS_PREFIX}/api/keys"; do
    SECRET_VALUE=$(aws secretsmanager get-secret-value --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --secret-id "${secret_name}" --query 'SecretString' --output text 2>/dev/null) || true
    
    if [ -n "$SECRET_VALUE" ]; then
        FILENAME=$(echo ${secret_name} | tr '/' '-')
        echo "${SECRET_VALUE}" > /tmp/secrets-backup/${FILENAME}.json
    fi
done

# 上傳到 S3 (加密)
aws s3 cp /tmp/secrets-backup/ s3://${BACKUP_BUCKET}/secrets-backup-${BACKUP_DATE}/ \
    --recursive --profile ${AWS_PROFILE} --sse AES256

rm -rf /tmp/secrets-backup

echo -e "${GREEN}✓ Secrets 備份完成${NC}"

# ===========================================
# 5. 儲存備份資訊
# ===========================================
echo ""
cat > /tmp/backup-info.json << EOF
{
    "backup_date": "${BACKUP_DATE}",
    "project_name": "${PROJECT_NAME}",
    "project_tag": "${PROJECT_TAG}",
    "rds_snapshot_id": "${RDS_SNAPSHOT_ID}",
    "s3_media_backup": "s3://${BACKUP_BUCKET}/media-backup-${BACKUP_DATE}/",
    "secrets_backup": "s3://${BACKUP_BUCKET}/secrets-backup-${BACKUP_DATE}/",
    "ecr_image": "${ECR_REPO_URI}:latest",
    "aws_region": "${AWS_REGION}"
}
EOF

aws s3 cp /tmp/backup-info.json s3://${BACKUP_BUCKET}/backup-info-${BACKUP_DATE}.json \
    --profile ${AWS_PROFILE}

rm /tmp/backup-info.json

# ===========================================
# 完成
# ===========================================
echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${GREEN}✅ 備份完成！${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo "備份清單:"
echo "  📊 RDS Snapshot: ${RDS_SNAPSHOT_ID}"
echo "  📁 S3 媒體: s3://${BACKUP_BUCKET}/media-backup-${BACKUP_DATE}/"
echo "  🔐 Secrets: s3://${BACKUP_BUCKET}/secrets-backup-${BACKUP_DATE}/"
echo "  📋 備份資訊: s3://${BACKUP_BUCKET}/backup-info-${BACKUP_DATE}.json"
echo ""
echo -e "${YELLOW}請記住備份時間: ${BACKUP_DATE}${NC}"
echo "還原時使用: ./restore-from-backup.sh ${BACKUP_DATE}"
echo ""
