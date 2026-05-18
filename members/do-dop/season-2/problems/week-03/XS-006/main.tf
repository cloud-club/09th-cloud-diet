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

resource "aws_lambda_function" "comp1_lambda-function-xoq9qq" {
  function_name = "lambda-function-xoq9qq"
  role          = aws_iam_role.lambda-function-xoq9qq_role.arn
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
    Name = "lambda-function-xoq9qq"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-0n5puy" {
  function_name = "lambda-function-0n5puy"
  role          = aws_iam_role.lambda-function-0n5puy_role.arn
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
    Name = "lambda-function-0n5puy"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-j5dyhj" {
  function_name = "lambda-function-j5dyhj"
  role          = aws_iam_role.lambda-function-j5dyhj_role.arn
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
    Name = "lambda-function-j5dyhj"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-v3uzlk" {
  function_name = "lambda-function-v3uzlk"
  role          = aws_iam_role.lambda-function-v3uzlk_role.arn
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
    Name = "lambda-function-v3uzlk"
  }
}

resource "aws_lambda_function" "comp1_lambda-function-87jhv8" {
  function_name = "lambda-function-87jhv8"
  role          = aws_iam_role.lambda-function-87jhv8_role.arn
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
    Name = "lambda-function-87jhv8"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/3 · seeded from L2-015
# ═══════════════════════════════════════════════════════════════

resource "aws_lambda_function" "comp2_lambda-function-w8lsz8" {
  function_name = "lambda-function-w8lsz8"
  role          = aws_iam_role.lambda-function-w8lsz8_role.arn
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
    Name = "lambda-function-w8lsz8"
  }
}

resource "aws_lambda_function" "comp2_lambda-function-bybdc5" {
  function_name = "lambda-function-bybdc5"
  role          = aws_iam_role.lambda-function-bybdc5_role.arn
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
    Name = "lambda-function-bybdc5"
  }
}

resource "aws_lambda_function" "comp2_lambda-function-yn04ka" {
  function_name = "lambda-function-yn04ka"
  role          = aws_iam_role.lambda-function-yn04ka_role.arn
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
    Name = "lambda-function-yn04ka"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 3/3 · seeded from L1-010
# ═══════════════════════════════════════════════════════════════

resource "aws_dynamodb_table" "comp3_dynamodb-table-bh7jai" {
  name         = "dynamodb-table-bh7jai"
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
    Name = "dynamodb-table-bh7jai"
  }
}

resource "aws_dynamodb_table" "comp3_dynamodb-table-1ziky1" {
  name         = "dynamodb-table-1ziky1"
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
    Name = "dynamodb-table-1ziky1"
  }
}
