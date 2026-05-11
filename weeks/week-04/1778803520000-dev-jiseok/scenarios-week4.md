# Week 4 — Live 환경 분석 (정적 분석 한계 사례)

> 이 문서는 [시즌 2 시나리오 카탈로그 v1.0 (상세본)](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2_DETAILED.md)의 **Week 4** 섹션입니다.
> 각 시나리오는 시즌 1과 동일한 6개 차원으로 구성됨. 전체 47선을 표 형태로 빠르게 훑으려면 [요약본](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md) 참조.

---

## Week 4 — Live 환경 분석 (정적 분석 한계 사례)

> 정적 Terraform/JSON으론 절대 못 푸는 시나리오들.
> 모두 "실시간 API가 없으면 시작도 못 함" 케이스.

---

### LV-001 · 어제부터 발생한 비용 spike

**상황**
월요일 출근 후 일일 비용 30% 증가 Slack 알람. CUR 파일은 어제까지의 stale data.

**정적 분석 불가능 이유**
anomaly 발생 시점부터의 hourly 데이터가 필요. 7일 baseline + 24h spike 검출은 raw event 기반.

**필요 Live API**
- `ce:GetCostAndUsage` (Granularity=HOURLY, GroupBy=SERVICE/USAGE_TYPE)
- `ce:GetAnomalies`
- `ce:GetAnomalySubscriptions`

**실전 분석**
spike의 line item drill-down → 24h 내 새로 deploy된 ECS service 발견 → CloudWatch Logs에서 "외부 API call timeout retry loop" 확인 → 1시간 내 root cause 식별.

**비교**
정적 분석으로는 다음날 CUR 받기 전까지 못 풀음 → 18시간 손실 시 spike 비용 그만큼 누적.

---

### LV-002 · Region/AZ 가격 차이 활용

**상황**
새 batch 워크로드 배치 결정. m5.4xlarge 동일 spec이 region별·spot price별 다름.

**정적 분석 불가능 이유**
- spot price는 분 단위로 변함
- region별 가격은 분기 단위로 변동
- 정적 catalog는 outdated

**필요 Live API**
- `pricing:GetProducts` (on-demand price)
- `ec2:DescribeSpotPriceHistory`

**실전 분석**
SLA(latency < 100ms to user) 충족 region 후보군 추출 → 각 region·family에서 spot price 30일 평균 → interruption rate × $0 (job restart 비용) 가중치 → 최적 region·family 자동 선택.

---

### LV-003 · CUR 2.0 일별 ETL + tag dimension 분석

**상황**
정적 cost_report.json은 daily aggregate라 한계. CUR 2.0은 hourly granularity + 모든 tag dimension + RI/SP allocation.

**정적 분석 불가능 이유**
- tag value 변화 추적 (이번 주에 tag 변경된 리소스 식별)
- RI/SP allocation 일별 변화
- line item drill-down (specific resource id)

**필요 Live API**
- CUR 2.0 → S3 → Athena
- `aws athena start-query-execution` 패턴

**실전 분석**
"service=X tag로 어제 추가된 리소스의 첫 24h 비용" 같은 multi-dimension 쿼리. 정적 daily report로는 불가능.

---

### LV-004 · RI utilization 실시간 추적

**상황**
구매한 RI 50개 중 어느 것이 미활용인지 실시간 추적 필요.

**정적 분석 불가능 이유**
utilization은 매시간 변하고, instance terminate/launch event를 분 단위로 반영해야 정확.

**필요 Live API**
- `ce:GetReservationUtilization`
- `ce:GetReservationCoverage`
- `ec2:DescribeReservedInstances`

**실전 분석**
utilization < 70% RI 식별 → AWS RI Marketplace에서 sell or modify (family swap) 권장 → Cost Explorer에 변경 영향 시뮬레이션.

---

### LV-005 · Spot interruption 패턴 학습

**상황**
Batch 워크로드를 spot으로 돌리는데 instance family 선택 까다로움.

**정적 분석 불가능 이유**
interruption rate는 family/region/AZ별로 매주 변동. AWS의 Spot Advisor 데이터 자체가 실시간.

**필요 Live API**
- Spot Advisor (DescribeSpotPriceHistory + 추정 interruption rate)
- `ec2:DescribeSpotInstanceRequests` (history)

**실전 분석**
워크로드 SLA(허용 interruption rate < 5%) → 모든 region·family에서 30일 spot 안정성 → 최적 family 선택 + diversified fleet (3~5 family 분산).

---

### LV-006 · Trusted Advisor → 자동 ticket

**상황**
Trusted Advisor cost optimization check 결과를 정기 받아 새 issue를 자동 ticket화.

**정적 분석 불가능 이유**
Trusted Advisor 결과는 매번 다른 issue 발견 (새 unattached EBS, 새 idle ELB 등).

**필요 Live API**
- `support:DescribeTrustedAdvisorCheckResult` (Business Support 이상)
- `support:RefreshTrustedAdvisorCheck`

**실전 분석**
new finding (어제 없던) → 자동 Jira ticket + owner assign (resource tag.Owner 활용) + Slack notification.

---

### LV-007 · Compute Optimizer 권장 → PR 자동 생성

**상황**
Compute Optimizer가 매주 EC2/Lambda/EBS rightsizing 권장.

**정적 분석 불가능 이유**
권장사항은 last 14일 CloudWatch metric 기반. 매주 다른 결과.

**필요 Live API**
- `compute-optimizer:GetEC2InstanceRecommendations`
- `compute-optimizer:GetLambdaFunctionRecommendations`
- `compute-optimizer:GetEBSVolumeRecommendations`

**실전 분석**
권장 인스턴스 타입을 Terraform PR로 자동 제출 + Compute Optimizer 권장 근거(CPU·memory 패턴) PR body에 포함 + 예상 절감액 코멘트.

---

### LV-008 · Cost Anomaly Detection → 자동 root-cause 분석

**상황**
AWS Cost Anomaly Detection 알림. SNS 알림만은 noise.

**정적 분석 불가능 이유**
anomaly별로 다른 root cause. dimension breakdown 동적 분석 필요.

**필요 Live API**
- `ce:GetAnomalies`
- `ce:GetCostAndUsage` (다양한 GroupBy 조합)
- CloudTrail event lookup (anomaly 시각 ±1h)

**실전 분석**
anomaly → Cost Explorer dimension breakdown (service → usage_type → resource_id) → CloudTrail에서 같은 시간대 이벤트 → 자동 분석 보고서 (root cause 가설 + 검증 데이터).

---