// Optimized variant of main.tf for MA-004.
// Merged version:
// - Keep provider-level default tags for cost governance.
// - Remove Kinesis Enhanced Fan-Out consumers instead of setting a non-standard consumer_type.
// - Reduce excessive Lambda timeout from 900s to 15s for safer p99 + buffer operation.
// - Scope S3 Cross-Region Replication to critical data only.
// - Add 7-day expiration lifecycle for Athena result buckets.

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

  default_tags {
    tags = {
      Env        = "production"
      Service    = "analytics-pipeline"
      Owner      = "finops"
      CostCenter = "data-platform"
    }
  }
}


# ═══════════════════════════════════════════════════════════════
# Component 1/4 · Kinesis optimization (L2-022)
# ═══════════════════════════════════════════════════════════════

resource "aws_kinesis_stream" "comp1_kinesis-stream-9j1271" {
  shard_count                 = 20
  retention_period_hours      = 24
  enhanced_fan_out            = false
  processing_interval_minutes = 5

  tags = {
    Name = "kinesis-stream-9j1271"
  }
}

# Removed Enhanced Fan-Out consumers:
# - comp1_kinesis-stream-consumer-jkt61h
# - comp1_kinesis-stream-consumer-db6im2
#
# Rationale:
# aws_kinesis_stream_consumer represents an Enhanced Fan-Out consumer.
# For this workload, iterator age is low and throughput limits are not reached,
# so standard shared-throughput consumers are sufficient.

resource "aws_kinesis_stream" "comp1_kinesis-stream-r6es5s" {
  shard_count                 = 5
  retention_period_hours      = 24
  enhanced_fan_out            = false
  processing_interval_minutes = 1

  tags = {
    Name = "kinesis-stream-r6es5s"
  }
}


# ═══════════════════════════════════════════════════════════════
# Component 2/4 · Lambda timeout optimization (L2-015)
# ═══════════════════════════════════════════════════════════════

resource "aws_lambda_function" "comp2_lambda-function-4rcx9y" {
  function_name = "lambda-function-4rcx9y"
  role          = aws_iam_role.lambda-function-4rcx9y_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  memory_size = 1024
  timeout     = 15

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-4rcx9y"
  }
}

resource "aws_lambda_function" "comp2_lambda-function-neikhx" {
  function_name = "lambda-function-neikhx"
  role          = aws_iam_role.lambda-function-neikhx_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  memory_size = 1024
  timeout     = 15

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-neikhx"
  }
}

resource "aws_lambda_function" "comp2_lambda-function-yyutt6" {
  function_name = "lambda-function-yyutt6"
  role          = aws_iam_role.lambda-function-yyutt6_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  memory_size = 1024
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-yyutt6"
  }
}


# ═══════════════════════════════════════════════════════════════
# Component 3/4 · S3 CRR scope optimization (L3-037)
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket_replication_configuration" "comp3_s3-bucket-replication-configuration-qlwap6" {
  bucket = aws_s3_bucket.data-primary-us-east-1.id
  role   = aws_iam_role.s3-bucket-replication-configuration-qlwap6_replication_role.arn

  rule {
    id     = "replication-rule"
    status = "Enabled"

    filter {
      prefix = "critical/"
    }

    destination {
      bucket        = "arn:aws:s3:::data-dr-us-west-2"
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "comp3_s3-bucket-replication-configuration-5cpqfg" {
  bucket = aws_s3_bucket.app-primary-us-east-1.id
  role   = aws_iam_role.s3-bucket-replication-configuration-5cpqfg_replication_role.arn

  rule {
    id     = "replication-rule"
    status = "Enabled"

    filter {
      prefix = "critical/"
    }

    destination {
      bucket        = "arn:aws:s3:::app-dr-us-west-2"
      storage_class = "STANDARD"
    }
  }
}


# ═══════════════════════════════════════════════════════════════
# Component 4/4 · Athena result bucket lifecycle optimization (L2-023)
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp4_s3-bucket-17yx3p" {
  bucket = "s3-bucket-17yx3p"

  tags = {
    Name    = "s3-bucket-17yx3p"
    Purpose = "athena-query-results"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "comp4_s3-bucket-17yx3p" {
  bucket = aws_s3_bucket.comp4_s3-bucket-17yx3p.id

  rule {
    id     = "expire-athena-results-after-7-days"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket" "comp4_s3-bucket-ynydrt" {
  bucket = "s3-bucket-ynydrt"

  tags = {
    Name    = "s3-bucket-ynydrt"
    Purpose = "athena-query-results"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "comp4_s3-bucket-ynydrt" {
  bucket = aws_s3_bucket.comp4_s3-bucket-ynydrt.id

  rule {
    id     = "expire-athena-results-after-7-days"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}