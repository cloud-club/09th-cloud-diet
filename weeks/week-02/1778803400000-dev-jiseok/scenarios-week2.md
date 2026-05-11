# Week 2 — 멀티 에이전트 (Emergent Behavior Cases)

> 이 문서는 [시즌 2 시나리오 카탈로그 v1.0 (상세본)](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2_DETAILED.md)의 **Week 2** 섹션입니다.
> 각 시나리오는 시즌 1과 동일한 6개 차원으로 구성됨. 전체 47선을 표 형태로 빠르게 훑으려면 [요약본](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md) 참조.

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