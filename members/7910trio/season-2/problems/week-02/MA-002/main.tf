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
# Component 1/5 · seeded from L2-016
# ═══════════════════════════════════════════════════════════════

resource "aws_ecs_service" "comp1_ecs-service-pcb1z0" {
  name            = "ecs-service-pcb1z0"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-pcb1z0.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-pcb1z0_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-pcb1z0"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-pcb1z0" {
  family                   = "ecs-service-pcb1z0"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-pcb1z0_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-pcb1z0_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-pcb1z0-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-pcb1z0"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-pcb1z0"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-ee2w8l" {
  name            = "ecs-service-ee2w8l"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-ee2w8l.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-ee2w8l_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-ee2w8l"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-ee2w8l" {
  family                   = "ecs-service-ee2w8l"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-ee2w8l_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-ee2w8l_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-ee2w8l-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-ee2w8l"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-ee2w8l"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-y2wbcp" {
  name            = "ecs-service-y2wbcp"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-y2wbcp.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-y2wbcp_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-y2wbcp"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-y2wbcp" {
  family                   = "ecs-service-y2wbcp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-y2wbcp_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-y2wbcp_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-y2wbcp-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-y2wbcp"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-y2wbcp"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-9hg3m7" {
  name            = "ecs-service-9hg3m7"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-9hg3m7.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-9hg3m7_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-9hg3m7"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-9hg3m7" {
  family                   = "ecs-service-9hg3m7"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-9hg3m7_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-9hg3m7_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-9hg3m7-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-9hg3m7"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-9hg3m7"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-tym49o" {
  name            = "ecs-service-tym49o"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-tym49o.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-tym49o_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-tym49o"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-tym49o" {
  family                   = "ecs-service-tym49o"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-tym49o_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-tym49o_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-tym49o-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-tym49o"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-tym49o"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-76tgcg" {
  name            = "ecs-service-76tgcg"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-76tgcg.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-76tgcg_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-76tgcg"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-76tgcg" {
  family                   = "ecs-service-76tgcg"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-76tgcg_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-76tgcg_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-76tgcg-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-76tgcg"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-76tgcg"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-o7hepw" {
  name            = "ecs-service-o7hepw"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-o7hepw.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-o7hepw_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-o7hepw"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-o7hepw" {
  family                   = "ecs-service-o7hepw"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-o7hepw_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-o7hepw_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-o7hepw-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-o7hepw"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-o7hepw"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-qw4tkk" {
  name            = "ecs-service-qw4tkk"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-qw4tkk.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-qw4tkk_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-qw4tkk"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-qw4tkk" {
  family                   = "ecs-service-qw4tkk"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-qw4tkk_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-qw4tkk_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-qw4tkk-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-qw4tkk"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-qw4tkk"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-5xubzj" {
  name            = "ecs-service-5xubzj"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-5xubzj.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-5xubzj_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-5xubzj"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-5xubzj" {
  family                   = "ecs-service-5xubzj"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-5xubzj_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-5xubzj_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-5xubzj-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-5xubzj"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-5xubzj"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-w6clto" {
  name            = "ecs-service-w6clto"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-w6clto.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-w6clto_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-w6clto"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-w6clto" {
  family                   = "ecs-service-w6clto"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
  execution_role_arn       = aws_iam_role.ecs-service-w6clto_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-w6clto_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-w6clto-app"
      image     = "nginx:latest"
      cpu       = 4096
      memory    = 8192
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-w6clto"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-w6clto"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-rapenv" {
  name            = "ecs-service-rapenv"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-rapenv.arn
  desired_count   = 3
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-rapenv_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-rapenv"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-rapenv" {
  family                   = "ecs-service-rapenv"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs-service-rapenv_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-rapenv_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-rapenv-app"
      image     = "nginx:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-rapenv"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-rapenv"
  }
}

resource "aws_ecs_service" "comp1_ecs-service-msgdbm" {
  name            = "ecs-service-msgdbm"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.comp1_ecs-service-msgdbm.arn
  desired_count   = 3
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs-service-msgdbm_sg.id]
    assign_public_ip = false
  }

  tags = {
    Name = "ecs-service-msgdbm"
  }
}

resource "aws_ecs_task_definition" "comp1_ecs-service-msgdbm" {
  family                   = "ecs-service-msgdbm"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs-service-msgdbm_execution_role.arn
  task_role_arn            = aws_iam_role.ecs-service-msgdbm_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-service-msgdbm-app"
      image     = "nginx:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/ecs-service-msgdbm"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-service-msgdbm"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/5 · seeded from L1-005
# ═══════════════════════════════════════════════════════════════

resource "aws_lb" "comp2_lb-t441sa" {
  name               = "lb-t441sa"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-t441sa_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-t441sa"
  }
}

resource "aws_lb" "comp2_lb-t6xf3i" {
  name               = "lb-t6xf3i"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-t6xf3i_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-t6xf3i"
  }
}

resource "aws_lb" "comp2_lb-p4kavo" {
  name               = "lb-p4kavo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-p4kavo_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-p4kavo"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 3/5 · seeded from L3-025
# ═══════════════════════════════════════════════════════════════

resource "aws_nat_gateway" "comp3_nat-gateway-lda7ia" {
  allocation_id = aws_eip.comp3_nat-gateway-lda7ia_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-lda7ia"
  }
}

resource "aws_eip" "comp3_nat-gateway-lda7ia_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-lda7ia-eip"
  }
}

resource "aws_subnet" "comp3_subnet-61q89e_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-61q89e-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-61q89e_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-61q89e-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-61q89e_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-61q89e-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_subnet" "comp3_subnet-zhbf25_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-zhbf25-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-zhbf25_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-zhbf25-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-zhbf25_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-zhbf25-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_subnet" "comp3_subnet-kcif6p_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-kcif6p-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-kcif6p_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-kcif6p-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-kcif6p_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-kcif6p-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_route_table" "comp3_route-table-5geyt2" {
  associated_subnets = "all_private"

  tags = {
    Name = "route-table-5geyt2"
  }
}
resource "aws_route_table" "comp3_route-table-dzry5c" {
  associated_subnets = "all_private"

  tags = {
    Name = "route-table-dzry5c"
  }
}
resource "aws_route_table" "comp3_route-table-3aq4k9" {
  associated_subnets = "all_private"

  tags = {
    Name = "route-table-3aq4k9"
  }
}
resource "aws_nat_gateway" "comp3_nat-gateway-qowpky" {
  allocation_id = aws_eip.comp3_nat-gateway-qowpky_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-qowpky"
  }
}

resource "aws_eip" "comp3_nat-gateway-qowpky_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-qowpky-eip"
  }
}

resource "aws_nat_gateway" "comp3_nat-gateway-ifycx9" {
  allocation_id = aws_eip.comp3_nat-gateway-ifycx9_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-ifycx9"
  }
}

resource "aws_eip" "comp3_nat-gateway-ifycx9_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-ifycx9-eip"
  }
}

resource "aws_nat_gateway" "comp3_nat-gateway-7rkqzc" {
  allocation_id = aws_eip.comp3_nat-gateway-7rkqzc_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-7rkqzc"
  }
}

resource "aws_eip" "comp3_nat-gateway-7rkqzc_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-7rkqzc-eip"
  }
}

resource "aws_subnet" "comp3_subnet-p7yl4o_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-p7yl4o-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-p7yl4o_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-p7yl4o-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-p7yl4o_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-p7yl4o-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_subnet" "comp3_subnet-56mmpw_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-56mmpw-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-56mmpw_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-56mmpw-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-56mmpw_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-56mmpw-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_subnet" "comp3_subnet-9twpop_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-9twpop-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-9twpop_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-9twpop-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp3_subnet-9twpop_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-9twpop-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_route_table" "comp3_route-table-tdvwj3" {
  associated_subnets = "same_az_private"

  tags = {
    Name = "route-table-tdvwj3"
  }
}
resource "aws_route_table" "comp3_route-table-1pfge2" {
  associated_subnets = "same_az_private"

  tags = {
    Name = "route-table-1pfge2"
  }
}
resource "aws_route_table" "comp3_route-table-qp4q2x" {
  associated_subnets = "same_az_private"

  tags = {
    Name = "route-table-qp4q2x"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 4/5 · seeded from L3-029
# ═══════════════════════════════════════════════════════════════

resource "aws_instance" "comp4_instance-0quxtl" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-0quxtl"
  }
}

resource "aws_instance" "comp4_instance-qp4lds" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-qp4lds"
  }
}

resource "aws_instance" "comp4_instance-ty0u9s" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-ty0u9s"
  }
}

resource "aws_instance" "comp4_instance-4zu30l" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-4zu30l"
  }
}

resource "aws_instance" "comp4_instance-1y5ar7" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-1y5ar7"
  }
}

resource "aws_nat_gateway" "comp4_nat-gateway-uvxwf2" {
  allocation_id = aws_eip.comp4_nat-gateway-uvxwf2_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-uvxwf2"
  }
}

resource "aws_eip" "comp4_nat-gateway-uvxwf2_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-uvxwf2-eip"
  }
}

resource "aws_instance" "comp4_instance-bg9pxp" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-bg9pxp"
  }
}

resource "aws_instance" "comp4_instance-8s3s56" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-8s3s56"
  }
}

resource "aws_vpc_endpoint" "comp4_vpc-endpoint-gpp7q6" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = {
    Name = "vpc-endpoint-gpp7q6"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 5/5 · seeded from L2-017
# ═══════════════════════════════════════════════════════════════

resource "aws_autoscaling_group" "comp5_autoscaling-group-uiofd9" {
  name                = "autoscaling-group-uiofd9"
  min_size            = 2
  max_size            = 20
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.comp5_autoscaling-group-uiofd9.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "autoscaling-group-uiofd9"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "comp5_autoscaling-group-uiofd9" {
  name_prefix   = "autoscaling-group-uiofd9-"
  image_id      = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "autoscaling-group-uiofd9"
    }
  }
}

resource "aws_autoscaling_policy" "comp5_autoscaling-group-uiofd9_target_tracking" {
  name                   = "autoscaling-group-uiofd9-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.comp5_autoscaling-group-uiofd9.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60
  }
}

resource "aws_autoscaling_group" "comp5_autoscaling-group-q7561j" {
  name                = "autoscaling-group-q7561j"
  min_size            = 2
  max_size            = 10
  desired_capacity    = 4
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.comp5_autoscaling-group-q7561j.id
    version = "$Latest"
  }

  default_instance_warmup = 300

  tag {
    key                 = "Name"
    value               = "autoscaling-group-q7561j"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "comp5_autoscaling-group-q7561j" {
  name_prefix   = "autoscaling-group-q7561j-"
  image_id      = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "autoscaling-group-q7561j"
    }
  }
}

resource "aws_autoscaling_policy" "comp5_autoscaling-group-q7561j_target_tracking" {
  name                   = "autoscaling-group-q7561j-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.comp5_autoscaling-group-q7561j.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60
  }
}
