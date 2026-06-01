# Cloud FinOps AI — 스터디 데모 가이드

> **DataFlow Inc.** 실제 SaaS 회사 케이스를 기반으로 구성한 AWS 환경에서  
> AI가 비용 낭비를 자동 탐지하고 최적화 방안을 제시하는 시스템입니다.

---

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [인프라 환경 구성](#2-인프라-환경-구성)
3. [DataFlow Inc. — 시나리오 배경](#3-dataflow-inc--시나리오-배경)
4. [AWS 인프라 전체 구성 (Terraform)](#4-aws-인프라-전체-구성-terraform)
5. [VM에 올라간 AWS 환경 상세](#5-vm에-올라간-aws-환경-상세)
6. [AI Agent 구조 및 기술 스택](#6-ai-agent-구조-및-기술-스택)
7. [3단계 탐지 프레임워크 (L1 / L2 / L3)](#7-3단계-탐지-프레임워크-l1--l2--l3)
8. [실제 실행 결과](#8-실제-실행-결과)
9. [탐지 항목 상세 리포트](#9-탐지-항목-상세-리포트)
10. [직접 실행하는 방법](#10-직접-실행하는-방법)

---

## 1. 프로젝트 개요

### 무엇을 만들었나?

클라우드 인프라의 **비용 낭비를 자동으로 찾아내는 FinOps AI 도구**입니다.

```
AWS 환경 (실제 or 시뮬레이션)
        ↓
  AI가 자동으로 스캔
        ↓
  L1 규칙 탐지 → L2 메트릭 분석 → L3 아키텍처 분석
        ↓
  "월 $7,212 절감 가능, 여기를 고치세요" 리포트 자동 생성
```

### 왜 만들었나?

| 현실 | AI 도입 후 |
|------|-----------|
| DevOps 팀이 비용 최적화할 시간이 없음 | 30초 만에 전체 스캔 |
| 팀마다 자기 서비스만 관리 → 전사 낭비 사각지대 | 전체 아키텍처 크로스 분석 |
| "비용이 왜 이렇게 나와?" 원인 파악 수일 소요 | 근본 원인 + 절감액 + 해결 코드 즉시 제시 |
| AWS 공식 보고서: 클라우드 비용 평균 **32%가 낭비** | 탐지 → 실행까지 원스톱 |

---

## 2. 인프라 환경 구성

### 물리 구성도

```
[ Mac (로컬) ]                    [ Gabia Cloud VM ]
                                   IP: 1.201.126.224
  Claude Code AI ─────────────────→ MiniStack (AWS 호환)
  FinOps 분석 도구                    포트: 4566
        ↑                              │
        │  SSH 터널                    │ AWS 서비스 시뮬레이션
        └──────────────────────────────┘
           localhost:14566 → VM:4566
```

### 핵심 기술: MiniStack

- **MiniStack**: AWS 호환 로컬 클라우드 환경 (LocalStack 대안, MIT 라이선스)
- S3, DynamoDB, Kinesis, ECR, SQS, Lambda, SSM, CloudWatch 등 **44개 서비스** 제공
- 실제 AWS SDK(boto3)가 `endpoint_url`만 바꾸면 그대로 연결됨
- 메모리 사용 ~30MB, 기동 ~2초

```python
# 실제 AWS 연결
boto3.client("s3")

# MiniStack 연결 (코드 변경 없이 endpoint만 교체)
boto3.client("s3", endpoint_url="http://localhost:4566")
```

### SSH 터널 구조

Mac에서 Gabia VM의 MiniStack에 직접 접근하기 위해 SSH 터널을 사용합니다.  
VM의 방화벽을 열지 않고도 안전하게 연결할 수 있습니다.

```bash
# 터널 연결 (한 번만 실행)
ssh -f -N -L 14566:localhost:4566 ubuntu@1.201.126.224

# 이후 Mac에서 localhost:14566으로 VM의 MiniStack에 접근
AWS_ENDPOINT_URL=http://localhost:14566 python3 run_analysis.py
```

---

## 3. DataFlow Inc. — 시나리오 배경

### 회사 소개

```
DataFlow Inc.
  업종: SaaS B2B — 고객사 사용자 행동 데이터 수집·분석 플랫폼
  규모: 고객사 50곳, 월 이벤트 처리량 약 50억 건
  성장: 창업 3년, 시리즈 B 직후 빠르게 스케일업
  문제: 월 AWS 비용 $45,000 → CFO "왜 이렇게 비싸냐?"
```

### 왜 이런 상황이 됐나?

> 빠르게 성장하는 스타트업의 전형적인 패턴입니다.

- 초기: "일단 크게 잡자" → 오버프로비저닝 누적
- 성장기: 기능 개발에 집중 → 비용 최적화는 나중으로
- 현재: 인프라가 복잡해져서 어디서 낭비가 나는지 파악 불가
- 결과: **연간 $86,000 이상이 조용히 낭비되고 있음**

### 실제 회사에서도 이런 일이?

AWS 공식 통계에 따르면:
- 기업 클라우드 비용의 평균 **32%가 낭비**
- 가장 많은 낭비 유형: 오버프로비저닝(40%), 미사용 리소스(30%), 요금제 미최적화(20%)
- L3 수준(아키텍처 문제)은 **전담 FinOps 엔지니어도 파악하는 데 수 주 소요**

---

## 4. AWS 인프라 전체 구성 (Terraform)

현재 VM(MiniStack)에 올라가 있는 DataFlow Inc. 전체 인프라를 Terraform 코드로 표현한 것입니다.  
실제로 이 코드를 `terraform apply` 하면 동일한 환경이 AWS에 구성됩니다.  
**빨간 주석(`# ⚠️`)이 AI가 탐지한 낭비 항목입니다.**

```hcl
# ─────────────────────────────────────────────────────────────
# S3 — 데이터 파이프라인 버킷
# ─────────────────────────────────────────────────────────────

resource "aws_s3_bucket" "raw_events" {
  bucket = "dataflow-raw-events"
  tags   = { Team = "platform", Environment = "production" }
  # ⚠️ L1: lifecycle_rule 없음 → 원시 데이터 무한 누적
  # ⚠️ L3: us-west-2로 전체 5TB CRR 복제 중 (DR 필요분 1TB뿐)
}

resource "aws_s3_bucket_replication_configuration" "raw_events_dr" {
  bucket = aws_s3_bucket.raw_events.id
  # ⚠️ L3: prefix 필터 없음 → 전체 복제 (필요한 건 "events/recent/" 뿐)
  rule {
    status      = "Enabled"
    destination { bucket = aws_s3_bucket.dr_backup.arn }
    # filter {} 없음 = 전체 복제
  }
}

resource "aws_s3_bucket" "processed" {
  bucket = "dataflow-processed"
  tags   = { Team = "platform", Environment = "production" }
}
resource "aws_s3_bucket_lifecycle_configuration" "processed" {
  bucket = aws_s3_bucket.processed.id
  rule {
    id     = "expire-old"
    status = "Enabled"
    expiration { days = 90 }
  }
}

resource "aws_s3_bucket" "athena_results" {
  bucket = "dataflow-athena-results"
  tags   = { Team = "platform", Environment = "production" }
  # ⚠️ L1: lifecycle_rule 없음 → Athena 쿼리 결과 무한 누적
}

resource "aws_s3_bucket" "reports" {
  bucket = "dataflow-reports"
  tags   = { Team = "platform", Environment = "production" }
}
resource "aws_s3_bucket_lifecycle_configuration" "reports" {
  bucket = aws_s3_bucket.reports.id
  rule {
    id     = "expire-old"
    status = "Enabled"
    expiration { days = 180 }
  }
}

resource "aws_s3_bucket" "dr_backup" {
  bucket   = "dataflow-dr-us-west-2"
  provider = aws.us_west_2
  tags     = { Team = "platform", Environment = "production" }
  # ⚠️ L3: 5TB 전체 미러 → DR 필요분 1TB만 복제해야 함
}


# ─────────────────────────────────────────────────────────────
# DynamoDB — 메타데이터 테이블
# ─────────────────────────────────────────────────────────────

resource "aws_dynamodb_table" "customer_metadata" {
  name         = "customer-metadata"
  billing_mode = "PROVISIONED"

  read_capacity  = 500   # ⚠️ L1: 실사용 RCU ~12 (활용률 2.4%)
  write_capacity = 200   # ⚠️ L1: 실사용 WCU ~5  → On-Demand로 전환 시 $99/월 절감

  hash_key = "pk"
  attribute {
    name = "pk"
    type = "S"
  }
  tags = { Team = "platform", Environment = "production" }
}

resource "aws_dynamodb_table" "pipeline_state" {
  name         = "pipeline-state"
  billing_mode = "PROVISIONED"
  read_capacity  = 50    # 실사용 ~40 (정상)
  write_capacity = 50
  hash_key = "pk"
  attribute { name = "pk", type = "S" }
  tags = { Team = "platform", Environment = "production" }
}

resource "aws_dynamodb_table" "report_cache" {
  name         = "report-cache"
  billing_mode = "PROVISIONED"
  read_capacity  = 100   # 소폭 과잉
  write_capacity = 20
  hash_key = "pk"
  attribute { name = "pk", type = "S" }
  tags = { Team = "platform", Environment = "production" }
}


# ─────────────────────────────────────────────────────────────
# Kinesis — 실시간 스트리밍
# ─────────────────────────────────────────────────────────────

resource "aws_kinesis_stream" "customer_events" {
  name        = "customer-events"
  shard_count = 100   # ⚠️ L2: 7일 CloudWatch 기준 peak 실사용 8 shard
                      # ⚠️ L2: 활용률 8%, 월 $1,080 → 10 shard면 $108 (절감 $972/월)
  tags = { Team = "platform", Environment = "production" }
}

resource "aws_kinesis_stream" "pipeline_output" {
  name        = "pipeline-output"
  shard_count = 10    # 실사용 ~7 (정상)
  tags = { Team = "platform", Environment = "production" }
}

resource "aws_kinesis_stream" "audit_stream" {
  name        = "audit-stream"
  shard_count = 5     # 실사용 ~4 (정상)
  tags = { Team = "platform", Environment = "production" }
}


# ─────────────────────────────────────────────────────────────
# Lambda — ETL 처리 함수
# ─────────────────────────────────────────────────────────────

resource "aws_lambda_function" "event_transformer" {
  function_name = "event-transformer"
  runtime       = "python3.11"
  handler       = "index.handler"
  memory_size   = 512    # 정상
  timeout       = 30
  role          = aws_iam_role.lambda_exec.arn
  filename      = "event_transformer.zip"
  tags = { Team = "platform", Environment = "production" }
}

resource "aws_lambda_function" "report_generator" {
  function_name = "report-generator"
  runtime       = "python3.11"
  handler       = "index.handler"
  memory_size   = 1024   # 정상
  timeout       = 60
  role          = aws_iam_role.lambda_exec.arn
  filename      = "report_generator.zip"
  tags = { Team = "platform", Environment = "production" }
}


# ─────────────────────────────────────────────────────────────
# ECR — 컨테이너 이미지 저장소
# ─────────────────────────────────────────────────────────────

resource "aws_ecr_repository" "event_collector" {
  name = "dataflow/event-collector"
  # ⚠️ L1: lifecycle_policy 없음 → CI/CD 배포마다 이미지 누적
}

resource "aws_ecr_repository" "stream_processor" {
  name = "dataflow/stream-processor"
  # ⚠️ L1: lifecycle_policy 없음
}

resource "aws_ecr_repository" "report_builder" {
  name = "dataflow/report-builder"
  # ⚠️ L1: lifecycle_policy 없음
}

# 올바른 설정 예시 (현재 미적용)
# resource "aws_ecr_lifecycle_policy" "example" {
#   repository = aws_ecr_repository.event_collector.name
#   policy = jsonencode({
#     rules = [{
#       rulePriority = 1
#       selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 10 }
#       action       = { type = "expire" }
#     }]
#   })
# }


# ─────────────────────────────────────────────────────────────
# SQS — 메시지 큐
# ─────────────────────────────────────────────────────────────

resource "aws_sqs_queue" "event_ingestion" {
  name = "event-ingestion-queue"
  # ⚠️ L1: redrive_policy(DLQ) 없음 → 처리 실패 시 메시지 유실
  tags = { Team = "platform", Environment = "production" }
}

resource "aws_sqs_queue" "report_trigger" {
  name = "report-trigger-queue"
  # ⚠️ L1: redrive_policy(DLQ) 없음
  tags = { Team = "platform", Environment = "production" }
}


# ─────────────────────────────────────────────────────────────
# 보이지 않는 인프라 (MiniStack 미지원 → SSM 메타데이터로 시뮬레이션)
# ─────────────────────────────────────────────────────────────

# ⚠️ L3: Redshift — 24/7 가동, 실사용 평일 09-18시만 (30%)
# resource "aws_redshift_cluster" "analytics" {
#   cluster_identifier = "analytics-cluster"
#   node_type          = "dc2.8xlarge"
#   number_of_nodes    = 4
#   # 월 비용: $4,380 / 실사용: $1,314 / 낭비: $3,066
#   # 해결: 야간·주말 pause 스케줄링 or Redshift Serverless 전환
# }

# ⚠️ L3: Savings Plans — 커버리지 58%, 미커버 On-Demand $4,200/월
# resource "aws_ce_cost_allocation_tag" "sp_coverage" { ... }
# 현재: Compute SP $8,000 + EC2 SP $3,000 구매
# 전체 컴퓨팅 $19,000/월 중 $4,200이 On-Demand 정가 과금
# 해결: Compute SP $3,000 추가 구매 → 커버리지 74%, $2,800/월 절감
```

---

## 5. VM에 올라간 AWS 환경 상세

현재 Gabia VM MiniStack에 구성된 DataFlow Inc.의 AWS 인프라입니다.

### S3 — 데이터 파이프라인 버킷

| 버킷 이름 | 용도 | Lifecycle | 상태 |
|-----------|------|-----------|------|
| `dataflow-raw-events` | 원시 이벤트 스트림 수집 | ❌ 없음 | **낭비** — 데이터 계속 누적 |
| `dataflow-processed` | 정제된 분석 데이터 | ✅ 있음 | 정상 |
| `dataflow-reports` | 고객사 리포트 배포 | ✅ 있음 | 정상 |
| `dataflow-athena-results` | Athena 쿼리 결과 저장 | ❌ 없음 | **낭비** — 쿼리 결과 무한 누적 |
| `dataflow-dr-us-west-2` | DR 복제 버킷 (us-west-2) | ❌ 없음 | **낭비** — 5TB 전체 복제 중 |

> `dataflow-raw-events` → `dataflow-dr-us-west-2`로 **전체 5TB 복제** 중  
> DR SLA상 필요한 데이터는 최근 30일분 **1TB뿐** → 4TB 초과 복제

### DynamoDB — 메타데이터 테이블

| 테이블 | RCU | WCU | 실사용 RCU | 상태 |
|--------|-----|-----|-----------|------|
| `customer-metadata` | **500** | **200** | ~12 | ❌ **40배 오버프로비저닝** |
| `pipeline-state` | 50 | 50 | ~40 | 정상 |
| `report-cache` | 100 | 20 | ~80 | 소폭 과잉 |

> `customer-metadata`: 고객사 설정 저장용인데 실제 RCU 12만 사용  
> RCU 500은 초당 500번의 읽기를 처리할 수 있는 용량 → 완전 낭비

### Kinesis — 실시간 스트리밍

| 스트림 | 프로비저닝 Shard | 실사용 peak | 활용률 | 월 비용 |
|--------|----------------|------------|--------|---------|
| `customer-events` | **100개** | **8개** | **8%** | **$1,080** |
| `pipeline-output` | 10개 | ~7개 | 70% | 정상 |
| `audit-stream` | 5개 | ~4개 | 80% | 정상 |

> `customer-events`: 고객사 50곳의 이벤트를 수집하는 메인 스트림  
> 100 shard 프로비저닝 → 7일 CloudWatch 메트릭 보면 peak 8 shard  
> 10 shard로 감축 시 월 $972 절감

### ECR — 컨테이너 이미지 저장소

| 레포지토리 | Lifecycle Policy | 상태 |
|-----------|----------------|------|
| `dataflow/event-collector` | ❌ 없음 | **이미지 무한 누적** |
| `dataflow/stream-processor` | ❌ 없음 | **이미지 무한 누적** |
| `dataflow/report-builder` | ❌ 없음 | **이미지 무한 누적** |

> CI/CD 배포마다 이미지 추가 → lifecycle 없으면 영구 저장 → ECR 스토리지 비용 누적

### SQS — 메시지 큐

| 큐 이름 | DLQ | 상태 |
|---------|-----|------|
| `event-ingestion-queue` | ❌ 없음 | DLQ 미설정 (메시지 유실 위험) |
| `report-trigger-queue` | ❌ 없음 | DLQ 미설정 |

### Lambda — ETL 함수

| 함수 | 메모리 | 런타임 | 상태 |
|------|--------|--------|------|
| `event-transformer` | 512MB | Python 3.11 | 정상 |
| `report-generator` | 1024MB | Python 3.11 | 정상 |

### 보이지 않는 인프라 (L3 — SSM 메타데이터로 시뮬레이션)

MiniStack이 직접 지원하지 않는 서비스(Redshift, Savings Plans 등)는  
SSM Parameter Store에 아키텍처 메타데이터를 저장하여 시뮬레이션합니다.

**Redshift 클러스터** (`analytics-cluster`)
```
노드 타입: dc2.8xlarge × 4노드
월 비용: $4,380
가동 시간: 24/7 (평일 + 야간 + 주말)
실사용 시간: 평일 09:00-18:00 KST (전체의 30%)
→ 야간/주말 504시간이 idle 상태로 과금
```

**Savings Plans 현황**
```
Compute SP 구매액: $8,000/월
EC2 SP 구매액: $3,000/월
전체 컴퓨팅 비용: $19,000/월
커버리지: 58%
미커버 On-Demand 비용: $4,200/월 (정가 과금)
```

**S3 Cross-Region Replication**
```
소스: dataflow-raw-events (전체 5TB)
대상: us-west-2 (dataflow-dr-us-west-2)
DR SLA 필요량: 최근 30일 데이터 1TB
초과 복제: 4TB (전체의 80%)
```

---

## 6. AI Agent 구조 및 기술 스택

### 전체 아키텍처

```
┌─────────────────────────────────────────────────────┐
│                  Claude AI (Sonnet 4.5)             │
│                                                     │
│  System Prompt: "너는 FinOps 전문가야.                 │
│  도구를 써서 AWS 환경을 분석하고 낭비를 찾아라"               │
└──────────────────────┬──────────────────────────────┘
                       │ Tool Use (최대 15회 반복)
                       ↓
┌─────────────────────────────────────────────────────┐
│              16개 분석 도구 (Tool Definitions)         │
│                                                     │
│  스캔 도구          분석 도구                            │
│  scan_s3_buckets    analyze_finops_waste (L1)       │
│  scan_dynamodb      analyze_l2_waste (L2)           │
│  scan_sqs           analyze_l3_waste (L3)           │
│  scan_rds           scan_cloudwatch_metrics         │
│  scan_lambda        scan_kinesis_streams            │
│  scan_ecr           scan_ecs_tasks                  │
│  scan_secrets       scan_tags                       │
│  resource_summary   calculate_savings               │
│                     generate_report                 │
└──────────────────────┬──────────────────────────────┘
                       │ boto3 API 호출
                       ↓
┌─────────────────────────────────────────────────────┐
│          MiniStack (AWS 호환 환경, 포트 4566)          │
│   S3 / DynamoDB / Kinesis / ECR / SQS / Lambda      │
│   CloudWatch / SSM / Secrets Manager / ...          │
└─────────────────────────────────────────────────────┘
```

### Agent 실행 루프

```
[1] Claude에게 분석 태스크 전달
      "DataFlow Inc.의 AWS 비용 낭비를 분석하라"
         ↓
[2] Claude가 도구 선택 및 호출
      → scan_s3_buckets() 호출
      → scan_dynamodb_tables() 호출
      → ...
         ↓
[3] 도구 실행 결과 Claude에게 반환
      → "S3 버킷 5개 발견, lifecycle 없는 버킷 3개"
      → "DynamoDB RCU 500인데 실사용 12"
         ↓
[4] Claude가 결과 분석 후 다음 도구 결정
      → analyze_finops_waste() 호출 (L1 규칙 적용)
      → analyze_l2_waste() 호출 (메트릭 분석)
      → analyze_l3_waste() 호출 (아키텍처 분석)
         ↓
[5] 모든 분석 완료 후 최종 리포트 생성
      → 총 15건, $7,212/월 절감 가능
      → 우선순위별 해결 방안 제시

※ 2~4 반복 (최대 15회)
```

### 기술 스택

| 구분 | 기술 | 역할 |
|------|------|------|
| **AI** | Claude Sonnet 4.5 | 분석 판단, 도구 선택, 리포트 생성 |
| **AI Framework** | Anthropic Tool Use API | AI가 도구를 자율 호출하는 Agent 루프 |
| **클라우드 SDK** | boto3 (Python) | AWS/MiniStack 리소스 조회 |
| **클라우드 시뮬레이션** | MiniStack 3.0 | AWS 호환 로컬 환경 (44개 서비스) |
| **인프라** | Gabia Cloud VM | MiniStack 호스팅 (Ubuntu) |
| **연결** | SSH 터널링 | Mac → VM 안전 연결 |
| **컨테이너** | Docker Compose | MiniStack + 부속 컨테이너 관리 |
| **메타데이터 저장** | SSM Parameter Store | L3 아키텍처 정보 저장 (MiniStack 지원) |
| **메트릭** | CloudWatch API | L2 시계열 사용률 분석 |

### 파이프라인 모드 vs Agent 모드

**파이프라인 모드** (Claude Pro, 비용 없음) — 데모에서 사용
```
순서 고정: 스캔 → L1 → L2 → L3 → LLM 리포트
장점: 안정적, 빠름 (~30초)
단점: AI가 자율 판단 없음
```

**Agent 모드** (API Key 필요)
```
AI가 직접 도구 순서를 결정하며 자율 분석
장점: 더 유연한 분석, 예상 못한 패턴 발견 가능
단점: 도구 15회+ 호출 → 시간 더 소요 (~3분)
```

---

## 7. 3단계 탐지 프레임워크 (L1 / L2 / L3)

### L1 — 규칙 기반 탐지 (설정만 봐도 보이는 낭비)

**특징**: 즉각 탐지, 빠른 속도, 명확한 판단

```python
# 예시: DynamoDB 오버프로비저닝 탐지 로직
if rcu > 100 and actual_item_count < rcu * 0.1:
    → "오버프로비저닝 탐지"
```

탐지 항목:
- S3 lifecycle policy 미설정
- DynamoDB 용량 오버프로비저닝
- SQS DLQ(Dead Letter Queue) 미설정
- RDS dev 환경 Multi-AZ (2배 비용)
- Lambda 과도 메모리 할당
- ECR lifecycle policy 없음 (이미지 무한 누적)
- Secrets Manager 미사용 시크릿

### L2 — 메트릭 기반 탐지 (CloudWatch 데이터 봐야 보이는 낭비)

**특징**: 7일치 시계열 데이터 분석, 실사용률 기반 판단

```
Kinesis 100 shard → 설정만 보면 "의도적인 것 같은데?"
                 → CloudWatch IncomingBytes 보면 peak 8 shard 수준
                 → "92개 shard가 놀고 있음" 확정
```

탐지 항목:
- Lambda 메모리 실사용률 30% 미만
- ECS Fargate CPU 실사용률 15% 미만
- Kinesis Shard 실사용률 50% 미만
- ElastiCache 노드 과잉
- RDS Read Replica 미사용 (ReadIOPS ≈ 0)
- SQS Short Polling (EmptyReceives 폭발)

### L3 — 아키텍처 탐지 (전체 구조 봐야 보이는 낭비)

**특징**: 여러 서비스 교차 분석, 단일 서비스 관점으론 절대 안 보임

```
Redshift 24/7 가동 → 인프라팀: "항상 켜두라고 했는데요?"
                  → FinOps AI: "CloudWatch 보니 09-18시만 쿼리가 있음"
                             → "야간/주말 pause 스케줄링 하면 $3,066 절감"
```

탐지 항목:
- NAT Gateway Single-AZ 배치 (cross-AZ 이중 과금)
- Transit Gateway 불필요 경유 (VPC Peering으로 대체 가능)
- Savings Plans 커버리지 갭
- Redshift 24/7 운영 (야간/주말 일시정지 가능)
- S3 CRR 과잉 복제
- EKS Pod resource request 과잉
- S3 Direct Egress (CloudFront 없음)
- Lambda → RDS 직접 연결 (연결 수 폭발)

---

## 8. 실제 실행 결과

### 실행 명령

```bash
# Mac에서 실행 (터널이 연결된 상태)
./finops.sh scan
```

### 콘솔 출력 결과

```
=== [1/4] 리소스 스캔 ===
  s3_buckets:        5개
  dynamodb_tables:   3개
  sqs_queues:        2개
  lambda_functions:  2개
  ecr_repos:         3개

=== [2/4] L1 규칙 분석 ===
  L1: 11건, $132.86/월

=== [3/4] L2 메트릭 분석 ===
  L2: 1건, $1,029.30/월

=== [4/4] L3 아키텍처 분석 ===
  L3: 3건, $6,050.00/월

==================================================
총 탐지: 15건
총 낭비: $7,212.16/월 ($86,545.92/연)
==================================================

=== Top 10 절감 항목 ===
   1. [HIGH  ] $  3,066.00/월  Redshift 클러스터 24/7 가동 — 실사용 30%
   2. [HIGH  ] $  2,800.00/월  Savings Plans 커버리지 58% — On-Demand 과다
   3. [HIGH  ] $  1,029.30/월  Kinesis 'customer-events' Shard 과잉 (100개 → 6개 권장)
   4. [MEDIUM] $    184.00/월  S3 Cross-Region Replication 전체 적용 — 불필요 데이터 복제
   5. [HIGH  ] $     99.64/월  DynamoDB 'customer-metadata' 오버프로비저닝
   6. [MEDIUM] $     19.93/월  DynamoDB 'pipeline-state' 오버프로비저닝
   7. [MEDIUM] $     13.29/월  DynamoDB 'report-cache' 오버프로비저닝
   8. [LOW   ] $      0.00/월  S3 'dataflow-athena-results' lifecycle policy 미설정
   9. [LOW   ] $      0.00/월  S3 'dataflow-dr-us-west-2' lifecycle policy 미설정
  10. [MEDIUM] $      0.00/월  S3 'dataflow-raw-events' lifecycle policy 미설정
```

### 탐지 요약

| 레벨 | 탐지 건수 | 월 절감액 | 대표 항목 |
|------|-----------|----------|----------|
| L1 (규칙 기반) | 11건 | $132/월 | DynamoDB 오버프로비저닝, ECR lifecycle 없음 |
| L2 (메트릭 기반) | 1건 | $1,029/월 | Kinesis 100 shard → 실사용 8개 |
| L3 (아키텍처) | 3건 | $6,050/월 | Redshift 24/7, SP 갭, S3 CRR |
| **합계** | **15건** | **$7,212/월** | **연간 $86,546 절감 가능** |

> L3가 건수는 적지만 금액의 84%를 차지합니다.  
> 아키텍처 문제가 가장 큰 낭비 원인이며, 사람이 발견하기 가장 어렵습니다.

---

## 9. 탐지 항목 상세 리포트

### [L3-001] Redshift 클러스터 24/7 가동 — $3,066/월

```
심각도: HIGH
서비스: Redshift
근본 원인: analytics-cluster(dc2.8xlarge × 4노드)가 24/7 가동 중이나
           실사용은 평일 09:00-18:00 KST (전체의 30%)
현재 비용: $4,380/월
Serverless 전환 시: $1,314/월
절감 가능: $3,066/월

해결 방법:
  aws redshift pause-cluster --cluster-identifier analytics-cluster
  # 스케줄 설정: 평일 18시 pause, 09시 resume
  # 또는 Redshift Serverless 전환 검토
```

### [L3-002] Savings Plans 커버리지 58% — $2,800/월

```
심각도: HIGH
서비스: EC2 / Fargate / Lambda
근본 원인: 전체 컴퓨팅 비용 $19,000/월 중 커버리지 58%
           미커버 On-Demand $4,200/월이 정가 과금
SP 약정 현황: Compute SP $8,000 + EC2 SP $3,000
절감 가능: $2,800/월

해결 방법:
  # AWS Cost Explorer → Savings Plans → Purchase recommendations
  # Compute SP $3,000 추가 구매
  # 커버리지 58% → 74%로 상승
  # On-Demand $4,200 → $1,400으로 절감
```

### [L2-001] Kinesis 'customer-events' Shard 과잉 — $1,029/월

```
심각도: HIGH
서비스: Kinesis
근본 원인: 100 shard 프로비저닝, 7일 CloudWatch 기준 peak 실사용 8 shard
           활용률 8% (shard당 1MB/s 처리 가능)
현재 비용: $1,080/월
최적 비용: $51/월 (6 shard)
절감 가능: $1,029/월

CloudWatch 증거:
  IncomingBytes 24h 평균: ~8MB/s (peak)
  → 필요 shard: ceil(8MB/s) = 8개 → 여유 포함 10개면 충분

해결 방법:
  aws kinesis update-shard-count \
    --stream-name customer-events \
    --target-shard-count 10 \
    --scaling-type UNIFORM_SCALING
  # 또는 On-Demand 모드로 전환 (자동 스케일링)
```

### [L3-003] S3 Cross-Region Replication 과잉 — $184/월

```
심각도: MEDIUM
서비스: S3
근본 원인: dataflow-raw-events 전체 5TB를 us-west-2로 복제
           DR SLA상 필요한 데이터는 최근 30일분 1TB뿐
현재 복제 비용: $230/월
최적 비용: $46/월
절감 가능: $184/월

해결 방법:
  # S3 CRR 규칙에 prefix 필터 추가
  replication_configuration {
    rules {
      filter { prefix = "events/recent/" }  # 최근 30일 데이터만
      status = "Enabled"
    }
  }
```

### [L1-001] DynamoDB 'customer-metadata' 오버프로비저닝 — $99.64/월

```
심각도: HIGH
서비스: DynamoDB
근본 원인: RCU 500, WCU 200 설정 / 실사용 RCU ~12 (활용률 2.4%)
현재 비용: $109.60/월
최적 비용: $9.96/월 (RCU 25, WCU 25 또는 On-Demand)
절감 가능: $99.64/월

해결 방법:
  aws dynamodb update-table \
    --table-name customer-metadata \
    --billing-mode PAY_PER_REQUEST
  # On-Demand 모드: 실사용량만큼만 과금
```

---

## 10. 직접 실행하는 방법

### 사전 준비 (최초 1회)

```bash
# 1. 프로젝트 클론
git clone <repo>
cd cloud-finops-ai

# 2. Python 패키지 설치
pip install boto3 anthropic

# 3. 실행 권한
chmod +x finops.sh
```

### 데모 실행 순서

```bash
# Step 1: VM과 SSH 터널 연결
./finops.sh tunnel
# → "터널 연결 완료! 엔드포인트: http://localhost:14566"

# Step 2: 연결 상태 확인
./finops.sh status
# → "터널 활성화 / MiniStack 응답 정상"

# Step 3: 무료 스캔 (규칙 기반, LLM 없음, ~30초)
./finops.sh scan

# Step 4: Claude AI 심화 분석 (Pro CLI 1회 호출, ~60초)
./finops.sh analyze
```

### 모드별 차이

| 명령 | 분석 방법 | Claude 호출 | 소요 시간 |
|------|----------|------------|----------|
| `./finops.sh scan` | 규칙 + 메트릭 + 아키텍처 | 없음 (완전 무료) | ~30초 |
| `./finops.sh analyze` | 위 + Claude LLM 심화 분석 | Pro CLI 1회 | ~90초 |

### 실제 AWS에 연결하려면?

현재 MiniStack(시뮬레이션) → 실제 AWS로 전환하려면 endpoint만 제거합니다.

```bash
# 현재 (MiniStack)
AWS_ENDPOINT_URL=http://localhost:14566 ./finops.sh scan

# 실제 AWS 전환 (1줄 변경)
AWS_PROFILE=your-company-prod ./finops.sh scan
```

`live_tools.py`의 boto3 코드는 변경 없이 실제 AWS 리소스를 분석합니다.

---

## 부록: 용어 정리

| 용어 | 설명 |
|------|------|
| **FinOps** | Financial Operations — 클라우드 비용을 최적화하는 실무 방법론 |
| **L1/L2/L3** | 탐지 난이도 레벨. L1=설정 분석, L2=메트릭 분석, L3=아키텍처 분석 |
| **오버프로비저닝** | 실제 필요량보다 과도하게 리소스를 할당한 상태 |
| **Savings Plans** | AWS 1~3년 약정 할인 (Compute SP: EC2+Fargate+Lambda 최대 66% 할인) |
| **CRR** | Cross-Region Replication — S3 데이터를 다른 리전에 자동 복제 |
| **Shard** | Kinesis 스트림의 처리 단위. 1 shard = 1MB/s 입력, 2MB/s 출력 |
| **DLQ** | Dead Letter Queue — 처리 실패한 메시지를 보관하는 큐 |
| **MiniStack** | AWS 호환 로컬 클라우드 환경. boto3 endpoint_url만 바꾸면 연결됨 |
| **Tool Use** | Claude가 외부 도구를 자율 호출하는 API 기능 (Agent의 핵심) |
| **SSH 터널** | 암호화된 SSH 연결을 통해 원격 포트를 로컬처럼 사용하는 기법 |

---

*분석 일시: 2026-04-16 / 환경: Gabia Cloud VM (MiniStack 3.0) / AI: Claude Sonnet 4.5*
