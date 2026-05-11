# 시즌 2 — FinOps 시나리오 카탈로그 (실무형)

시즌 1의 40개 단일 시나리오를 베이스로, 시즌 2 8주 커리큘럼 주제에 맞춰 **실무에서 자주 마주치는 복합 / 고난이도 FinOps 시나리오**를 정리했습니다.

> **표기**
> - `M$ 월낭비` — 일반적인 mid-size SaaS(연매출 $50M, AWS bill $30K/mo) 가정 추정치
> - `+S1-NNN` — 시즌 1 시나리오 카탈로그와의 결합 (자세한 패턴은 시즌 1 README 참조)
> - `난이도` — ⭐ 단일 도메인 / ⭐⭐ 복합 / ⭐⭐⭐ 아키텍처 + 정책

---

## Week 2 — 멀티 에이전트 아키텍처 (Multi-domain Fusion)

> 단일 에이전트로는 컨텍스트 한계나 도메인 누락이 발생하는 **다중 도메인 동시 발생** 시나리오.
> "오케스트레이터 + 도메인 전문가" 패턴을 검증하기 좋은 케이스들.

| ID | 시나리오 | 월 낭비 | 난이도 | 구성 |
|----|----------|---------|--------|------|
| MA-001 | Lambda 메모리 + S3 lifecycle + DynamoDB 프로비전 동시 과잉 | $1,400 | ⭐⭐ | +S1-014, +S1-011, +S1-010 |
| MA-002 | ECS Fargate vCPU 과잉 + ALB idle + NAT cross-AZ + warmup 미설정 | $2,800 | ⭐⭐⭐ | +S1-016, +S1-005, +S1-025, +S1-017 |
| MA-003 | EKS pod request 과잉 + ECR lifecycle 없음 + 태그 거버넌스 붕괴 | $5,500 | ⭐⭐⭐ | +S1-038, +S1-009, +S1-031 |
| MA-004 | 데이터 파이프라인 (Kinesis EFO + Lambda timeout + S3 CRR + Athena 무제한) | $3,200 | ⭐⭐⭐ | +S1-022, +S1-015, +S1-037, +S1-023 |
| MA-005 | Multi-account RI family 미스매치 + SP coverage gap + 미통합 | $5,800 | ⭐⭐⭐ | +S1-032, +S1-033, +S1-034 |
| MA-006 | DB fleet (RDS Multi-AZ on dev + 백업 35일 + Read Replica 미활용 + RDS Proxy 없음) | $2,200 | ⭐⭐ | +S1-004, +S1-013, +S1-020, +S1-040 |
| MA-007 | 100+ 리소스 컨텍스트 폭발 — 단일 에이전트는 누락 발생 | varies | ⭐⭐⭐ | context-stress test |

### MA-007 상세 — Context-stress 시나리오
- 가상 회사 인프라: EC2 35개, S3 28개, Lambda 47개, RDS 4개, ElastiCache 6개, Kinesis 3개, SQS 12개
- 그 중 18개에 시즌 1 시나리오 중 하나씩 심어둠
- 단일 에이전트(Claude Code 1개 세션)는 평균 12/18 식별 → recall 67%
- 오케스트레이터 + EC2 전문가 + Storage 전문가 + Network 전문가 + DB 전문가 분할시 평균 17/18 → recall 94%

---

## Week 3 — Cross-Service 결합 낭비 (Coupled Waste)

> 단일 도메인 분석에서는 안 보이는, **서비스 경계를 넘나드는** 낭비 패턴.
> 시즌 2의 핵심 신규 카테고리.

| ID | 시나리오 | 월 낭비 | 난이도 | 패턴 |
|----|----------|---------|--------|------|
| XS-001 | Lambda → S3 GET 폭증 (캐시 없음, 동일 키 매 invocation) | $850 | ⭐⭐ | request + transfer 동시 폭증 |
| XS-002 | EC2 종료 후 잔존 자원 (detached EBS + 미연결 EIP + 미사용 snapshot) | $420 | ⭐⭐ | +S1-001, +S1-003, +S1-007 |
| XS-003 | ECS 다운스케일 후 살아남은 ALB / target group / NAT 처리 capacity | $480 | ⭐⭐ | infra가 워크로드를 못 따라감 |
| XS-004 | SageMaker training 종료 후 endpoint 24/7 실행 | $720 | ⭐⭐ | 학습/추론 lifecycle 비동기 |
| XS-005 | S3 → NAT 경유 접근 (VPC Endpoint 미설정) | $360 | ⭐⭐ | +S1-029 |
| XS-006 | API GW throttle 없음 → Lambda 폭주 → DynamoDB throttle → Lambda retry 폭증 | $1,200 | ⭐⭐⭐ | cascade failure → cost explosion |
| XS-007 | Step Functions polling 패턴 (transition 비용 폭증) | $290 | ⭐⭐ | wait state 잘못 씀 |
| XS-008 | EventBridge → fanout (같은 이벤트가 N개 타깃에 중복 처리) | $640 | ⭐⭐ | event amplification |
| XS-009 | Route53 cross-region health check + ELB cross-zone transfer | $180 | ⭐⭐ | DNS layer transfer |
| XS-010 | Glue ETL → S3 → Athena → S3 cycle (중간 결과 영구 저장) | $550 | ⭐⭐ | data lake 위생 |
| XS-011 | RDS Read Replica가 다른 region에 위치 (transfer 폭증) | $470 | ⭐⭐ | replication direction 실수 |
| XS-012 | CloudFront origin이 EC2 (S3가 아님) — origin egress 누적 | $310 | ⭐⭐ | 캐싱 레이어 잘못 배치 |

---

## Week 4 — Live 환경 분석 (정적 파일 졸업)

> 정적 Terraform/JSON 분석으로는 풀 수 없는, **실시간 API 호출이 필수**인 시나리오.
> boto3 / Cost Explorer / CUR 2.0 / Pricing API / Trusted Advisor / Compute Optimizer 활용.

| ID | 시나리오 | 월 낭비 | 난이도 | 필요 API |
|----|----------|---------|--------|----------|
| LV-001 | 어제부터 비용 30% 폭증 — 원인 서비스/태그 동적 추적 | varies | ⭐⭐ | Cost Explorer + Anomaly Detection |
| LV-002 | Region/AZ별 가격 차이로 인스턴스 배치 재최적화 | $400~ | ⭐⭐ | Pricing API |
| LV-003 | CUR 2.0 일별 ETL — 어제까지 전체 trends 자동 추출 | n/a (insight) | ⭐⭐⭐ | CUR 2.0 + Athena |
| LV-004 | RI utilization 실시간 추적 + 미활용분 권장 | $600~ | ⭐⭐ | RI Coverage/Utilization API |
| LV-005 | Spot interruption 패턴 학습 후 워크로드별 family 추천 | $1,200~ | ⭐⭐⭐ | Spot Advisor + 워크로드 매핑 |
| LV-006 | Trusted Advisor cost checks 동기화 → 자동 ticket | varies | ⭐ | Trusted Advisor |
| LV-007 | Compute Optimizer 권장사항 자동 반영 PR 생성 | $800~ | ⭐⭐ | Compute Optimizer + PR bot |
| LV-008 | Cost Anomaly Detection alert → 자동 root-cause 분석 | varies | ⭐⭐ | Anomaly Detection + CE |
| LV-009 | Last 24h CloudWatch 메트릭 기반 idle 인스턴스 detection | $300~ | ⭐ | CloudWatch GetMetricData |
| LV-010 | 현재 가격 + 사용량 결합 → "지금 변경하면 X 절감" 동적 추천 | varies | ⭐⭐ | Pricing + CE 결합 |

---

## Week 5 — AI 워크로드 (L4)

> 시즌 1에 없던 신규 카테고리. AI/ML 워크로드의 비용 구조는 일반 인프라와 완전히 다름.
> 실제 LLM 운영 / RAG / 학습 파이프라인에서 자주 새는 비용 패턴.

| ID | 시나리오 | 월 낭비 | 난이도 | 도메인 |
|----|----------|---------|--------|--------|
| L4-001 | Bedrock Provisioned Throughput 과잉 (활용률 5%, 평소 5MTU만 필요) | $4,800 | ⭐⭐ | LLM serving |
| L4-002 | SageMaker Endpoint Auto Scaling 미설정 → 야간/주말 24/7 idle | $1,500 | ⭐⭐ | LLM serving |
| L4-003 | GPU 인스턴스 (p4d.24xlarge) 야간 미정지 — 학습 종료 후 살아있음 | $13,200 | ⭐⭐ | Training |
| L4-004 | LLM API 토큰 과금 vs 자체 호스팅 TCO 미비교 (월 100M 토큰) | $3,600 | ⭐⭐⭐ | TCO 판단 |
| L4-005 | 임베딩 캐시 부재 — 동일 텍스트 매번 재호출 | $720 | ⭐⭐ | RAG |
| L4-006 | SageMaker training data가 다른 region → cross-region transfer | $480 | ⭐⭐ | Data locality |
| L4-007 | Bedrock invocation 결과 무한 S3 저장 (lifecycle 없음) | $290 | ⭐ | Output 위생 |
| L4-008 | RAG vector DB OpenSearch 과잉 (m5.4xl x6 → m5.large x3로 충분) | $2,100 | ⭐⭐ | Vector store |
| L4-009 | Multi-modal API — 이미지 base64로 매번 전송 (vision API + cache 미사용) | $1,800 | ⭐⭐ | Multi-modal cost |
| L4-010 | 학습 데이터셋이 여러 S3 location에 중복 (Lake Formation 미사용) | $850 | ⭐⭐ | Data lake |
| L4-011 | Fine-tuning job이 매번 base model 다운로드 (체크포인트 캐시 없음) | $450 | ⭐⭐ | Training optimization |
| L4-012 | Inference batch 미사용 — 단일 요청씩 처리 (Batch Transform 가능한데) | $1,200 | ⭐⭐ | Batch vs realtime |

---

## Week 6 — Shift Left (배포 전 자동 비용 검증)

> 배포된 인프라 분석이 아닌, **PR/Terraform plan 단계에서 사전 차단**할 시나리오.
> GitHub Actions PR bot, OPA/Conftest, `terraform plan` 분석.

| ID | 시나리오 | 검증 시점 | 정책 | 권장 액션 |
|----|----------|----------|------|-----------|
| SL-001 | NAT Gateway 신규 추가 (월 $33 + 트래픽) | PR | warn | PR comment에 월 예상 비용 |
| SL-002 | RDS Multi-AZ on dev env (Env=dev 태그) | PR | reject | OPA 정책 위반 |
| SL-003 | EC2 instance family upgrade (m5.4xl → m5.24xl) | PR | warn | 4배 비용 경고 |
| SL-004 | S3 bucket lifecycle 미설정 (신규) | PR | reject | Conftest fail |
| SL-005 | CloudWatch Logs retention 없음 (영구 저장) | PR | reject | retention 90d 기본값 강제 |
| SL-006 | 필수 태그 누락 (Project/Owner/Env/CostCenter) | PR | reject | tag policy |
| SL-007 | RDS backup_retention_period > 14 on non-prod | PR | warn | 환경별 정책 |
| SL-008 | Lambda 메모리 > 4096 (Power Tuning 미수행) | PR | warn | 자동 PR로 Power Tuning 결과 제안 |
| SL-009 | 인터넷 노출 ALB + CloudFront 미설정 | PR | warn | egress 비용 비교 코멘트 |
| SL-010 | Spot 가능 워크로드를 On-Demand로 정의 (batch/dev) | PR | warn | Spot 전환 PR 제안 |
| SL-011 | Reserved Instance / SP 커버리지 < 50%인 family 추가 구매 | PR | warn | 기존 RI에 맞춰 family 변경 권장 |
| SL-012 | DynamoDB Provisioned 모드 신규 (On-Demand가 더 싸도) | PR | warn | 워크로드 패턴 비교 |
| SL-013 | EKS pod resource request > 측정 사용량의 200% | PR | warn | rightsizing |
| SL-014 | GPU 인스턴스 + auto-shutdown 미설정 | PR | reject | nightly shutdown 강제 |
| SL-015 | EBS volume type = gp2 (gp3가 더 싸고 빠름) | PR | warn | gp3 자동 PR |

### Shift Left 결합 시나리오 (난이도 ↑)

| ID | 결합 패턴 | 권장 |
|----|----------|------|
| SL-COMBO-1 | SL-001 + SL-006 + SL-009 (인터넷 노출 새 서비스 + 태그 누락 + NAT 추가) | 신규 서비스 launch checklist 자동 검증 |
| SL-COMBO-2 | SL-002 + SL-007 + SL-014 (dev에 prod급 설정 다수) | env 정책 일괄 검증 |

---

## Week 7 — 멀티 클라우드 + FOCUS 1.1

> AWS 단일 → GCP / Azure 확장. FOCUS 1.1로 비용 표준화.

| ID | 시나리오 | 월 낭비 | 난이도 | 클라우드 |
|----|----------|---------|--------|----------|
| MC-001 | 같은 웹앱이 AWS + GCP 동시 운영 — 단가 비교 후 한쪽 통합 | $1,800 | ⭐⭐ | AWS+GCP |
| MC-002 | Azure Reserved vs AWS SP TCO 비교 (3년 약정 워크로드) | $2,400 | ⭐⭐⭐ | AWS+Azure |
| MC-003 | FOCUS 1.1로 AWS CUR + GCP Billing + Azure CDF 통합 normalize | n/a (insight) | ⭐⭐⭐ | All |
| MC-004 | Egress 비용 비교 (AWS NAT vs GCP egress vs Azure outbound) | $900 | ⭐⭐ | All |
| MC-005 | EKS vs GKE vs AKS — 동일 워크로드 TCO | $1,400 | ⭐⭐⭐ | All |
| MC-006 | S3 vs GCS vs Azure Blob lifecycle + 비용 비교 | $620 | ⭐⭐ | All |
| MC-007 | Multi-cloud DR (primary AWS, DR Azure) — replication frequency 최적화 | $1,100 | ⭐⭐⭐ | AWS+Azure |
| MC-008 | LLM 멀티 프로바이더 (Bedrock vs Vertex vs Azure OpenAI) 토큰 비용 | $2,200 | ⭐⭐ | All |
| MC-009 | Cross-cloud VPN/Interconnect 비용 비교 | $480 | ⭐⭐ | All |
| MC-010 | FOCUS 표준에 없는 클라우드 특화 비용 (예: AWS Transit Gateway, Azure ExpressRoute) 매핑 | n/a | ⭐⭐⭐ | All |

---

## 보너스 — Week 1 / Week 8 참고용

### Week 1 (FinOps 핵심) 학습용 추천 시나리오
시즌 1 카탈로그의 **L1-001 ~ L1-013** 중 5~7개를 골라 해부해보는 워크샵 형태로 사용. 단순 패턴부터 시작해서 도메인 감 잡기.

### Week 8 (결과 발표) 데모용 핵심 시나리오
각자 자기 도구로 다음을 시연:
- MA-002 또는 MA-005 (멀티 도메인 분석 능력)
- XS-006 또는 XS-008 (cross-service 분석 능력)
- L4-001 ~ L4-003 (AI 워크로드 대응)
- SL-COMBO-1 (Shift Left 통합 데모)

---

## 시나리오 활용 가이드

### 매주 출제 시 권장 조합

| 주차 | 권장 시나리오 수 | 난이도 분포 |
|------|-----------------|-------------|
| Week 2 | MA-001 ~ MA-003 중 1개 (개인별 다른 것) | ⭐⭐ ~ ⭐⭐⭐ |
| Week 3 | XS-001 ~ XS-005 중 2개 결합 | ⭐⭐ |
| Week 4 | LV-001 + LV-004 또는 LV-002 + LV-007 | ⭐⭐ |
| Week 5 | L4-001 ~ L4-003 중 1개 + L4-005 또는 L4-008 | ⭐⭐ |
| Week 6 | SL-001 ~ SL-010 중 3개 + SL-COMBO 중 1개 | ⭐ ~ ⭐⭐⭐ |
| Week 7 | MC-003 (FOCUS 표준화) + MC-004 또는 MC-008 | ⭐⭐⭐ |

### 시즌 1 시나리오와 결합 권장 패턴

```
시즌 1 단일 시나리오 ──┐
                       ├─→ 시즌 2 복합 시나리오 (난이도 ↑)
시즌 2 신규 도메인 ────┘
```

예) `L1-001(중지 EC2 EBS) + L1-003(미연결 EIP) + L1-007(오래된 snapshot)` → `XS-002` 로 결합하면 단일 도메인 정답률 90% → 결합시 60%로 떨어지면서 **cross-service 분석의 필요성**을 체감.

---

## 참고

- 시즌 1 시나리오 카탈로그: 시즌 1 [09th-ai-cloud-finops/README.md](https://github.com/cloud-club/09th-ai-cloud-finops/blob/main/README.md#시나리오-카탈로그)
- 시즌 1 패턴 가이드: [09th-ai-cloud-finops/platform/docs/scenarios-guide.md](https://github.com/cloud-club/09th-ai-cloud-finops/blob/main/platform/docs/scenarios-guide.md)
- 본 문서는 v0.1 — 스터디 진행 중 추가/조정될 예정
