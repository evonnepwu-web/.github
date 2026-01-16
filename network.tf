# ===========================================
# VPC & Networking (Steps 00, 01, 02, 03)
# ===========================================

# 1. VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-VPC"
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-IGW"
  }
}

# 3. Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.public_subnet_azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.project_name}-Public-${substr(var.public_subnet_azs[count.index], -2, 2)}"
    Layer = "Public"
  }
}

resource "aws_subnet" "app" {
  count             = length(var.app_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = var.app_subnet_azs[count.index]

  tags = {
    Name  = "${var.project_name}-App-${substr(var.app_subnet_azs[count.index], -2, 2)}"
    Layer = "Application"
  }
}

resource "aws_subnet" "data" {
  count             = length(var.data_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.data_subnet_cidrs[count.index]
  availability_zone = var.data_subnet_azs[count.index]

  tags = {
    Name  = "${var.project_name}-Data-${substr(var.data_subnet_azs[count.index], -2, 2)}"
    Layer = "Data"
  }
}

# 4. NAT Gateway
resource "aws_eip" "nat" {
  count = var.environment == "production" ? length(var.public_subnet_cidrs) : 1
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-NAT-EIP-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = var.environment == "production" ? length(var.public_subnet_cidrs) : 1
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id 

  tags = {
    Name = "${var.project_name}-NAT-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}

# 5. Route Tables
# Public RT
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-Public-RT"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# App RT (Private with NAT)
# Prod: Create 1 RT per AZ (to use local NAT)
# Dev: Still create 1 RT per AZ (but all point to NAT[0]) for consistency
resource "aws_route_table" "app" {
  count  = length(var.app_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    # If Prod: Use NAT[0] for Subnet[0], NAT[1] for Subnet[1]
    # If Dev : Use NAT[0] for both
    nat_gateway_id = var.environment == "production" ? aws_nat_gateway.main[count.index].id : aws_nat_gateway.main[0].id
  }

  tags = {
    Name = "${var.project_name}-App-RT-${count.index + 1}"
  }
}

resource "aws_route_table_association" "app" {
  count          = length(var.app_subnet_cidrs)
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app[count.index].id
}

# Data RT (Private no NAT)
resource "aws_route_table" "data" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-Data-RT"
  }
}

resource "aws_route_table_association" "data" {
  count          = length(var.data_subnet_cidrs)
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.data.id
}

# 6. Security Groups (Step 01)
# ALB SG
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-ALB-SG"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-ALB-SG" }
}

# ECS SG
resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-ECS-SG"
  description = "Security group for ECS Fargate tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.wp_port
    to_port         = var.wp_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-ECS-SG" }
}

# RDS SG
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-RDS-SG"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-RDS-SG" }
}

# EFS SG
resource "aws_security_group" "efs" {
  name        = "${var.project_name}-EFS-SG"
  description = "Security group for EFS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-EFS-SG" }
}

# 7. NACLs (Step 02)
# Public NACL
resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  # Inbound
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "-1"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Outbound
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "-1"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = { Name = "${var.project_name}-Public-NACL" }
}

# App NACL
resource "aws_network_acl" "app" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.app[*].id

  # Inbound
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = var.wp_port
    to_port    = var.wp_port
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = var.db_port
    to_port    = var.db_port
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 2049
    to_port    = 2049
  }
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = { Name = "${var.project_name}-App-NACL" }
}

# Data NACL
resource "aws_network_acl" "data" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.data[*].id

  # Inbound
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.app_subnet_cidrs[0]
    from_port  = var.db_port
    to_port    = var.db_port
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.app_subnet_cidrs[1]
    from_port  = var.db_port
    to_port    = var.db_port
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = var.app_subnet_cidrs[0]
    from_port  = 2049
    to_port    = 2049
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 111
    action     = "allow"
    cidr_block = var.app_subnet_cidrs[1]
    from_port  = 2049
    to_port    = 2049
  }

  # Outbound
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.app_subnet_cidrs[0]
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 201
    action     = "allow"
    cidr_block = var.app_subnet_cidrs[1]
    from_port  = 1024
    to_port    = 65535
  }

  tags = { Name = "${var.project_name}-Data-NACL" }
}

# 8. VPC Endpoints (Step 03)
# S3 Gateway (Free & adds performance)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  # Support multiple App Route Tables (Splatted List)
  route_table_ids   = concat(aws_route_table.app[*].id, [aws_route_table.data.id])

  tags = { Name = "${var.project_name}-S3-Endpoint" }
}
