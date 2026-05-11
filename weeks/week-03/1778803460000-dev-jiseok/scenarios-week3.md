# Week 3 — Cross-Service 결합 낭비 (Coupled Waste)

> 이 문서는 [시즌 2 시나리오 카탈로그 v1.0 (상세본)](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2_DETAILED.md)의 **Week 3** 섹션입니다.
> 각 시나리오는 시즌 1과 동일한 6개 차원으로 구성됨. 전체 47선을 표 형태로 빠르게 훑으려면 [요약본](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md) 참조.

---

## Week 3 — Cross-Service 결합 낭비 (Coupled Waste)

> 단일 도메인 분석으로는 절대 안 잡히는 패턴.
> Lambda 비용만 봐도, S3 비용만 봐도 정상으로 보이는데 둘을 같이 봐야만 보이는 함정들.

---

### XS-001 · Lambda → S3 GET 폭증 (캐시 부재)

**상황**
B2B 주문 처리 SaaS. 주문 lambda가 상품 카탈로그 (~80MB JSON)를 매 invocation마다 S3에서 GET. 카탈로그는 운영팀이 시간당 1~2회만 갱신. 6개월간 캐시 없이 운영. 4월 트래픽 4배 증가하며 lambda·S3 비용 동시 폭증.

**청구서 모양**
- `S3-Requests-Tier1` (GET request, $0.0004/1K)
- `Lambda-GB-Second` — 카탈로그 다운로드·파싱 시간만큼 duration 증가 (~250ms/invocation)
- DataTransfer는 same-region이라 $0 (이게 함정의 핵심)

**왜 안 보이는지**
S3 비용은 보통 storage만 모니터링하고 request cost는 노이즈로 취급. Lambda duration 증가는 "트래픽 4배 늘었으니 당연"으로 합리화. 두 서비스 line item이 각각 정상 추세로 보임.

**가격 수식**
```
GET 400M/월 × $0.0004/1K               = $160/월
Lambda extra duration:
  250ms × 400M × 1769MB × $1.67e-5/GB·s = $2,940/월
────────────────────────────────────────────
                                        $3,100/월
```

**탐지**
- CloudWatch `S3.NumberOfRequests` 시계열을 Lambda 함수별로 attribute (CloudTrail `s3:GetObject` event records의 `userIdentity.sessionContext.sessionIssuer.userName` 매칭)
- X-Ray segment에서 S3 sub-segment latency 누적 (`subsegments[].name == "S3"`)
- Lambda `Duration` p50 vs cold start duration 비교 — gap이 크면 매 호출 외부 의존 의심

**해결 후**
- DynamoDB on-demand 캐시 1개 테이블 (5분 TTL) `$50/월` + Lambda `/tmp` 메모리 캐시 (콜드 스타트만 GET) → 총 `$85/월`
- 또는 Lambda Layer로 catalog 임베드 (배포 시 갱신) → S3 호출 자체 제거

**시즌 1 결합**
- `+S1-014` (Lambda 메모리 과잉) 동반 시 메모리도 8192MB로 잡혀있어서 GB-second 더 큼

---

### XS-002 · EC2 종료 후 잔존 자원 클러스터

**상황**
인프라팀이 자동화 스크립트로 EC2를 종료했지만 `terminate_on_shutdown=false`로 EBS는 detach 후 남김. EIP는 release 안 함. AMI는 deregister만 하고 associated snapshot은 남김. 1년간 50회 반복.

**청구서 모양**
- `EBS:VolumeUsage.gp3` — orphan volume마다 별개 line item
- `ElasticIP:IdleAddress` — $0.005/h
- `EBS:SnapshotUsage` — $0.05/GB·mo
- 원래 어느 EC2의 것이었는지 정보 손실 (`Name` tag만 남아있고 instance-id 참조 없음)

**왜 안 보이는지**
EC2에는 cost allocation tag가 있었는데 detached resource는 태그 상속이 자동이 아님. EBS volume이 가진 태그가 없으면 "Untagged" 풀에 빠짐. Trusted Advisor "Unused EBS Volumes" check가 있지만 30일 이상 detached만 잡고 비용 표시는 없음.

**가격 수식**
```
Detached gp3 EBS  50 × 평균 500GB × $0.08/GB·mo  = $2,000/월
Unassociated EIP  12 × $0.005/h × 730h          =    $44/월
Orphan snapshot  200 × 평균 50GB × $0.05/GB     =   $500/월
─────────────────────────────────────────────────────
                                                 $2,544/월
```

**탐지**
- AWS Config aggregator rule `ec2-volume-inuse-check` (Lambda evaluator로 confirmedDetachedDays > 7)
- `aws ec2 describe-addresses --filters Name=domain,Values=vpc --query "Addresses[?!InstanceId].PublicIp"` (EC2 미연결 EIP)
- AMI vs snapshot cross-reference: `aws ec2 describe-snapshots --owner-ids self` vs `describe-images --owners self` 의 `BlockDeviceMappings[].Ebs.SnapshotId`

**해결 후**
- AWS Resource Explorer + EventBridge schedule + Lambda cleaner (delete unattached after 7d cooldown) → `$2,544 → $0`
- AWS Backup으로 snapshot 정책 통합 (lifecycle 자동)

**시즌 1 결합** — `+S1-001 +S1-003 +S1-007` 세 단일 패턴의 cross-resource fusion. 단일 시나리오에서는 각각 $150 / $18 / $100 수준인데 결합되면 attribution 손실로 발견조차 어려워짐.

---

### XS-003 · ECS 다운스케일 후 살아남은 인프라

**상황**
Black Friday 대비 ECS 클러스터 task 100 → 400 확장. 동시에 ALB 2개 추가, target group split, NAT processing capacity 증설. 이벤트 후 task는 100으로 자동 복귀했지만 ALB, target group 라우팅, NAT 흐름 capacity는 IaC와 별개로 콘솔에서 손으로 만든 거라 남아 있음.

**청구서 모양**
- `ELB-LoadBalancerUsage` ($0.0225/h × 2개 = $33/월 × 2 = $66) — 트래픽 거의 0인 idle ALB
- `NAT-Hours` ($0.045/h × 3 AZ × $98/월) — 사용량과 별개로 hourly fixed
- ECS task 비용은 정확히 비례 감소 → "비용 줄었다"는 착시

**왜 안 보이는지**
ECS Fargate 비용 절감 그래프는 visible. 동시에 만든 부속 infra는 별개 service code로 청구돼 "다른 비용"으로 보임. cost allocation tag가 ALB/NAT에 안 붙어 있으면 service별 attribution 안 됨.

**가격 수식**
```
미사용 ALB 2개 × $33                = $66/월
미사용 NAT capacity overhead         = $250/월 (NAT 3개 × $98 - 실수요 $44)
─────────────────────────────────────────
                                     $316/월
```

**탐지**
- ALB `RequestCount` < 1 req/s for 7 consecutive days
- ALB `ActiveConnectionCount` < 5
- NAT `BytesProcessed` 시계열이 ECS `RunningTaskCount`와 decoupled

**해결 후**
- IaC에 lifecycle 연동: ECS `desired_count`가 baseline의 1.5x 이하로 7일 유지되면 ALB/NAT count 감소 alert
- terraform module로 "이벤트 스케일링"을 정의해서 cleanup도 자동화

**시즌 1 결합**
- `+S1-005` (사용 안 하는 LB)의 root cause를 찾는 패턴

---

### XS-004 · SageMaker training 종료 후 endpoint 24/7 idle

**상황**
ML팀이 매주 retraining job 실행, 결과 모델을 SageMaker Endpoint에 자동 배포. inference는 weekday 09:00–18:00만 발생, 야간·주말 invocation 거의 0. 그러나 endpoint는 24/7 가동. 6개월 누적.

**청구서 모양**
- `SageMaker-Endpoint-Instance.ml.m5.4xlarge` ($1.512/h)
- training spike와 별개의 steady-state line item이라 "training 비용은 spike형, endpoint는 baseline"으로 분리 인식

**왜 안 보이는지**
training cost는 spike형이라 anomaly detection 알람도 잘 작동하는데, endpoint는 steady-state라 정상 budget으로 인식됨. ML팀의 KPI는 "inference latency"라서 endpoint를 끄는 것에 거부감.

**가격 수식**
```
ml.m5.4xlarge × 2 instance × $1.512/h × 730h = $2,207/월
idle 시간 비율: 14h × 5일 + 24h × 2일 = 118h / 168h = 70%
직접 낭비: $2,207 × 0.70 = $1,545/월
```

**탐지**
- CloudWatch `SageMaker.Invocations` 시간대별 histogram → 야간·주말 zero pattern
- `InvocationsPerInstance` < threshold (예: 10/min)
- CloudWatch dashboard에 hourly heatmap 추가

**해결 후**
- SageMaker Multi-Model Endpoint 또는 Serverless Inference (cold start ~3s 허용 가능 시) → `$1,545 → $200`
- 또는 EventBridge schedule (`UpdateEndpointWeightsAndCapacities` 0→2 09:00, 2→0 18:00) → `$2,207 → $662`

---

### XS-005 · S3 데이터를 NAT 경유 접근 (VPC Endpoint 미설정)

**상황**
Data 분석 EC2 fleet이 Private subnet 위치. S3 Gateway Endpoint 설정 누락. 모든 S3 접근이 NAT → Internet → S3 경유. 일일 분석 데이터셋 평균 2TB.

**청구서 모양**
- `NAT-Bytes` ($0.045/GB) — 단순히 "트래픽 비용"으로 보임
- `S3-DataTransfer-Out-Bytes` 0 (S3가 receiver side라 카운트 안 됨)
- 청구서에는 NAT processing이라고만 표시되어 destination이 S3였는지 모름

**왜 안 보이는지**
NAT 비용을 "그냥 인프라 비용"으로 인식. S3 Gateway Endpoint가 무료라는 걸 잊는 경우 흔함. VPC Flow Logs를 안 보면 NAT 트래픽의 destination이 안 보임.

**가격 수식**
```
2TB/일 × 30일 × $0.045/GB = $2,700/월
Gateway Endpoint 도입 시: $0 (무료)
순 절감: $2,700/월
```

**탐지**
- VPC Flow Logs를 Athena에서 쿼리: `WHERE dstaddr IN (s3 prefix list)` → NAT 트래픽의 destination이 S3인 비율 확인
- S3 prefix list: `aws ec2 describe-prefix-lists --filters Name=prefix-list-name,Values=com.amazonaws.us-east-1.s3`
- NAT `BytesOutToDestination` 시계열의 dest 분포

**해결 후**
- S3 Gateway Endpoint 생성 (무료, route table 1줄 변경) → `$2,700 → $0`
- DynamoDB도 Gateway Endpoint 사용 가능, 그 외는 Interface Endpoint 검토

**시즌 1 결합** — `+S1-029`를 Athena·Glue·Lambda 등 다른 데이터 워크로드로 확장. 단일 EC2 시나리오에서는 흔히 발견되지만 fleet 단위는 누락.

---

### XS-006 · API Gateway → Lambda → DynamoDB cascade amplification

**상황**
마케팅 캠페인 트래픽이 평소 10배. API Gateway에 usage plan throttle 미설정. Lambda reserved concurrency 1000 도달. DynamoDB는 provisioned 모드인데 RCU/WCU 초과로 `ProvisionedThroughputExceededException`. Lambda는 default retry (3회) + DLQ 미설정. 같은 요청이 1~4회 반복 처리됨. 1주일간 미발견.

**청구서 모양**
- `APIGateway-Requests` 폭증
- `Lambda-Duration` + `Lambda-GB-Second` 폭증
- `DynamoDB-WriteRequestUnits` (failed throughput으로 RCU 소모) + on-demand 변환 후엔 cost spike
- `CloudWatch-Logs` (Lambda log 폭증)

**왜 안 보이는지**
각 서비스 단위로 보면 "트래픽 늘었으니 늘어야 정상". 진짜 문제는 retry amplification — 같은 logical request 1개가 4× cost로 계산됨.

**가격 수식**
```
정상 일일 cost            = $500/일
Spike 1주일 일평균        = $4,000/일
총 추가 비용             = $24,500
Amplification 분 (~75%) = $18,375 (retry로 인한 순 낭비)
```

**탐지**
- Lambda `Errors` / `Invocations` ratio > 5%
- Lambda `Throttles` > 0
- DynamoDB `ThrottledRequests` 또는 `UserErrors`
- API GW `5XXError` rate
- CloudWatch Anomaly Detection on `IntegrationLatency`

**해결 후**
- API GW usage plan throttle (RPS limit)
- DynamoDB on-demand 전환 (workload 가변형이면)
- Lambda DLQ + exponential backoff retry
- Step Functions로 retry 로직을 명시화 (max retry, jitter)
- 회복 후 정상 비용 $500/일 복귀

**시즌 1 결합** — `S1-010` (DDB 프로비전 과잉)의 inverse: 부족할 때 발생. 같은 risk landscape의 반대편.

---

### XS-007 · Step Functions polling 패턴 (transition 폭증)

**상황**
Long-running task (predictions, video transcoding) 상태 확인을 Step Functions의 `Wait` state로 30초 polling 구현. 100개 동시 워크플로우 × 평균 2시간 실행. 매 polling iteration이 transition 2회 (Wait → CheckStatus → Wait or Done).

**청구서 모양**
- `StepFunctions-StateTransition` ($0.025/1000 in us-east-1)
- 워크플로우 비용으로 인식되어 "관리 비용" 명목으로 무시됨

**왜 안 보이는지**
Step Functions가 워크플로우 도구라 "비싸봐야 얼마"라는 안일함. 실제 transition rate는 visual editor에서 안 보이고 metric을 query 해야 함.

**가격 수식**
```
워크플로우당 transition: 2h × 3600s ÷ 30s × 2 transitions = 480 transition/run
일일 100 runs × 480 = 48,000 transition/일
월 30일 × 48,000 = 1,440,000 transition/월 (단일 워크플로우 type)
모든 워크플로우 합 (~20 type) = 28,800,000 transition/월
$0.025/1000 × 28,800,000 = $720/월

스케일 큰 회사는 polling이 더 짧고 (10s) workflow 수 많으면 $10K+/월 흔함
```

**탐지**
- CloudWatch `StepFunctions.ExecutionsStarted` vs `StateTransitions` ratio
- ratio > 100이면 polling 패턴 의심 (정상 워크플로우는 ratio ~10–30)

**해결 후**
- Wait state polling → **EventBridge callback pattern** 또는 **task token + sendTaskSuccess** 사용
- 외부 worker가 끝나면 callback으로 알림 → transition 1회로 수렴
- `$720 → $40`

---

### XS-008 · EventBridge fanout 중복 처리

**상황**
단일 `OrderCreated` 이벤트가 EventBridge로 발행 → 8개 Lambda target에 fanout. 각 Lambda는 "다른 책임"이라고 설계됐는데 코드 리뷰 안 한 사이 3개 Lambda가 같은 downstream service (notification provider) 호출. 같은 주문에 알림 3번.

**청구서 모양**
- `Lambda-Invocations` 8배 (각 lambda 개별 line item)
- 외부 SaaS API (notification provider) 호출 비용 — AWS bill 바깥
- 사용자 입장에서 "내가 한 주문에 알림 3개" → CS 클레임 → 별개 비용

**왜 안 보이는지**
각 lambda는 책임이 다르다고 주장. 중복은 코드 리뷰 + downstream API call log 봐야 확인됨.

**가격 수식**
```
주문 1M/월 × 3 중복 lambda × 200ms × 512MB × $1.67e-5
                                          = 약 $5/월 (Lambda 자체)
외부 notification API ($0.001/call) × 2M 중복 = $2,000/월
CS 비용 (incident 처리) — quantify 어려움
─────────────────────────────────────────
                                          $2,000+/월
```

**탐지**
- EventBridge rule 시각화 → 같은 source pattern의 target lambda 목록
- Lambda code static analysis로 동일 외부 API 호출 검출 (e.g., `grep -r "notification-provider.com"`)
- downstream API 측 dedup metric

**해결 후**
- 책임 통합: 1 lambda가 동기적으로 3 작업 처리
- 또는 EventBridge에 dedup logic (idempotency key) 추가
- 또는 SNS 단일 topic → notification handler 1개

---

### XS-009 · Route53 health check + ELB cross-zone overcharge

**상황**
Active-active 3 region 구성. Route53 health check를 모든 region에서 모든 endpoint로 (full mesh). ELB는 NLB이고 cross-zone load balancing default 활성화.

**청구서 모양**
- `Route53-HealthCheck` ($0.50/check/mo for AWS endpoint, $0.75 for external)
- `DataTransfer-Regional-Bytes` (NLB cross-zone) $0.01/GB
- ALB는 cross-zone 무료, NLB는 과금이라는 차이를 모름

**왜 안 보이는지**
Route53 비용 자체는 작아 보임. health check가 곱셈으로 늘어남 (regions × endpoints × checkers). NLB cross-zone은 `DataTransfer-Regional-Bytes`로 뭉뚱그려져 ALB 트래픽과 구분 안 됨.

**가격 수식**
```
3 region × 20 endpoint × 3 region checker = 180 check × $0.50 = $90/월
NLB cross-zone traffic 100GB/일 × $0.01 × 30 = $300/월
3 region이라 ×3 = $900/월
────────────────────────────────────────────
                                              $990/월
```

**탐지**
- Route53 console health check count
- NLB CloudWatch `ProcessedBytes` by AZ (cross-zone이면 AZ별 균등)
- CUR usage type `DataTransfer-Regional-Bytes`를 NLB ARN과 join

**해결 후**
- ALB 가능하면 ALB로 전환 (cross-zone 무료, health check도 ALB 자체 지원)
- NLB 유지 시 cross-zone 끄고 zone affinity 적용
- Route3 health check를 minimum (region당 1개)로 축소

**시즌 1 결합** — `+S1-028` 패턴의 multi-region 확장

---

### XS-010 · Glue → S3 → Athena 데이터 레이크 위생 붕괴

**상황**
ETL pipeline이 Glue로 raw → S3 intermediate → Athena query → S3 result → 다시 Athena chain. 중간 결과물 lifecycle 없음. 6개월 누적.

**청구서 모양**
- `S3-StorageObject-Days` (Standard tier) — intermediate + result 누적
- `Athena-DataScannedBytes` ($5/TB) — partition 없어서 full scan
- `Glue-DPU-Hour` ($0.44/DPU·h)

**왜 안 보이는지**
각 서비스가 별개 line item으로 청구되어 "ETL 비용은 원래 비싸지" 합리화. data lake 청소는 누구 책임인지 불분명 (data eng vs platform 책임 회피).

**가격 수식**
```
Intermediate S3 누적 1TB × $23/TB·mo               =    $23/월
Stale Athena results 일 100GB × 180일 = 18TB        =   $414/월
Partition 없는 반복 scan 일 200 query × 평균 50GB    
    = 10TB/일 × 30 = 300TB scan × $5/TB             = $1,500/월
─────────────────────────────────────────────────────
                                                    $1,937/월
```

**탐지**
- S3 Storage Lens "old non-current versions" + "incomplete multipart upload"
- Athena `query_history`에서 `data_scanned_in_bytes` top 10 분석
- Glue job log에서 input/output S3 path mapping

**해결 후**
- Athena results bucket 7일 lifecycle
- Partition projection (날짜별 자동 partition)
- Glue job 분리 (raw 1회 분석 후 curated table 생성, 이후 query는 curated만)
- `$1,937 → $250`

**시즌 1 결합** — `+S1-023 +S1-035` 결합. 단일 시나리오 각각은 명확한데 결합되면 어디서 시작할지 모름.

---

### XS-011 · RDS Read Replica가 cross-region (transfer 폭증)

**상황**
DR 목적으로 ap-northeast-2 → us-west-2 cross-region replica 구축. 그런데 dev팀이 read traffic을 misconfiguration으로 cross-region replica로 보내도록 설정. 6개월 늦게 발견.

**청구서 모양**
- `RDS-Inter-Region-Replication-Bytes` ($0.02/GB)
- `EC2-DataTransfer-Out-Inter-Region` (app → replica query)
- `RDS-Instance-Hours` (replica 자체)

**왜 안 보이는지**
replica 비용은 instance 자체보다 transfer가 큼. app → replica 호출은 region 간이라 다시 transfer. 단일 region 같은 코드면 무료라 dev팀이 비용 변화를 모름.

**가격 수식**
```
Replication 100GB/일 × $0.02 × 30      = $60/월
App cross-region query 500GB/월 × $0.02 = $10/월
Replica instance r6g.large × $0.252/h × 730 = $184/월
─────────────────────────────────────────
                                       $254/월 (단순)
대규모 환경에서 같은 패턴이 multi-region 5개 = $1,300/월
```

**탐지**
- VPC Flow Logs cross-region direction (`srcaddr` region vs `dstaddr` region)
- RDS `ReplicaLag` + endpoint resolve된 region 확인
- Application Insights — DB connection string의 endpoint region

**해결 후**
- dev traffic을 same-region replica로 redirect (DNS 변경)
- DR replica는 read-only로만 사용 (route53 weighted 0)

---

### XS-012 · CloudFront origin이 EC2 (S3 아님) — egress 누적

**상황**
정적 자산을 EC2 nginx에서 서빙. CloudFront 앞에 두기는 했는데 origin이 EC2라 cache miss 시 EC2 egress 발생. cache TTL이 1시간으로 짧게 설정되어 miss ratio 40%.

**청구서 모양**
- `CloudFront-DataTransfer-Out` (정상 egress)
- `EC2-DataTransfer-Out-Bytes` (cache miss마다 EC2 → CloudFront)
- S3 사용 안 함

**왜 안 보이는지**
CloudFront 도입했다는 안정감 → "이미 CDN 썼으니 비용 최적"이라 모니터링 약함. cache hit ratio 모니터링 안 함.

**가격 수식**
```
일일 traffic 100GB, hit ratio 60%
Cache miss = 100GB × 40% = 40GB/일 × 30 = 1,200GB/월
EC2 egress $0.09/GB × 1,200 = $108/월

CloudFront egress $0.0085/GB × 3,000 GB out = $25/월
─────────────────────────────────────────────
                                            $133/월 + ↑
규모 키워 100TB/월 traffic 가정 시 EC2 egress $4,000/월
S3 origin이면 CloudFront ↔ S3 무료라 $0
```

**탐지**
- CloudFront `CacheHitRate` metric < 90%
- EC2 `NetworkOut` for nginx instance vs S3 traffic 비교
- CloudFront Real-time logs에서 `x-edge-result-type` = `Miss` 비율

**해결 후**
- 정적 자산을 S3로 이전 + CloudFront origin을 S3로 변경
- Cache TTL 늘림 (정적 자산은 24h 이상)
- `$108 → ~$2` (CloudFront ↔ S3 무료)

**시즌 1 결합** — `+S1-039` (CloudFront 없는 S3 egress)의 반대 시나리오. CloudFront는 있는데 origin 잘못된 경우.

---