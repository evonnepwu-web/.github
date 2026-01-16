# ===========================================
# Storage Layer (EFS + S3)
# Steps 05, 06
# ===========================================

# 1. EFS File System
resource "aws_efs_file_system" "main" {
  creation_token   = "${var.project_name}-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"  # 統一使用 bursting
  encrypted        = true

  tags = {
    Name        = "${var.project_name}-EFS"
    Environment = var.environment
  }
}

resource "aws_efs_mount_target" "main" {
  count           = length(var.data_subnet_cidrs)
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = aws_subnet.data[count.index].id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "main" {
  file_system_id = aws_efs_file_system.main.id

  posix_user {
    gid = 33
    uid = 33
  }

  root_directory {
    path = "/wordpress"
    creation_info {
      owner_gid   = 33
      owner_uid   = 33
      permissions = "0755"
    }
  }

  tags = {
    Name = "${var.project_name}-EFS-AP"
  }
}

resource "aws_ssm_parameter" "efs_ap_id" {
  name        = "/${var.project_tag}/efs-access-point-id"
  description = "EFS Access Point ID for WordPress"
  type        = "String"
  value       = aws_efs_access_point.main.id
}

# 2. S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket_prefix = "${var.project_name}-s3-"
  force_destroy = local.force_destroy  # 使用 locals

  tags = {
    Name        = "${var.project_name}-s3"
    Purpose     = "WordPress-Media"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name        = "/${var.project_tag}/s3-bucket-name"
  description = "S3 Bucket Name for WordPress Media"
  type        = "String"
  value       = aws_s3_bucket.main.id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Bucket Policy: Allow CloudFront OAC + ECS Task Role
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.main.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      },
      {
        Sid    = "AllowECSTaskRoleAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.task.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.main.arn,
          "${aws_s3_bucket.main.arn}/*"
        ]
      }
    ]
  })
}

# CORS
resource "aws_s3_bucket_cors_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  cors_rule {
    id              = "WordPressCORS"
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = [var.wp_site_url, "https://${var.acm_domain_name}"]
    expose_headers  = ["ETag", "Content-Length", "Content-Type"]
    max_age_seconds = 3600
  }
}

# Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "CleanupIncompleteUploads"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  rule {
    id     = "TransitionToInfrequentAccess"
    status = "Enabled"
    filter {
      prefix = "wp-content/uploads/"
    }
    transition {
      days          = local.is_production ? 90 : 180  # 生產環境更早轉移
      storage_class = "STANDARD_IA"
    }
  }

  # 生產環境額外規則：轉移到 Glacier
  dynamic "rule" {
    for_each = local.is_production ? [1] : []
    content {
      id     = "TransitionToGlacier"
      status = "Enabled"
      filter {
        prefix = "wp-content/uploads/"
      }
      transition {
        days          = 365
        storage_class = "GLACIER"
      }
    }
  }
}

# 生產環境：啟用版本控制
resource "aws_s3_bucket_versioning" "main" {
  count  = local.is_production ? 1 : 0
  bucket = aws_s3_bucket.main.id
  
  versioning_configuration {
    status = "Enabled"
  }
}
