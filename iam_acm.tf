# ===========================================
# Authentication, Authorization, Accounting
# Steps 07, 08
# ===========================================

# 1. IAM Roles
# Task Execution Role
resource "aws_iam_role" "execution" {
  name = "${var.project_name}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = { Name = "${var.project_name}-ecsTaskExecutionRole" }
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "execution_custom" {
  name = "${var.project_name}-ecsTaskExecutionRole-policy"
  role = aws_iam_role.execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SecretsManagerAccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.secrets_prefix}/*"
        ]
      },
      {
        Sid    = "KMSDecrypt"
        Effect = "Allow"
        Action = ["kms:Decrypt"]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "secretsmanager.${var.aws_region}.amazonaws.com"
          }
        }
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      },
      {
          Sid = "ECRAccess"
          Effect = "Allow"
          Action = [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage"
          ]
          Resource = "*"
      }
    ]
  })
}

# Task Role
resource "aws_iam_role" "task" {
  name = "${var.project_name}-ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = { Name = "${var.project_name}-ecsTaskRole" }
}

resource "aws_iam_role_policy" "task_s3" {
  name = "${var.project_name}-ecsTaskRole-s3-policy"
  role = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
            "s3:GetObject","s3:PutObject","s3:DeleteObject",
            "s3:PutObjectAcl","s3:GetObjectAcl","s3:ListBucket",
            "s3:GetBucketLocation","s3:GetBucketAcl","s3:GetBucketPolicy",
            "s3:GetBucketPublicAccessBlock","s3:GetBucketOwnershipControls",
            "s3:PutBucketOwnershipControls"
        ]
        Resource = [
            aws_s3_bucket.main.arn,
            "${aws_s3_bucket.main.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = ["s3:ListAllMyBuckets","s3:GetBucketLocation"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "task_efs" {
  name = "${var.project_name}-ecsTaskRole-efs-policy"
  role = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Action = [
            "elasticfilesystem:ClientMount",
            "elasticfilesystem:ClientWrite",
            "elasticfilesystem:ClientRootAccess"
        ]
        Resource = "arn:aws:elasticfilesystem:${var.aws_region}:${data.aws_caller_identity.current.account_id}:file-system/${aws_efs_file_system.main.id}"
    }]
  })
}

resource "aws_iam_role_policy" "task_ssm" {
  name = "${var.project_name}-ecsTaskRole-ssm-policy"
  role = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Action = ["ssmmessages:CreateControlChannel","ssmmessages:CreateDataChannel","ssmmessages:OpenControlChannel","ssmmessages:OpenDataChannel"]
        Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "task_secrets" {
  name = "${var.project_name}-ecsTaskRole-secrets-policy"
  role = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Action = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
        ]
        Resource = [
            "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.secrets_prefix}/*"
        ]
    }]
  })
}

# 2. ACM Certificates
# ALB Certificate
resource "aws_acm_certificate" "alb" {
  domain_name       = var.domain_name
  subject_alternative_names = [var.acm_domain_name]
  validation_method = "DNS"

  tags = {
    Name = "${var.project_name}-SSL"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# CloudFront Certificate (us-east-1)
resource "aws_acm_certificate" "cloudfront" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  subject_alternative_names = [var.acm_domain_name]
  validation_method = "DNS"

  tags = {
    Name = "${var.project_name}-CloudFront-SSL"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Data source for account ID
data "aws_caller_identity" "current" {}
