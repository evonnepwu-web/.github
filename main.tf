terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Local backend by default.
  # 多人協作優點：狀態鎖定 (State Locking)、單一真實來源 (Single Source of Truth)
  # 若要啟用 Remote Backend (S3 + DynamoDB)，請取消註解以下區塊並填入數值：
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "wordpress-ecs/terraform.tfstate"
  #   region         = "ap-northeast-1"
  #   dynamodb_table = "your-terraform-lock-table"
  #   encrypt        = true
  # }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile # 本地開發使用，CI/CD 會使用環境變數或 IAM Role

  default_tags {
    tags = {
      Project     = var.project_tag
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = var.project_tag
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
