# Week 6 — Shift Left (배포 전 자동 비용 검증) 학습 자료

> 이번 주차 목표: **배포된 인프라 분석**(시즌 1~Week 5)에서 → **배포 전 PR 단계 비용 검증**으로 이동.
> `terraform plan`을 JSON으로 뽑아 **PR에 자동 비용 코멘트** + **OPA/Conftest 정책 검증** + **자동 수정 PR**을 거는 게 핵심.
> 본인 도구에 **PR 봇** 또는 **`/review-tf` 모드**를 추가하는 게 산출물.

---

## 🎯 이번 주차에서 가져가야 할 것

1. **`terraform show -json`** — `plan -out=tfplan` → JSON 변환. `resource_changes[].change.{before,after,actions}`만 보면 클라우드 접근·비용 0으로 "미래 상태"를 분석 가능
2. **Infracost** — 두 브랜치의 plan을 비교해 **월 증분 비용 diff**를 PR 코멘트로. Rego cost policy로 "월 +$X 초과 시 차단" 가드레일
3. **OPA / Conftest** — plan JSON에 Rego 정책 적용. `deny`(차단) / `warn`(경고)로 dev Multi-AZ·필수 태그 누락·GPU autoshutdown 미설정 등 사전 차단
4. **자동 수정 PR** — 정책 위반 탐지 → S3 lifecycle·gp2→gp3·log retention 등 **fix diff를 봇이 직접 생성**
5. **Shift Left 원칙** — 비용 결정이 prod에 박히기 전, 설계·개발(PR) 단계에서 검증 (FinOps Foundation Policy & Governance 케이퍼빌리티)

---

## 🔴 필수 (이번 주차 토론 베이스)

### 1. [Infracost GitHub Action — infracost/actions](https://github.com/infracost/actions) · [CI/CD 셋업 docs](https://www.infracost.io/docs/integrations/cicd/)
**Infracost / 읽기 25분**
`terraform plan`이 바뀐 PR마다 **비용 diff 코멘트**를 자동 게시. open/sync/reopen 전체 PR lifecycle 처리 + base↔head 비용 차이 계산. "Shift FinOps Left"의 사실상 표준 도구로, SL-001(NAT GW)·SL-003(인스턴스 업그레이드)·SL-015(gp2→gp3) 직결. (메인 repo: [infracost/infracost](https://github.com/infracost/infracost))

### 2. [Terraform 정책 — Open Policy Agent (공식 튜토리얼)](https://www.openpolicyagent.org/docs/terraform) · [Conftest](https://www.conftest.dev/)
**OPA 공식 / 읽기 30분**
`terraform show -json` 출력에 Rego 정책을 평가(`opa exec` / `conftest test`). 리소스를 만들지 않으니 **비용·클라우드 접근 없이** 미래 상태를 `deny`/`warn`. SL-002(dev Multi-AZ)·SL-006(필수 태그)·SL-007(backup 과잉)·SL-014(GPU autoshutdown) 직결. Conftest는 OPA 래퍼 CLI로 PR CI에 가장 가볍게 붙는 진입점.

### 3. [JSON output format — Terraform (HashiCorp)](https://developer.hashicorp.com/terraform/internals/json-format) · [`terraform show` 명령](https://developer.hashicorp.com/terraform/cli/commands/show)
**HashiCorp 공식 / 읽기 20분**
`terraform plan -out=tfplan` → `terraform show -json tfplan`이 뱉는 `resource_changes` 스키마(`actions`, `before`, `after`)가 **PR 봇이 파싱할 입력 구조의 뼈대**. `format_version "1.0"`, 미인식 필드는 무시(forward-compatible). 여기서 diff를 읽어 비용·정책 판정으로 연결.

---

## 🟡 권장 (자기 도구 적용 시 참고)

### 비용 정책 / 자동 코멘트 (SL-001 · SL-004 · SL-015)

| 자료 | 한 줄 설명 |
|------|-----------|
| [Cost policies (Rego) — Infracost](https://www.infracost.io/docs/features/cost_policies/) | `infracost.json` + `--policy-path`로 "월 증분 > $X면 fail" 가드레일을 CI에서 강제 |
| [FinOps policies — Infracost Cloud](https://www.infracost.io/docs/infracost_cloud/finops_policies/) | Well-Architected 70+ 베스트 프랙티스를 PR에서 자동 점검 — 파일·라인까지 짚어줌 |
| [Open Policy Agent 통합 — Infracost](https://www.infracost.io/docs/integrations/open_policy_agent/) | Infracost 비용 데이터를 OPA 입력으로 결합해 비용 기반 정책 작성 |

### 정책 엔진 / IaC 스캔 (SL-002 · SL-005 · SL-006 · SL-014)

| 자료 | 한 줄 설명 |
|------|-----------|
| [Checkov — bridgecrewio/checkov](https://github.com/bridgecrewio/checkov) | `.tf` / plan JSON 그래프 기반 정적 스캔. 1000+ 내장 정책 + custom 정책 작성 |
| [Atlantis — runatlantis/atlantis](https://github.com/runatlantis/atlantis) | PR 코멘트로 `plan`/`apply` 구동 + Conftest 정책 위반 시 `apply` 차단. **PR 봇 아키텍처** 레퍼런스 |
| [aws-samples/aws-infra-policy-as-code-with-terraform](https://github.com/aws-samples/aws-infra-policy-as-code-with-terraform) | 배포 전 예방적 통제를 OPA로 구현한 AWS 공식 샘플 (Rego 정책 베이스라인) |

### 태그 거버넌스 / 워크로드 (SL-006 · SL-008)

| 자료 | 한 줄 설명 |
|------|-----------|
| [Tag policies — AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html) | 필수 태그 표준화·강제로 "Untagged" 풀 분류 방지. IaC enforce 지원 |
| [AWS Lambda Power Tuning — alexcasalboni](https://github.com/alexcasalboni/aws-lambda-power-tuning) | Step Functions로 메모리별 cost/speed 측정. SL-008 "power tuning 결과 없는 대용량 메모리" 검증 입력 |

---

## 🟩 한국어 사례 (실전)

### 1. [인프라코스트(Infracost) 소개 및 사용 방법 — Log on Me](https://logonme.click/tech/terraform/infracost/)
**개인 블로그 / 읽기 20분**
변경 전 비용을 터미널·PR에서 보는 Infracost 개요 + 설치·사용. 본인 도구의 PR 코멘트 출력 레이어 설계에 바로 참고.

### 2. [추가 예상 비용 확인하기 — Hands on Terraform with GCP](https://heumsi.github.io/hands-on-terraform-with-gcp/03-operation/02-github-based/03-actions-if-pr/02-estimate-costs/)
**개인 문서 / 읽기 20분**
GitHub Actions PR에서 Infracost로 비용 변화를 코멘트로 노출하는 워크플로 구성 실전(한국어). Actions YAML 그대로 응용 가능.

### 3. [비용 할당 전략 구축 — AWS 리소스 태그 지정 모범 사례 (KR)](https://docs.aws.amazon.com/ko_kr/whitepapers/latest/tagging-best-practices/building-a-cost-allocation-strategy.html)
**AWS 공식 / 읽기 25분**
필수 태그가 왜 cost allocation의 전제인지(SL-006의 근거). 태그 기반 vs 계정 기반 할당 모델 비교.

### 4. [AWS Resource TAG 전략 — JHB의 삽질 이야기](https://jhb.kr/416)
**개인 블로그 / 읽기 15분**
실무에서 태그 키 설계·강제를 어떻게 굴렸는지 한국어 경험담. PR 단계 태그 정책(SL-006) 룰 설계 참고.

---

## 🟢 심화 (시간 남으면)

### 1. [Governance, Policy & Risk — FinOps Framework Capability](https://www.finops.org/framework/capabilities/policy-governance)
**FinOps Foundation / 레퍼런스**
"Shift Left"가 FinOps 프레임워크 어디에 위치하는지. 정책을 설계·개발 단계로 당기는 케이퍼빌리티의 공식 정의 — 본인 도구의 정당화 근거.

### 2. [State of FinOps 2026](https://data.finops.org/)
**FinOps Foundation / 데이터**
Shift Left가 2026 4대 트렌드 중 하나(Week 1에서 다룬 그 트렌드)임을 데이터로 확인. 발표 자료의 "왜 지금 Shift Left인가" 근거.

### 3. [Enforce consistent tagging across IaC with AWS Organizations Tag Policies — AWS Cloud Operations Blog](https://aws.amazon.com/blogs/mt/enforce-consistent-tagging-across-iac-deployments-with-aws-organizations-tag-policies/)
**AWS / 읽기 25분**
CloudFormation·Terraform·Pulumi 배포에 태그를 일관 강제하는 최신 기능. PR 단계 정책과 조직 단위 가드레일을 어떻게 이중으로 거는지.

---

## 📋 토론 토픽 (월요일 22:00 세션용)

읽어 오고 본인 도구·시나리오에 대입해서 답 준비:

1. **plan JSON 파싱 경계** — 본인 시나리오는 `resource_changes`의 어떤 `actions`(create/update)·필드를 봐야 판정되나? before/after diff에서 무엇을 추출?
2. **차단 vs 경고** — 어떤 위반을 `deny`(머지 차단)로, 어떤 걸 `warn`(코멘트만)으로? dev/staging/prod 환경별 정책은 어떻게 분기?
3. **비용 추정 방법** — 단가 catalog/Pricing API로 PR 시점에 월 증분을 어떻게 계산? Infracost를 쓸지, 자체 단가 모듈을 쓸지 trade-off?
4. **자동 수정 PR** — 위반을 fix하는 diff(lifecycle·gp3·retention)를 봇이 어떻게 생성·커밋? 사람이 리뷰할 형태는?
5. **PR 봇 vs `/review-tf`** — GitHub Actions로 PR에 코멘트 다는 봇과, 로컬에서 도는 `/review-tf` 모드 중 본인 도구엔 뭐가 맞나? 둘의 입력(plan JSON)은 같게 추상화 가능한가?

---

## 🎯 산출물 (다음 주까지)

- [ ] **PR 봇 또는 `/review-tf` 모드** — `terraform plan` JSON을 입력받아 비용·정책을 검증하는 진입점
- [ ] **정책 세트** — Rego(OPA/Conftest) 또는 자체 룰로 SL 시나리오 3~5개를 `deny`/`warn` 판정
- [ ] **비용 코멘트** — 변경분 월 증분 추정 + 위반 목록 + 권장을 PR 코멘트(또는 Markdown)로 출력
- [ ] (옵션) **자동 수정 PR** — 위반 1종 이상에 대해 fix diff 자동 생성
- [ ] **Report** — `report.md` (정책 설계 결정 / 차단 기준 / 페어 비교 / 회고)

---

## 📎 참고

- 본주 시나리오 상세(SL-001~015 + COMBO): [scenarios-week6.md](../1778803640000-dev-jiseok/scenarios-week6.md)
- 시나리오 카탈로그 (요약): [docs/SCENARIOS_S2.md](SCENARIOS_S2.md)
- 시나리오 카탈로그 (상세본): [docs/SCENARIOS_S2_DETAILED.md](SCENARIOS_S2_DETAILED.md)
- 본주 본인 시나리오: Problems → 시즌 2 → Week 6
