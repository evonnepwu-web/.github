# WordPress ECS Fargate CI/CD 完整展示手冊

本文件將引導您展示完整的 DevOps 生命週期，包含「環境建置 (Infrastructure as Code)」、「持續部署 (CI/CD)」、「環境銷毀 (Cleanup)」，以及 Development 與 Production 環境的規格與成本比較。

---

## 📋 展示總覽 (The 3 Phases)

| 階段                  | 腳本/動作              | 展示重點                                                                                   |
| :-------------------- | :--------------------- | :----------------------------------------------------------------------------------------- |
| **Phase 1: Setup**    | `deploy-everything.sh` | **IaC (Infrastructure as Code)**<br>展示如何用一個指令，從零自動建立整個 AWS 雲端架構      |
| **Phase 2: CI/CD**    | `git push`             | **Continuous Deployment**<br>展示修改程式碼後，如何自動觸發 Pipeline 並無縫更新線上服務    |
| **Phase 3: Teardown** | `nuke-everything.sh`   | **Cost Control & Disposable Infrastructure**<br>展示雲端資源的彈性，用完即丟，避免閒置成本 |

---

## 💰 環境規格與成本比較

### Development vs Production 規格對照

| 項目                         | Development (預設) | Production      | 差異說明                    |
| :--------------------------- | :----------------- | :-------------- | :-------------------------- |
| **ECS Task CPU**             | 0.5 vCPU (512)     | 1 vCPU (1024)   | Production 2 倍運算能力     |
| **ECS Task Memory**          | 1 GB (1024 MB)     | 2 GB (2048 MB)  | Production 2 倍記憶體       |
| **Task 數量 (Desired)**      | 1                  | 2               | Production 預設雙機備援     |
| **Task 數量 (Min/Max)**      | 1 ~ 3              | 2 ~ 10          | Production 可擴展更多       |
| **RDS Instance**             | db.t3.micro        | db.t3.small     | Production 連線數 150 vs 66 |
| **RDS Multi-AZ**             | ❌ 單一 AZ         | ✅ 雙 AZ 備援   | Production 高可用           |
| **RDS Performance Insights** | ❌ 不支援          | ✅ 啟用         | Production 效能監控         |
| **NAT Gateway**              | 1 個               | 2 個 (每 AZ)    | Production 高可用，Dev 省錢 |
| **EFS Throughput**           | Bursting           | Bursting        | 相同                        |
| **Auto Scaling**             | Target Tracking    | Target Tracking | 相同策略                    |
| **Scaling CPU Target**       | 70%                | 60%             | Production 更早擴展         |
| **Scale Out Cooldown**       | 120 秒             | 60 秒           | Production 更快反應         |
| **CloudFront Price Class**   | PriceClass_100     | PriceClass_200  | Production 更多邊緣節點     |
| **Log Retention**            | 30 天              | 90 天           | Production 保留更久         |
| **Backup Retention**         | 7 天               | 14 天           | Production 備份更久         |

---

### 💵 月成本估算 (ap-northeast-1 東京區域)

#### ECS Fargate 成本

| 環境            | CPU      | Memory | Tasks | 小時費率                                  | 月成本 (730hr) |
| :-------------- | :------- | :----- | :---- | :---------------------------------------- | :------------- |
| **Development** | 0.5 vCPU | 1 GB   | 1     | $0.02534 + $0.00278 = **$0.028/hr**       | **~$20/月**    |
| **Production**  | 1 vCPU   | 2 GB   | 2     | ($0.05068 + $0.00556) × 2 = **$0.112/hr** | **~$82/月**    |

> 💡 Fargate 定價：vCPU $0.05068/hr、Memory $0.00556/GB/hr (東京)

#### RDS 成本

| 環境            | Instance    | Multi-AZ | 小時費率               | 月成本      |
| :-------------- | :---------- | :------- | :--------------------- | :---------- |
| **Development** | db.t3.micro | ❌       | $0.018/hr              | **~$13/月** |
| **Production**  | db.t3.small | ✅       | $0.036 × 2 = $0.072/hr | **~$53/月** |

#### 其他固定成本

| 服務                | Development    | Production     | 說明                       |
| :------------------ | :------------- | :------------- | :------------------------- |
| **NAT Gateway**     | ~$32/月 (1 個) | ~$64/月 (2 個) | 固定費用 + 資料傳輸        |
| **ALB**             | ~$16/月        | ~$16/月        | 固定費用 + LCU             |
| **EFS**             | ~$3/月         | ~$3/月         | 依儲存量 (假設 10GB)       |
| **CloudFront**      | ~$1-5/月       | ~$1-5/月       | 依流量                     |
| **Route 53**        | ~$0.50/月      | ~$0.50/月      | Hosted Zone                |
| **Secrets Manager** | ~$2/月         | ~$2/月         | 4 個 Secrets               |
| **CloudWatch**      | ~$3/月         | ~$5/月         | Logs + Metrics + Dashboard |

#### 總成本比較

| 環境            | ECS | RDS | NAT Gateway | 其他 | **總計**     |
| :-------------- | :-- | :-- | :---------- | :--- | :----------- |
| **Development** | $20 | $13 | $32         | ~$26 | **~$91/月**  |
| **Production**  | $82 | $53 | $64         | ~$27 | **~$226/月** |

> ⚠️ 以上為估算值，實際費用依使用量而定
>
> 💡 **Development vs Production 成本差異主要來自：**
>
> - NAT Gateway: +$32 (多 1 個)
> - ECS Fargate: +$62 (規格 × 2，數量 × 2)
> - RDS: +$40 (規格升級 + Multi-AZ)

---

### 🆚 ECS Fargate vs EC2 成本比較

假設相同規格：1 vCPU + 2 GB Memory，24/7 運行

| 方案             | 規格          | 月成本  | 優點                       | 缺點                       |
| :--------------- | :------------ | :------ | :------------------------- | :------------------------- |
| **Fargate**      | 1 vCPU / 2 GB | ~$41/月 | 免管理、秒級計費、自動擴展 | 單位成本較高               |
| **EC2 t3.small** | 2 vCPU / 2 GB | ~$15/月 | 便宜、彈性大               | 需管理 OS、Patch、擴展複雜 |
| **EC2 + Spot**   | 2 vCPU / 2 GB | ~$5/月  | 最便宜                     | 可能被中斷、不適合生產     |

#### 何時選 Fargate？

✅ **適合 Fargate 的情況：**

- 團隊小、沒有專職 SRE
- 流量波動大、需要快速擴展
- 想專注在應用開發，不想管 Server
- 短期專案、Demo 展示

✅ **適合 EC2 的情況：**

- 長期穩定負載
- 有專職維運人員
- 需要 GPU 或特殊硬體
- 成本敏感的專案

---

### 🔄 環境切換方式

只需修改一個變數，即可切換所有配置：

```hcl
# terraform.tfvars

# 開發環境 (省錢)
environment = "development"

# 生產環境 (高可用)
environment = "production"
```

然後執行：

```bash
terraform plan   # 預覽變更
terraform apply  # 套用變更
```

---

## ✅ Phase 1: 環境建置 (Setup)

**情境**：模擬在新 Region 或為新客戶快速建立整套環境。

### 步驟

1. 開啟 VS Code 終端機
2. 切換到專案目錄：
   ```bash
   cd infrastructure/terraform
   ```
3. 執行一鍵部署腳本：
   ```bash
   ./scripts/deploy-everything.sh
   ```

### 解說重點

- 腳本會自動呼叫 **Terraform** 建立基礎設施
- 自動建立 **ECR** 並推送 Docker Image
- 最後部署 **ECS Service**
- 整個過程約需 **15-20 分鐘**

### 建立的資源清單

```
VPC + 6 Subnets (Public/App/Data × 2 AZs)
├── Internet Gateway
├── NAT Gateway (× 2 for Production)
├── ALB + Target Group
├── ECS Cluster + Service + Task Definition
├── ECR Repository
├── RDS MySQL (Multi-AZ for Production)
├── EFS + Access Point
├── S3 Bucket (Media Storage)
├── CloudFront Distribution
├── WAF Web ACL (5 Managed Rules)
├── Route 53 Records
├── ACM Certificates (× 2)
├── Secrets Manager (× 4)
├── CloudWatch Dashboard + Alarms
└── IAM Roles + Policies
```

---

## 🚀 Phase 2: CI/CD 自動化部署 (Demo)

**情境**：開發者修改網站樣式，自動部署到線上環境。

### CI/CD Pipeline 流程圖

```
┌─────────────────────────────────────────────────────────────────┐
│                        git push to main                          │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│  🔨 Build & Push                                                 │
│  ├── Build Docker Image                                         │
│  ├── Push to ECR                                                │
│  └── Trivy Security Scan                                        │
└─────────────────────────────────────────────────────────────────┘
                                │
                ┌───────────────┴───────────────┐
                │                               │
                ▼                               ▼
┌───────────────────────────┐     ┌───────────────────────────────┐
│  environment=development  │     │  environment=production        │
├───────────────────────────┤     ├───────────────────────────────┤
│                           │     │                               │
│  🚀 Deploy to Dev         │     │  🧪 Deploy to Staging         │
│  (自動，不需審核)          │     │  (自動)                        │
│                           │     │         │                      │
│  ✅ Verify & WAF Test     │     │         ▼                      │
│                           │     │  ✋ Approval Gate              │
│  📧 Email 通知            │     │  (需要人工審核)                 │
│                           │     │         │                      │
└───────────────────────────┘     │         ▼                      │
                                  │  🚀 Deploy to Production       │
                                  │                               │
                                  │  ✅ Verify & WAF Test         │
                                  │                               │
                                  │  📧 Email 通知                │
                                  └───────────────────────────────┘
```

### 環境判斷邏輯

| 環境            | 觸發條件                                |    審核需求     | Email 通知 |
| --------------- | --------------------------------------- | :-------------: | :--------: |
| **Development** | `environment=development` (預設)        |    ❌ 不需要    |   ✅ 有    |
| **Staging**     | `environment=production`                |    ❌ 不需要    |   ❌ 無    |
| **Production**  | `environment=production` + Staging 通過 | ✅ **需要審核** |   ✅ 有    |

### GitHub Environment 設定（Production Approval）

要啟用 Production Approval Gate，需要在 GitHub 設定：

1. 前往 GitHub Repo → **Settings** → **Environments**
2. 點擊 **New environment**，建立三個環境：
   - `development` (不需設定)
   - `staging` (不需設定)
   - `production` (需設定審核者)
3. 在 `production` 環境：
   - 勾選 **Required reviewers**
   - 加入審核者（你自己或團隊成員）

### Email 通知範例

部署完成後會收到 Email：

```
Subject: ✅ [DEVELOPMENT] Deployment SUCCESS

✅ Deployment SUCCESS

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Deployment Details
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Environment: development
Status: SUCCESS
Image Tag: abc1234-20260115-143000

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Commit Info
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SHA: abc1234
Author: evonnepwu
Message: DEMO: Update site title color

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔗 Links
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Website: https://evoger.tw
Pipeline: https://github.com/.../actions/runs/123456
```

---

### 步驟一：展示現狀 (Before)

1. 打開瀏覽器，前往 `https://evoger.tw`
2. 指著網站的某個明顯特徵 (例如標題顏色)
3. 說明：「目前網站標題是**黑色**的」

### 步驟二：修改程式碼 (Code)

1. 在 VS Code 開啟：`src/theme/style.css`
2. 在檔案最後加入測試 CSS：
   ```css
   /* CI/CD Demo: 將標題改為紅色 */
   .site-title a,
   .site-title {
     color: #ff0000 !important;
   }
   ```
3. 儲存檔案

### 步驟三：觸發 CI/CD (Push)

```bash
git add .
git commit -m "DEMO: Update site title color to red"
git push origin main
```

**解說**：「我現在將修改推送到 GitHub，這會自動觸發 GitHub Actions Pipeline，完全不需要登入 AWS Console。」

### 步驟四：監控流程 (Monitor)

1. 切換到 GitHub Actions 頁面：
   `https://github.com/evonnepwu-web/.github/actions`

2. 展示 Pipeline 步驟：

   **Development 環境流程：**
   | 步驟 | 說明 | 時間 |
   |:-----|:-----|:-----|
   | **Setup** | 偵測變更、判斷環境 | ~10s |
   | **Build & Push** | 打包 Docker Image 並推送到 ECR | ~2-3min |
   | **Trivy Scan** | 掃描 Image 安全漏洞 | ~30s |
   | **Deploy to Dev** | 更新 Task Definition 並部署 | ~3-5min |
   | **Verify** | Health Check + WAF Test | ~1min |
   | **Notify** | 發送 Email 通知 | ~10s |

   **Production 環境流程 (額外)：**
   | 步驟 | 說明 |
   |:-----|:-----|
   | **Deploy to Staging** | 先部署到 Staging 測試 |
   | **Smoke Test** | Staging 環境自動測試 |
   | ⏸️ **Approval Gate** | **等待人工審核** |
   | **Deploy to Production** | 審核通過後部署到 Production |

### 步驟五：驗證結果 (After)

1. 等待 GitHub Actions 顯示 ✅ **Success**
2. 回到瀏覽器，重新整理 `https://evoger.tw`
3. **標題變紅色了！** 🎉

**解說**：「部署成功，過程中：

- ❌ 不需要手動 SSH 進伺服器
- ❌ 不需要傳輸檔案
- ❌ 不需要手動重啟服務
- ✅ ECS 滾動更新，零停機時間」

### CI/CD 流程圖

```
Developer                GitHub                    AWS
   │                        │                       │
   │  git push              │                       │
   │───────────────────────>│                       │
   │                        │                       │
   │                        │  Trigger Workflow     │
   │                        │──────────────────────>│
   │                        │                       │
   │                        │  1. Build Docker      │
   │                        │  2. Push to ECR       │
   │                        │  3. Update Task Def   │
   │                        │  4. Deploy ECS        │
   │                        │  5. Health Check      │
   │                        │<──────────────────────│
   │                        │                       │
   │  ✅ Success            │                       │
   │<───────────────────────│                       │
```

---

## 🛡️ Phase 2.5: WAF 安全測試 Demo

**情境**：展示 AWS WAF 如何保護網站免受常見攻擊。

### WAF 已啟用的規則

| 優先級 | 規則                      | 說明                                          |  模式   |    Dev    |   Prod    |
| :----: | ------------------------- | --------------------------------------------- | :-----: | :-------: | :-------: |
|   0    | **AllowWordPressAdmin**   | 允許 `/wp-admin`, `/wp-json`, `/wp-login.php` |  Allow  |    ✅     |    ✅     |
|   1    | **CommonRuleSet**         | XSS, LFI, RFI 等常見攻擊                      | Block\* |    ✅     |    ✅     |
|   2    | **KnownBadInputsRuleSet** | 已知惡意輸入模式                              |  Block  |    ✅     |    ✅     |
|   3    | **SQLiRuleSet**           | SQL Injection 防護                            |  Block  |    ✅     |    ✅     |
|   4    | **WordPressRuleSet**      | WordPress 專用防護                            |  Count  |    ✅     |    ✅     |
|   5    | **RateLimitRule**         | 速率限制                                      |  Block  | 5000/5min | 2000/5min |
|   6    | **IpReputationList**      | 惡意 IP 黑名單                                |  Block  |    ❌     |    ✅     |

> **\* CommonRuleSet 例外**：`SizeRestrictions_BODY`, `GenericRFI_BODY`, `CrossSiteScripting_BODY` 改為 Count 模式，避免誤擋 WordPress 正常操作（如 Gutenberg 編輯器）。

### WAF 設計說明

| 設計考量                      | 說明                                                        |
| ----------------------------- | ----------------------------------------------------------- |
| **AllowWordPressAdmin 優先**  | 優先級 0，確保管理路徑不會被後續規則誤擋                    |
| **WordPressRuleSet 用 Count** | 避免誤擋正常的 WordPress 操作，同時記錄可疑行為             |
| **部分規則例外**              | CommonRuleSet 的 Body 檢查規則可能誤判 Gutenberg 編輯器內容 |

### 測試 1: SQL Injection 攻擊

```bash
# 正常請求 (應該返回 200 或 301)
curl -I "https://evoger.tw/"

# SQL Injection 攻擊 (應該返回 403 Forbidden)
curl -I "https://evoger.tw/?id=1' OR '1'='1"
```

**預期結果**：

```
HTTP/2 403
server: CloudFront
x-cache: Error from cloudfront
```

**解說**：「WAF 的 SQLi 規則偵測到 SQL Injection 語法，直接在 CloudFront 層就擋掉了，請求根本沒有到達我們的 ECS 服務。」

### 測試 2: XSS (跨站腳本) 攻擊

```bash
# XSS 攻擊嘗試 (應該返回 403)
curl -I "https://evoger.tw/?q=<script>alert('xss')</script>"

# 另一種 XSS 變體
curl -I "https://evoger.tw/?name=<img src=x onerror=alert(1)>"
```

**預期結果**：403 Forbidden

**解說**：「CommonRuleSet 包含 XSS 防護，任何嘗試注入 JavaScript 的請求都會被攔截。」

### 測試 3: Path Traversal 攻擊

```bash
# 嘗試讀取系統檔案 (應該返回 403)
curl -I "https://evoger.tw/wp-content/../../../etc/passwd"

# 編碼變體
curl -I "https://evoger.tw/?file=....//....//etc/passwd"
```

**預期結果**：403 Forbidden

**解說**：「攻擊者嘗試用 `../` 跳出 web 目錄讀取系統檔案，WAF 直接阻擋。」

### 測試 4: WordPress 特定攻擊

```bash
# XML-RPC 濫用攻擊 (常用於暴力破解和 DDoS)
curl -X POST "https://evoger.tw/xmlrpc.php" \
  -H "Content-Type: text/xml" \
  -d '<?xml version="1.0"?><methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>admin</value></param><param><value>password123</value></param></params></methodCall>'
```

**預期結果**：403 Forbidden

**解說**：「WordPress 的 XML-RPC 是常見的攻擊入口，WordPressRuleSet 會特別保護這個端點。」

### 測試 5: Rate Limit (速率限制)

```bash
# 安裝測試工具 (如果沒有)
# macOS: brew install hey
# Linux: go install github.com/rakyll/hey@latest

# 發送大量請求測試 Rate Limit
# ⚠️ 注意：這會發送 500 個請求，小心不要被自己擋掉
hey -n 500 -c 20 -q 50 https://evoger.tw/

# 或使用 ab (Apache Benchmark)
ab -n 500 -c 20 https://evoger.tw/
```

**預期結果**：

- 前面的請求：200 OK
- 超過閾值後：403 Forbidden

**解說**：「Rate Limit 防止單一 IP 發送過多請求，可以阻擋簡單的 DDoS 攻擊。Development 環境設定 5000 req/5min，Production 更嚴格只有 2000 req/5min。」

### 查看 WAF 攔截紀錄

#### 方法 1: AWS Console

1. 前往 **WAF & Shield** → **Web ACLs** (記得選 **Global (CloudFront)** 區域)
2. 選擇 `project-WAF`
3. 點擊 **Sampled requests** 查看被攔截的請求詳情

#### 方法 2: CloudWatch Dashboard

你的 Dashboard 已包含 WAF 指標，展示：

- **WAF Total Requests** - 總請求數
- **WAF Blocked Requests** - 被攔截數量

#### 方法 3: CLI 查詢

```bash
# 查看過去 1 小時被攔截的請求數
aws cloudwatch get-metric-statistics \
  --namespace AWS/WAFV2 \
  --metric-name BlockedRequests \
  --dimensions Name=WebACL,Value=project-WAF Name=Rule,Value=ALL \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
  --period 300 \
  --statistics Sum \
  --region us-east-1 \
  --profile evonne
```

### WAF 測試腳本 (一鍵測試)

```bash
#!/bin/bash
# waf-test.sh - WAF 安全測試腳本

DOMAIN="https://evoger.tw"
echo "🛡️ WAF Security Test for ${DOMAIN}"
echo "=========================================="

echo ""
echo "1️⃣ SQL Injection Test..."
SQLI=$(curl -s -o /dev/null -w "%{http_code}" "${DOMAIN}/?id=1' OR '1'='1")
if [ "$SQLI" == "403" ]; then
    echo "   ✅ BLOCKED (HTTP 403) - SQLi protection working"
else
    echo "   ❌ NOT BLOCKED (HTTP $SQLI) - Check WAF rules"
fi

echo ""
echo "2️⃣ XSS Test..."
XSS=$(curl -s -o /dev/null -w "%{http_code}" "${DOMAIN}/?q=<script>alert(1)</script>")
if [ "$XSS" == "403" ]; then
    echo "   ✅ BLOCKED (HTTP 403) - XSS protection working"
else
    echo "   ❌ NOT BLOCKED (HTTP $XSS) - Check WAF rules"
fi

echo ""
echo "3️⃣ Path Traversal Test..."
LFI=$(curl -s -o /dev/null -w "%{http_code}" "${DOMAIN}/?file=../../../etc/passwd")
if [ "$LFI" == "403" ]; then
    echo "   ✅ BLOCKED (HTTP 403) - LFI protection working"
else
    echo "   ❌ NOT BLOCKED (HTTP $LFI) - Check WAF rules"
fi

echo ""
echo "4️⃣ WordPress XML-RPC Test..."
XMLRPC=$(curl -s -o /dev/null -w "%{http_code}" -X POST "${DOMAIN}/xmlrpc.php" \
    -H "Content-Type: text/xml" \
    -d '<?xml version="1.0"?><methodCall><methodName>system.listMethods</methodName></methodCall>')
if [ "$XMLRPC" == "403" ]; then
    echo "   ✅ BLOCKED (HTTP 403) - WordPress protection working"
else
    echo "   ⚠️ ALLOWED (HTTP $XMLRPC) - XML-RPC may be enabled"
fi

echo ""
echo "5️⃣ Normal Request Test..."
NORMAL=$(curl -s -o /dev/null -w "%{http_code}" "${DOMAIN}/")
if [ "$NORMAL" == "200" ] || [ "$NORMAL" == "301" ] || [ "$NORMAL" == "302" ]; then
    echo "   ✅ ALLOWED (HTTP $NORMAL) - Normal traffic works"
else
    echo "   ❌ BLOCKED (HTTP $NORMAL) - Something wrong"
fi

echo ""
echo "=========================================="
echo "🎯 WAF Test Complete!"
echo ""
echo "View detailed logs:"
echo "  AWS Console → WAF & Shield → Web ACLs → project-WAF → Sampled requests"
```

### Demo 解說重點

1. **Defense in Depth** - WAF 是第一道防線，在 CloudFront 層就擋掉惡意請求
2. **Managed Rules** - 使用 AWS 維護的規則集，自動更新防護新型攻擊
3. **成本效益** - WAF 按請求計費，比自己維護 ModSecurity 便宜且省心
4. **零程式碼** - 不需要修改應用程式，純粹在基礎架構層防護
5. **可視化** - CloudWatch Dashboard 即時監控攻擊狀況

---

**情境**：Demo 結束，或測試環境使用完畢，清理資源以節省成本。

### ⚠️ 清理前必讀：備份策略

| 資料類型       | cleanup.sh 行為 | 還原方式           |
| -------------- | --------------- | ------------------ |
| **RDS 資料庫** | ✅ 保留         | 自動保留，無需處理 |
| **EFS 檔案**   | ✅ 保留         | 自動保留，無需處理 |
| **S3 媒體**    | ❌ 刪除         | 需先備份！         |
| **ECR Image**  | ❌ 刪除         | 需先備份或重新建置 |
| **Secrets**    | ⚠️ 詢問         | 建議保留           |

### 🔒 建議流程：先備份再清理

```bash
# 1. 先執行備份
./scripts/backup-before-cleanup.sh

# 2. 確認備份完成後，再清理
./scripts/cleanup.sh
```

### 備份內容

執行 `backup-before-cleanup.sh` 會備份：

- 📊 **RDS Snapshot** - 完整資料庫（文章、頁面、設定、版型配置、選單）
- 📁 **S3 媒體** - 所有上傳的圖片、影片
- 🔐 **Secrets** - RDS 密碼、WordPress Salts

### 選項 A: 保留資料的清理

```bash
./scripts/cleanup.sh
```

輸入 `DELETE` 確認。保留 RDS、EFS，刪除計費資源。

### 選項 B: 完全刪除 (Nuke)

```bash
./scripts/nuke-everything.sh
```

輸入 `NUKE` 確認，將**自動刪除所有資源**：

| 資源                 | 狀態    |
| -------------------- | ------- |
| RDS Database         | ❌ 刪除 |
| RDS Snapshots (所有) | ❌ 刪除 |
| S3 媒體 Bucket       | ❌ 刪除 |
| S3 備份 Bucket       | ❌ 刪除 |
| EFS                  | ❌ 刪除 |
| ECR Repository       | ❌ 刪除 |
| ECS, ALB, VPC        | ❌ 刪除 |
| CloudFront, WAF      | ❌ 刪除 |
| Secrets Manager      | ❌ 刪除 |
| CloudWatch Logs      | ❌ 刪除 |

> ⚠️ **注意：nuke-everything.sh 會刪除所有備份，執行後無法還原！**

---

## 🔄 Phase 4: 完整還原 (Restore)

**情境**：從備份還原完整的 WordPress 網站，包含版型、設定、圖片。

### 還原指令

```bash
# 查看可用的備份
./scripts/restore-from-backup.sh

# 從特定備份還原
./scripts/restore-from-backup.sh 20260115-143000
```

### 還原流程

```
restore-from-backup.sh
│
├── 1. 讀取備份資訊
│
├── 2. Terraform 建立基礎設施
│      └── 使用 RDS Snapshot 還原資料庫
│
├── 3. 還原 S3 媒體檔案
│
├── 4. 部署 Docker Image
│
├── 5. 等待 ECS 服務穩定
│
└── 6. 清除 CloudFront 快取
```

### 還原後的內容

| 項目      | 還原狀態    | 說明               |
| --------- | ----------- | ------------------ |
| 文章/頁面 | ✅ 完整還原 | 從 RDS Snapshot    |
| 版型配置  | ✅ 完整還原 | 存在 wp_options 表 |
| 選單設定  | ✅ 完整還原 | 存在 wp_terms 表   |
| 外掛設定  | ✅ 完整還原 | 存在 wp_options 表 |
| 媒體檔案  | ✅ 完整還原 | 從 S3 備份         |
| 圖片位置  | ✅ 完整還原 | URL 存在資料庫     |
| 佈景主題  | ✅ 完整還原 | Docker Image       |

### 還原時間估算

| 步驟                   | 時間              |
| ---------------------- | ----------------- |
| Terraform 建立基礎設施 | 15-20 分鐘        |
| RDS 從 Snapshot 還原   | 5-10 分鐘         |
| S3 媒體還原            | 依檔案大小        |
| ECS 部署               | 3-5 分鐘          |
| **總計**               | **約 25-40 分鐘** |

---

## 📊 CloudWatch Dashboard Demo

### 展示監控面板

1. 登入 AWS Console
2. 前往 CloudWatch → Dashboards → `project-WordPress-development`

### Dashboard 功能說明

| 區塊                   | 內容                                                | 預警線                       |
| :--------------------- | :-------------------------------------------------- | :--------------------------- |
| **關鍵指標**           | CPU、Memory、Tasks、Response Time、Requests、Errors | -                            |
| **SRE Golden Signals** | Latency P50/P90/P99、Traffic、HTTP Status Codes     | 1s/3s SLA                    |
| **ECS 運算**           | CPU 使用率、Memory 使用率、Auto Scaling 狀態        | Scale Target、Min/Max        |
| **RDS 資料庫**         | CPU、連線數、IOPS、剩餘空間                         | 80% Warning、Max Connections |
| **EFS 儲存**           | IO Limit %、Throughput                              | 80%/95% Warning              |
| **CloudFront**         | Traffic、Cache Hit Rate、Error Rate                 | 50%/80% Cache Hit            |
| **WAF 安全**           | Allowed/Blocked Requests、Blocks by Rule            | -                            |

### Auto Scaling Demo (選用)

如果想展示 Auto Scaling：

1. 使用壓測工具產生負載：

   ```bash
   # 安裝 hey
   brew install hey

   # 發送 1000 個請求，50 並發
   hey -n 1000 -c 50 https://evoger.tw
   ```

2. 觀察 Dashboard：

   - CPU 使用率上升
   - Task 數量增加 (1 → 2 → 3)
   - Response Time 變化

3. 停止壓測後：
   - CPU 使用率下降
   - Task 數量縮減 (Cooldown 後)

---

## ❓ 常見問題 (Q&A)

### Q: 為什麼圖片沒有不見？

**A:** 因為我們使用 S3 + CloudFront 儲存媒體檔案，Docker Image 只包含程式碼與佈景主題，兩者分離。這也是為什麼部署速度快 — Image 很小。

### Q: 部署失敗怎麼辦？

**A:** ECS 具備 **Circuit Breaker** 機制，如果新版本健康檢查失敗，會自動 Rollback 到上一版，不需人工介入。

### Q: `deploy-everything.sh` 和 GitHub Actions 有什麼不同？

**A:**

- `deploy-everything.sh` — 用於**從無到有**建立整個環境 (Day 0)
- GitHub Actions — 用於**持續更新**既有環境 (Day 2+)

### Q: Development 和 Production 怎麼切換？

**A:** 只需修改 `terraform.tfvars` 中的 `environment` 變數，然後執行 `terraform apply`。所有資源規格會自動調整。

### Q: cleanup.sh 後如何還原網站（包含版型和圖片）？

**A:**

1. **如果有先執行 `backup-before-cleanup.sh`**：執行 `restore-from-backup.sh <備份日期>` 即可完整還原
2. **如果沒有備份**：
   - RDS 和 EFS 會保留，資料庫和上傳檔案不會丟失
   - 需要重新執行 `deploy-everything.sh`
   - S3 媒體檔案需要從 WordPress 後台重新上傳

### Q: 為什麼選擇 Fargate 而不是 EC2？

**A:**

- **免管理**：不需要管 OS Patch、Security Update
- **彈性計費**：秒級計費，沒有閒置浪費
- **快速擴展**：Auto Scaling 可在 60 秒內啟動新 Task
- **安全**：每個 Task 獨立運行，隔離性更好

### Q: 成本可以再降低嗎？

**A:** 可以考慮：

- 使用 **Fargate Spot** (最多省 70%，但可能被中斷)
- 非上班時間用 **Scheduled Scaling** 縮減 Task
- 開發環境用完就 **Destroy**，需要再建立

### Q: 備份會佔用多少空間/成本？

**A:**

- RDS Snapshot：免費（與 RDS 備份配額共用）
- S3 備份：約 $0.023/GB/月（Standard 儲存）
- 建議定期清理舊備份，保留最近 3-5 個即可

---

## 📁 專案結構

```
project/
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD Pipeline
├── infrastructure/
│   └── terraform/
│       ├── main.tf                 # Provider 設定
│       ├── variables.tf            # 變數定義
│       ├── locals.tf               # 環境預設值
│       ├── terraform.tfvars        # 實際配置值
│       ├── network.tf              # VPC/Subnet/SG
│       ├── iam_acm.tf              # IAM + ACM
│       ├── database.tf             # RDS + Secrets
│       ├── storage.tf              # EFS + S3
│       ├── compute.tf              # ECS + ALB + ECR
│       ├── cdn_security.tf         # CloudFront + WAF
│       ├── dns.tf                  # Route 53
│       ├── monitoring.tf           # Auto Scaling + Alarms
│       ├── dashboard.tf            # CloudWatch Dashboard
│       ├── cicd.tf                 # GitHub OIDC
│       ├── outputs.tf              # Outputs
│       └── scripts/
│           ├── deploy-everything.sh      # 一鍵部署
│           ├── nuke-everything.sh        # 一鍵刪除 (含備份)
│           ├── cleanup.sh                # 清理 (保留資料)
│           ├── backup-before-cleanup.sh  # 備份腳本
│           ├── restore-from-backup.sh    # 還原腳本
│           ├── redeploy.sh               # 重新部署
│           └── manual-deploy-image.sh    # 手動建置
└── src/
    └── docker/
        └── Dockerfile              # WordPress Image
```

---

## 🔗 相關連結

| 資源                     | URL                                                     |
| :----------------------- | :------------------------------------------------------ |
| **網站**                 | https://evoger.tw                                       |
| **GitHub Repo**          | https://github.com/evonnepwu-web/.github                |
| **GitHub Actions**       | https://github.com/evonnepwu-web/.github/actions        |
| **AWS Console**          | https://ap-northeast-1.console.aws.amazon.com           |
| **CloudWatch Dashboard** | CloudWatch → Dashboards → project-WordPress-development |

---

_文件版本：v2.0_
_更新日期：2026-01-15_
_適用專案：ECS Fargate WordPress 高併發架構_
