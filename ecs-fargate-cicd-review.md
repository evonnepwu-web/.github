# ECS Fargate 高併發架構 CI/CD 審查報告

## 📋 執行摘要

經過完整審查，你的 Terraform 基礎架構整體設計良好，符合 AWS Well-Architected Framework 的多項最佳實踐。以下是最終配置的環境差異對照表。

---

## ✅ 環境配置對照表

| 項目                         | Development (預設) | Production      |
| ---------------------------- | ------------------ | --------------- |
| **ECS Task CPU**             | 512                | 1024            |
| **ECS Task Memory**          | 1024 MB            | 2048 MB         |
| **Task Desired Count**       | 1                  | 2               |
| **Task Min Count**           | 1                  | 2               |
| **Task Max Count**           | 3                  | 10              |
| **RDS Instance**             | db.t3.micro        | db.t3.small     |
| **RDS Multi-AZ**             | ❌                 | ✅              |
| **RDS Performance Insights** | ❌ (不支援)        | ✅              |
| **NAT Gateway**              | 1 個               | 2 個 (每 AZ)    |
| **EFS Throughput**           | bursting           | bursting        |
| **Auto Scaling**             | Target Tracking    | Target Tracking |
| **Scaling CPU Target**       | 70%                | 60%             |
| **Scaling Cooldown Out**     | 120s               | 60s             |
| **Scaling Cooldown In**      | 300s               | 300s            |
| **CloudFront Price Class**   | PriceClass_100     | PriceClass_200  |
| **Deletion Protection**      | ❌                 | ❌              |
| **Force Destroy**            | ✅                 | ❌              |
| **Log Retention**            | 30 days            | 90 days         |
| **Backup Retention**         | 7 days             | 14 days         |

---

## 📁 檔案結構

```
project/
├── .github/
│   └── workflows/
│       └── deploy.yml              # GitHub Actions CI/CD
├── scripts/
│   ├── deploy-everything.sh        # 一鍵部署
│   ├── nuke-everything.sh          # 一鍵刪除 (含所有備份)
│   ├── cleanup.sh                  # 清理資源 (保留 RDS/EFS)
│   ├── backup-before-cleanup.sh    # 清理前備份
│   ├── restore-from-backup.sh      # 從備份還原
│   ├── manual-deploy-image.sh      # 手動部署映像
│   └── redeploy.sh                 # 重新部署
├── src/
│   └── docker/
│       ├── Dockerfile              # WordPress Image
│       └── wp-config.php           # WordPress 設定 (含 CI Trigger)
├── theme_source/
│   └── cosmetics-shop/             # WordPress 佈景主題原始碼
├── main.tf                         # Provider 設定
├── variables.tf                    # 變數定義
├── locals.tf                       # 環境預設值 (核心)
├── network.tf                      # VPC/Subnet/SG/NACL
├── iam_acm.tf                      # IAM Roles + ACM
├── database.tf                     # RDS + Secrets Manager
├── storage.tf                      # EFS + S3
├── compute.tf                      # ECS + ALB + ECR
├── cdn_security.tf                 # CloudFront + WAF
├── dns.tf                          # Route53
├── monitoring.tf                   # Auto Scaling + Alarms
├── dashboard.tf                    # CloudWatch Dashboard
├── cicd.tf                         # GitHub OIDC (選用)
├── outputs.tf                      # Outputs
├── terraform.tfvars                # 實際配置
└── terraform.tfvars.example        # 範例配置
```

---

## 🛠️ 腳本說明

| 腳本                       | 用途     | 說明                        |
| -------------------------- | -------- | --------------------------- |
| `deploy-everything.sh`     | 一鍵部署 | 從零建立整個環境            |
| `cleanup.sh`               | 清理資源 | 保留 RDS/EFS，刪除計費資源  |
| `nuke-everything.sh`       | 完全刪除 | 刪除所有資源含備份，不可逆  |
| `backup-before-cleanup.sh` | 備份     | 在 cleanup 前備份重要資料   |
| `restore-from-backup.sh`   | 還原     | 從備份完整還原網站          |
| `manual-deploy-image.sh`   | 手動部署 | 重新建置並部署 Docker Image |
| `redeploy.sh`              | 重新部署 | 使用現有 Image 重新部署     |
| `waf-test.sh`              | WAF 測試 | 測試 WAF 安全防護是否正常   |

---

## 🚀 使用方式

### 1. 複製範例配置

```bash
cp terraform.tfvars.example terraform.tfvars
```

### 2. 編輯配置

```hcl
# terraform.tfvars
environment = "development"  # 或 "production"
```

### 3. 部署

```bash
terraform init
terraform plan
terraform apply
```

---

## ⚙️ 環境切換

只需修改一個變數即可切換所有配置：

```hcl
# Development (預設)
environment = "development"

# Production
environment = "production"
```

### 手動覆蓋 (選用)

如果需要覆蓋自動設定的值：

```hcl
# terraform.tfvars
environment = "development"

# 手動覆蓋特定值
task_cpu    = 1024  # 覆蓋 development 預設的 512
task_memory = 2048  # 覆蓋 development 預設的 1024
```

---

## 📊 CloudWatch Dashboard 功能

### 關鍵指標概覽 (Single Value)

- 🔥 ECS CPU
- 💾 ECS Memory
- 📦 Running Tasks
- ⏱️ Response Time
- 📈 Requests/min
- ❌ 5XX Errors

### SRE Golden Signals

- **Latency**: P50/P90/P99 分布圖 + SLA 預警線 (1s/3s)
- **Traffic**: 請求數 + WAF 攔截
- **Errors**: HTTP Status Code 堆疊圖

### 運算資源

- ECS CPU (含 Scale Target 預警線)
- ECS Memory (含 70%/85% 預警線)
- Auto Scaling 狀態 (含 Min/Max 預警線)

### 資料庫與儲存

- RDS CPU (含 80% 預警線)
- RDS 連線數 (含 max connections 預警線)
- RDS IOPS
- EFS IO Limit (含 80%/95% 預警線)

### CDN & Security

- CloudFront Traffic
- CloudFront Cache Hit Rate (含 50%/80% 預警線)
- CloudFront Error Rates
- WAF Requests & Blocks

---

## 🔔 CloudWatch Alarms

| Alarm                 | 條件                 | 環境       |
| --------------------- | -------------------- | ---------- |
| ECS CPU High          | > Scale Target + 10% | 全部       |
| ECS CPU Low           | < 20%                | 全部       |
| ECS Memory High       | > 80%                | Production |
| ALB 5XX High          | > 10/min             | Production |
| ALB Latency P99       | > 3s                 | Production |
| RDS Connections       | > 80% of max         | 全部       |
| EFS IO Limit          | > 80%                | 全部       |
| CloudFront Error Rate | > 5%                 | Production |
| Healthy Host Count    | < Min Tasks          | 全部       |

---

## 🔄 Auto Scaling 策略

### 所有環境使用 Target Tracking

| Policy                 | Target        | 說明            |
| ---------------------- | ------------- | --------------- |
| CPU Target Tracking    | 60-70%        | 主要指標        |
| Memory Target Tracking | 70%           | 輔助指標        |
| ALB Request Count      | 1000 req/task | Production only |

### Cooldown 設定

| 環境        | Scale Out | Scale In |
| ----------- | --------- | -------- |
| Development | 120s      | 300s     |
| Production  | 60s       | 300s     |

---

## 🔐 CI/CD 設定 (GitHub Actions)

### 啟用 OIDC

```hcl
# terraform.tfvars
enable_github_oidc = true
github_repo        = "your-org/your-repo"
```

### GitHub Secrets

設定 `AWS_ROLE_ARN`：

```
arn:aws:iam::ACCOUNT_ID:role/project-github-actions-role
```

### 部署流程

1. Push to `main` branch
2. Detect changes (app/infra)
3. Build & Push Docker image
4. Scan for vulnerabilities (Trivy)
5. Update ECS Task Definition
6. Deploy to ECS (with Circuit Breaker)
7. Health check verification
8. CloudFront cache invalidation

---

## 🛡️ WAF 配置

### 規則優先級

| 優先級 | 規則名稱              |  動作   | 說明                                          |
| :----: | --------------------- | :-----: | --------------------------------------------- |
|   0    | AllowWordPressAdmin   |  Allow  | 允許 `/wp-admin`, `/wp-json`, `/wp-login.php` |
|   1    | CommonRuleSet         | Block\* | XSS, LFI, RFI 防護                            |
|   2    | KnownBadInputsRuleSet |  Block  | Log4j, 已知惡意輸入                           |
|   3    | SQLiRuleSet           |  Block  | SQL Injection 防護                            |
|   4    | WordPressRuleSet      |  Count  | WordPress 專用防護（Count 避免誤擋）          |
|   5    | RateLimitRule         |  Block  | 速率限制 (Dev: 5000, Prod: 2000)              |
|   6    | IpReputationList      |  Block  | 惡意 IP 黑名單 (Production only)              |

### CommonRuleSet 例外規則

以下規則改為 **Count** 模式，避免誤擋 WordPress Gutenberg 編輯器：

- `SizeRestrictions_BODY`
- `GenericRFI_BODY`
- `CrossSiteScripting_BODY`

### S3 Bucket Policy

允許以下存取：

- **CloudFront OAC**: 讀取媒體檔案
- **ECS Task Role**: 上傳/刪除媒體檔案

---

## 📝 注意事項

1. **EFS**: 所有環境統一使用 `bursting` 模式
2. **Auto Scaling**: 所有環境統一使用 `Target Tracking`
3. **Deletion Protection**: 已移除，方便管理
4. **RDS t3.micro**: 不支援 Performance Insights，僅限 Development
5. **Production Multi-AZ**: 自動啟用 RDS Multi-AZ
6. **WAF WordPressRuleSet**: 使用 Count 模式避免誤擋正常操作
7. **S3 上傳**: ECS Task Role 需要 S3 寫入權限
