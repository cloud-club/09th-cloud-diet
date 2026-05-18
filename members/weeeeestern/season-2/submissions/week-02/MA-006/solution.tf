# MA-006 optimized Terraform proposal
#
# This file is a focused proposal for the MA-006 scenario. It keeps the original
# resource labels where possible and avoids inventing missing IAM roles, security
# groups, secrets, variables, or Lambda application code.
#
# Conceptual changes:
# - Disable Multi-AZ for dev RDS instances.
# - Reduce excessive backup retention from 35 to 7 days.
# - Remove or disable unused read replicas.
# - Add production RDS Proxy for app-db-prod.
# - Route production Lambda DB endpoint through the production RDS Proxy.
# - Conservatively downsize app-db-prod after production proxy introduction.
# - Fix obvious invalid Terraform references.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# L1-004: dev RDS Multi-AZ disabled.
resource "aws_db_instance" "comp1_db-instance-sw1sg4" {
  identifier     = "db-instance-sw1sg4"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name        = "db-instance-sw1sg4"
    Environment = "dev"
  }
}

resource "aws_db_instance" "comp1_db-instance-4zhufn" {
  identifier     = "db-instance-4zhufn"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name        = "db-instance-4zhufn"
    Environment = "dev"
  }
}

resource "aws_db_instance" "comp1_db-instance-0zeive" {
  identifier     = "db-instance-0zeive"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = true

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name        = "db-instance-0zeive"
    Environment = "production"
  }
}

# L1-013: excessive backup retention reduced from 35 to 7.
resource "aws_db_instance" "comp2_db-instance-octwi4" {
  identifier     = "db-instance-octwi4"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name         = "db-instance-octwi4"
    BackupPolicy = "standard-7-day"
  }
}

resource "aws_db_instance" "comp2_db-instance-epinll" {
  identifier     = "db-instance-epinll"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name         = "db-instance-epinll"
    BackupPolicy = "standard-7-day"
  }
}

resource "aws_db_instance" "comp2_db-instance-knak74" {
  identifier     = "db-instance-knak74"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 200
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name = "db-instance-knak74"
  }
}

# L2-020: keep the primary; remove unused read replicas from active config.
resource "aws_db_instance" "comp3_db-instance-dk1bl1" {
  identifier     = "db-instance-dk1bl1"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = true

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name = "db-instance-dk1bl1"
    Role = "primary"
  }
}

# Removed from active proposal unless read IOPS, CPU, replica lag, and
# application read routing justify keeping them:
# - aws_db_instance.comp3_db-instance-ly8nh7
# - aws_db_instance.comp3_db-instance-j8jybk
# - aws_db_instance.comp3_db-instance-w3anjt
#
# If a replica must be restored, use the actual primary reference:
# replicate_source_db = aws_db_instance.comp3_db-instance-dk1bl1.identifier

# L3-040: production app DB downsize after proxy introduction.
resource "aws_db_instance" "comp4_db-instance-1wqhi1" {
  identifier     = "app-db-prod"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r6g.2xlarge"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = true

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name        = "db-instance-1wqhi1"
    Environment = "production"
  }
}

resource "aws_db_instance" "comp4_db-instance-tm5iur" {
  identifier     = "app-db-staging"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r6g.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7
  skip_final_snapshot     = false

  tags = {
    Name        = "db-instance-tm5iur"
    Environment = "staging"
  }
}

# Existing staging proxy retained, with invalid target reference corrected.
resource "aws_db_proxy" "comp4_db-proxy-41yxru" {
  name                   = "app-db-staging-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = aws_iam_role.db-proxy-41yxru_role.arn
  vpc_security_group_ids = [aws_security_group.db-proxy-41yxru_sg.id]
  vpc_subnet_ids         = var.private_subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.db-proxy-41yxru_secret.arn
  }

  tags = {
    Name        = "db-proxy-41yxru"
    Environment = "staging"
  }
}

resource "aws_db_proxy_default_target_group" "comp4_db-proxy-41yxru" {
  db_proxy_name = aws_db_proxy.comp4_db-proxy-41yxru.name

  connection_pool_config {
    max_connections_percent      = 80
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "comp4_db-proxy-41yxru" {
  db_proxy_name          = aws_db_proxy.comp4_db-proxy-41yxru.name
  target_group_name      = aws_db_proxy_default_target_group.comp4_db-proxy-41yxru.name
  db_instance_identifier = aws_db_instance.comp4_db-instance-tm5iur.identifier
}

# New production proxy. Reuse the same missing IAM/security group/secret pattern
# as the scenario extract; replace these references with real production
# resources in a complete module.
resource "aws_db_proxy" "comp4_db-proxy-prod" {
  name                   = "app-db-prod-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = aws_iam_role.db-proxy-prod_role.arn
  vpc_security_group_ids = [aws_security_group.db-proxy-prod_sg.id]
  vpc_subnet_ids         = var.private_subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.db-proxy-prod_secret.arn
  }

  tags = {
    Name        = "app-db-prod-proxy"
    Environment = "production"
  }
}

resource "aws_db_proxy_default_target_group" "comp4_db-proxy-prod" {
  db_proxy_name = aws_db_proxy.comp4_db-proxy-prod.name

  connection_pool_config {
    max_connections_percent      = 80
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "comp4_db-proxy-prod" {
  db_proxy_name          = aws_db_proxy.comp4_db-proxy-prod.name
  target_group_name      = aws_db_proxy_default_target_group.comp4_db-proxy-prod.name
  db_instance_identifier = aws_db_instance.comp4_db-instance-1wqhi1.identifier
}

# Production Lambdas should route DB traffic through app-db-prod-proxy.
# The scenario extract does not include DB endpoint variables, so this proposal
# shows the intended endpoint variable without inventing application code.
locals {
  app_db_prod_proxy_endpoint = aws_db_proxy.comp4_db-proxy-prod.endpoint
}

# Production Lambda routing through the production proxy. If the application
# expects a different DB endpoint variable name, replace DB_ENDPOINT with the
# actual key used by the function code.
resource "aws_lambda_function" "comp4_lambda-function-1ms0ht" {
  function_name = "lambda-function-1ms0ht"
  role          = aws_iam_role.lambda-function-1ms0ht_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 128
  timeout     = 30

  reserved_concurrent_executions = 200

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda-function-1ms0ht_sg.id]
  }

  environment {
    variables = {
      ENVIRONMENT = "production"
      DB_ENDPOINT = local.app_db_prod_proxy_endpoint
    }
  }

  tags = {
    Name = "lambda-function-1ms0ht"
  }
}

resource "aws_lambda_function" "comp4_lambda-function-tp451f" {
  function_name = "lambda-function-tp451f"
  role          = aws_iam_role.lambda-function-tp451f_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 128
  timeout     = 30

  reserved_concurrent_executions = 200

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda-function-tp451f_sg.id]
  }

  environment {
    variables = {
      ENVIRONMENT = "production"
      DB_ENDPOINT = local.app_db_prod_proxy_endpoint
    }
  }

  tags = {
    Name = "lambda-function-tp451f"
  }
}

resource "aws_lambda_function" "comp4_lambda-function-y39zua" {
  function_name = "lambda-function-y39zua"
  role          = aws_iam_role.lambda-function-y39zua_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 128
  timeout     = 30

  reserved_concurrent_executions = 200

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda-function-y39zua_sg.id]
  }

  environment {
    variables = {
      ENVIRONMENT = "production"
      DB_ENDPOINT = local.app_db_prod_proxy_endpoint
    }
  }

  tags = {
    Name = "lambda-function-y39zua"
  }
}

resource "aws_lambda_function" "comp4_lambda-function-s8kfw8" {
  function_name = "lambda-function-s8kfw8"
  role          = aws_iam_role.lambda-function-s8kfw8_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 128
  timeout     = 30

  reserved_concurrent_executions = 200

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda-function-s8kfw8_sg.id]
  }

  environment {
    variables = {
      ENVIRONMENT = "production"
      DB_ENDPOINT = local.app_db_prod_proxy_endpoint
    }
  }

  tags = {
    Name = "lambda-function-s8kfw8"
  }
}

resource "aws_lambda_function" "comp4_lambda-function-hu7kie" {
  function_name = "lambda-function-hu7kie"
  role          = aws_iam_role.lambda-function-hu7kie_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 128
  timeout     = 30

  reserved_concurrent_executions = 200

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda-function-hu7kie_sg.id]
  }

  environment {
    variables = {
      ENVIRONMENT = "production"
      DB_ENDPOINT = local.app_db_prod_proxy_endpoint
    }
  }

  tags = {
    Name = "lambda-function-hu7kie"
  }
}

# Keep or tune reserved_concurrent_executions only after measuring throughput,
# database connections, latency, and throttling behavior.