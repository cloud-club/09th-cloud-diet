# Week 5 — AI 워크로드 (L4 신규 도메인)

> 이 문서는 [시즌 2 시나리오 카탈로그 v1.0](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md)의 **Week 5** 섹션입니다.
> 각 시나리오는 시즌 1과 동일한 6개 차원 (상황 / 청구서 모양 / 왜 안 보이는지 / 가격 수식 / 탐지 / 해결 후 변화)으로 구성되었습니다.

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