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
# Component 1/3 · seeded from L3-038
# ═══════════════════════════════════════════════════════════════

resource "aws_eks_cluster" "comp1_eks-cluster-ebry20" {
  name     = "prod-main"
  role_arn = aws_iam_role.eks-cluster-ebry20_cluster_role.arn
  version  = "1.28"

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = {
    Name = "eks-cluster-ebry20"
  }
}

resource "aws_instance" "comp1_instance-66nj1e" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-66nj1e"
  }
}

resource "aws_instance" "comp1_instance-ty2wg2" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-ty2wg2"
  }
}

resource "aws_instance" "comp1_instance-ogza48" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-ogza48"
  }
}

resource "aws_instance" "comp1_instance-23i258" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-23i258"
  }
}

resource "aws_instance" "comp1_instance-0htdyu" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-0htdyu"
  }
}

resource "aws_instance" "comp1_instance-0xlfwr" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-0xlfwr"
  }
}

resource "aws_instance" "comp1_instance-745v52" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-745v52"
  }
}

resource "aws_instance" "comp1_instance-z7la33" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-z7la33"
  }
}

resource "aws_instance" "comp1_instance-yoick6" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-yoick6"
  }
}

resource "aws_instance" "comp1_instance-a48ulw" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-a48ulw"
  }
}

resource "aws_instance" "comp1_instance-euv5sx" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-euv5sx"
  }
}

resource "aws_instance" "comp1_instance-f63oyj" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-f63oyj"
  }
}

resource "aws_instance" "comp1_instance-8ud102" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-8ud102"
  }
}

resource "aws_instance" "comp1_instance-nmsx78" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-nmsx78"
  }
}

resource "aws_instance" "comp1_instance-u3iwwa" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-u3iwwa"
  }
}

resource "aws_instance" "comp1_instance-c31t23" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-c31t23"
  }
}

resource "aws_instance" "comp1_instance-t565pw" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-t565pw"
  }
}

resource "aws_instance" "comp1_instance-z1jqvs" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-z1jqvs"
  }
}

resource "aws_instance" "comp1_instance-22ujgy" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-22ujgy"
  }
}

resource "aws_instance" "comp1_instance-8erayc" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-8erayc"
  }
}

resource "aws_instance" "comp1_instance-m66p8l" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-m66p8l"
  }
}

resource "aws_instance" "comp1_instance-syjyi4" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-syjyi4"
  }
}

resource "aws_instance" "comp1_instance-ys3aj3" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-ys3aj3"
  }
}

resource "aws_instance" "comp1_instance-mb8klp" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-mb8klp"
  }
}

resource "aws_instance" "comp1_instance-c5rsh1" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-c5rsh1"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/3 · seeded from L1-009
# ═══════════════════════════════════════════════════════════════

resource "aws_ecr_repository" "comp2_ecr-repository-puho0e" {
  name                 = "ecr-repository-puho0e"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "ecr-repository-puho0e"
  }
}

resource "aws_ecr_repository" "comp2_ecr-repository-l1zgtp" {
  name                 = "ecr-repository-l1zgtp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "ecr-repository-l1zgtp"
  }
}

resource "aws_ecr_repository" "comp2_ecr-repository-9et0xi" {
  name                 = "ecr-repository-9et0xi"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "ecr-repository-9et0xi"
  }
}

resource "aws_ecr_repository" "comp2_ecr-repository-km9geh" {
  name                 = "ecr-repository-km9geh"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "ecr-repository-km9geh"
  }
}

resource "aws_ecr_lifecycle_policy" "comp2_ecr-repository-km9geh" {
  repository = aws_ecr_repository.comp2_ecr-repository-km9geh.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository" "comp2_ecr-repository-g9wsmk" {
  name                 = "ecr-repository-g9wsmk"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "ecr-repository-g9wsmk"
  }
}

resource "aws_ecr_lifecycle_policy" "comp2_ecr-repository-g9wsmk" {
  repository = aws_ecr_repository.comp2_ecr-repository-g9wsmk.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ═══════════════════════════════════════════════════════════════
# Component 3/3 · seeded from L3-031
# ═══════════════════════════════════════════════════════════════

resource "aws_instance" "comp3_instance-xxk6uk" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-xxk6uk"
  }
}

resource "aws_instance" "comp3_instance-zzs50h" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-zzs50h"
  }
}

resource "aws_instance" "comp3_instance-epnqs5" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-epnqs5"
  }
}

resource "aws_instance" "comp3_instance-njwybl" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-njwybl"
  }
}

resource "aws_instance" "comp3_instance-l2n8q5" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-l2n8q5"
  }
}

resource "aws_instance" "comp3_instance-y5r5t8" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-y5r5t8"
  }
}

resource "aws_instance" "comp3_instance-o8hdnu" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "c5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-o8hdnu"
    environment = "production"
  }
}

resource "aws_instance" "comp3_instance-inxlqo" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "c5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-inxlqo"
    environment = "production"
  }
}

resource "aws_instance" "comp3_instance-vuibh9" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "c5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-vuibh9"
    environment = "production"
  }
}

resource "aws_instance" "comp3_instance-7ox1p8" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "c5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-7ox1p8"
    environment = "production"
  }
}

resource "aws_db_instance" "comp3_db-instance-mwto3k" {
  identifier     = "db-instance-mwto3k"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-mwto3k"
  }
}

resource "aws_db_instance" "comp3_db-instance-wtb6e5" {
  identifier     = "db-instance-wtb6e5"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-wtb6e5"
  }
}

resource "aws_db_instance" "comp3_db-instance-w9l3u9" {
  identifier     = "db-instance-w9l3u9"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-w9l3u9"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-q521qe" {
  bucket = "s3-bucket-q521qe"

  tags = {
    Name        = "s3-bucket-q521qe"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-ioc7uy" {
  bucket = "s3-bucket-ioc7uy"

  tags = {
    Name        = "s3-bucket-ioc7uy"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-32gr15" {
  bucket = "s3-bucket-32gr15"

  tags = {
    Name        = "s3-bucket-32gr15"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-1szzzr" {
  bucket = "s3-bucket-1szzzr"

  tags = {
    Name        = "s3-bucket-1szzzr"
  }
}

resource "aws_lb" "comp3_lb-cc82t5" {
  name               = "lb-cc82t5"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-cc82t5_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-cc82t5"
    team = "platform"
  }
}

resource "aws_lb" "comp3_lb-7ft9y9" {
  name               = "lb-7ft9y9"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-7ft9y9_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-7ft9y9"
    team = "platform"
  }
}

resource "aws_lb" "comp3_lb-nrynyf" {
  name               = "lb-nrynyf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-nrynyf_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-nrynyf"
    team = "platform"
  }
}

resource "aws_instance" "comp3_instance-3lro7k" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-3lro7k"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_instance" "comp3_instance-lo1sxn" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-lo1sxn"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_instance" "comp3_instance-boaizh" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-boaizh"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_instance" "comp3_instance-398x34" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-398x34"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_db_instance" "comp3_db-instance-1288d1" {
  identifier     = "db-instance-1288d1"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-1288d1"
    cost-center = "CC-1002"
    team = "data"
    environment = "production"
    project = "analytics"
  }
}

resource "aws_db_instance" "comp3_db-instance-whmilk" {
  identifier     = "db-instance-whmilk"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-whmilk"
    cost-center = "CC-1002"
    team = "data"
    environment = "production"
    project = "analytics"
  }
}

resource "aws_db_instance" "comp3_db-instance-g80uz5" {
  identifier     = "db-instance-g80uz5"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-g80uz5"
    cost-center = "CC-1002"
    team = "data"
    environment = "production"
    project = "analytics"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-g7eqgn" {
  bucket = "s3-bucket-g7eqgn"

  tags = {
    Name        = "s3-bucket-g7eqgn"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-93ek7p" {
  bucket = "s3-bucket-93ek7p"

  tags = {
    Name        = "s3-bucket-93ek7p"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_s3_bucket" "comp3_s3-bucket-3b06a6" {
  bucket = "s3-bucket-3b06a6"

  tags = {
    Name        = "s3-bucket-3b06a6"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}
