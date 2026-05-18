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


# ═══════════════════════════════════════════════════════════════
# Component 1/2 · seeded from L2-020
# ═══════════════════════════════════════════════════════════════

resource "aws_db_instance" "comp1_db-instance-ebfxrm" {
  identifier     = "db-instance-ebfxrm"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  replicate_source_db = aws_db_instance.primary.identifier

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-ebfxrm"
    Role        = "read_replica"
  }
}

resource "aws_db_instance" "comp1_db-instance-7xmaoj" {
  identifier     = "db-instance-7xmaoj"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  replicate_source_db = aws_db_instance.primary.identifier

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-7xmaoj"
    Role        = "read_replica"
  }
}

resource "aws_db_instance" "comp1_db-instance-auqu1s" {
  identifier     = "db-instance-auqu1s"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  replicate_source_db = aws_db_instance.primary.identifier

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-auqu1s"
    Role        = "read_replica"
  }
}

resource "aws_db_instance" "comp1_db-instance-ucurem" {
  identifier     = "db-instance-ucurem"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = true

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-ucurem"
    Role        = "primary"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/2 · seeded from L1-004
# ═══════════════════════════════════════════════════════════════

resource "aws_db_instance" "comp2_db-instance-luhltf" {
  identifier     = "db-instance-luhltf"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = true

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-luhltf"
    Environment = "dev"
  }
}

resource "aws_db_instance" "comp2_db-instance-tj6z5f" {
  identifier     = "db-instance-tj6z5f"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = true

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-tj6z5f"
    Environment = "dev"
  }
}

resource "aws_db_instance" "comp2_db-instance-ic9a67" {
  identifier     = "db-instance-ic9a67"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = true

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-ic9a67"
    Environment = "production"
  }
}
