# 시즌 2 — FinOps 시나리오 47선

시즌 1의 [40선](https://github.com/cloud-club/09th-ai-cloud-finops/blob/main/platform/docs/scenarios-guide.md)과 같은 깊이로, 시즌 2의 8주 커리큘럼 주제(멀티 에이전트 / Cross-Service / Live 환경 / AI 워크로드 / Shift Left / 멀티 클라우드)에 맞춰 실무에서 자주 마주치는 함정들을 정리.

> 각 시나리오의 **상황 / 청구서 모양 / 가격 수식 / 탐지 방법 / 해결 후 변화**는 [SCENARIOS_S2_DETAILED.md](SCENARIOS_S2_DETAILED.md)에서 6개 차원으로 풀어둠.

---

## 🟦 Week 2 — 멀티 에이전트 fusion (7개)

> 단일 에이전트로는 컨텍스트 한계나 도메인 누락이 발생하는 케이스. 오케스트레이터 + 도메인 전문가 패턴이 필요한 시나리오.

| # | 시나리오 | 설명 |
|---|---------|------|
| MA-001 | **Lambda + S3 + DDB 결합** | 3 도메인 동시 발생. 단일 에이전트는 컨텍스트 65K tok 초과로 후반 도메인 recall 30%. 멀티 에이전트 분할시 92%. DDB 전문가가 Lambda 호출 패턴을 cross-query하는 emergent finding. |
| MA-002 | **ECS + ALB + NAT 경계** | "ALB idle"과 "NAT 폭증"이 같은 service-X 때문이라는 결론은 Network·Compute 전문가의 cross-question에서만 도출. 단일 에이전트는 두 line item을 별개 사건으로 분류. |
| MA-003 | **EKS + ECR + Tag 거버넌스** | pod request 과잉 진단은 단일도 가능. 하지만 "왜 그렇게 됐나"는 Registry pull frequency + tag coverage cross-분석이 필요. |
| MA-004 | **데이터 파이프라인 4-도메인** | Kinesis EFO + Lambda timeout + S3 CRR + Athena 무제한이 chain reasoning으로 연결됨. "Lambda timeout이 backlog 만들어 Athena scan 패턴 변경"을 단일 에이전트는 못 잡음. |
| MA-005 | **Multi-account RI / SP / 미통합** | 1개 계정 분석으론 정상으로 보이는 RI 구매가, 12 계정 cross-비교시 idle 발견. Org RI sharing 도입으로 $1,875/월 추가 절감. |
| MA-006 | **RDS Fleet 진단** | RDS Proxy 부재 영향은 Lambda concurrency 같이 봐야 결론. DB · Backup · Application 3 전문가 협업으로 r6g.4xlarge → r6g.large 다운사이즈 가능 확인. |
| MA-007 | **Context-stress (100+ 리소스)** | main.tf 5,000줄 + cost_report 100+ services. 단일 에이전트 recall 43%, 멀티 에이전트 병렬 분석시 90%. 분석 시간 wall clock 비슷 (병렬 덕). |

---

## 🟪 Week 3 — Cross-Service 결합 낭비 (12개)

> 단일 도메인 분석으로는 안 잡히는 패턴. Lambda만 봐도, S3만 봐도 정상으로 보이는 함정.

| # | 시나리오 | 설명 |
|---|---------|------|
| XS-001 | **Lambda → S3 GET 폭증** | 매 invocation 80MB 카탈로그 S3 GET. 캐시 없음. S3 line item은 storage만 보고 request 비용은 놓침. Duration도 "트래픽 4배 늘었으니 당연"으로 합리화. 합 $3,100/월. |
| XS-002 | **EC2 종료 후 잔존 자원** | detached EBS + unassociated EIP + orphan snapshot. 원래 owner EC2 정보 손실되어 cost allocation 안 됨. 평균 $2,544/월. (S1-001+S1-003+S1-007 fusion) |
| XS-003 | **ECS 다운스케일 후 살아남은 인프라** | Black Friday 후 task는 100으로 복귀했는데 ALB·target group·NAT capacity는 콘솔 추가분이라 남음. $316/월. (S1-005 root cause 추적) |
| XS-004 | **SageMaker training 후 endpoint 24/7** | training은 spike형이라 alarm 있는데 endpoint는 steady-state라 정상 budget으로 인식. 야간·주말 invocation 0인데 70% idle. $1,545/월 낭비. |
| XS-005 | **S3 → NAT 경유 (Gateway Endpoint 미설정)** | data fleet의 2TB/일 분석이 NAT 경유. Gateway Endpoint는 무료인데 잊음. $2,700/월 → $0. (S1-029 확장) |
| XS-006 | **API GW → Lambda → DDB cascade** | API GW throttle 없음 + DDB ProvisionedThroughputExceeded + Lambda retry. 같은 요청 1~4회 반복 처리되어 cost 4x amplification. 캠페인 1주에 $18,375 손실. |
| XS-007 | **Step Functions polling 폭증** | 100 워크플로우 × 30초 Wait state polling. transition rate가 visual editor에선 안 보임. 28.8M transition/월 = $720/월. EventBridge callback으로 $40로. |
| XS-008 | **EventBridge fanout 중복 처리** | OrderCreated → 8 lambda target 중 3개가 같은 notification provider 호출. 사용자에게 알림 3번 + downstream API $2,000/월 중복 결제. |
| XS-009 | **Route53 + NLB cross-zone** | 3 region × 20 endpoint × 3 checker = 180 check. NLB cross-zone은 $0.01/GB (ALB는 무료). DataTransfer-Regional-Bytes로 뭉뚱그려짐. $990/월. |
| XS-010 | **Glue → S3 → Athena 데이터 레이크 위생** | 중간 결과 lifecycle 없음 + partition 없는 반복 scan. 6개월 누적 $1,937/월. lake 청소 책임 불분명. (S1-023+S1-035) |
| XS-011 | **RDS Read Replica가 cross-region** | DR용 cross-region replica를 dev팀이 read query로 misuse. replication transfer + app cross-region query 이중 transfer. $254~$1,300/월. |
| XS-012 | **CloudFront origin이 EC2** | CloudFront는 있는데 origin이 S3 아닌 EC2 → cache miss마다 EC2 egress $0.09/GB. cache hit ratio 모니터링 안 함. 100TB/월 기준 $4,000/월. |

---

## 🟧 Week 4 — Live 환경 분석 (8개)

> 정적 Terraform/JSON으로는 절대 못 풀어서 실시간 AWS API가 필수인 케이스.

| # | 시나리오 | 설명 / 필요 Live API |
|---|---------|------|
| LV-001 | **어제부터 발생한 비용 spike** | Anomaly가 일어난 시점부터의 hourly 데이터 필요. CUR은 stale. → `ce:GetCostAndUsage` Hourly + `ce:GetAnomalies` |
| LV-002 | **Region/AZ 가격 차이 활용** | spot price는 분 단위 변동, 정적 catalog는 outdated. 워크로드 SLA 충족 region 후보군에서 자동 선택. → Pricing API + DescribeSpotPriceHistory |
| LV-003 | **CUR 2.0 hourly + tag dimension** | "이번 주에 tag 바뀐 리소스의 24h 비용" 같은 multi-dim 쿼리. daily aggregate JSON으론 불가. → CUR 2.0 + Athena |
| LV-004 | **RI utilization 실시간 추적** | utilization 시간 단위 변동. 70% 미만 RI는 sell/modify 자동 권장. → GetReservationUtilization/Coverage |
| LV-005 | **Spot interruption 패턴 학습** | family·region·AZ별 interruption rate 매주 변동. 워크로드 SLA에 매칭. → Spot Advisor + 30일 spot history |
| LV-006 | **Trusted Advisor 자동 ticket** | TA cost check 결과는 매번 다른 finding. new issue만 Jira 자동 생성. → `support:DescribeTrustedAdvisorCheckResult` |
| LV-007 | **Compute Optimizer → PR 자동** | 권장사항은 14일 metric 기반 동적. Terraform PR로 자동 제출. → `compute-optimizer:GetEC2InstanceRecommendations` |
| LV-008 | **Anomaly Detection → root cause** | anomaly별로 dimension breakdown + CloudTrail 시각 매칭으로 자동 root cause 가설. → ce:GetAnomalies + CloudTrail LookupEvents |

---

## 🟥 Week 5 — AI 워크로드 (L4 신규 도메인, 12개)

> 시즌 1에 없던 카테고리. LLM·Training·RAG·Fine-tuning 비용 구조는 일반 인프라와 완전히 다름.

| # | 시나리오 | 설명 |
|---|---------|------|
| L4-001 | **Bedrock PT 과잉** | 출시 전 영업이 "런칭 대비" 5MU PT 약정 구매. 실제 사용 0.5MU. 약정이라 "고정비" 인식, on-demand 대비 단가 절감만 보고 활용률 안 봄. $16,710/월 낭비. |
| L4-002 | **SageMaker Endpoint Auto Scaling 미설정** | ml.g4dn.xlarge × 2, 야간·주말 invocation 0인데 24/7. ML 모니터링은 training spike 위주, endpoint는 steady-state라 baseline 인식. $752/월 idle. |
| L4-003 | **GPU 야간 미정지** | p4d.24xlarge ($32.77/h) 매일 6h만 학습, 18h idle. GPU 비용은 큰 금액이라 alarm 있지만 idle 시간 비율은 안 봄. $17,696/월 낭비. |
| L4-004 | **LLM API vs self-host TCO 미비교** | 100M input + 30M output token = $750. 10x 성장 후엔 self-host TCO < API ($6,632 vs $7,500). cross-over 분석 안 하면 모름. |
| L4-005 | **임베딩 캐시 부재 (RAG)** | FAQ 챗봇이 같은 질문 5,000회/일 매번 임베딩. 단가 낮아 보여 캐시 우선순위 떨어짐. 10x 성장 + completion 캐시 시 90% 절감 ($10K → $1K). |
| L4-006 | **Cross-region training data** | 데이터셋 us-east-1, 학습 us-west-2 SageMaker. job마다 5TB 재다운로드. GPU 비용에 묻혀 transfer 누락. $90,000/월. |
| L4-007 | **Inference 결과 무한 S3 저장** | Bedrock 호출 결과 audit 명목 lifecycle 없음. "compliance" 면죄부로 검토 안 함. 1년 누적 73TB = $1,679/월 (계속 증가). |
| L4-008 | **RAG vector DB OpenSearch 과잉** | m5.4xlarge × 6 초기 sizing 후 재검토 X. 실제 인덱스 200GB, QPS 50. m5.large × 3로 충분. $1,288/월 낭비. |
| L4-009 | **Multi-modal API base64 매번** | 같은 이미지가 prompt마다 1500 token씩 재인코딩. text token만 모니터링하면 multi-modal cost 묻힘. 100K image/일 = $13,500/월. |
| L4-010 | **학습 데이터셋 S3 중복** | 데이터팀 4명이 각자 prefix에 같은 10TB raw dataset 복사. owner 별개라 분산되어 보임. Lake Formation으로 통합시 $920 → $230. |
| L4-011 | **Fine-tuning 매번 base 다운로드** | Llama 3.1 70B (~140GB)를 매일 학습 시작마다 S3에서 받음. instance idle prep 30분. multi-instance면 $1,964/월. FSx Lustre 캐시로 해결. |
| L4-012 | **Inference batch 미사용** | 100만 user 일일 추천을 LLM API 1명씩 순차 호출. Bedrock Batch API (50% off) 모름. $3,450/월 절감 가능. |

---

## 🟫 Week 6 — Shift Left (PR 사전 차단, 15개 + COMBO 2개)

> 배포 후 분석이 아닌, PR/Terraform plan 단계에서 사전 reject·warn. 각 시나리오는 PR diff + 자동 분석 코멘트 + OPA 정책 형태.

| # | 시나리오 | 정책 | 설명 |
|---|---------|------|------|
| SL-001 | **NAT Gateway 신규 추가** | warn | 월 $33 fixed + traffic. VPC Endpoint로 대체 가능 여부 PR comment. |
| SL-002 | **dev RDS Multi-AZ enable** | reject | Env=dev tag + multi_az=true 충돌. OPA Rego deny. dev에 HA 불필요. |
| SL-003 | **EC2 family upgrade (m5.4xl → m5.24xl)** | warn | 비용 6x 증가. Compute Optimizer 권장 검증 후 진행. |
| SL-004 | **S3 bucket without lifecycle** | reject | 1년 후 $300~$500/월 누적 예상. 자동 lifecycle PR로 fix 제안. |
| SL-005 | **CloudWatch Logs retention 없음** | reject | default Never. 환경별 default (prod 90 / staging 30 / dev 7) 강제. |
| SL-006 | **필수 태그 누락** | reject | Project/Owner/Env/CostCenter. 누락시 unallocated spend로 분류. |
| SL-007 | **RDS backup_retention > 환경 기준** | warn | dev 1d / staging 7d / prod 14d 권장. 35는 prod에서도 과잉. |
| SL-008 | **Lambda memory > 4096 without Power Tuning** | warn | 1024~2048MB가 보통 cost-optimal. Power Tuning 결과 첨부 요청. |
| SL-009 | **인터넷 노출 ALB without CloudFront** | warn | direct egress $0.09 vs CloudFront $0.0085 (10x). ROI 분석 코멘트. |
| SL-010 | **Spot 가능 워크로드를 OD로** | warn | Workload=batch tag 감지시 자동 spot mixed-fleet PR 제안. |
| SL-011 | **RI/SP coverage 낮은 family 추가** | warn | 기존 family로 변경 권장 또는 추가 SP 구매 검토. |
| SL-012 | **DDB Provisioned 신규 (검증 X)** | warn | 패턴 모를 때는 on-demand로 시작 후 학습. |
| SL-013 | **EKS pod request 과잉 (>200% 실사용)** | warn | VPA recommender 결과로 right-size 제안. pod density 5x 가능. |
| SL-014 | **GPU instance without autoshutdown** | reject | tags.autoshutdown 필수. 24/7 가동시 p4d 월 $23,920. |
| SL-015 | **gp2 EBS volume** | warn | gp3가 20% 저렴 + 더 빠름. 자동 PR로 전환. |
| SL-COMBO-1 | **public service launch (SL-001+006+009)** | review | 인터넷 노출 신규 서비스 launch checklist 통합 검증. 최적화 시 $558 → $120/월. |
| SL-COMBO-2 | **dev에 prod급 설정 (SL-002+007+014)** | review | env 정책 위반 다수. terragrunt module variant로 환경별 default 분리 권장. |

---

## 🟨 Week 7 — 멀티 클라우드 + FOCUS 1.1 (8개)

> 단순 비교가 아니라 multi-cloud 도입으로 **오히려 비용 증가한** 실제 함정 케이스.

| # | 시나리오 | 설명 |
|---|---------|------|
| MC-001 | **AWS + GCP egress 함정** | 50:50 Route53 split. GCP Premium egress $0.12 > AWS $0.09. single-cloud 대비 $750/월 추가. "GCP가 컴퓨트 더 싸 보임"이 진짜 비용이 아님. |
| MC-002 | **Azure RI + AWS SP 이중 commit** | migration 중 약정 잔여 + 새 약정 동시 lock-in. 워크로드 이동 빠르면 idle SP commit $4,300/월. 약정 잔여 18개월 총 $77,400 손실. |
| MC-003 | **FOCUS 1.1 unmapped 20%** | 표준화 후 "이제 통합 가능"이라 안심하는데 unmapped(TGW, ExpressRoute, Premium Tier 등)가 $6K. ChargeCategory에 명시 표시 필요. |
| MC-004 | **Multi-cloud DR이 더 비쌈** | AWS → Azure 1TB/일 replication = $2,700/월. AWS multi-region이면 $600. "risk 분산" 명분에 비용 검증 약함. $25,200/년 차이. |
| MC-005 | **EKS / GKE / AKS TCO 함정** | control plane만 비교 (AKS 무료)하면 함정. cross-zone traffic, LB, registry 합산하면 AKS가 비싼 case 흔함. 7개 카테고리 합산 필요. |
| MC-006 | **Object storage lifecycle 차이** | 같은 정책을 S3/GCS/Blob 동일 적용. Azure Blob은 transition op마다 $0.10/10K op. 100M object × monthly transition = $1,000/월 추가 (S3는 0). |
| MC-007 | **LLM 멀티 프로바이더 routing 부재** | Claude / GPT-4 / Gemini 동시 사용. 같은 task 가격 차이 5x. tiered routing (simple → Flash, complex → Sonnet)으로 $8,000 → $581 (93% 절감). |
| MC-008 | **Cross-cloud Interconnect 이중 commit** | DX + ExpressRoute + Cloud Interconnect 동시 운영. 실제 cloud↔on-prem만 사용하는데 cloud간 link도 fixed cost. 미사용 link 해지. |

---

## 📊 요약

| 주차 | 카테고리 | 시나리오 수 | 시즌 1 결합 패턴 |
|------|---------|:---:|------|
| **Week 2** | Multi-Agent Fusion | 7 | S1 시나리오 2~4개씩 결합한 multi-domain 케이스 |
| **Week 3** | Cross-Service Coupled Waste | 12 | 서비스 경계 넘는 새 도메인 + S1 일부 확장 |
| **Week 4** | Live Environment Analysis | 8 | API 호출이 필수 (정적 분석 불가) |
| **Week 5** | AI Workload (L4) | 12 | 신규 도메인 — Bedrock / SageMaker / GPU / RAG |
| **Week 6** | Shift Left | 17 | 사전 차단 (PR + OPA), 시나리오 + 정책 |
| **Week 7** | Multi-cloud + FOCUS | 8 | multi-cloud 실전 함정 (비교 X) |
| **합계** | | **47** | |

> **시즌 1 vs 시즌 2 차이**
> 시즌 1은 단일 도메인 패턴 40선이었다면, 시즌 2는 **결합·시간축·도메인 확장·정책 자동화** 4가지 새 축에서 함정을 다룬다.
> 각 시나리오 상세(상황 / 청구서 모양 / 가격 수식 / 탐지 / 해결 후 변화)는 [SCENARIOS_S2_DETAILED.md](SCENARIOS_S2_DETAILED.md) 참조.

---

## 매주 출제 시 권장 조합

| 주차 | 출제 수 | 권장 |
|------|:---:|------|
| Week 1 | (시즌 1 L1 5~7개 학습) | 도메인 감 잡기 |
| Week 2 | 1개 (MA-001~003 중) | 멀티 도메인 fusion |
| Week 3 | 2개 (XS-001~012 cross-pair) | Lambda↔Storage + Network↔Compute 같은 |
| Week 4 | 1개 (LV-001~008 중) | Live API 활용 강제 |
| Week 5 | 2개 (L4-001~012 중) | AI 도메인 신규 |
| Week 6 | 3~5개 SL + 1 COMBO | Shift Left 통합 |
| Week 7 | 1~2개 (MC-001~008 중) | Multi-cloud 실전 |
| Week 8 | 종합 시연 | 8주 학습 발표 |

8명 멤버 기준, 같은 주차라도 다른 시나리오 배정해서 코드 리뷰 시 비교 가능하도록 출제.

---

## 참고

- 시즌 1 카탈로그: [09th-ai-cloud-finops/platform/docs/scenarios-guide.md](https://github.com/cloud-club/09th-ai-cloud-finops/blob/main/platform/docs/scenarios-guide.md)
- 시즌 2 상세본: [SCENARIOS_S2_DETAILED.md](SCENARIOS_S2_DETAILED.md)
- AWS Pricing API · Compute Optimizer · FOCUS 1.1: 본 카탈로그 Week 4 / 7 섹션 참조
