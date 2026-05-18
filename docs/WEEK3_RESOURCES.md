# Week 3 — Cross-Service 결합 낭비 분석 학습 자료

> 이번 주차 목표: 단일 도메인 분석으로 안 보이는 **서비스 경계를 넘나드는 낭비** 패턴을 발견하는 도구·방법론 학습.
> 본인 도구에 cross-service analyzer 모듈을 추가하는 게 산출물.

---

## 🎯 이번 주차에서 가져가야 할 것

1. **NAT/VPC Endpoint 가격 구조** — Lambda↔S3, EC2↔S3, ECS↔NAT 같은 cross-service 트래픽이 어디서 어떻게 과금되는지
2. **Cost Explorer + Cost Anomaly Detection 드릴다운** — single line item에서 cross-service root cause로 내려가는 방법론
3. **VPC Flow Logs + Athena** — line item만으로 안 보이는 destination별 attribution
4. **CUR 2.0 cross-dimension 쿼리** — service × tag × region 결합 분석
5. **본인 도구 적용 plan** — cross-service analyzer를 어떻게 통합할지

---

## 🔴 필수 (이번 주차 토론 베이스)

### 1. [Reduce data transfer charges for a NAT gateway — AWS re:Post](https://repost.aws/knowledge-center/vpc-reduce-nat-gateway-transfer-costs)
**AWS 공식 / 읽기 15분**
NAT GW 비용 절감 공식 가이드. **cross-AZ 이중 과금** 메커니즘 + **VPC Endpoint로 우회** 패턴 정리. 본주 시나리오 XS-005 직결.

### 2. [Reduce unexpected AWS costs: Tracing AWS billing charges with log correlation — AWS Blog](https://aws.amazon.com/blogs/networking-and-content-delivery/reduce-unexpected-aws-costs-tracing-aws-billing-charges-with-log-correlation-techniques/)
**AWS Networking 블로그 / 읽기 30분**
**Cross-service cost coupling의 정전.** CUR에서 발견한 의문 line item을 VPC Flow Logs · CloudTrail · resource metadata와 join해서 진짜 원인 추적하는 방법론. XS-001/005/009 모두에 적용 가능.

### 3. [Detecting unusual spend with AWS Cost Anomaly Detection — AWS Docs](https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html)
**AWS 공식 / 읽기 20분**
Anomaly가 발견됐을 때 cross-service drill-down 방법론. ML 기반 root cause analysis로 **상위 10개 contributor + dollar attribution**. 본인 도구에 통합하기 좋은 layer.

---

## 🟡 권장 (자기 도구 적용 시 참고)

### NAT / VPC Endpoint 비용 구조

| 자료 | 한 줄 설명 |
|------|-----------|
| [Pricing for NAT gateways — AWS Docs](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-pricing.html) | 시간당 fixed + GB 처리 요금 + DataTransfer 정확한 계산식 |
| [Balancing VPC endpoints and NAT Gateways for maximum cost savings — Hykell](https://hykell.com/uncategorized/aws-vpc-endpoint-cost-savings/) | Interface Endpoint vs NAT — 트래픽 160GB/월 break-even 분석 |
| [How to Optimize Data Transfer Costs with VPC Endpoints — OneUptime](https://oneuptime.com/blog/post/2026-02-12-optimize-data-transfer-costs-with-vpc-endpoints/view) | Gateway Endpoint(S3/DynamoDB 무료) vs Interface Endpoint(시간당 + GB) 비교 |

### Cost Explorer / Anomaly Detection

| 자료 | 한 줄 설명 |
|------|-----------|
| [AWS Cost Anomaly Detection 공식](https://aws.amazon.com/aws-cost-management/aws-cost-anomaly-detection/) | 무료 ML 기반 비정상 비용 자동 탐지 + 알람 |
| [AWS Cost Anomaly Detection: A FinOps and Security Guide — Binadox](https://www.binadox.com/blog/binadox-article-cost-fluctuation-forecast/) | FinOps 관점에서 anomaly detection 설정 + 보안 사고 vs 단순 spike 구분 |
| [AWS Cost Anomaly Detection: Intelligent Spend Monitoring & Alert Architecture — AWS Startups](https://aws.amazon.com/startups/prompt-library/cost-anomaly-detection) | LLM prompt library — anomaly response 자동화 prompt 템플릿 |

### VPC Flow Logs + Athena 분석

| 자료 | 한 줄 설명 |
|------|-----------|
| [Query VPC flow logs — Amazon Athena Docs](https://docs.aws.amazon.com/athena/latest/ug/vpc-flow-logs.html) | Flow Logs를 Athena 외부 테이블로 쿼리하는 표준 패턴 |
| [Analyze VPC Flow Logs with point-and-click Athena integration — AWS Blog](https://aws.amazon.com/blogs/networking-and-content-delivery/analyze-vpc-flow-logs-with-point-and-click-amazon-athena-integration/) | CloudFormation으로 Athena 준비 자동화. 시작용 |
| [AWS Customer Playbook — Analyzing VPC Flow Logs (GitHub)](https://github.com/aws-samples/aws-customer-playbook-framework/blob/main/docs/Analyzing_VPC_Flow_Logs.md) | AWS 공식 customer playbook. 실전 쿼리 예제 다수 |
| [Network monitoring · VPC Flow Logs Athena — binbash blog](https://medium.com/binbash-inc/network-monitoring-use-aws-athena-to-query-vpc-flow-logs-66a9dc7043bc) | top-talkers, suspicious traffic 패턴 검출 쿼리 예제 |

### Step Functions / EventBridge (XS-007, XS-008 관련)

| 자료 | 한 줄 설명 |
|------|-----------|
| [AWS Step Functions Pricing 공식](https://aws.amazon.com/step-functions/pricing/) | Standard($0.025/1K transition) vs Express(execution+duration) 차이 |
| [EventBridge vs Step Functions: When to choreograph and when to orchestrate](https://medium.com/@naeemulhaq/eventbridge-vs-step-functions-when-to-choreograph-and-when-to-orchestrate-4cc5e6780dde) | 두 패턴 비용 trade-off — high-volume routing이면 EventBridge가 싸다 |
| [Handle unpredictable processing times — AWS Compute Blog](https://aws.amazon.com/blogs/compute/handle-unpredictable-processing-times-with-operational-consistency-when-integrating-asynchronous-aws-services-with-an-aws-step-functions-state-machine/) | Wait state polling → WaitForCallback 패턴 전환 가이드. XS-007 직결 |
| [Cost optimization — AWS Prescriptive Guidance (Serverless Agentic AI)](https://docs.aws.amazon.com/prescriptive-guidance/latest/agentic-ai-serverless/cost-optimization.html) | serverless 아키텍처 cost optimization 공식 가이드 |

### CloudFront / Origin 최적화 (XS-012 관련)

| 자료 | 한 줄 설명 |
|------|-----------|
| [Cost-Optimizing your AWS architectures by utilizing Amazon CloudFront — AWS Blog](https://aws.amazon.com/blogs/networking-and-content-delivery/cost-optimizing-your-aws-architectures-by-utilizing-amazon-cloudfront-features/) | CloudFront 도입 시 origin egress 무료화 + 비용 절감 패턴 |
| [Increase the proportion of requests served from CloudFront caches — AWS Docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cache-hit-ratio.html) | cache hit ratio 90%+ 달성 전략. XS-012 핵심 |
| [How to Configure CloudFront Origin Shield for Cache Hit Optimization](https://oneuptime.com/blog/post/2026-02-12-cloudfront-origin-shield-cache-optimization/view) | Origin Shield로 cache hit 한 단계 더 |

### Cross-Service Cost Coupling 분석

| 자료 | 한 줄 설명 |
|------|-----------|
| [Serverless Cost Optimization in 2026 — LeanOps](https://leanopstech.com/blog/serverless-cost-optimization-autoscaling-guide-2026/) | Lambda 호출이 downstream service 비용으로 cascade되는 분석 + 실제 cost-per-invocation 계산법 |
| [AWS Lambda Cost Optimization Best Strategies — Sedai](https://sedai.io/blog/strategies-for-aws-lambda-cost-optimization) | Lambda 비용을 downstream 영향과 함께 보는 시각 |
| [AWS Costs Explained: What Actually Charges You (April 2026)](https://computingforgeeks.com/aws-costs-explained-real-numbers/) | 청구서에서 안 보이는 cross-service 함정 카탈로그 |

---

## 🟩 한국어 사례 (실전 블로그)

### 1. [AWS 범용 클라우드 아키텍처의 데이터 전송 비용 알아보기 — AWS 한국 블로그](https://aws.amazon.com/ko/blogs/korea/overview-of-data-transfer-costs-for-common-architectures/)
**AWS 공식 한국어 / 읽기 25분**
ALB/NLB cross-zone, EC2↔RDS cross-AZ, S3↔EC2 cross-region 등 **모든 cross-service 데이터 전송 비용을 그림으로 정리**. 본주 출제의 시각 자료로 쓰기 좋음.

### 2. [Regional NAT Gateway: 다중 가용 영역 환경에서의 실전 적용 가이드 — AWS 한국 기술 블로그](https://aws.amazon.com/ko/blogs/tech/rregional-nat-practical-use/)
**AWS 한국 기술 블로그 / 읽기 30분**
2025년 출시된 Regional NAT Gateway가 cross-AZ 비용 함정을 어떻게 줄이는지. **시즌 1 NAT 단일 시나리오의 진화 형태**.

### 3. [AWS Private EC2 운영 가이드 5편: 비용 분석과 최적화 전략 — rhcwlq89 blog](https://rhcwlq89.github.io/blog/aws-private-ec2-guide-5/)
**개인 블로그 / 읽기 25분**
실제 월 $110 환경에서 NAT $65 → $5~$30로 줄인 사례. **VPC Endpoint 적용 전후 청구서 캡처** 포함. 학습용으로 매우 실전적.

### 4. [AWS VPC 비용 구조 완전 이해하기 — brunch](https://brunch.co.kr/@mentorsapiens/105)
**개인 블로그 / 읽기 20분**
VPC 비용의 4가지 숨은 함정 정리.

### 5. [Amazon CloudFront Pricing: 3 Models, 1 Breakeven Point — Cloud Burn](https://cloudburn.io/blog/amazon-cloudfront-pricing)
**해외 블로그 / 읽기 15분**
CloudFront 도입 break-even point 정량 분석.

---

## 🟢 심화 (시간 남으면)

### 1. [Cost Optimization Pillar — AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/welcome.html)
**AWS 공식 / 읽기 60분+**
정전. **Cloud Financial Management / Expenditure Awareness / Cost-Effective Resources / Demand & Supply / Optimize Over Time** 5개 영역. cross-service 챕터 포함.

### 2. [Cost optimization — Data Analytics Lens (Well-Architected)](https://docs.aws.amazon.com/wellarchitected/latest/analytics-lens/cost-optimization.html)
**AWS 공식 / 읽기 30분**
Data Lake / Athena / Glue 비용 패턴 정리. XS-010(Glue→S3→Athena cycle) 직결.

### 3. [Optimize your modern data architecture for sustainability — AWS Architecture Blog](https://aws.amazon.com/blogs/architecture/optimize-your-modern-data-architecture-for-sustainability-part-1-data-ingestion-and-data-lake/)
**AWS Architecture / 읽기 30분**
S3 storage tier · partition · CRR 패턴을 비용+탄소 동시 최적화. XS-010 보강.

### 4. [Event-Driven Architecture on AWS: Complete Refactoring Guide — Braincuber](https://www.braincuber.com/tutorial/event-driven-architecture-aws-2026)
**2026 / 읽기 40분**
EventBridge / SQS / SNS 패턴별 cost trade-off. XS-008 보강.

### 5. [AWS NAT Gateway Pricing: The Ultimate Cost Reduction Guide (2026) — Spendark](https://spendark.com/blog/aws-nat-gateway-pricing/)
**2026 / 읽기 20분**
NAT 비용 절감 6가지 전략 + 실제 케이스 ROI.

---

## 📋 토론 토픽 (월요일 22:00 세션용)

읽어 오고 본인 도구·시나리오에 대입해서 답 준비:

1. **VPC Endpoint vs NAT** — 본주 시나리오의 데이터 전송 패턴 보면 break-even이 어디 있나? Interface Endpoint를 만들 worth가 있는 service는?
2. **Cross-service drill-down 자동화** — 본인 도구가 line item만 보는지, 다른 데이터(Flow Logs / CloudTrail / X-Ray)와 join해서 root cause 찾는지? 못 하면 어떻게 추가?
3. **Cost Anomaly Detection의 한계** — ML 기반인데 "trend가 점진 변화" 케이스는 못 잡음. 본인 도구가 점진 변화를 어떻게 감지?
4. **Cross-service analyzer 모듈 설계** — orchestrator + service-specific specialist 패턴 (Week 2 학습 활용)에 cross-service 분석 layer를 어떻게 끼워넣을지?
5. **본주 시나리오의 cross-service 함정 식별** — 본인 시나리오의 component들이 청구서에서 어떻게 다른 line item으로 흩어져 있나? 어떤 메트릭·로그를 join해야 진짜 원인이 보이나?

---

## 🎯 산출물 (다음 주까지)

- [ ] **본주 시나리오 분석** — Submit Answer로 제출 (문제 식별 / root cause / 권장 해결 / 절감 추정 / multi-agent 측정 데이터)
- [ ] **본인 도구에 cross-service analyzer 모듈 추가** — Week 2의 multi-agent 구조에 "cross-service correlation" layer 끼워넣기
  - 입력: main.tf + cost_report + (VPC Flow Logs 또는 CUR 시뮬레이션)
  - 출력: cross-service coupling 찾기 (예: `NAT-Bytes 80%가 S3 destination` 같은 attribution)
- [ ] **measurements** — Week 2처럼 single vs cross-service-aware multi-agent 비교
- [ ] (옵션) 본인 도구에 VPC Endpoint 권장 자동 PR generator 추가

---

## 📎 참고

- 시나리오 카탈로그 Week 3 (요약): [docs/SCENARIOS_S2.md](SCENARIOS_S2.md#-week-3--cross-service-결합-낭비-12개)
- 시나리오 카탈로그 Week 3 (상세본): [docs/SCENARIOS_S2_DETAILED.md](SCENARIOS_S2_DETAILED.md#week-3--cross-service-결합-낭비-coupled-waste)
- 본주 본인 시나리오: Problems → 시즌 2 → Week 3
