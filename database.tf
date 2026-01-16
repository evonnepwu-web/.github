# ===========================================
# Database Layer (RDS + Secrets Manager)
# Steps 04, 04a
# ===========================================

# 1. Random Password Generation
resource "random_password" "db_password" {
  length           = 32
  special          = false
}

resource "random_password" "wp_salts" {
  count   = 8
  length  = 64
  special = true
}

resource "random_password" "cf_origin_verify" {
  length  = 32
  special = false
}

# 2. Secrets Manager

# RDS Credentials
resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = "${var.secrets_prefix}/rds/credentials"
  description = "RDS MySQL credentials for ${var.project_name}"
  
  recovery_window_in_days = local.is_production ? 7 : 0  # 生產環境保留恢復期
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    engine   = "mysql"
    host     = aws_db_instance.main.address
    port     = var.db_port
    dbname   = var.db_name
  })
}

# WordPress Salts
resource "aws_secretsmanager_secret" "wp_salts" {
  name        = "${var.secrets_prefix}/wordpress/salts"
  description = "WordPress authentication keys and salts"
  recovery_window_in_days = local.is_production ? 7 : 0
}

resource "aws_secretsmanager_secret_version" "wp_salts" {
  secret_id = aws_secretsmanager_secret.wp_salts.id
  secret_string = jsonencode({
    AUTH_KEY           = random_password.wp_salts[0].result
    SECURE_AUTH_KEY    = random_password.wp_salts[1].result
    LOGGED_IN_KEY      = random_password.wp_salts[2].result
    NONCE_KEY          = random_password.wp_salts[3].result
    AUTH_SALT          = random_password.wp_salts[4].result
    SECURE_AUTH_SALT   = random_password.wp_salts[5].result
    LOGGED_IN_SALT     = random_password.wp_salts[6].result
    NONCE_SALT         = random_password.wp_salts[7].result
  })
}

# CloudFront Origin Verify
resource "aws_secretsmanager_secret" "cf_origin_verify" {
  name        = "${var.secrets_prefix}/cloudfront/origin-verify"
  description = "CloudFront origin verification header"
  recovery_window_in_days = local.is_production ? 7 : 0
}

resource "aws_secretsmanager_secret_version" "cf_origin_verify" {
  secret_id = aws_secretsmanager_secret.cf_origin_verify.id
  secret_string = jsonencode({
    header_name  = "X-Origin-Verify"
    header_value = random_password.cf_origin_verify.result
  })
}

# API Keys (Placeholder)
resource "aws_secretsmanager_secret" "api_keys" {
  name        = "${var.secrets_prefix}/api/keys"
  description = "API keys for third-party integrations"
  recovery_window_in_days = local.is_production ? 7 : 0
}

resource "aws_secretsmanager_secret_version" "api_keys" {
  secret_id = aws_secretsmanager_secret.api_keys.id
  secret_string = jsonencode({
    woocommerce_api_key    = ""
    woocommerce_api_secret = ""
    stripe_public_key      = ""
    stripe_secret_key      = ""
    google_analytics_id    = ""
    smtp_username          = ""
    smtp_password          = ""
  })
}

# 3. RDS Instance
resource "aws_db_subnet_group" "main" {
  name        = "${var.project_name}-rds-subnet-group"
  description = "Subnet group for WordPress RDS in Data Layer"
  subnet_ids  = aws_subnet.data[*].id

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-db"

  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = local.rds_instance_class  # 使用 locals

  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result
  port     = var.db_port

  multi_az               = local.rds_multi_az  # 使用 locals
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = local.is_production ? 14 : 7  # 生產環境保留更久
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"
  
  deletion_protection     = false  # 統一關閉，方便管理
  skip_final_snapshot     = !local.is_production       # 生產環境不跳過
  final_snapshot_identifier = local.is_production ? "${var.project_name}-db-final-${formatdate("YYYY-MM-DD", timestamp())}" : null
  apply_immediately       = !local.is_production       # 生產環境不立即套用

  snapshot_identifier     = var.db_snapshot_identifier

  # Performance Insights - 只有 t3.small 以上才支援
  performance_insights_enabled          = local.rds_performance_insights_enabled
  performance_insights_retention_period = local.rds_performance_insights_enabled ? 7 : null

  # CloudWatch Logs Export
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]

  tags = {
    Name        = "${var.project_name}-db"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}
