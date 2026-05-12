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
# Component 1/3 · seeded from L2-014
# ═══════════════════════════════════════════════════════════════

resource "aws_lambda_function" "comp1_lambda-function-r09fbh" {
  function_name = "lambda-function-r09fbh"
  role          = aws_iam_role.lambda-function-r09fbh_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 3008
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-r09fbh"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-i9ynig" {
  function_name = "lambda-function-i9ynig"
  role          = aws_iam_role.lambda-function-i9ynig_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 3008
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-i9ynig"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-h1ampi" {
  function_name = "lambda-function-h1ampi"
  role          = aws_iam_role.lambda-function-h1ampi_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 3008
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-h1ampi"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-ocoqhq" {
  function_name = "lambda-function-ocoqhq"
  role          = aws_iam_role.lambda-function-ocoqhq_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 512
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-ocoqhq"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-qk2ee7" {
  function_name = "lambda-function-qk2ee7"
  role          = aws_iam_role.lambda-function-qk2ee7_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 512
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-qk2ee7"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/3 · seeded from L1-011
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp2_s3-bucket-hoo8na" {
  bucket = "data-lake-raw"

  tags = {
    Name        = "data-lake-raw"
  }
}

resource "aws_s3_bucket" "comp2_s3-bucket-ftvpvj" {
  bucket = "data-lake-archive"

  tags = {
    Name        = "data-lake-archive"
  }
}

resource "aws_s3_bucket" "comp2_s3-bucket-t9r0hc" {
  bucket = "data-lake-curated"

  tags = {
    Name        = "data-lake-curated"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "comp2_s3-bucket-t9r0hc" {
  bucket = aws_s3_bucket.comp2_s3-bucket-t9r0hc.id

  rule {
    id     = "transition-rule"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

  }

}

# ═══════════════════════════════════════════════════════════════
# Component 3/3 · seeded from L1-010
# ═══════════════════════════════════════════════════════════════

resource "aws_dynamodb_table" "comp3_dynamodb-table-3p8ltl" {
  name         = "dynamodb-table-3p8ltl"
  billing_mode = "PROVISIONED"

  hash_key  = "id"

  attribute {
    name = "id"
    type = "S"
  }

  read_capacity  = 5000
  write_capacity = 1000

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "dynamodb-table-3p8ltl"
  }
}

resource "aws_dynamodb_table" "comp3_dynamodb-table-5fs7q6" {
  name         = "dynamodb-table-5fs7q6"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "dynamodb-table-5fs7q6"
  }
}
