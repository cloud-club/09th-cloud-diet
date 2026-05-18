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
# Component 1/2 · seeded from L2-014
# ═══════════════════════════════════════════════════════════════

resource "aws_lambda_function" "comp1_lambda-function-9wz74e" {
  function_name = "lambda-function-9wz74e"
  role          = aws_iam_role.lambda-function-9wz74e_role.arn
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
    Name = "lambda-function-9wz74e"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-2pa381" {
  function_name = "lambda-function-2pa381"
  role          = aws_iam_role.lambda-function-2pa381_role.arn
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
    Name = "lambda-function-2pa381"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-th4omg" {
  function_name = "lambda-function-th4omg"
  role          = aws_iam_role.lambda-function-th4omg_role.arn
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
    Name = "lambda-function-th4omg"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-sjqg7a" {
  function_name = "lambda-function-sjqg7a"
  role          = aws_iam_role.lambda-function-sjqg7a_role.arn
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
    Name = "lambda-function-sjqg7a"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-6t00ny" {
  function_name = "lambda-function-6t00ny"
  role          = aws_iam_role.lambda-function-6t00ny_role.arn
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
    Name = "lambda-function-6t00ny"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/2 · seeded from L1-011
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp2_s3-bucket-kjarfq" {
  bucket = "data-lake-raw"

  tags = {
    Name        = "data-lake-raw"
  }
}

resource "aws_s3_bucket" "comp2_s3-bucket-s2ia8s" {
  bucket = "data-lake-archive"

  tags = {
    Name        = "data-lake-archive"
  }
}

resource "aws_s3_bucket" "comp2_s3-bucket-xs9ads" {
  bucket = "data-lake-curated"

  tags = {
    Name        = "data-lake-curated"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "comp2_s3-bucket-xs9ads" {
  bucket = aws_s3_bucket.comp2_s3-bucket-xs9ads.id

  rule {
    id     = "transition-rule"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

  }

}
