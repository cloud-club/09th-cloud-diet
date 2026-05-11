# 시즌 2 — FinOps 실무 시나리오 카탈로그 (v1.0)

시즌 1의 40선이 단일 도메인 패턴을 깊게 다뤘다면, 시즌 2는 **실제 청구서를 들고 와도 한 사람으로는 못 푸는 복합·고난도 케이스**를 모았다.
각 시나리오는 시즌 1과 같은 6개 차원으로 구성된다.

> **시나리오 포맷**
> - **상황** — 어떤 회사가 어떻게 함정에 빠졌는지 (서사)
> - **청구서 모양** — CUR line item / usage type / 어떤 라벨로 묶이는지
> - **왜 안 보이는지** — 자동 툴·casual review가 놓치는 이유
> - **가격 수식** — 정확한 단가 × 수량 = 월 낭비 (산출 근거)
> - **탐지** — 어떤 metric·query·log를 봐야 발견되는지
> - **해결 후** — mitigation 적용시 비용 변화
> - **시즌 1 결합** (해당 시) — 어떤 단일 패턴과 결합되어 더 깊은 함정이 되는지

> **컨텍스트** — mid-size SaaS (연매출 $50M, AWS bill $30K/mo, 12 AWS account, 80+ microservices). 모든 가격은 us-east-1 2026-03 기준.

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

## Week 5 — AI 워크로드 (L4 신규 도메인)

> 시즌 1에 없는 신규 카테고리. LLM·Training·RAG·Fine-tuning 비용 구조는 일반 인프라와 완전히 다르고 같은 함정이 새로운 형태로 등장.

---

### L4-001 · Bedrock Provisioned Throughput 과잉

**상황**
챗봇 출시 직전 영업측이 "런칭 트래픽 대비"라며 Anthropic Claude 5MU PT (Provisioned Throughput) 6개월 약정 구매. 실제 출시 후 트래픽은 평소 0.5MU 수준, 피크도 1.5MU 미만. 약정 잔여 4개월.

**청구서 모양**
- `Bedrock-ProvisionedThroughputUnits` — flat hourly rate, 사용량과 무관
- 매월 동일 금액이라 "고정비" 항목으로 인식

**왜 안 보이는지**
PT는 약정 = 같은 금액이라 "고정비" 인식. on-demand 대비 단가 절감만 보고 활용률 안 봄. Bedrock 메트릭은 default dashboard에 없음.

**가격 수식**
```
Claude 3.5 Sonnet PT 5MU × ~$5.40/h × 730h        = $19,710/월
실제 사용량 on-demand 환산:
  input 100M tok × $3/M + output 30M tok × $15/M  =    $750/월 (지금 트래픽)
                                                  (피크 잡아도 $3,000/월)
PT vs on-demand 차이                              = $16,710/월 낭비
약정 잔여 × 16,710                                = $66,840 (4개월)
```

**탐지**
- CloudWatch `Bedrock.Invocations` per MU 비율
- `InputTokens` + `OutputTokens` rate vs PT capacity
- PT utilization < 30%면 의심

**해결 후**
- PT 조기 해지 패널티 vs 잔여 약정 비교
- PT 1MU로 축소 후 burst는 on-demand
- 또는 cheap model (Haiku)로 fallback routing

---

### L4-002 · SageMaker Endpoint Auto Scaling 미설정

**상황**
ML팀이 prod에 `ml.g4dn.xlarge` × 2 endpoint 배포. Application Auto Scaling 설정 안 함. 야간·주말 invocation 거의 0인데 24/7 가동. 6개월 누적.

**청구서 모양**
- `SageMaker-Endpoint-Instance.ml.g4dn.xlarge` $0.736/h
- training cost와 분리되어 `Endpoint` line item에 묶임

**왜 안 보이는지**
ML 비용 모니터링은 training spike 위주. inference endpoint는 steady-state라 baseline budget으로 인식.

**가격 수식**
```
$0.736/h × 2 × 730h × 30일/30          = $1,074/월
Idle 시간 비율 (14h × 5일 + 24h × 2일) / 168 = 70%
직접 낭비: $1,074 × 0.7                = $752/월
```

**탐지**
- CloudWatch `SageMaker.Invocations` hourly histogram
- `InvocationsPerInstance` < 10/min for >2h
- `CPUUtilization` < 10% (GPU model이면 `GPUUtilization`)

**해결 후**
- Application Auto Scaling target tracking on `InvocationsPerInstance` → min 0, max 2
- 또는 Serverless Inference (cold start 3~5s 허용 시) → `$1,074 → ~$200`
- 또는 EventBridge schedule (`update-endpoint-weights-and-capacities` 0↔2)

---

### L4-003 · GPU 인스턴스 야간 미정지

**상황**
Research팀이 daily fine-tuning job을 `p4d.24xlarge`에서 실행. job은 매일 00:00–06:00 6시간 실행. 나머지 18시간 idle. shutdown 자동화 없음.

**청구서 모양**
- `EC2-Instance-Usage:p4d.24xlarge` $32.77/h (us-east-1 on-demand)
- 한 줄짜리 line item이라 단순히 EC2 비용으로 보임

**왜 안 보이는지**
GPU 비용은 큰 금액이라 alarm은 있는데 idle 시간 비율은 안 봄. P99 GPU utilization만 모니터링하면 학습 시간만 봐서 "정상".

**가격 수식**
```
$32.77/h × 730h          = $23,920/월
18h idle × 30일 × $32.77 = $17,696/월 낭비 (74% idle)
```

**탐지**
- CloudWatch agent custom metric: `nvidia-smi --query-gpu=utilization.gpu`
- `GPUUtilization < 5% for >1h` alarm
- training job 시작/종료 timestamp vs instance running 시간 비교

**해결 후**
- EventBridge schedule (06:00 stop, 23:30 start) → `$23,920 → $5,977` (75% 절감)
- 또는 SageMaker training job (자동 종료, billing 정확히 학습 시간만)
- 또는 Spot p4d (~$10/h, interruption 감수) → 추가 70% 절감

---

### L4-004 · LLM API 토큰 과금 vs 자체 호스팅 TCO 미비교

**상황**
초기에 Claude 3.5 Sonnet API로 PoC 시작 (월 1M token). 1년 후 100M input + 30M output token/월로 성장. 자체 호스팅(Llama 3.1 70B + g5.12xlarge)으로 전환 가능한지 검토 안 함.

**청구서 모양**
- `Bedrock-InputTokens` ($3/M tok)
- `Bedrock-OutputTokens` ($15/M tok)
- monthly cost가 트래픽에 비례

**왜 안 보이는지**
처음엔 작아서 "API가 답"이라고 결론. 성장 후에도 cross-over 분석 안 하면 자체 호스팅 ROI 모름.

**가격 수식**
```
현재: 100M × $3 + 30M × $15 = $750/월 (API)
1년 후 트래픽 10x: $7,500/월
자체 호스팅:
  g5.12xlarge × 2 × $4.20/h × 730   = $6,132/월 (트래픽 무관)
  + 운영비/모델 sync               = $500/월
                                   = $6,632/월

Cross-over: 트래픽 ~9x 지점부터 self-host TCO < API
단, 성능 차이(Claude vs Llama), 운영 부담 고려 필요
```

**탐지**
- CloudWatch `Bedrock.InputTokenCount` + `OutputTokenCount` 6개월 추세
- 트래픽 성장률 vs cross-over point projection

**해결 방향**
- 성장률이 빠르면 hybrid: simple task는 self-host, complex는 API
- 또는 Bedrock 모델 다운그레이드 (Haiku는 in $0.25/M, out $1.25/M)

---

### L4-005 · 임베딩 캐시 부재 (RAG)

**상황**
FAQ 챗봇이 사용자 질문을 Titan Embeddings로 매번 임베딩. 같은 질문 ("환불은 어떻게 받나요?")이 일평균 5,000회 반복. 캐시 없음. 1년 운영.

**청구서 모양**
- `Bedrock-InvokeModel:amazon.titan-embed-text-v1` ($0.0001/1K tok)
- 작아 보이는 단가라 monitoring 약함

**왜 안 보이는지**
단가가 $0.0001/1K로 매우 낮아 캐시 도입 우선순위 떨어짐. completion cost만 봄.

**가격 수식**
```
5M query/월 × 평균 200 tok × $0.0001/1K   = $100/월 (지금)
10x 성장 시                              = $1,000/월
+ completion에도 같은 패턴이면 ($3/M input)
  완전 LLM response 캐시 미적용         = $9,000/월 추가
─────────────────────────────────────────
                                        $10,000/월 (캐시 도입 전)
캐시 hit ratio 70% 가정 시              = $3,000/월 (70% 절감)
```

**탐지**
- 동일 query hash 빈도 (SHA256 of normalized query) 분석
- Bedrock InvokeModel API call rate

**해결 후**
- Redis(ElastiCache Serverless) 또는 DynamoDB on-demand로 임베딩 캐시
- semantic similarity threshold (0.95+)로 유사 질문도 cache hit
- completion 결과도 캐시 (1h TTL)

---

### L4-006 · Cross-region training data → cross-region transfer

**상황**
학습 데이터(5TB 데이터셋)는 us-east-1 S3. GPU 가용성 문제로 학습은 us-west-2 SageMaker. job 시작 시마다 매번 5TB 다운로드.

**청구서 모양**
- `S3-DataTransfer-Out-Bytes` (region 간) $0.02/GB
- `SageMaker-Training-Job` (compute 비용)
- 학습 비용 = GPU 비용이라는 인식 → transfer 누락

**왜 안 보이는지**
GPU 비용이 dominant라 transfer는 묻힘. 같은 데이터 매일 다시 다운로드되는 패턴은 SageMaker training job log 안 봐서 모름.

**가격 수식**
```
5TB × $0.02/GB × 매일 30회 retraining × 30일 = $90,000/월
(매번 5TB 다시 받음)
```

**탐지**
- VPC Flow Logs cross-region direction
- SageMaker training job `InputDataConfig.DataSource.S3DataSource.S3Uri`의 region

**해결 후**
- 데이터셋을 us-west-2로 복제 (one-time $100) → `$90,000 → 0`
- 또는 학습 자체를 us-east-1로 이동
- 또는 FSx for Lustre를 SageMaker training instance에 mount (한 번 hydrate 후 재사용)

---

### L4-007 · Inference 결과 무한 S3 저장

**상황**
Bedrock 호출 결과를 audit·replay 목적으로 모두 S3 저장. lifecycle 없음. 1년 누적.

**청구서 모양**
- `S3-StorageObject-Days` (Standard tier $0.023/GB·mo)
- Bedrock log 비용 자체는 negligible

**왜 안 보이는지**
log/audit 데이터는 "compliance 때문에 보관" 명목으로 lifecycle 검토 안 함. compliance 요건이 정말 7년 Standard인지 확인 안 함.

**가격 수식**
```
일 200GB × 365일 = 73TB
73TB × $0.023/GB·mo                = $1,679/월 (1년 시점)
2년 후 누적 146TB                  = $3,358/월 (계속 증가)
```

**탐지**
- S3 Storage Lens "object age distribution"
- S3 inventory 보고서로 age별 distribution

**해결 후**
- 30일 후 IA ($0.0125/GB), 90일 후 Glacier IR ($0.004/GB), 365일 후 Deep Archive ($0.00099/GB)
- `$1,679 → $250` (1년 데이터 기준)

**시즌 1 결합** — `+S1-011` AI 도메인 변형

---

### L4-008 · RAG vector DB OpenSearch 과잉

**상황**
5M document RAG 시스템. OpenSearch 클러스터 `m5.4xlarge × 6` instance로 시작. 실제 인덱스 크기 200GB, 검색 QPS 평균 50. 초기 sizing 후 재검토 안 함.

**청구서 모양**
- `ES-Instance-Hours.m5.4xlarge` $0.336/h
- `ES-Storage` EBS gp3

**왜 안 보이는지**
초기 sizing 후 "검색 속도" 우려로 보수적 운영. utilization metric 안 봄.

**가격 수식**
```
m5.4xlarge × 6 × $0.336/h × 730h  = $1,472/월 (현재)
적정 sizing m5.large × 3 × $0.084/h × 730h = $184/월
낭비: $1,288/월
```

**탐지**
- OpenSearch metric `CPUUtilization`, `JVMMemoryPressure` < 30%
- `SearchableDocuments` 대비 free storage 비율
- `SearchLatency` p99 < SLA

**해결 후**
- 단계적 다운사이즈 (Blue/Green 배포로 zero downtime)
- UltraWarm storage tier로 cold index 이전 (storage 50% 절감)

---

### L4-009 · Multi-modal API — 이미지 base64 매번 전송

**상황**
사용자가 업로드한 이미지를 Claude Vision API로 분석. 같은 이미지가 prompt마다 반복 사용. 매번 base64 인코딩 후 prompt에 포함. 일 100K 이미지 분석.

**청구서 모양**
- `Bedrock-InputTokens` — 이미지 1024×1024는 ~1,500 input token으로 카운트
- text token만 모니터링하면 multi-modal cost 묻힘

**왜 안 보이는지**
text 사용량만 비교 → 정상으로 보임. multi-modal token 별도 추적 dashboard 없음.

**가격 수식**
```
일 100K image × 1,500 input tok × 30일 = 4.5B tok/월
$3/M × 4,500 = $13,500/월
```

**탐지**
- Bedrock log analysis에서 message content type별 token count 분리
- model_invocation_logging 활성화 후 CloudWatch Logs 쿼리

**해결 후**
- 이미지 1회 분석 후 결과 S3 캐시 (image SHA256 key)
- 같은 이미지 prompt에서 재사용 시 cached analysis 참조
- 또는 Vision 호출 시 image reference (S3 URL)만 전달 (Claude는 base64 또는 URL 둘 다 지원)

---

### L4-010 · 학습 데이터셋 S3 중복

**상황**
데이터팀 4명이 각자 personal S3 prefix에 같은 raw dataset (10TB) 복사해서 사용. Lake Formation 없음. 각자 cost allocation tag 다름.

**청구서 모양**
- `S3-StorageObject-Days` (Standard $0.023/GB·mo)
- 각 팀원 prefix별로 다른 line item이라 중복 탐지 어려움

**왜 안 보이는지**
prefix별 owner 다르고 cost allocation tag 다름 → 분산되어 보임.

**가격 수식**
```
4명 × 10TB × $0.023/GB·mo = $920/월
```

**탐지**
- S3 inventory의 object SHA(ETag for non-multipart) 중복 검출
- S3 Storage Lens "duplicate object detection" (Advanced tier)

**해결 후**
- AWS Lake Formation 도입 + Glue Catalog 공유
- 1 카피만 유지, 권한은 Lake Formation으로 grant
- `$920 → $230`

---

### L4-011 · Fine-tuning이 매번 base model 다운로드

**상황**
매일 fine-tuning job이 Llama 3.1 70B base model을 S3에서 다운로드 후 학습. 70B 모델 ~140GB. 모델 prep만 30분 소요.

**청구서 모양**
- `SageMaker-Training-Job` (instance hours)
- S3 transfer는 same-region이라 free
- 진짜 비용은 학습 인스턴스의 idle prep time

**왜 안 보이는지**
S3 transfer 자체 비용은 0이지만 학습 인스턴스(p4d.24xlarge $32.77/h)가 prep 30분 동안 idle 가동.

**가격 수식**
```
30분 prep × 30회 × $32.77/h = $491/월 (단일 instance)
multi-instance training이면 ×4 = $1,964/월
```

**탐지**
- SageMaker training job 로그에서 model download 시간 측정
- FSx for Lustre vs S3 input 처리 시간 차이

**해결 후**
- SageMaker FSx for Lustre 활용 (모델 한 번 hydrate 후 재사용)
- 또는 EFS persistent model storage
- `$1,964 → $50`

---

### L4-012 · Inference batch 미사용

**상황**
일일 배치 작업이 사용자별 추천을 LLM API로 1명씩 순차 호출. 100만 사용자. 실시간성 요구 없음.

**청구서 모양**
- `Bedrock-InputTokens` + `OutputTokens`
- on-demand 가격으로 100% 청구

**왜 안 보이는지**
"추천은 실시간"이라는 잘못된 가정. batch API의 50% 할인 (대부분 LLM 프로바이더) 모름.

**가격 수식**
```
1M user × 평균 1.3K input + 200 output tok
= 1.3B in + 200M out tok/월
On-demand: 1.3B × $3 + 200M × $15 = $3,900 + $3,000 = $6,900/월
Batch (50% off): $3,450/월
절감: $3,450/월
```

**해결 후**
- AWS Bedrock Batch Inference API (50% 할인)
- 또는 prompt batching (10 user 묶어 1 call)

---

## Week 2 — 멀티 에이전트 (Emergent Behavior Cases)

> 단일 에이전트로는 못 푸는 시나리오들.
> "왜 분할이 필요한가" + "분할 시 어떤 새로운 통찰이 나오는가" 둘 다 보여주는 케이스.

---

### MA-001 · Lambda + S3 + DynamoDB 결합 — 컨텍스트 분할 문제

**상황**
B2C 앱의 주문 처리 인프라. main.tf에 Lambda 50개 + S3 30 bucket + DynamoDB 12 table. 같이 보면 각각 시나리오 — Lambda 메모리 과잉, S3 lifecycle 없음, DDB provisioned over-allocated.

**단일 에이전트 실패 모드**
Claude Code 1 세션에 main.tf + cost_report + metrics 전부 컨텍스트로 던지면 ~65K tokens. Lambda 분석에 처음 토큰 다 써서 S3/DDB 결론은 generic ("lifecycle 검토 권장" 같은 문장).
- 단일 에이전트 평균 recall: 13/40 issues → **약 30%**
- 누락되는 패턴: cross-service 결합 (예: "Lambda timeout 길어서 DDB 연결 안 닫혀서 connection 누적" 같은 chain)

**멀티 에이전트 해결**
Orchestrator가 main.tf를 resource type별로 chunking:
- Lambda 전문가 → Lambda 함수들만, 컨텍스트 ~15K tok
- Storage 전문가 → S3 bucket들만, ~12K tok
- DDB 전문가 → DynamoDB만 + Lambda 호출 패턴 메타데이터, ~18K tok

평균 recall **11/12** (92%).

**Emergent finding (단일 에이전트는 못 찾는 것)**
DDB 전문가가 "이 테이블의 RCU 적정 판단은 Lambda 호출 패턴 봐야 가능"이라며 Orchestrator에 cross-domain query.
→ Orchestrator가 Lambda 전문가에게 "lambda-X의 DDB query rate를 알려달라" 요청
→ Lambda 전문가가 X-Ray data로 응답
→ DDB 전문가가 "Lambda burst pattern이라 provisioned가 부적합, on-demand 권장" 결론

**해결시 절감**
시즌 1 결합 시나리오 3개 (S1-014, S1-011, S1-010)가 각각 발견되면 합 ~$1,400/월. 단일 에이전트로 발견하면 ~$420 (30% recall × 평균). 멀티 에이전트 ~$1,288 (92% recall × 평균).

---

### MA-002 · ECS Fargate + ALB + NAT — 네트워크↔컴퓨트 도메인 경계

**상황**
마이크로서비스 30개를 ECS Fargate에서 운영. 각 service는 ALB target group 등록, private subnet, NAT으로 egress. service-X(분석 워크로드)가 S3 호출을 NAT 경유로 한다는 점 + ALB 한 개는 idle이라는 점 + auto scaling warm-up 미설정이라는 점이 동시 존재.

**단일 에이전트 실패 모드**
ALB idle을 보면 "ECS task가 적어서"라고 결론하고, NAT 비용 폭증을 보면 "트래픽 많아서"로 결론. 두 결론이 서로 모순인데 같은 컨텍스트에 있어도 단일 에이전트는 둘을 연결 안 함.

**멀티 에이전트 해결**
- Network 전문가가 NAT-Bytes를 service별로 attribute → "service-X가 NAT의 80% 차지"
- Compute 전문가가 service-X의 task count·CPU pattern 분석 → "auto scaling warm-up 없어서 task 수가 부정확하게 spike"
- 두 전문가 cross-question → Orchestrator가 "service-X는 S3 호출이 많은데 Gateway Endpoint 미사용 + scaling 과잉" emergent finding

**Emergent finding**
- service-X 단독으로는 "S3 호출 많은 정상 분석 워크로드"로 보임
- 하지만 NAT 분배 비율 + scaling 패턴 + S3 traffic 세 데이터를 cross 분석해야 "VPC Endpoint 도입 + warm-up 설정 + ALB 정리" 셋 다 필요

**시즌 1 결합** — `+S1-016 +S1-005 +S1-025 +S1-029 +S1-017`

---

### MA-003 · EKS + ECR + Tag Governance

**상황**
EKS 클러스터 5개. 각 클러스터 50+ namespace. ECR 이미지 lifecycle 없음 (1,000+ tag). 리소스의 50%에 cost allocation tag missing.

**단일 에이전트 실패 모드**
pod resource over-provision 진단은 도달함. 하지만 "왜 그렇게 됐는지" root cause는 못 감 (Karpenter 미사용 + cluster autoscaler 보수적 설정 같은 거버넌스 issue).

**멀티 에이전트 해결**
- EKS 전문가: pod request·limit 적정성, node utilization
- Registry 전문가: ECR image별 pull frequency, vulnerability scan 결과
- Governance 전문가: tag coverage, cost allocation rules

**Emergent finding**
Governance 전문가가 "untagged ECR image의 pull frequency 데이터 없음 → 어떤 image가 안 쓰이는지 모름 → lifecycle 못 만듦" 지적. Registry 전문가가 "ECR scan으로 vulnerability 있고 6개월 미만 pull 없는 image는 제거 안전" 권장. EKS 전문가가 "old image pull 시 node에 large image 다운로드 → EBS 사용 증가" 발견.

**시즌 1 결합** — `+S1-038 +S1-009 +S1-031`

---

### MA-004 · 데이터 파이프라인 4-domain fusion

**상황**
실시간 분석 파이프라인. Kinesis EFO 활성, Lambda timeout 900초, S3 CRR 전체 적용, Athena 결과 무제한 저장.

**단일 에이전트 실패 모드**
4개 시나리오 각각 단일로는 명확. 합쳐서 보면 downstream 영향 분석 필요. 단일 에이전트는 4 도메인을 동시 깊이로 분석할 컨텍스트 부족.

**멀티 에이전트 해결**
Streaming + Compute + Storage + Analytics 4 전문가.

**Emergent finding**
"Lambda timeout 900초가 Kinesis EFO 처리량을 못 따라가서 backlog 누적 → backlog 처리 후 S3에 결과 dump → Athena가 backlog 보정용으로 large scan 패턴" 같은 chain reasoning. 단일 에이전트는 backlog와 Athena scan을 별개로 분류.

**시즌 1 결합** — `+S1-022 +S1-015 +S1-037 +S1-023`

---

### MA-005 · Multi-account RI + SP + 계정 미통합

**상황**
AWS Organizations 미통합 12 계정. 각 계정 따로 RI/SP 구매. utilization 70% 미만 다수. consolidated billing은 있지만 RI/SP sharing 미설정.

**단일 에이전트 실패 모드**
1 계정만 보면 RI 구매 자체는 정상으로 보임. 12 계정 cross-account 비교는 컨텍스트 한계로 불가능.

**멀티 에이전트 해결**
계정별 전문가 12개 + Governance orchestrator.

**Emergent finding**
"account-A의 m5 RI utilization 65%, account-B의 m5 사용량이 on-demand로 청구되고 있음. Org level RI sharing 활성화 시 같은 RI가 양쪽 커버 → $X 추가 절감" 같은 cross-account 통찰.

**가격 수식**
```
RI sharing 미설정 영향: 12 계정 평균 SP coverage 60%, 통합 시 85% 추정
$30K bill × 25% gap × 평균 SP 할인 25% = $1,875/월 추가 절감 가능
```

**시즌 1 결합** — `+S1-032 +S1-033 +S1-034`

---

### MA-006 · RDS Fleet 진단

**상황**
dev/staging/prod에 RDS 12개. dev에 Multi-AZ on, backup 35일, Read Replica 만들었지만 미사용, RDS Proxy 없는 Lambda 연결.

**단일 에이전트 실패 모드**
instance별 진단으로는 "Multi-AZ off"는 쉽게 발견. 하지만 "RDS Proxy 부재 영향"은 Lambda concurrency 같이 봐야 결론 가능.

**멀티 에이전트 해결**
- DB 전문가: instance sizing, Multi-AZ 적정성
- Backup/DR 전문가: snapshot 정책, backup retention
- Application 전문가: Lambda 연결 패턴, connection pool

**Emergent finding**
Application 전문가가 Lambda 로그에서 connection pool exhaustion 패턴 발견 → DB 전문가가 "RDS Proxy 도입 시 r6g.4xlarge → r6g.large 다운사이즈 가능 ($732 → $184/월)" 결론.

**시즌 1 결합** — `+S1-004 +S1-013 +S1-020 +S1-040`

---

### MA-007 · Context-stress test (real-world 100+ 리소스)

**상황**
100+ AWS 리소스 인프라. main.tf 5,000줄, cost_report 100+ services.

**단일 에이전트 실패 모드**
컨텍스트 한계로 일부 리소스 누락. main.tf 4,000줄 지나면 토큰 한계.
- 평균 recall 50% 미만 (테스트 결과 12/40 = 30%)

**멀티 에이전트 해결**
- Orchestrator가 main.tf를 module별/resource type별 chunking
- 전문가 N개 병렬 분석 (compute, storage, network, database, AI)
- 각 전문가 컨텍스트 ~15K tok
- 최종 recall **>90%**

**측정 데이터**
```
단일 에이전트 (Claude 3.5 Sonnet 1 세션):
- 평균 17/40 issue 발견 (recall 43%)
- 평균 분석 시간 8분

멀티 에이전트 (Orchestrator + 4 전문가 병렬):
- 평균 36/40 issue 발견 (recall 90%)
- 평균 분석 시간 12분 (병렬이라 wall clock)
- 비용: 토큰 사용량 2.5x
```

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

## Week 7 — 멀티 클라우드 + FOCUS 1.1 (Real Traps)

> 단순 "AWS vs GCP 비교"가 아니라, multi-cloud 도입으로 **오히려 비용이 늘어난** 실제 함정 케이스들.

---

### MC-001 · AWS + GCP 이중 운영 — egress 함정

**상황**
같은 웹앱이 AWS와 GCP에 동시 운영 (Route53 weighted routing 50:50). GCP가 컴퓨트 단가 약간 싸 보여 점차 GCP 비중 증가. 그런데 egress는 GCP Premium Tier $0.12/GB > AWS $0.09/GB. 사용자 데이터 외부로 나가는 비용 폭증.

**청구서 모양**
- AWS: `DataTransfer-Out-Bytes`
- GCP: `Network Egress (Premium Tier, Worldwide Destinations)`
- 두 cloud 각각 별도 청구라 합산 비교 표준 없음 (FOCUS 도입 전)

**왜 안 보이는지**
같은 logical service의 비용이 두 cloud의 다른 line item으로 분리. 비교하지 않으면 "GCP가 더 싸다"는 처음 인상이 유지됨.

**가격 수식**
```
월 egress 50TB
AWS-only:       $4,500
50/50 split:    $4,500 ÷ 2 + $6,000 ÷ 2 = $5,250
→ multi-cloud로 인한 추가 $750/월
연 환산: $9,000 손실
```

**탐지**
- FOCUS 1.1로 normalize 후 ChargeCategory = DataTransfer 항목 cloud별 비교
- 같은 service tag → cloud → egress 매핑

**해결 후**
- 사용자별 가장 가까운 cloud로 routing (latency-based, GeoDNS)
- 또는 egress 비싼 쪽에 caching layer 추가 (Cloudflare 같은 멀티 cloud CDN)

---

### MC-002 · Azure RI + AWS SP 이중 약정 함정

**상황**
워크로드를 AWS에서 Azure로 migration 계획. AWS SP 3년 약정 잔여 18개월인 상태에서 Azure RI 1년 구매. AWS 워크로드 빠르게 줄였더니 SP coverage 30%로 떨어져 SP가 무의미한 청구로 남음.

**청구서 모양**
- AWS: `SavingsPlan-Recurring` (사용량 무관 monthly commitment)
- Azure: `Reserved-Instance` (사용량 무관 monthly commitment)
- 두 cloud 합 SaaS의 진짜 인프라 비용보다 큼

**가격 수식**
```
AWS SP commitment: $5,000/월 (3년 약정 잔여 18개월)
실제 매칭 워크로드: 30% × $5,000 = $1,500
Idle SP commit: $3,500/월

Azure RI: $4,000/월 (1년 약정)
실제 매칭: 80% × $4,000 = $3,200
Idle Azure RI: $800/월

총 이중 commit 손실: $4,300/월 × 18 = $77,400
```

**왜 안 보이는지**
약정은 양쪽 다 lock-in인데 워크로드 이동 비용 산정 시 약정 잔여 고려 안 함.

**해결 방향**
- SP marketplace에서 sell (가능한 만큼)
- AWS SP는 만기 후 migrate (남은 시간 활용)
- 또는 multi-account에 SP share해서 idle 최소화

---

### MC-003 · FOCUS 1.1의 'unmapped 20%' 함정

**상황**
AWS CUR + GCP Billing + Azure CDF를 FOCUS 1.1로 normalize. 매핑 잘 되는 line item은 80%인데 나머지 20%가 cloud-specific (AWS Transit Gateway, Azure ExpressRoute, GCP Premium Network Tier).

**청구서 모양**
- FOCUS에서 ChargeCategory = "Other" 또는 vendor-specific service name
- 표준화 후 dashboard에서 "Other"가 갑자기 큰 비율 차지

**왜 안 보이는지**
FOCUS 도입 후 "이제 통합 비교 가능"이라는 안심. unmapped 20%가 큰 금액일 수 있음.

**가격 수식**
```
$30K monthly bill × 20% unmapped = $6K가 "Other"
이 중 진짜 비교 가능한 부분: AWS NAT vs Azure NAT 같은 직접 대응 가능 → 5%
나머지 15%는 진짜 cloud-specific (TGW, ExpressRoute 등)
```

**해결 방향**
- vendor-specific category로 명시 표시
- FOCUS의 ChargeCategory에 'Tax', 'Adjustment', 'Other' 활용
- BI tool dashboard에 "Unmapped" 면적 별도 표시

---

### MC-004 · Multi-cloud DR이 single-cloud DR보다 비쌈

**상황**
AWS primary, Azure DR. 일일 replication 1TB. "multi-cloud로 risk 분산"이라는 의사결정.

**청구서 모양**
- AWS: `DataTransfer-Out-Bytes` (egress to Azure) $0.09/GB
- Azure: ingress 무료지만 storage 비용 + ExpressRoute 또는 VPN 비용

**가격 수식**
```
AWS → Azure egress 1TB/일 × 30 × $0.09/GB = $2,700/월

대비 AWS multi-region DR:
- us-east-1 → us-west-2 transfer 1TB/일 × $0.02 = $600/월

차이: $2,100/월 = $25,200/년
```

**왜 안 보이는지**
"risk 분산"이라는 의사결정 명분 → 비용 검증 약함. cross-cloud egress 단가 vs cross-region 단가 비교 안 함.

**해결 방향**
- latency-sensitive하지 않으면 AWS 다른 region이 90% 저렴
- 진짜 multi-cloud 필요하면 압축·dedup으로 transfer 줄임

---

### MC-005 · EKS vs GKE vs AKS TCO — control plane 함정

**상황**
동일 워크로드 (50 nodes, 1000 pods). EKS → AKS로 이전 검토 (control plane 무료라는 이유).

**가격 비교 (월)**
```
EKS control plane: $0.10/h × 730 = $73/월
GKE Autopilot: pod 시간 기반 (다른 모델)
AKS control plane: 무료

겉보기로 AKS가 $73 절감
```

**실제 함정 — 다른 항목에서 더 비쌈**
```
[Cross-AZ traffic]
EKS: $0.01/GB (AWS internal)
AKS: $0.012/GB (Azure inter-zone)
→ pod-to-pod 1TB/일이면 AKS가 월 $60 더 비쌈

[Load Balancer]
ALB: $22/월 + LCU 기반
Azure App Gateway: V2 기준 $0.246/h + Capacity Unit
→ workload에 따라 Azure가 2-3x 비싼 케이스

[Container Registry]
ECR: $0.10/GB
ACR Premium: $0.667/일 base = $20/월 fixed
→ 1GB 이하 사용량이면 ACR이 훨씬 비쌈
```

**해결 방향**
워크로드 specific TCO 모델 (단일 항목 비교 X). 7개 카테고리 (compute, network, storage, LB, registry, observability, support) 합산.

---

### MC-006 · Object Storage lifecycle 함정

**상황**
같은 lifecycle policy (30d → IA, 90d → Archive)를 S3 / GCS / Azure Blob에 동일 적용.

**숨겨진 차이**
```
[S3]
Lifecycle transition: 무료
IA storage: $0.0125/GB
Glacier IR: $0.004/GB

[GCS]
Storage class change: lifecycle 자동은 무료, manual은 $0.01/1K op
Nearline: $0.01/GB (S3 IA보다 약간 비쌈)
Coldline: $0.004/GB

[Azure Blob]
Storage class change: $0.10/10K op (lifecycle 자동이라도 op 비용 발생)
Cool: $0.0152/GB
Archive: $0.00099/GB (rehydration 시간/비용 별도)
```

**실제 함정**
Azure Blob lifecycle은 transition op마다 과금. 100M object를 month마다 transition하면 $1,000/월 추가 비용. S3는 0.

**해결 방향**
- cloud-native lifecycle 패턴 활용 (GCS Autoclass 같은 auto-tier)
- 단순 동일 정책 복사 금지

---

### MC-007 · LLM 멀티 프로바이더 routing 부재

**상황**
Bedrock(Claude), Vertex AI(Gemini), Azure OpenAI(GPT-4) 동시 사용. 팀별로 선호 모델 다름. routing 정책 없음.

**가격 차이 (input/output per M tokens)**
```
Claude 3.5 Sonnet:   $3.00 / $15.00
GPT-4 Turbo:        $10.00 / $30.00
Gemini 1.5 Pro:      $1.25 / $5.00
Gemini 1.5 Flash:    $0.075 / $0.30
Claude 3.5 Haiku:    $0.80 / $4.00
```

**왜 안 보이는지**
팀별 선호로 GPT-4 많이 씀. 같은 task를 Haiku나 Flash로 처리 가능한지 검증 안 함.

**가격 수식**
```
월 500M input + 100M output token
All GPT-4: $5,000 + $3,000 = $8,000/월
Tiered routing:
  Simple (60%): Gemini Flash → $0.075 × 300M + $0.30 × 60M = $23 + $18 = $41
  Medium (30%): Claude Haiku → $0.80 × 150M + $4 × 30M = $120 + $120 = $240
  Complex (10%): Claude Sonnet → $3 × 50M + $15 × 10M = $150 + $150 = $300
Total tiered: $581/월

절감: $7,419/월 (93%)
```

**해결 방향**
cost-aware LLM router (task complexity → model tier). LangChain RouterChain 또는 자체 routing.

---

### MC-008 · Cross-cloud Interconnect 이중 commit

**상황**
AWS Direct Connect + Azure ExpressRoute + GCP Cloud Interconnect 모두 운영. on-prem 연결 + cloud간 연결 명목.

**고정비 (월)**
```
AWS DX 1Gbps port: $0.30/h × 730 = $219
Azure ER 1Gbps: $0.36/h × 730 = $263
GCP CI 1Gbps: $0.024/h × 730 = $17.5
─────────────────────────────────
Fixed total: $500/월
```

**실제 사용량 분석**
대부분 cloud↔on-prem 트래픽이고 cloud간 트래픽은 거의 없음. 그런데 GCP CI는 cloud간 backup link 명목 → 거의 0 사용량.

**해결 방향**
GCP CI 해지 (cloud간은 IPSec VPN over public)으로 $17.5/월 절감 + management overhead 감소

---

## 시나리오 활용 가이드

### 매주 출제 시 권장 조합

| 주차 | 출제 시나리오 수 | 권장 조합 | 난이도 |
|------|----------------|-----------|--------|
| Week 1 | (시즌 1 L1 5~7개 학습) | 도메인 감 잡기 | ⭐ |
| Week 2 | 1개 (MA-001 ~ 003 중) | 멀티 도메인 fusion | ⭐⭐⭐ |
| Week 3 | 2개 결합 (XS-001 ~ 012 중) | Lambda↔Storage + Network↔Compute 같은 cross-pair | ⭐⭐ |
| Week 4 | 1개 (LV-001 ~ 008 중) | Live API 활용 강제 | ⭐⭐ |
| Week 5 | 2개 (L4-001 ~ 012 중) | AI domain 신규 도메인 | ⭐⭐ |
| Week 6 | 3~5개 SL + 1 COMBO | Shift Left 통합 PR 시나리오 | ⭐⭐⭐ |
| Week 7 | 1~2개 (MC-001 ~ 008 중) | Multi-cloud 실전 함정 | ⭐⭐⭐ |
| Week 8 | 종합 | 8주 학습 시연 | ⭐⭐⭐ |

### 멤버별 출제 분배 권장 (8명 기준)

같은 주차라도 멤버마다 다른 시나리오 배정해서 코드 리뷰 시 비교 가능하도록.
예) Week 3:
- 멤버 1: XS-001 + XS-005
- 멤버 2: XS-002 + XS-006
- 멤버 3: XS-003 + XS-007
- ...

### 시즌 1 결합 패턴

각 시즌 2 시나리오의 "시즌 1 결합" 표기를 활용해 step-by-step 학습:
1. 먼저 시즌 1 단일 시나리오로 도메인 감 잡기
2. 시즌 2 결합 시나리오로 cross-domain 분석 훈련
3. multi-agent / shift-left / live-env 같은 신규 기법으로 자기 도구에 통합

---

## 참고

- 시즌 1 카탈로그: [09th-ai-cloud-finops/platform/docs/scenarios-guide.md](https://github.com/cloud-club/09th-ai-cloud-finops/blob/main/platform/docs/scenarios-guide.md)
- AWS Pricing API: https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_pricing_GetProducts.html
- AWS Compute Optimizer: https://docs.aws.amazon.com/compute-optimizer/
- FOCUS 1.1 Spec: https://focus.finops.org/

> 본 카탈로그는 v1.0 — 스터디 진행 중 멤버별 발견 사례를 추가해서 v1.1, v1.2로 진화 예정.
