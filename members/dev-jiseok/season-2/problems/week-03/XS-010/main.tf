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
# Component 1/5 · seeded from L2-023
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp1_s3-bucket-xaesq0" {
  bucket = "s3-bucket-xaesq0"

  tags = {
    Name        = "s3-bucket-xaesq0"
    Purpose     = "athena-query-results"
  }
}

resource "aws_s3_bucket" "comp1_s3-bucket-qlt033" {
  bucket = "s3-bucket-qlt033"

  tags = {
    Name        = "s3-bucket-qlt033"
    Purpose     = "athena-query-results"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "comp1_s3-bucket-qlt033" {
  bucket = aws_s3_bucket.comp1_s3-bucket-qlt033.id

  rule {
    id     = "transition-rule"
    status = "Enabled"

    expiration {
      days = 7
    }
  }

}

# ═══════════════════════════════════════════════════════════════
# Component 2/5 · seeded from L3-035
# ═══════════════════════════════════════════════════════════════

resource "aws_glue_catalog_table" "comp2_glue-catalog-table-rabc4o" {
  database_name = "analytics_db"
  table_name = "raw_events"
  storage_location = "s3://data-lake-prod/raw_events/"
  total_data_size_tb = 10
  format = "parquet"

  tags = {
    Name = "glue-catalog-table-rabc4o"
  }
}
resource "aws_s3_bucket" "comp2_s3-bucket-l7oz6l" {
  bucket = "data-lake-prod"

  tags = {
    Name        = "data-lake-prod"
  }
}

resource "aws_glue_catalog_table" "comp2_glue-catalog-table-vtmdgk" {
  database_name = "analytics_db"
  table_name = "processed_events"
  storage_location = "s3://data-lake-prod/processed_events/"
  total_data_size_tb = 8
  format = "parquet"

  tags = {
    Name = "glue-catalog-table-vtmdgk"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 3/5 · seeded from L1-011
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp3_s3-bucket-ae6hjn" {
  bucket = "data-lake-raw"

  tags = {
    Name        = "data-lake-raw"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-y0djrr" {
  bucket = "data-lake-archive"

  tags = {
    Name        = "data-lake-archive"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-lvihs9" {
  bucket = "data-lake-curated"

  tags = {
    Name        = "data-lake-curated"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "comp3_s3-bucket-lvihs9" {
  bucket = aws_s3_bucket.comp3_s3-bucket-lvihs9.id

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
# Component 4/5 · seeded from L1-012
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp4_s3-bucket-md3to0" {
  bucket = "app-assets-prod"

  tags = {
    Name        = "app-assets-prod"
  }
}

resource "aws_s3_bucket_versioning" "comp4_s3-bucket-md3to0" {
  bucket = aws_s3_bucket.comp4_s3-bucket-md3to0.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "comp4_s3-bucket-ml4hps" {
  bucket = "app-assets-staging"

  tags = {
    Name        = "app-assets-staging"
  }
}

resource "aws_s3_bucket_versioning" "comp4_s3-bucket-ml4hps" {
  bucket = aws_s3_bucket.comp4_s3-bucket-ml4hps.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 5/5 · seeded from L3-037
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket_replication_configuration" "comp5_s3-bucket-replication-configuration-48kluw" {
  bucket = aws_s3_bucket.data-primary-us-east-1.id
  role   = aws_iam_role.s3-bucket-replication-configuration-48kluw_replication_role.arn

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

resource "aws_s3_bucket_replication_configuration" "comp5_s3-bucket-replication-configuration-7kzayn" {
  bucket = aws_s3_bucket.app-primary-us-east-1.id
  role   = aws_iam_role.s3-bucket-replication-configuration-7kzayn_replication_role.arn

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
