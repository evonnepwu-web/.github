#!/bin/bash
# ===========================================
# Nuke Everything Script
# Usage: ./nuke-everything.sh
# DANGER: This script deletes ALL resources including RDS, S3, backups, and snapshots.
# ===========================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

source ./env-config.sh 2>/dev/null || true

BACKUP_BUCKET="${PROJECT_NAME}-backups-${AWS_ACCOUNT_ID}"

echo -e "\033[0;31m==========================================\033[0m"
echo -e "\033[0;31m       ⚠️  DANGER ZONE: NUKE EVERYTHING  ⚠️        \033[0m"
echo -e "\033[0;31m==========================================\033[0m"
echo ""
echo -e "This script will permanently DELETE \033[0;31mEVERYTHING\033[0m:"
echo ""
echo -e "  ❌ RDS Database (所有資料)"
echo -e "  ❌ RDS Snapshots (所有備份快照)"
echo -e "  ❌ S3 Bucket (所有媒體檔案)"
echo -e "  ❌ S3 Backup Bucket (所有備份檔案)"
echo -e "  ❌ EFS (所有上傳檔案)"
echo -e "  ❌ All infrastructure (ECS, ALB, VPC, CloudFront, WAF...)"
echo -e "  ❌ Secrets Manager (所有密碼和金鑰)"
echo -e "  ❌ CloudWatch Logs"
echo -e "  ❌ ECR Repository (所有 Docker Images)"
echo ""
echo -e "\033[0;31m⚠️  警告：此操作不可逆！所有資料將永久刪除！\033[0m"
echo ""
read -p "確定要刪除所有資源? 輸入 'NUKE' 確認: " confirmation

if [ "$confirmation" != "NUKE" ]; then
    echo "已取消"
    exit 1
fi

echo ""
echo "開始刪除所有資源..."

# ===========================================
# 1. 刪除備份 Bucket
# ===========================================
echo ""
echo -e "\033[0;33m[Step 1/5] 刪除備份 Bucket...\033[0m"

if aws s3api head-bucket --bucket ${BACKUP_BUCKET} --profile ${AWS_PROFILE} 2>/dev/null; then
    echo "  刪除備份 Bucket: ${BACKUP_BUCKET}"
    
    # 刪除所有版本 (因為啟用了版本控制)
    echo "  刪除所有物件版本..."
    aws s3api list-object-versions --bucket ${BACKUP_BUCKET} --profile ${AWS_PROFILE} \
        --query 'Versions[].{Key:Key,VersionId:VersionId}' --output text 2>/dev/null | \
    while read key version; do
        if [ -n "$key" ] && [ -n "$version" ]; then
            aws s3api delete-object --bucket ${BACKUP_BUCKET} --key "$key" --version-id "$version" \
                --profile ${AWS_PROFILE} 2>/dev/null || true
        fi
    done
    
    # 刪除所有刪除標記
    echo "  刪除所有刪除標記..."
    aws s3api list-object-versions --bucket ${BACKUP_BUCKET} --profile ${AWS_PROFILE} \
        --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output text 2>/dev/null | \
    while read key version; do
        if [ -n "$key" ] && [ -n "$version" ]; then
            aws s3api delete-object --bucket ${BACKUP_BUCKET} --key "$key" --version-id "$version" \
                --profile ${AWS_PROFILE} 2>/dev/null || true
        fi
    done
    
    # 刪除 bucket
    aws s3api delete-bucket --bucket ${BACKUP_BUCKET} --profile ${AWS_PROFILE} --region ${AWS_REGION} 2>/dev/null || true
    
    echo -e "\033[0;32m✓ 備份 Bucket 已刪除\033[0m"
else
    echo "  備份 Bucket 不存在，跳過"
fi

# ===========================================
# 2. 刪除所有 RDS Snapshots
# ===========================================
echo ""
echo -e "\033[0;33m[Step 2/5] 刪除所有 RDS Snapshots...\033[0m"

# 刪除手動建立的 Snapshots
SNAPSHOTS=$(aws rds describe-db-snapshots --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --snapshot-type manual \
    --query "DBSnapshots[?contains(DBSnapshotIdentifier, '${PROJECT_NAME}')].DBSnapshotIdentifier" \
    --output text 2>/dev/null) || true

for snapshot in $SNAPSHOTS; do
    echo "  刪除 Snapshot: $snapshot"
    aws rds delete-db-snapshot --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --db-snapshot-identifier $snapshot 2>/dev/null || true
done

# 也嘗試刪除 final snapshot (如果有)
FINAL_SNAPSHOTS=$(aws rds describe-db-snapshots --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --snapshot-type manual \
    --query "DBSnapshots[?contains(DBSnapshotIdentifier, 'final')].DBSnapshotIdentifier" \
    --output text 2>/dev/null) || true

for snapshot in $FINAL_SNAPSHOTS; do
    if [[ "$snapshot" == *"${PROJECT_NAME}"* ]]; then
        echo "  刪除 Final Snapshot: $snapshot"
        aws rds delete-db-snapshot --profile ${AWS_PROFILE} --region ${AWS_REGION} \
            --db-snapshot-identifier $snapshot 2>/dev/null || true
    fi
done

echo -e "\033[0;32m✓ RDS Snapshots 已刪除\033[0m"

# ===========================================
# 3. 清空並刪除 S3 媒體 Bucket
# ===========================================
echo ""
echo -e "\033[0;33m[Step 3/5] 清空 S3 媒體 Bucket...\033[0m"

if [ -n "${S3_BUCKET_NAME}" ]; then
    echo "  清空 Bucket: ${S3_BUCKET_NAME}"
    aws s3 rm "s3://${S3_BUCKET_NAME}" --recursive --profile ${AWS_PROFILE} 2>/dev/null || true
    echo -e "\033[0;32m✓ S3 Bucket 已清空\033[0m"
else
    # 嘗試從 Terraform output 取得
    # 嘗試從 Terraform output 取得
    cd "$SCRIPT_DIR/.." 2>/dev/null || true
    BUCKET_NAME=$(terraform output -raw s3_bucket_name 2>/dev/null || echo "")
    
    # 檢查是否為無效的 Output (包含 "Warning" 或 "No outputs")
    if echo "$BUCKET_NAME" | grep -q "Warning"; then
        BUCKET_NAME=""
    fi

    # 如果 Terraform 找不到，嘗試用 Tag 搜尋 (Fallback)
    if [ -z "$BUCKET_NAME" ]; then
        echo "  Terraform output 無法取得 Bucket 名稱，改為使用 Tag 搜尋..."
        
        # 使用 Tag 搜尋
        BUCKETS=$(aws s3api list-buckets --profile ${AWS_PROFILE} --query "Buckets[].Name" --output text)
        for b in $BUCKETS; do
            # 忽略非專案的 buckets (加速搜尋)
            if [[ "$b" != *"${PROJECT_NAME}"* ]]; then
                continue
            fi
            
            TAGS=$(aws s3api get-bucket-tagging --bucket $b --profile ${AWS_PROFILE} 2>/dev/null || true)
            if echo "$TAGS" | grep -q "${PROJECT_TAG}" && echo "$TAGS" | grep -q "WordPress-Media"; then
                BUCKET_NAME=$b
                break
            fi
        done
    fi

    if [ -n "$BUCKET_NAME" ]; then
        echo "  找到 Bucket: $BUCKET_NAME"
        echo "  清空 Bucket..."
        aws s3 rm "s3://$BUCKET_NAME" --recursive --profile ${AWS_PROFILE} 2>/dev/null || true
        
        # 嘗試強制刪除 Bucket (如果是 Nuke 流程)
        aws s3api delete-bucket --bucket $BUCKET_NAME --profile ${AWS_PROFILE} --region ${AWS_REGION} 2>/dev/null || true
        echo -e "\033[0;32m✓ S3 Bucket 已清空並標記刪除\033[0m"
    else
        echo -e "\033[0;31m無法找到 S3 Bucket，請手動確認。\033[0m"
    fi
    cd "$SCRIPT_DIR"
fi

# ===========================================
# 4. Terraform Destroy
# ===========================================
echo ""
echo -e "\033[0;33m[Step 4/5] 執行 Terraform Destroy...\033[0m"
echo -e "\033[0;33m[Step 4/5] 執行 Terraform Destroy...\033[0m"
# Files are in the parent directory of scripts/
cd "$SCRIPT_DIR/.." 2>/dev/null

# Ensure plugins are installed
terraform init

terraform destroy -auto-approve \
    -var="force_destroy=true"

cd "$SCRIPT_DIR"

# ===========================================
# 5. 刪除 Secrets Manager (強制刪除)
# ===========================================
echo ""
echo -e "\033[0;33m[Step 5/5] 刪除 Secrets Manager...\033[0m"
for secret_name in "${SECRETS_PREFIX}/rds/credentials" "${SECRETS_PREFIX}/wordpress/salts" "${SECRETS_PREFIX}/cloudfront/origin-verify" "${SECRETS_PREFIX}/api/keys"; do
    aws secretsmanager delete-secret --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --secret-id "${secret_name}" \
        --force-delete-without-recovery 2>/dev/null || true
done
echo -e "\033[0;32m✓ Secrets Manager 已刪除\033[0m"

# ===========================================
# 完成
# ===========================================
echo ""
echo -e "\033[0;32m==========================================\033[0m"
echo -e "\033[0;32m✅ 所有資源已完全刪除！\033[0m"
echo -e "\033[0;32m==========================================\033[0m"
echo ""
echo "已刪除:"
echo "  ✅ RDS Database"
echo "  ✅ RDS Snapshots (所有備份快照)"
echo "  ✅ S3 Bucket (媒體檔案)"
echo "  ✅ S3 Backup Bucket (所有備份)"
echo "  ✅ EFS (上傳檔案)"
echo "  ✅ ECS, ALB, VPC 等基礎設施"
echo "  ✅ CloudFront, WAF"
echo "  ✅ ECR Repository"
echo "  ✅ Secrets Manager"
echo "  ✅ CloudWatch Logs"
echo ""
echo "環境已完全清空，如需重新建立請執行:"
echo "  ./deploy-everything.sh"
echo ""
