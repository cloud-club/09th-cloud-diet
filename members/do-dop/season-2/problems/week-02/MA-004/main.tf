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
# Component 1/4 · seeded from L2-022
# ═══════════════════════════════════════════════════════════════

resource "aws_kinesis_stream" "comp1_kinesis-stream-9j1271" {
  shard_count = 20
  retention_period_hours = 24
  enhanced_fan_out = true
  processing_interval_minutes = 5

  tags = {
    Name = "kinesis-stream-9j1271"
  }
}
resource "aws_kinesis_stream_consumer" "comp1_kinesis-stream-consumer-jkt61h" {
  consumer_type = "enhanced_fan_out"
  data_read_gb_per_day = 250

  tags = {
    Name = "kinesis-stream-consumer-jkt61h"
  }
}
resource "aws_kinesis_stream_consumer" "comp1_kinesis-stream-consumer-db6im2" {
  consumer_type = "enhanced_fan_out"
  data_read_gb_per_day = 250

  tags = {
    Name = "kinesis-stream-consumer-db6im2"
  }
}
resource "aws_kinesis_stream" "comp1_kinesis-stream-r6es5s" {
  shard_count = 5
  retention_period_hours = 24
  enhanced_fan_out = false
  processing_interval_minutes = 1

  tags = {
    Name = "kinesis-stream-r6es5s"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/4 · seeded from L2-015
# ═══════════════════════════════════════════════════════════════

resource "aws_lambda_function" "comp2_lambda-function-4rcx9y" {
  function_name = "lambda-function-4rcx9y"
  role          = aws_iam_role.lambda-function-4rcx9y_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  memory_size = 1024
  timeout     = 900

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
  timeout     = 900

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
# Component 3/4 · seeded from L3-037
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket_replication_configuration" "comp3_s3-bucket-replication-configuration-qlwap6" {
  bucket = aws_s3_bucket.data-primary-us-east-1.id
  role   = aws_iam_role.s3-bucket-replication-configuration-qlwap6_replication_role.arn

  rule {
    id     = "replication-rule"
    status = "Enabled"

    filter {}

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
# Component 4/4 · seeded from L2-023
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp4_s3-bucket-17yx3p" {
  bucket = "s3-bucket-17yx3p"

  tags = {
    Name        = "s3-bucket-17yx3p"
    Purpose     = "athena-query-results"
  }
}

resource "aws_s3_bucket" "comp4_s3-bucket-ynydrt" {
  bucket = "s3-bucket-ynydrt"

  tags = {
    Name        = "s3-bucket-ynydrt"
    Purpose     = "athena-query-results"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "comp4_s3-bucket-ynydrt" {
  bucket = aws_s3_bucket.comp4_s3-bucket-ynydrt.id

  rule {
    id     = "transition-rule"
    status = "Enabled"

    expiration {
      days = 7
    }
  }

}
