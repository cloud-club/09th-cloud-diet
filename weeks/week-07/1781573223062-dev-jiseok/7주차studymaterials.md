# Week 7 — 멀티 클라우드 + FOCUS 1.1 학습 자료

> 이번 주차 목표: AWS 단일 → **GCP / Azure 확장**. **FOCUS 1.1로 비용 데이터를 표준화**하고 클라우드 추상화 레이어를 설계.
> 본인 도구의 **데이터 입력 레이어를 FOCUS 호환으로 리팩토링 + 최소 1개 추가 클라우드 프로토타입**이 산출물.
> 핵심은 "AWS vs GCP 단가 비교"가 아니라, **multi-cloud로 오히려 비용이 늘어난 함정(MC-001~008)**을 표준 데이터로 잡는 것.

---

## 🎯 이번 주차에서 가져가야 할 것

1. **FOCUS = 표준 스키마** — 클라우드마다 제각각인 청구 데이터(CUR / BigQuery Billing / Azure CDF)를 공통 컬럼으로 정규화 (FinOps Foundation 주도)
2. **4대 비용 컬럼** — `BilledCost` / `EffectiveCost` / `ListCost` / `ContractedCost`. 할인·약정 상각(RI/SP amortization)을 일관 처리
3. **분류 컬럼** — `ChargeCategory`(Usage/Purchase/Tax/Credit/Adjustment) · `ServiceCategory` · `ProviderName` 로 cloud 간 비교 축 통일
4. **3대 클라우드 FOCUS export** — AWS Data Exports / GCP BigQuery FOCUS export / Azure Cost Management FOCUS export
5. **cross-cloud 함정** — egress 단가 차이(MC-001), 이중 약정 lock-in(MC-002), unmapped 20%(MC-003), multi-cloud DR(MC-004), LLM 멀티 프로바이더 routing(MC-007)

---

## 🔴 필수 (이번 주차 토론 베이스)

### 1. [What is FOCUS? + Spec v1.1 — FinOps Foundation](https://focus.finops.org/what-is-focus/) · [Specification v1.1](https://focus.finops.org/focus-specification/v1-1/)
**FinOps Foundation / 읽기 35분**
FOCUS(FinOps Open Cost and Usage Specification)는 멀티클라우드 비용 데이터를 하나의 스키마로 정규화하는 오픈 표준. 4대 비용(Billed/Effective/List/Contracted)과 `ChargeCategory`(MUST, null 불가) 같은 필수 컬럼이 cross-cloud 비교의 뼈대. MC-001/MC-003 직결. (스펙 원문: [v1.1 PDF](https://focus.finops.org/wp-content/uploads/2024/11/FOCUS-spec-v1_1.pdf))

### 2. [Data Exports for FOCUS — AWS Billing & Cost Management](https://docs.aws.amazon.com/cur/latest/userguide/dataexports-create.html) · [FOCUS 1.0 AWS 컬럼 사전](https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-focus-1-0-aws.html)
**AWS 공식 / 읽기 25분**
CUR을 FOCUS 스키마(S3, Parquet/CSV, 일단위)로 export. `ListCost/ContractedCost/BilledCost/EffectiveCost` 4컬럼 + AWS-specific 컬럼 포함. 본인 도구의 AWS 입력을 FOCUS로 통일하는 출발점. (FOCUS 1.2도 [GA](https://aws.amazon.com/blogs/aws-cloud-financial-management/data-exports-for-focus-1-2-is-now-generally-available))

### 3. [FOCUS export to BigQuery — GCP](https://docs.cloud.google.com/billing/docs/how-to/export-data-bigquery-focus-setup) · [Cost Management exports (FOCUS) — Azure](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports)
**GCP / Azure 공식 / 읽기 30분**
GCP는 immutable BigQuery 데이터셋(`gcp_billing_export_focus_*`)으로, Azure는 Cost Management exports에서 "Cost and usage (FOCUS)" 데이터셋으로 동일 표준 출력. **3-cloud를 같은 컬럼으로 받으면** MC 시나리오를 cloud별로 나란히 비교 가능. (GCP [export 구조](https://docs.cloud.google.com/billing/docs/how-to/export-data-bigquery-tables/focus-export))

---

## 🟡 권장 (자기 도구 적용 시 참고)

### FOCUS 스펙 / 정규화 (MC-003 unmapped 함정)

| 자료 | 한 줄 설명 |
|------|-----------|
| [FOCUS_Spec — GitHub](https://github.com/FinOps-Open-Cost-and-Usage-Spec/FOCUS_Spec) | 컬럼 정의·변경 이력·이슈. 매핑 구현 시 SoT |
| [FOCUS Specification v1.2](https://focus.finops.org/focus-specification/) | 최신 GA 버전. v1.1 대비 컬럼 추가/정제 — 도구는 버전 인지 파싱 권장 |
| [Structure of FOCUS export — GCP](https://docs.cloud.google.com/billing/docs/how-to/export-data-bigquery-tables/focus-export) | FOCUS 컬럼 ↔ GCP Detailed export 필드 매핑. unmapped 항목 식별에 유용 |

### cross-cloud 비용 함정 (MC-001 · MC-002 · MC-004 · MC-007)

| 자료 | 한 줄 설명 |
|------|-----------|
| [LLM routing: overview, strategies, and tools — merge.dev](https://www.merge.dev/blog/llm-routing) | task complexity → model tier 라우팅으로 30~85% 절감. MC-007(멀티 프로바이더 routing 부재) 직결 |
| [LiteLLM](https://github.com/BerriAI/litellm) · [OpenRouter](https://openrouter.ai/) | 여러 LLM 프로바이더를 단일 API로 — cost-aware routing/관측 게이트웨이 구현 베이스 |
| [Overview of data transfer costs — AWS Docs](https://docs.aws.amazon.com/whitepapers/latest/aws-fault-isolation-boundaries/data-transfer-costs.html) | egress/cross-region/cross-AZ 단가 구조. MC-001·MC-004 수식의 입력 |

---

## 🟩 한국어 사례 (실전)

### 1. [Cloud FinOps란 무엇인가요? — Google Cloud (KR)](https://cloud.google.com/learn/what-is-finops?hl=ko)
**Google Cloud 공식 / 읽기 20분**
멀티클라우드 FinOps 개념과 비용 데이터 통합의 필요성을 한국어로. FOCUS 도입 동기 정리에 적합.

### 2. [2025년 FinOps 트렌드 4가지 — 인포그랩 기술 블로그](https://insight.infograb.net/blog/2025/06/04/finops/)
**기술 블로그 / 읽기 20분**
FOCUS 표준화·멀티클라우드 통합 대시보드 흐름을 한국어로 정리. "왜 지금 FOCUS인가"의 근거(도입률 등).

### 3. [클라우드 비용 30% 절감을 위한 FinOps 실천 가이드 — 에이핀아이앤씨](https://a-fin.co.kr/insights/cloud-cost-optimization)
**파트너 인사이트 / 읽기 25분**
AWS·OCI·Azure 데이터 형식 차이와 통합 대시보드 필요성을 실무 관점으로. 추상화 레이어 설계 참고.

### 4. [FinOps 솔루션 — 클라우드 비용 최적화 (Azure, KR)](https://azure.microsoft.com/ko-kr/solutions/finops)
**Microsoft / 읽기 15분**
Azure 쪽 FinOps/FOCUS export 관점. AWS만 보던 시야를 multi-cloud로 넓히는 진입점.

---

## 🟢 심화 (시간 남으면)

### 1. [FOCUS Specification v1.2 PDF — FinOps Foundation](https://focus.finops.org/wp-content/uploads/2025/05/FOCUS-spec-v1_2.pdf)
**FinOps Foundation / 레퍼런스**
컬럼 정의 원문(데이터 타입·null 허용·제약). 매핑 검증(conformance) 로직 작성 시 직접 참조.

### 2. [EKS vs GKE vs AKS — 워크로드 TCO 관점 (MC-005)](https://focus.finops.org/what-is-focus/)
**개념 / 토론용**
control plane 단가만 비교하면 함정. compute·network(cross-AZ)·LB·registry·observability·support 7개 카테고리 합산 TCO로 봐야 함. FOCUS `ServiceCategory`로 cloud 간 동일 카테고리 묶어 비교.

### 3. [Object Storage lifecycle 단가 차이 (MC-006)](https://focus.finops.org/focus-specification/v1-1/)
**개념 / 토론용**
같은 lifecycle 정책이라도 transition op 과금이 다름(Azure Blob은 op마다, S3는 무료). FOCUS로 `ChargeCategory=Usage` 안에서 op vs storage를 분리해 봐야 보임.

---

## 📋 토론 토픽 (월요일 22:00 세션용)

읽어 오고 본인 도구·시나리오에 대입해서 답 준비:

1. **FOCUS 매핑 경계** — 본인 도구의 입력(CUR/JSON)을 FOCUS 4대 비용 컬럼으로 어떻게 매핑? 어디서 정보 손실이 나나?
2. **unmapped 20%** — cloud-specific 항목(TGW/ExpressRoute/Premium Tier)을 `ChargeCategory=Other`로 둘지, vendor 카테고리로 명시할지?
3. **추상화 레이어** — 분석 로직이 cloud를 모르게 하려면 인터페이스를 어디서 끊어야 하나? (`load_focus() → analyze() → report()`)
4. **cross-cloud 단가** — egress·약정·DR을 비교할 때 FOCUS의 어떤 컬럼 조합으로 "같은 logical service"를 묶나?
5. **프로토타입 범위** — 추가 1개 클라우드(GCP/Azure)는 어디까지? export 연동만? 시나리오 1개 재현까지?

---

## 🎯 산출물 (다음 주까지)

- [ ] **FOCUS 입력 레이어** — 본인 도구가 FOCUS 스키마(또는 FOCUS-like 정규화 모델)로 비용을 받도록 리팩토링
- [ ] **추가 클라우드 프로토타입** — GCP/Azure 중 1개를 FOCUS export로 연동(또는 mock FOCUS 데이터)
- [ ] **cross-cloud 분석 1종** — MC 시나리오 1개 이상(egress/약정/DR/LLM routing)을 표준 데이터로 탐지
- [ ] **Report** — FOCUS 매핑 설계 / unmapped 처리 / 페어 비교 / 회고

---

## 📎 참고

- 본주 시나리오 상세(MC-001~008): [scenarios-week7.md](../1778803700000-dev-jiseok/scenarios-week7.md)
- 시나리오 카탈로그 (요약): [docs/SCENARIOS_S2.md](SCENARIOS_S2.md)
- 시나리오 카탈로그 (상세본): [docs/SCENARIOS_S2_DETAILED.md](SCENARIOS_S2_DETAILED.md)
- 본주 본인 시나리오: Problems → 시즌 2 → Week 7
