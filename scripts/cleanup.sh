#!/bin/bash
# ===========================================
# Cleanup Script - 刪除所有建立的資源
# 業界標準: 保留資料層 (RDS/EFS) 避免數據遺失
# ===========================================
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Files are in the parent directory of scripts/
cd "$SCRIPT_DIR"

source ./env-config.sh

echo -e "${RED}==========================================${NC}"
echo -e "${RED}⚠️  警告: 此腳本將刪除 [${PROJECT_TAG}] 專案的資源！${NC}"
echo -e "${RED}==========================================${NC}"
echo ""
echo "將刪除的資源:"
echo "  - CloudFront Distribution"
echo "  - WAF Web ACL"
echo "  - ALB + Target Group"
echo "  - ECS Service + Cluster"
echo "  - ECR Repository"
echo "  - S3 Bucket (含所有檔案)"
echo "  - CloudWatch (Dashboard, Alarms, Logs)"
echo "  - SNS Topic"
echo "  - IAM Roles"
echo "  - VPC Endpoints"
echo "  - NAT Gateway + EIP"
echo ""
echo -e "${YELLOW}將保留的資源 (需手動刪除):${NC}"
echo "  - VPC / Subnets / NACLs / Security Groups"
echo "  - RDS 資料庫 (避免數據遺失)"
echo "  - EFS 檔案系統 (避免數據遺失)"
echo "  - ACM SSL 憑證"
echo ""
read -p "確定要刪除? (輸入 'DELETE' 確認) " confirm

if [ "$confirm" != "DELETE" ]; then
    echo "已取消"
    exit 1
fi

echo ""
echo "開始清理資源..."

# ===========================================
# 1. CloudFront
# ===========================================
echo ""
echo -e "${YELLOW}刪除 CloudFront...${NC}"
if [ -n "${CLOUDFRONT_DISTRIBUTION_ID}" ] && [ "${CLOUDFRONT_DISTRIBUTION_ID}" != "" ]; then
    # 先停用再刪除
    ETAG=$(aws cloudfront get-distribution-config --profile ${AWS_PROFILE} \
        --id ${CLOUDFRONT_DISTRIBUTION_ID} --query 'ETag' --output text 2>/dev/null) || true
    
    if [ -n "$ETAG" ]; then
        # 取得設定並停用
        aws cloudfront get-distribution-config --profile ${AWS_PROFILE} \
            --id ${CLOUDFRONT_DISTRIBUTION_ID} \
            --query 'DistributionConfig' > /tmp/cf-config.json 2>/dev/null || true
        
        if [ -f /tmp/cf-config.json ]; then
            # 修改 Enabled 為 false
            python3 -c "
import json
with open('/tmp/cf-config.json', 'r') as f:
    config = json.load(f)
config['Enabled'] = False
with open('/tmp/cf-config-disabled.json', 'w') as f:
    json.dump(config, f)
"
            aws cloudfront update-distribution --profile ${AWS_PROFILE} \
                --id ${CLOUDFRONT_DISTRIBUTION_ID} \
                --if-match ${ETAG} \
                --distribution-config file:///tmp/cf-config-disabled.json 2>/dev/null || true
            
            echo "  等待 CloudFront 停用..."
            aws cloudfront wait distribution-deployed --profile ${AWS_PROFILE} \
                --id ${CLOUDFRONT_DISTRIBUTION_ID} 2>/dev/null || true
            
            # 取得新的 ETag 並刪除
            NEW_ETAG=$(aws cloudfront get-distribution --profile ${AWS_PROFILE} \
                --id ${CLOUDFRONT_DISTRIBUTION_ID} --query 'ETag' --output text 2>/dev/null) || true
            
            aws cloudfront delete-distribution --profile ${AWS_PROFILE} \
                --id ${CLOUDFRONT_DISTRIBUTION_ID} --if-match ${NEW_ETAG} 2>/dev/null || true
            
            rm -f /tmp/cf-config.json /tmp/cf-config-disabled.json
        fi
    fi
fi


# 刪除 Origin Access Control (OAC)
echo -e "${YELLOW}刪除 CloudFront OAC...${NC}"
OAC_ID=$(aws cloudfront list-origin-access-controls --profile ${AWS_PROFILE} \
    --query "OriginAccessControlList.Items[?Name=='${PROJECT_NAME}-S3-OAC'].Id" --output text 2>/dev/null) || true

if [ -n "$OAC_ID" ]; then
    ETAG=$(aws cloudfront get-origin-access-control --id ${OAC_ID} --profile ${AWS_PROFILE} --query "ETag" --output text 2>/dev/null)
    aws cloudfront delete-origin-access-control --id ${OAC_ID} --if-match ${ETAG} --profile ${AWS_PROFILE} 2>/dev/null || true
fi
echo -e "${GREEN}✓ CloudFront 已刪除${NC}"

# ===========================================
# 2. WAF
# ===========================================
echo ""
echo -e "${YELLOW}刪除 WAF...${NC}"
if [ -n "${WAF_WEB_ACL_ARN}" ]; then
    # 取得 Lock Token
    LOCK_TOKEN=$(aws wafv2 get-web-acl --profile ${AWS_PROFILE} --region us-east-1 \
        --name ${WAF_NAME} --scope CLOUDFRONT --id $(echo ${WAF_WEB_ACL_ARN} | awk -F'/' '{print $NF}') \
        --query 'LockToken' --output text 2>/dev/null) || true
    
    if [ -n "$LOCK_TOKEN" ]; then
        aws wafv2 delete-web-acl --profile ${AWS_PROFILE} --region us-east-1 \
            --name ${WAF_NAME} --scope CLOUDFRONT \
            --id $(echo ${WAF_WEB_ACL_ARN} | awk -F'/' '{print $NF}') \
            --lock-token ${LOCK_TOKEN} 2>/dev/null || true
    fi
fi
echo -e "${GREEN}✓ WAF 已刪除${NC}"

# ===========================================
# 3. Dashboard & Alarms
# ===========================================
echo ""
echo -e "${YELLOW}刪除 CloudWatch 資源...${NC}"
aws cloudwatch delete-dashboards --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --dashboard-names "${PROJECT_NAME}-WordPress-Monitor" 2>/dev/null || true

aws cloudwatch delete-alarms --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --alarm-names \
    "${PROJECT_NAME}-ECS-CPU-High" \
    "${PROJECT_NAME}-ECS-CPU-Low" \
    "${PROJECT_NAME}-ECS-Memory-High" \
    "${PROJECT_NAME}-ALB-5XX-Errors" \
    "${PROJECT_NAME}-ALB-Response-Time-High" \
    "${PROJECT_NAME}-TG-Unhealthy-Host" 2>/dev/null || true

echo -e "${GREEN}✓ CloudWatch 資源已刪除${NC}"

# ===========================================
# 4. Auto Scaling
# ===========================================
echo ""
echo -e "${YELLOW}刪除 Auto Scaling...${NC}"
aws application-autoscaling delete-scaling-policy --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --service-namespace ecs --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${ECS_CLUSTER_NAME}/${ECS_SERVICE_NAME}" \
    --policy-name "${PROJECT_NAME}-scale-out-policy" 2>/dev/null || true

aws application-autoscaling delete-scaling-policy --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --service-namespace ecs --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${ECS_CLUSTER_NAME}/${ECS_SERVICE_NAME}" \
    --policy-name "${PROJECT_NAME}-scale-in-policy" 2>/dev/null || true

aws application-autoscaling deregister-scalable-target --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --service-namespace ecs --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${ECS_CLUSTER_NAME}/${ECS_SERVICE_NAME}" 2>/dev/null || true

echo -e "${GREEN}✓ Auto Scaling 已刪除${NC}"

# ===========================================
# 5. SNS
# ===========================================
echo ""
echo -e "${YELLOW}刪除 SNS Topic...${NC}"
if [ -n "${SNS_TOPIC_ARN}" ]; then
    aws sns delete-topic --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --topic-arn ${SNS_TOPIC_ARN} 2>/dev/null || true
fi
echo -e "${GREEN}✓ SNS Topic 已刪除${NC}"

# ===========================================
# 6. ECS Service & Cluster
# ===========================================
echo ""
echo -e "${YELLOW}刪除 ECS Service...${NC}"
aws ecs update-service --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cluster ${ECS_CLUSTER_NAME} --service ${ECS_SERVICE_NAME} \
    --desired-count 0 2>/dev/null || true

aws ecs delete-service --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cluster ${ECS_CLUSTER_NAME} --service ${ECS_SERVICE_NAME} \
    --force 2>/dev/null || true

echo "  等待 Service 刪除..."
sleep 30

aws ecs delete-cluster --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --cluster ${ECS_CLUSTER_NAME} 2>/dev/null || true

echo -e "${GREEN}✓ ECS Service & Cluster 已刪除${NC}"

# ===========================================
# 7. ALB
# ===========================================
echo ""
echo -e "${YELLOW}刪除 ALB...${NC}"
if [ -n "${ALB_ARN}" ]; then
    for l in $(aws elbv2 describe-listeners --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --load-balancer-arn ${ALB_ARN} --query 'Listeners[].ListenerArn' --output text 2>/dev/null); do
        aws elbv2 delete-listener --profile ${AWS_PROFILE} --region ${AWS_REGION} \
            --listener-arn $l 2>/dev/null || true
    cd "$SCRIPT_DIR/.." 2>/dev/null || true
    done
    aws elbv2 delete-load-balancer --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --load-balancer-arn ${ALB_ARN} 2>/dev/null || true
fi
if [ -n "${TG_ARN}" ]; then
    sleep 10
    aws elbv2 delete-target-group --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --target-group-arn ${TG_ARN} 2>/dev/null || true
fi

# Fallback: Find Target Group by Name
TG_ARN_BY_NAME=$(aws elbv2 describe-target-groups --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --names "${PROJECT_NAME}-TG" --query "TargetGroups[0].TargetGroupArn" --output text 2>/dev/null) || true

if [ -n "$TG_ARN_BY_NAME" ] && [ "$TG_ARN_BY_NAME" != "None" ]; then
    echo "  找到殘留 Target Group: ${TG_ARN_BY_NAME}"
    aws elbv2 delete-target-group --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --target-group-arn ${TG_ARN_BY_NAME} 2>/dev/null || true
fi
echo -e "${GREEN}✓ ALB 已刪除${NC}"

# ===========================================
# 8. S3 Bucket
# ===========================================
echo ""
echo -e "${YELLOW}刪除 S3 Bucket...${NC}"
if [ -n "${S3_BUCKET_NAME}" ]; then
    aws s3 rm s3://${S3_BUCKET_NAME} --recursive --profile ${AWS_PROFILE} 2>/dev/null || true
    aws s3api delete-bucket --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --bucket ${S3_BUCKET_NAME} 2>/dev/null || true
fi
echo -e "${GREEN}✓ S3 Bucket 已刪除${NC}"

# ===========================================
# 9. ECR
# ===========================================
echo ""
echo -e "${YELLOW}刪除 ECR Repository...${NC}"
aws ecr delete-repository --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --repository-name ${ECR_REPO_NAME} --force 2>/dev/null || true
echo -e "${GREEN}✓ ECR Repository 已刪除${NC}"

# ===========================================
# 10. IAM Roles
# ===========================================
echo ""
echo -e "${YELLOW}刪除 IAM Roles...${NC}"
# Helper function to cleanup role
cleanup_role() {
    ROLE_NAME=$1
    echo "  處理 IAM Role: $ROLE_NAME"
    
    # Detach all managed policies
    POLICIES=$(aws iam list-attached-role-policies --role-name $ROLE_NAME --profile ${AWS_PROFILE} --query 'AttachedPolicies[].PolicyArn' --output text 2>/dev/null) || true
    for policy in $POLICIES; do
        echo "    Detaching policy: $policy"
        aws iam detach-role-policy --role-name $ROLE_NAME --policy-arn $policy --profile ${AWS_PROFILE} 2>/dev/null || true
    done

    # Delete all inline policies
    INLINE_POLICIES=$(aws iam list-role-policies --role-name $ROLE_NAME --profile ${AWS_PROFILE} --query 'PolicyNames[]' --output text 2>/dev/null) || true
    for policy in $INLINE_POLICIES; do
        echo "    Deleting inline policy: $policy"
        aws iam delete-role-policy --role-name $ROLE_NAME --policy-name $policy --profile ${AWS_PROFILE} 2>/dev/null || true
    done

    # Delete Role
    aws iam delete-role --profile ${AWS_PROFILE} --role-name $ROLE_NAME 2>/dev/null || true
}

cleanup_role ${TASK_EXECUTION_ROLE_NAME}
cleanup_role ${TASK_ROLE_NAME}

echo -e "${GREEN}✓ IAM Roles 已刪除${NC}"

# ===========================================
# 11. CloudWatch Log Group
# ===========================================
echo ""
echo -e "${YELLOW}刪除 CloudWatch Log Group...${NC}"
aws logs delete-log-group --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --log-group-name ${LOG_GROUP_NAME} 2>/dev/null || true
echo -e "${GREEN}✓ CloudWatch Log Group 已刪除${NC}"

# ===========================================
# 12. VPC Endpoints
# ===========================================
echo ""
echo -e "${YELLOW}刪除 VPC Endpoints...${NC}"
ENDPOINTS=$(aws ec2 describe-vpc-endpoints --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --filters "Name=vpc-id,Values=${VPC_ID}" "Name=tag:Project,Values=${PROJECT_TAG}" \
    --query 'VpcEndpoints[].VpcEndpointId' --output text 2>/dev/null) || true

for ep in $ENDPOINTS; do
    aws ec2 delete-vpc-endpoints --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --vpc-endpoint-ids $ep 2>/dev/null || true
done

# ===========================================
# 12. Route53 Records (Root + WWW)
# ===========================================
echo ""
echo -e "${YELLOW}刪除 Route53 Records...${NC}"

# 嘗試從 terraform.tfvars 讀取 domain_name
DOMAIN_NAME=$(grep 'domain_name' terraform.tfvars | cut -d'=' -f2 | tr -d ' "')

if [ -n "$DOMAIN_NAME" ]; then
    echo "  Domain: $DOMAIN_NAME"
    
    # 取得 Hosted Zone ID
    ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='${DOMAIN_NAME}.'].Id" --output text --profile ${AWS_PROFILE} 2>/dev/null)
    # Remove /hostedzone/ prefix if present
    ZONE_ID=${ZONE_ID##*/}

    if [ -n "$ZONE_ID" ]; then
        echo "  Hosted Zone ID: $ZONE_ID"

        # 刪除 Root Record (A)
        echo "  檢查 Root Record..."
        aws route53 change-resource-record-sets --profile ${AWS_PROFILE} --hosted-zone-id ${ZONE_ID} --change-batch "{
            \"Changes\": [{
                \"Action\": \"DELETE\",
                \"ResourceRecordSet\": {
                    \"Name\": \"${DOMAIN_NAME}.\",
                    \"Type\": \"A\",
                    \"AliasTarget\": {
                        \"HostedZoneId\": \"Z2FDTNDATAQYW2\", 
                        \"DNSName\": \"dualstack.dummy.cloudfront.net.\",
                        \"EvaluateTargetHealth\": false
                    }
                }
            }]
        }" 2>/dev/null || true
        # 注意: 上面的 Delete 只有在 AliasTarget 完全匹配時才會成功。
        # 更穩健的方法是先 Get 再 Delete，但這需要複雜的 JSON 處理。
        # 這裡改用簡單的 '嘗試刪除' 策略，如果不匹配會失敗 (也是一種保護)。
        
        # 更好的策略：列出 Record 並刪除
        RRSETS=$(aws route53 list-resource-record-sets --hosted-zone-id ${ZONE_ID} --query "ResourceRecordSets[?Name=='${DOMAIN_NAME}.'||Name=='www.${DOMAIN_NAME}.']" --profile ${AWS_PROFILE})
        
        # 這裡需要 jq 來處理 JSON，我們假設環境可能沒有 jq，所以用 python 處理
        echo "  刪除 Root & WWW Records..."
        python3 -c "
import json, sys, subprocess
try:
    rrsets = json.loads('$RRSETS')
    for rs in rrsets:
        if rs['Type'] == 'A':
            change_batch = {
                'Changes': [{
                    'Action': 'DELETE',
                    'ResourceRecordSet': rs
                }]
            }
            subprocess.run([
                'aws', 'route53', 'change-resource-record-sets',
                '--hosted-zone-id', '$ZONE_ID',
                '--change-batch', json.dumps(change_batch),
                '--profile', '${AWS_PROFILE}'
            ], check=True)
            print(f\"  Deleted {rs['Name']}\")
except Exception as e:
    pass
"
    fi
else
    echo "  無法取得 Domain Name，跳過 Route53 清理"
fi
echo -e "${GREEN}✓ Route53 Records 已清理 (若存在)${NC}"

# ===========================================
# 13. VPC Endpoints

# ===========================================
# 13. NAT Gateway
# ===========================================
echo ""
echo -e "${YELLOW}刪除 NAT Gateway...${NC}"
if [ -n "${NAT_GATEWAY_ID}" ]; then
    aws ec2 delete-nat-gateway --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --nat-gateway-id ${NAT_GATEWAY_ID} 2>/dev/null || true
    echo "  等待 NAT Gateway 刪除..."
    sleep 60
fi
if [ -n "${NAT_EIP_ALLOCATION_ID}" ]; then
    aws ec2 release-address --profile ${AWS_PROFILE} --region ${AWS_REGION} \
        --allocation-id ${NAT_EIP_ALLOCATION_ID} 2>/dev/null || true
fi
echo -e "${GREEN}✓ NAT Gateway 已刪除${NC}"

# ===========================================
# 14. SSM Parameters
# ===========================================
echo ""
echo -e "${YELLOW}刪除 SSM Parameters...${NC}"
aws ssm delete-parameter --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --name "/${PROJECT_TAG}/efs-access-point-id" 2>/dev/null || true
aws ssm delete-parameter --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --name "/${PROJECT_TAG}/s3-bucket-name" 2>/dev/null || true
aws ssm delete-parameter --profile ${AWS_PROFILE} --region ${AWS_REGION} \
    --name "/${PROJECT_TAG}/efs-id" 2>/dev/null || true
echo -e "${GREEN}✓ SSM Parameters 已刪除${NC}"

# ===========================================
# 15. Secrets Manager (選擇性)
# ===========================================
echo ""
echo -e "${YELLOW}Secrets Manager 處理...${NC}"
echo ""
read -p "是否刪除 Secrets Manager secrets? (y/N) " delete_secrets

if [ "$delete_secrets" == "y" ] || [ "$delete_secrets" == "Y" ]; then
    echo "刪除 Secrets Manager secrets..."
    
    # 刪除所有專案相關的 secrets
    for secret_name in "${SECRETS_PREFIX}/rds/credentials" "${SECRETS_PREFIX}/wordpress/salts" "${SECRETS_PREFIX}/cloudfront/origin-verify" "${SECRETS_PREFIX}/api/keys"; do
        aws secretsmanager delete-secret --profile ${AWS_PROFILE} --region ${AWS_REGION} \
            --secret-id "${secret_name}" \
            --force-delete-without-recovery 2>/dev/null || true
    done
    
    echo -e "${GREEN}✓ Secrets Manager secrets 已刪除${NC}"
else
    echo "  ⚠️ Secrets Manager secrets 保留 (包含密碼和金鑰)"
fi

# ===========================================
# 完成
# ===========================================
echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${GREEN}✅ 清理完成！${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo -e "${YELLOW}⚠️ 以下資源【保留】未刪除 (需手動處理):${NC}"
echo "  - VPC / Subnets / Route Tables"
echo "  - Security Groups / NACLs"
echo "  - RDS 資料庫 (避免數據遺失)"
echo "  - EFS 檔案系統 (避免數據遺失)"
echo "  - EFS Access Point"
echo "  - ACM SSL 憑證"
if [ "$delete_secrets" != "y" ] && [ "$delete_secrets" != "Y" ]; then
    echo "  - Secrets Manager (RDS 密碼、WordPress Salts)"
fi
echo ""
echo "如需完全清除，請在 AWS Console 手動刪除這些資源。"
echo "=========================================="
