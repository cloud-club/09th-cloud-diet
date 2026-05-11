# Week 6 — Shift Left (PR 사전 차단)

> 이 문서는 [시즌 2 시나리오 카탈로그 v1.0](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md)의 **Week 6** 섹션입니다.
> 각 시나리오는 시즌 1과 동일한 6개 차원 (상황 / 청구서 모양 / 왜 안 보이는지 / 가격 수식 / 탐지 / 해결 후 변화)으로 구성되었습니다.

---

## Week 6 — Shift Left (PR 사전 차단)

> 각 항목은 실제 PR diff + 자동 분석 + OPA 정책 형태로 정리.

---

### SL-001 · 신규 NAT Gateway 추가

```hcl
# PR diff
+ resource "aws_nat_gateway" "staging" {
+   allocation_id = aws_eip.nat.id
+   subnet_id     = aws_subnet.public.id
+ }
```

**자동 분석 (PR comment)**
```
[Cost Impact]
- Fixed: $32.85/월 (730h × $0.045)
- Traffic: $0.045/GB (staging 일평균 5GB egress 추정)
- Monthly estimate: $40-50

[Suggestion]
S3/DynamoDB 트래픽이면 VPC Endpoint(무료) 분리 검토
```

**OPA 정책**
```rego
warn[msg] {
    input.resource_changes[_].type == "aws_nat_gateway"
    msg := "NAT Gateway 추가됨. VPC Endpoint로 대체 가능 여부 검토 필요"
}
```

---

### SL-002 · dev RDS Multi-AZ enable

```hcl
- multi_az = false
+ multi_az = true
```

**자동 분석**
```
[Cost Impact]
db.r6g.large $0.276/h × Multi-AZ 2x = $0.552/h
24h × 30 추가 비용: $201/월
[Policy Violation]
Env=dev tag + multi_az=true 충돌
```

**OPA 정책**
```rego
deny[msg] {
    rc := input.resource_changes[_]
    rc.type == "aws_db_instance"
    rc.change.after.tags.Env == "dev"
    rc.change.after.multi_az == true
    msg := "dev 환경에 Multi-AZ 활성화 불가. 정책 위반."
}
```

---

### SL-003 · EC2 instance family upgrade

```hcl
- instance_type = "m5.4xlarge"
+ instance_type = "m5.24xlarge"
```

**자동 분석**
```
[Cost Impact]
$0.768/h → $4.608/h (6x)
24/7: $560 → $3,364/월 (+$2,800)

[Compute Optimizer Check]
이 인스턴스 ID에 대한 권장: m5.xlarge (CPU p99 < 30%)
업그레이드 반대 권장.
```

---

### SL-004 · 신규 S3 bucket without lifecycle

```hcl
+ resource "aws_s3_bucket" "data" { bucket = "..." }
# lifecycle_rule 없음
```

**자동 분석 + 자동 PR**
```
[Policy Violation: mandatory lifecycle]
1년 후 누적 추정 비용: $300-500/월 (사용 패턴 기반)

[Auto-generated fix]
+ resource "aws_s3_bucket_lifecycle_configuration" "data" {
+   rule {
+     id     = "default"
+     status = "Enabled"
+     transition { days = 30  storage_class = "STANDARD_IA" }
+     transition { days = 90  storage_class = "GLACIER_IR" }
+     transition { days = 365 storage_class = "DEEP_ARCHIVE" }
+   }
+ }
```

---

### SL-005 · CloudWatch Logs retention 미설정

```hcl
+ resource "aws_cloudwatch_log_group" "app" {
+   name = "/aws/lambda/app"
+ }
# retention_in_days 없음
```

**자동 분석**
```
[Policy Violation]
default = Never expire. 영구 누적 시 $0.5/GB Standard
[Required]
retention_in_days 설정 (환경별: prod 90, staging 30, dev 7)
```

---

### SL-006 · 필수 태그 누락

```hcl
+ resource "aws_lb" "public" { ... }
# tags = {} 비어있음
```

**자동 분석**
```
[Missing required tags]
Project, Owner, Env, CostCenter

[Impact]
cost allocation 불가능 → "Untagged" 풀로 분류
연간 unallocated spend 추정: $50K (현재 untagged 비율 12%)
```

---

### SL-007 · RDS backup_retention_period 과잉

```hcl
+ backup_retention_period = 35
```

**환경별 정책**
```rego
warn[msg] {
    rc := input.resource_changes[_]
    rc.type == "aws_db_instance"
    rc.change.after.tags.Env == "dev"
    rc.change.after.backup_retention_period > 1
    msg := sprintf("dev에 %d일 backup. 권장 1일.", [rc.change.after.backup_retention_period])
}
```

---

### SL-008 · Lambda 메모리 > 4096 without Power Tuning 결과

```hcl
+ memory_size = 10240
```

**자동 분석**
```
[Power Tuning 결과 없음]
이 함수에 대한 power tuning 실행 권장
일반적으로 1024-2048MB가 가장 비용 효율

[Suggestion]
AWS Lambda Power Tuner 실행 후 결과 PR body에 첨부
```

---

### SL-009 · 인터넷 노출 ALB without CloudFront

```hcl
+ resource "aws_lb" "public" {
+   internal = false
+   ...
+ }
# CloudFront distribution 없음
```

**자동 분석**
```
[Egress Comparison]
Direct ALB: $0.09/GB
CloudFront: $0.0085/GB (10x 차이)

월 100GB egress 가정: $9 vs $90
1TB: $90 vs $900
```

---

### SL-010 · Spot 가능 워크로드 → On-Demand

```hcl
+ resource "aws_instance" "batch" {
+   instance_type = "c5.4xlarge"
+   tags = { Workload = "batch", Env = "prod" }
+ }
# spot_price 없음
```

**자동 분석**
```
[Workload Pattern]
Workload=batch tag 감지 → spot 적합 candidate
spot 가격 (최근 30일): $0.213/h 평균 (on-demand $0.68 대비 68% 절감)
interruption rate: 2.1% (low risk)

[Auto-generated PR]
spot mixed-instance fleet 변환 diff
```

---

### SL-011 · RI/SP 커버리지 낮은 family에 추가 구매

```hcl
+ instance_type = "m5.large"  # 새 인스턴스 type
```

**자동 분석**
```
[Current RI/SP Coverage]
m5 family: 30% coverage (낮음, SP 추가 안 사면 OD로 청구)
c5 family: 85% coverage (높음)

[Suggestion]
같은 워크로드를 c5.large로 변경 → 기존 SP 활용
또는 m5 추가 SP 구매 (월 commit $200 권장)
```

---

### SL-012 · DynamoDB Provisioned without 검토

```hcl
+ billing_mode = "PROVISIONED"
+ read_capacity = 100
+ write_capacity = 100
```

**자동 분석**
```
[Pattern Unknown]
새 테이블 + provisioned + 워크로드 패턴 모름
On-demand 권장 (초기 1-2개월 패턴 학습)

[비용 비교]
Provisioned 100/100 RCU/WCU 고정: $90/월
On-demand: 실제 사용량 기반 (변동, 평균 사례 $40-60/월)
```

---

### SL-013 · EKS pod resource request 과잉

```yaml
# k8s manifest in PR
resources:
  requests:
    cpu: 1
    memory: 2Gi
```

**자동 분석 (VPA/Goldilocks recommendation 통합)**
```
[Actual Usage from VPA Recommender]
p99 CPU: 0.2 (요청의 20%)
p99 Memory: 500Mi (요청의 25%)

[Suggestion]
requests.cpu: 250m, memory: 750Mi
pod density 5x 증가 가능, 노드 수 80% 감소 예상
```

---

### SL-014 · GPU instance without auto-shutdown

```hcl
+ resource "aws_instance" "training" {
+   instance_type = "p4d.24xlarge"
+ }
# autoshutdown tag 또는 schedule 없음
```

**OPA 정책 (reject)**
```rego
deny[msg] {
    rc := input.resource_changes[_]
    rc.type == "aws_instance"
    startswith(rc.change.after.instance_type, "p4d")
    not rc.change.after.tags.autoshutdown
    msg := "GPU 인스턴스는 autoshutdown tag 필수"
}
```

---

### SL-015 · gp2 EBS volume type

```hcl
+ volume_type = "gp2"
```

**자동 분석 + 자동 PR**
```
[Suggestion]
gp3는 gp2 대비 20% 저렴 + 더 빠름 (baseline 3000 IOPS)
다운타임 없이 modify-volume 가능

[Auto PR]
- volume_type = "gp2"
+ volume_type = "gp3"
```

---

### SL-COMBO-1 · 신규 public service launch (SL-001 + SL-006 + SL-009)

**상황**
PR 제목: "Add new public API service" — ALB internet-facing + NAT GW + Lambda 동시 추가

**종합 분석 (launch checklist)**
```
[Issues]
1. NAT Gateway 추가 (월 $33 + 트래픽) — SL-001
2. 필수 태그 4개 누락 — SL-006
3. ALB internet-facing + CloudFront 미설정 — SL-009

[Cost Estimate (월)]
NAT fixed:           $33
NAT traffic:         $50 (10GB/일 추정)
ALB:                 $25
ALB egress (no CF): $450 (5TB/월 가정)
─────────────────
Total:              $558/월

[CloudFront 도입 시]
ALB egress → CF egress: -$408
NAT 검토 후 VPC Endpoint 가능: -$30
─────────────────
Optimized:          $120/월 (78% 절감)
```

---

### SL-COMBO-2 · dev에 prod급 설정 다수 (SL-002 + SL-007 + SL-014)

**상황**
PR 제목: "Mirror prod config to dev" — copy-paste로 prod terraform을 dev로 복사

**종합 분석**
```
[Issues]
1. RDS Multi-AZ on dev (SL-002) — reject
2. backup_retention 35d on dev (SL-007) — warn
3. GPU instance autoshutdown 없음 (SL-014) — reject

[Pattern]
dev 환경 정책 위반 다수 → 환경별 정책 강제 필요
권장: terragrunt 또는 module variant로 환경별 default 분리
```

---