# ===========================================
# CDN & Security Layer (CloudFront + WAF)
# Steps 15, 16, 17
# ===========================================

# 1. WAF (us-east-1)
resource "aws_wafv2_web_acl" "main" {
  provider    = aws.us_east_1
  name        = "${var.project_name}-WAF"
  scope       = "CLOUDFRONT"
  description = "WAF for CloudFront - ${var.environment}"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-WAF-Metrics"
    sampled_requests_enabled   = true
  }

  # 0. 允許 WordPress Admin 路徑 (優先級最高，避免被其他規則擋住)
  rule {
    name     = "AllowWordPressAdmin"
    priority = 0
    action {
      allow {}
    }
    statement {
      or_statement {
        statement {
          byte_match_statement {
            search_string         = "/wp-admin"
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
            positional_constraint = "STARTS_WITH"
          }
        }
        statement {
          byte_match_statement {
            search_string         = "/wp-json"
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
            positional_constraint = "STARTS_WITH"
          }
        }
        statement {
          byte_match_statement {
            search_string         = "/wp-login.php"
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 0
              type     = "LOWERCASE"
            }
            positional_constraint = "EXACTLY"
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowWordPressAdmin"
      sampled_requests_enabled   = true
    }
  }

  # 1. Common Rule Set
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        
        # 排除可能誤判 WordPress 的規則
        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericRFI_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "CrossSiteScripting_BODY"
          action_to_use {
            count {}
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # 2. Known Bad Inputs
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  # 3. SQLi
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 3
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # 4. WordPress - 使用 Count 模式避免誤擋
  rule {
    name     = "AWSManagedRulesWordPressRuleSet"
    priority = 4
    override_action {
      count {}  # 改為 Count 模式，避免誤擋正常操作
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesWordPressRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WordPressRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # 5. Rate Limit - 生產環境更嚴格
  rule {
    name     = "RateLimitRule"
    priority = 5
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit              = local.is_production ? 2000 : 5000  # 生產環境更嚴格
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  # 6. 生產環境額外規則：IP 信譽
  dynamic "rule" {
    for_each = local.is_production ? [1] : []
    content {
      name     = "AWSManagedRulesAmazonIpReputationList"
      priority = 6
      override_action {
        none {}
      }
      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesAmazonIpReputationList"
          vendor_name = "AWS"
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IpReputationList"
        sampled_requests_enabled   = true
      }
    }
  }

  tags = { 
    Name        = "${var.project_name}-WAF"
    Environment = var.environment
  }
}

# 2. Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "${var.project_name}-S3-OAC"
  description                       = "OAC for WordPress S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# 3. CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = aws_lb.main.dns_name
    origin_id   = "ALB-Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      origin_read_timeout    = local.is_production ? 30 : 60  # 生產環境更短超時
      origin_keepalive_timeout = 5
    }

    custom_header {
      name  = "X-Custom-Header"
      value = "${var.project_tag}-cloudfront-origin"
    }
  }

  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id   = "S3-Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "WordPress CDN - ${var.project_name} - ${var.environment}"
  price_class     = local.cloudfront_price_class  # 使用 locals

  aliases = [var.domain_name]

  # Default: ALB (Dynamic)
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-Origin"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # AllViewerExceptHostHeader
  }

  # /wp-content/uploads/*: S3 (Static)
  ordered_cache_behavior {
    path_pattern     = "wp-content/uploads/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Origin"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"  # CachingOptimized
  }

  # /wp-admin/*: ALB (No Cache)
  ordered_cache_behavior {
    path_pattern     = "wp-admin/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ALB-Origin"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # AllViewerExceptHostHeader
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cloudfront.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  web_acl_id = aws_wafv2_web_acl.main.arn

  tags = { 
    Name        = "${var.project_name}-CloudFront"
    Environment = var.environment
  }
}

# 4. Update ALB Security Group (to allow CloudFront Managed Prefix List)
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group_rule" "alb_ingress_cloudfront" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  security_group_id = aws_security_group.alb.id
  description       = "Allow CloudFront Traffic"
}
