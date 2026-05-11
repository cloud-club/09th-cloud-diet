# Week 7 — 멀티 클라우드 + FOCUS 1.1 (Real Traps)

> 이 문서는 [시즌 2 시나리오 카탈로그 v1.0 (상세본)](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2_DETAILED.md)의 **Week 7** 섹션입니다.
> 각 시나리오는 시즌 1과 동일한 6개 차원으로 구성됨. 전체 47선을 표 형태로 빠르게 훑으려면 [요약본](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md) 참조.

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