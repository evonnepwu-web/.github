# ===========================================
# CloudWatch Dashboard - 優化版本
# 專為 ECS Fargate 高併發監控設計
# ===========================================

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-WordPress-${var.environment}"
  
  dashboard_body = jsonencode({
    widgets = concat(
      # ===========================================
      # Row 0: 環境資訊標題
      # ===========================================
      [
        {
          type   = "text"
          x      = 0
          y      = 0
          width  = 24
          height = 1
          properties = {
            markdown = "# 📊 ${var.project_name} WordPress Monitor | Environment: **${upper(var.environment)}** | Region: ${var.aws_region}"
            background = "transparent"
          }
        }
      ],

      # ===========================================
      # Row 1: 關鍵指標概覽 (Single Value Widgets)
      # ===========================================
      [
        {
          type   = "metric"
          x      = 0
          y      = 1
          width  = 4
          height = 4
          properties = {
            metrics = [
              ["AWS/ECS", "CPUUtilization", "ServiceName", aws_ecs_service.main.name, "ClusterName", aws_ecs_cluster.main.name]
            ]
            view    = "singleValue"
            region  = var.aws_region
            title   = "🔥 ECS CPU"
            stat    = "Average"
            period  = 60
          }
        },
        {
          type   = "metric"
          x      = 4
          y      = 1
          width  = 4
          height = 4
          properties = {
            metrics = [
              ["AWS/ECS", "MemoryUtilization", "ServiceName", aws_ecs_service.main.name, "ClusterName", aws_ecs_cluster.main.name]
            ]
            view    = "singleValue"
            region  = var.aws_region
            title   = "💾 ECS Memory"
            stat    = "Average"
            period  = 60
          }
        },
        {
          type   = "metric"
          x      = 8
          y      = 1
          width  = 4
          height = 4
          properties = {
            metrics = [
              ["AWS/ECS", "RunningTaskCount", "ServiceName", aws_ecs_service.main.name, "ClusterName", aws_ecs_cluster.main.name]
            ]
            view    = "singleValue"
            region  = var.aws_region
            title   = "📦 Running Tasks"
            stat    = "Average"
            period  = 60
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 1
          width  = 4
          height = 4
          properties = {
            metrics = [
              ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.main.arn_suffix]
            ]
            view    = "singleValue"
            region  = var.aws_region
            title   = "⏱️ Response Time"
            stat    = "Average"
            period  = 60
          }
        },
        {
          type   = "metric"
          x      = 16
          y      = 1
          width  = 4
          height = 4
          properties = {
            metrics = [
              ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.main.arn_suffix]
            ]
            view    = "singleValue"
            region  = var.aws_region
            title   = "📈 Requests/min"
            stat    = "Sum"
            period  = 60
          }
        },
        {
          type   = "metric"
          x      = 20
          y      = 1
          width  = 4
          height = 4
          properties = {
            metrics = [
              ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", aws_lb.main.arn_suffix]
            ]
            view    = "singleValue"
            region  = var.aws_region
            title   = "❌ 5XX Errors"
            stat    = "Sum"
            period  = 300
          }
        }
      ],

      # ===========================================
      # Row 2: SRE Golden Signals 標題
      # ===========================================
      [
        {
          type   = "text"
          x      = 0
          y      = 5
          width  = 24
          height = 1
          properties = {
            markdown = "## 🚦 SRE Golden Signals: Latency | Traffic | Errors | Saturation"
            background = "transparent"
          }
        }
      ],

      # ===========================================
      # Row 3: Latency (延遲分析)
      # ===========================================
      [
        {
          type   = "metric"
          x      = 0
          y      = 6
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.main.arn_suffix, { stat = "Average", label = "Average" }],
              ["...", { stat = "p50", label = "P50" }],
              ["...", { stat = "p90", label = "P90" }],
              ["...", { stat = "p99", label = "P99" }]
            ]
            view    = "timeSeries"
            stacked = false
            region  = var.aws_region
            title   = "⏱️ Response Time Distribution"
            period  = 60
            yAxis = {
              left = {
                min   = 0
                label = "Seconds"
              }
            }
            annotations = {
              horizontal = [
                { value = 1, label = "1s SLA", color = "#ff7f0e" },
                { value = 3, label = "3s Critical", color = "#d62728" }
              ]
            }
          }
        },
        {
          type   = "metric"
          x      = 8
          y      = 6
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.main.arn_suffix, { label = "Total Requests" }],
              ["AWS/WAFV2", "BlockedRequests", "WebACL", "${var.project_name}-WAF-Metrics", "Region", "us-east-1", "Rule", "ALL", { label = "WAF Blocked" }]
            ]
            view    = "timeSeries"
            stacked = false
            region  = var.aws_region
            title   = "📊 Traffic & WAF"
            period  = 60
            stat    = "Sum"
          }
        },
        {
          type   = "metric"
          x      = 16
          y      = 6
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", aws_lb.main.arn_suffix, { label = "2XX ✓", color = "#2ca02c" }],
              [".", "HTTPCode_Target_3XX_Count", ".", ".", { label = "3XX →", color = "#1f77b4" }],
              [".", "HTTPCode_Target_4XX_Count", ".", ".", { label = "4XX ⚠", color = "#ff7f0e" }],
              [".", "HTTPCode_Target_5XX_Count", ".", ".", { label = "5XX ✗", color = "#d62728" }]
            ]
            view    = "timeSeries"
            stacked = true
            region  = var.aws_region
            title   = "📉 HTTP Status Codes"
            period  = 60
            stat    = "Sum"
          }
        }
      ],

      # ===========================================
      # Row 4: ECS 運算資源標題
      # ===========================================
      [
        {
          type   = "text"
          x      = 0
          y      = 12
          width  = 24
          height = 1
          properties = {
            markdown = "## ⚙️ ECS Compute Resources | CPU: ${local.task_cpu} | Memory: ${local.task_memory}MB | Min: ${local.task_min_count} | Max: ${local.task_max_count}"
            background = "transparent"
          }
        }
      ],

      # ===========================================
      # Row 5: ECS CPU & Memory
      # ===========================================
      [
        {
          type   = "metric"
          x      = 0
          y      = 13
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/ECS", "CPUUtilization", "ServiceName", aws_ecs_service.main.name, "ClusterName", aws_ecs_cluster.main.name]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "🔥 ECS CPU Utilization"
            period  = 60
            stat    = "Average"
            yAxis = {
              left = { min = 0, max = 100 }
            }
            annotations = {
              horizontal = [
                { value = local.scaling_cpu_target, label = "Scale Target ${local.scaling_cpu_target}%", color = "#ff7f0e" },
                { value = 80, label = "Warning 80%", color = "#d62728" }
              ]
            }
          }
        },
        {
          type   = "metric"
          x      = 8
          y      = 13
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/ECS", "MemoryUtilization", "ServiceName", aws_ecs_service.main.name, "ClusterName", aws_ecs_cluster.main.name]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "💾 ECS Memory Utilization"
            period  = 60
            stat    = "Average"
            yAxis = {
              left = { min = 0, max = 100 }
            }
            annotations = {
              horizontal = [
                { value = 70, label = "Scale Target 70%", color = "#ff7f0e" },
                { value = 85, label = "Warning 85%", color = "#d62728" }
              ]
            }
          }
        },
        {
          type   = "metric"
          x      = 16
          y      = 13
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/ECS", "RunningTaskCount", "ServiceName", aws_ecs_service.main.name, "ClusterName", aws_ecs_cluster.main.name, { label = "Running", color = "#2ca02c" }],
              [".", "DesiredTaskCount", ".", ".", ".", ".", { label = "Desired", color = "#1f77b4" }],
              [".", "PendingTaskCount", ".", ".", ".", ".", { label = "Pending", color = "#ff7f0e" }]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "📦 Auto Scaling Status"
            period  = 60
            stat    = "Average"
            yAxis = {
              left = { min = 0 }
            }
            annotations = {
              horizontal = [
                { value = local.task_min_count, label = "Min ${local.task_min_count}", color = "#1f77b4" },
                { value = local.task_max_count, label = "Max ${local.task_max_count}", color = "#d62728" }
              ]
            }
          }
        }
      ],

      # ===========================================
      # Row 6: 資料庫與儲存標題
      # ===========================================
      [
        {
          type   = "text"
          x      = 0
          y      = 19
          width  = 24
          height = 1
          properties = {
            markdown = "## 🗄️ Database & Storage | RDS: ${local.rds_instance_class} | Multi-AZ: ${local.rds_multi_az} | EFS: bursting"
            background = "transparent"
          }
        }
      ],

      # ===========================================
      # Row 7: RDS Metrics
      # ===========================================
      [
        {
          type   = "metric"
          x      = 0
          y      = 20
          width  = 6
          height = 6
          properties = {
            metrics = [
              ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.main.identifier]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "🔥 RDS CPU"
            period  = 60
            stat    = "Average"
            yAxis = {
              left = { min = 0, max = 100 }
            }
            annotations = {
              horizontal = [
                { value = 80, label = "Warning", color = "#d62728" }
              ]
            }
          }
        },
        {
          type   = "metric"
          x      = 6
          y      = 20
          width  = 6
          height = 6
          properties = {
            metrics = [
              ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", aws_db_instance.main.identifier]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "🔗 RDS Connections"
            period  = 60
            stat    = "Average"
            annotations = {
              horizontal = local.rds_instance_class == "db.t3.micro" ? [
                { value = 50, label = "Warning (66 max)", color = "#ff7f0e" },
                { value = 66, label = "Max Connections", color = "#d62728" }
              ] : [
                { value = 120, label = "Warning (150 max)", color = "#ff7f0e" },
                { value = 150, label = "Max Connections", color = "#d62728" }
              ]
            }
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 20
          width  = 6
          height = 6
          properties = {
            metrics = [
              ["AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", aws_db_instance.main.identifier, { label = "Read", color = "#2ca02c" }],
              [".", "WriteIOPS", ".", ".", { label = "Write", color = "#d62728" }]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "💿 RDS IOPS"
            period  = 60
            stat    = "Average"
          }
        },
        {
          type   = "metric"
          x      = 18
          y      = 20
          width  = 6
          height = 6
          properties = {
            metrics = [
              ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", aws_db_instance.main.identifier]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "💾 RDS Free Storage"
            period  = 300
            stat    = "Average"
            yAxis = {
              left = {
                label = "Bytes"
              }
            }
          }
        }
      ],

      # ===========================================
      # Row 8: EFS & CloudFront
      # ===========================================
      [
        {
          type   = "metric"
          x      = 0
          y      = 26
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/EFS", "PercentIOLimit", "FileSystemId", aws_efs_file_system.main.id]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "📁 EFS IO Limit %"
            period  = 60
            stat    = "Average"
            yAxis = {
              left = { min = 0, max = 100 }
            }
            annotations = {
              horizontal = [
                { value = 80, label = "Warning", color = "#ff7f0e" },
                { value = 95, label = "Critical", color = "#d62728" }
              ]
            }
          }
        },
        {
          type   = "metric"
          x      = 8
          y      = 26
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/EFS", "TotalIOBytes", "FileSystemId", aws_efs_file_system.main.id, { stat = "Sum", label = "Total IO" }],
              [".", "DataReadIOBytes", ".", ".", { stat = "Sum", label = "Read" }],
              [".", "DataWriteIOBytes", ".", ".", { stat = "Sum", label = "Write" }]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "📁 EFS Throughput"
            period  = 60
          }
        },
        {
          type   = "metric"
          x      = 16
          y      = 26
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/CloudFront", "Requests", "DistributionId", aws_cloudfront_distribution.main.id, "Region", "Global", { label = "Requests" }],
              [".", "BytesDownloaded", ".", ".", ".", ".", { label = "Downloaded", yAxis = "right" }]
            ]
            view    = "timeSeries"
            region  = "us-east-1"
            title   = "🌐 CloudFront Traffic"
            period  = 60
            stat    = "Sum"
          }
        }
      ],

      # ===========================================
      # Row 9: CloudFront Cache & Errors
      # ===========================================
      [
        {
          type   = "metric"
          x      = 0
          y      = 32
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/CloudFront", "CacheHitRate", "DistributionId", aws_cloudfront_distribution.main.id, "Region", "Global"]
            ]
            view    = "timeSeries"
            region  = "us-east-1"
            title   = "🎯 CloudFront Cache Hit Rate"
            period  = 300
            stat    = "Average"
            yAxis = {
              left = { min = 0, max = 100 }
            }
            annotations = {
              horizontal = [
                { value = 80, label = "Good", color = "#2ca02c" },
                { value = 50, label = "Low", color = "#ff7f0e" }
              ]
            }
          }
        },
        {
          type   = "metric"
          x      = 8
          y      = 32
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/CloudFront", "4xxErrorRate", "DistributionId", aws_cloudfront_distribution.main.id, "Region", "Global", { label = "4XX Rate", color = "#ff7f0e" }],
              [".", "5xxErrorRate", ".", ".", ".", ".", { label = "5XX Rate", color = "#d62728" }],
              [".", "TotalErrorRate", ".", ".", ".", ".", { label = "Total Error", color = "#9467bd" }]
            ]
            view    = "timeSeries"
            region  = "us-east-1"
            title   = "❌ CloudFront Error Rates"
            period  = 300
            stat    = "Average"
            yAxis = {
              left = { min = 0 }
            }
          }
        },
        {
          type   = "metric"
          x      = 16
          y      = 32
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/CloudFront", "OriginLatency", "DistributionId", aws_cloudfront_distribution.main.id, "Region", "Global"]
            ]
            view    = "timeSeries"
            region  = "us-east-1"
            title   = "⏱️ CloudFront Origin Latency"
            period  = 60
            stat    = "Average"
            yAxis = {
              left = {
                label = "Milliseconds"
                min   = 0
              }
            }
          }
        }
      ],

      # ===========================================
      # Row 10: WAF Security Metrics
      # ===========================================
      [
        {
          type   = "text"
          x      = 0
          y      = 38
          width  = 24
          height = 1
          properties = {
            markdown = "## 🛡️ Security & WAF Metrics"
            background = "transparent"
          }
        }
      ],
      [
        {
          type   = "metric"
          x      = 0
          y      = 39
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/WAFV2", "AllowedRequests", "WebACL", "${var.project_name}-WAF-Metrics", "Region", "us-east-1", "Rule", "ALL", { label = "Allowed", color = "#2ca02c" }],
              [".", "BlockedRequests", ".", ".", ".", ".", ".", ".", { label = "Blocked", color = "#d62728" }]
            ]
            view    = "timeSeries"
            region  = "us-east-1"
            title   = "🛡️ WAF Requests"
            period  = 60
            stat    = "Sum"
          }
        },
        {
          type   = "metric"
          x      = 8
          y      = 39
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/WAFV2", "BlockedRequests", "WebACL", "${var.project_name}-WAF-Metrics", "Region", "us-east-1", "Rule", "RateLimitRule", { label = "Rate Limit" }],
              ["...", "Rule", "AWSManagedRulesCommonRuleSet", { label = "Common Rules" }],
              ["...", "Rule", "AWSManagedRulesSQLiRuleSet", { label = "SQLi" }],
              ["...", "Rule", "AWSManagedRulesWordPressRuleSet", { label = "WordPress" }]
            ]
            view    = "timeSeries"
            region  = "us-east-1"
            title   = "🚫 WAF Blocks by Rule"
            period  = 300
            stat    = "Sum"
          }
        },
        {
          type   = "metric"
          x      = 16
          y      = 39
          width  = 8
          height = 6
          properties = {
            metrics = [
              ["AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", aws_lb.main.arn_suffix, { label = "Active" }],
              [".", "NewConnectionCount", ".", ".", { label = "New" }]
            ]
            view    = "timeSeries"
            region  = var.aws_region
            title   = "🔗 ALB Connections"
            period  = 60
            stat    = "Sum"
          }
        }
      ],

      # ===========================================
      # Row 11: Logs Insights (Optional)
      # ===========================================
      [
        {
          type   = "log"
          x      = 0
          y      = 45
          width  = 24
          height = 6
          properties = {
            query   = "SOURCE '/ecs/${var.project_name}-wordpress' | fields @timestamp, @message | filter @message like /error|Error|ERROR|exception|Exception/ | sort @timestamp desc | limit 50"
            region  = var.aws_region
            title   = "📋 Recent Errors (Last 50)"
            view    = "table"
          }
        }
      ]
    )
  })
}

# ===========================================
# 額外的 Alarms (補充 monitoring.tf)
# ===========================================

# RDS 連線數警報
resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "${var.project_name}-RDS-Connections-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  # t3.micro max = 66, t3.small max = 150
  threshold           = local.rds_instance_class == "db.t3.micro" ? 50 : 120
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.identifier
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  
  tags = {
    Environment = var.environment
  }
}

# EFS IO 限制警報
resource "aws_cloudwatch_metric_alarm" "efs_io_limit" {
  alarm_name          = "${var.project_name}-EFS-IO-Limit-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "PercentIOLimit"
  namespace           = "AWS/EFS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    FileSystemId = aws_efs_file_system.main.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  
  tags = {
    Environment = var.environment
  }
}

# CloudFront 錯誤率警報 (生產環境)
resource "aws_cloudwatch_metric_alarm" "cloudfront_error_rate" {
  count = local.is_production ? 1 : 0

  alarm_name          = "${var.project_name}-CloudFront-Error-Rate-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TotalErrorRate"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "Average"
  threshold           = 5  # 5% error rate
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    DistributionId = aws_cloudfront_distribution.main.id
    Region         = "Global"
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  
  tags = {
    Environment = var.environment
  }

  provider = aws.us_east_1
}

# ALB Target Response Time 警報 (生產環境)
resource "aws_cloudwatch_metric_alarm" "alb_response_time_p99" {
  count = local.is_production ? 1 : 0

  alarm_name          = "${var.project_name}-ALB-ResponseTime-P99-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  extended_statistic  = "p99"
  threshold           = 3  # 3 seconds
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  
  tags = {
    Environment = var.environment
  }
}

# Healthy Host Count 警報
resource "aws_cloudwatch_metric_alarm" "healthy_host_count" {
  alarm_name          = "${var.project_name}-ALB-Unhealthy-Hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Minimum"
  threshold           = local.task_min_count
  treat_missing_data  = "breaching"
  
  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
    TargetGroup  = aws_lb_target_group.main.arn_suffix
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  
  tags = {
    Environment = var.environment
  }
}
