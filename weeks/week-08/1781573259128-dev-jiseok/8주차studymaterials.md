# Week 8 — 결과 발표 + 외부 공개 학습 자료

> 이번 주차 목표: 8주간 고도화한 **본인 프로젝트를 라이브 시연 + 회고**하고, 결과를 **외부 공개(블로그 / 밋업 / 오픈소스)**로 연결.
> 핵심은 기술 구현을 **"절감 스토리 + 단위경제 + 의사결정"**으로 번역하는 것. 코드가 아니라 *임팩트*를 발표한다.

---

## 🎯 이번 주차에서 가져가야 할 것

1. **절감 스토리텔링** — 문제 → 증거(데이터) → 해결 → 임팩트(월/연 절감, 단위경제 변화)의 내러티브 아크
2. **비용 → 비즈니스 가치 연결** — FinOps Reporting & Analytics: "value is transparent"가 목표
3. **KPI로 정량화** — cost/order, cost/1k requests, 절감률, RI/SP coverage, PT utilization 등 8주 성과를 숫자로
4. **데모 craft** — 라이브 시연 시나리오, before/after, 실패 대비(녹화 백업)
5. **외부 공개** — README / 라이선스 / 블로그로 프로젝트를 *재사용 가능한 자산*으로

---

## 🔴 필수 (발표 준비 베이스)

### 1. [Reporting & Analytics — FinOps Framework Capability](https://www.finops.org/framework/capabilities/reporting-analytics/)
**FinOps Foundation / 읽기 25분**
"비용/사용 데이터를 그것이 만든 **비즈니스 가치와 연결**"하는 게 이 케이퍼빌리티의 핵심. 페르소나별(엔지니어/리더)로 무엇을 보여줄지 — 발표 슬라이드 구성의 프레임. 8주 결과를 "리포트"로 정리.

### 2. [How to Tell a Story With Data — Harvard Business School Online](https://online.hbs.edu/blog/post/data-storytelling)
**HBS Online / 읽기 20분**
데이터 발표의 3요소(스토리·데이터·비주얼)와 **내러티브 아크(문제→증거→해결)**. 청중 맞춤(execs=big picture, 엔지니어=방법론). 비교는 bar, 추세는 line — 차트 선택까지.

### 3. [KPIs & Benchmarking — FinOps Framework Capability](https://www.finops.org/framework/capabilities/kpis-benchmarking/)
**FinOps Foundation / 읽기 20분**
8주 성과를 어떤 지표로 말할지 — 단위경제(cost/unit), 절감률, coverage, forecast accuracy. "막연히 좋아졌다"가 아니라 **기준선 대비 정량 비교**로 발표.

---

## 🟡 권장 (발표·공개 시 참고)

### 발표 / 데모

| 자료 | 한 줄 설명 |
|------|-----------|
| [State of FinOps 2026](https://data.finops.org/) | 발표 도입부 "왜 이게 중요한가" 근거 데이터(Shift Left·AI·Unit Economics·FOCUS 트렌드) |
| [Cost Optimization Pillar — AWS Well-Architected](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/welcome.html) | 8주간 찾은 낭비를 lifecycle 단계로 매핑해 "체계적으로 했다"는 프레임 |
| [FinOps Framework Overview](https://www.finops.org/framework/) | Inform→Optimize→Operate 흐름으로 본인 도구 여정 정리 |

### 외부 공개 (블로그 / 오픈소스)

| 자료 | 한 줄 설명 |
|------|-----------|
| [Starting an Open Source Project — GitHub Open Source Guides](https://opensource.guide/starting-a-project/) | 라이선스·README·기여 가이드 등 공개 전 체크리스트 |
| [Best practices for repositories — GitHub Docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/best-practices-for-repositories) | README/topics/릴리스 등 repo를 "쓸 수 있게" 만드는 기본기 |

---

## 🟩 한국어 사례 (실전)

### 1. [GitHub 한국 1위 개발자가 말하는 오픈소스 해야 하는 이유 5가지 — 박상권](https://medium.com/박상권의-삽질블로그/github-우리나라-1위-개발자가-말하는-오픈소스-해야-하는-이유-5가지-491b0df70301)
**개인 블로그 / 읽기 15분**
사이드 프로젝트/도구를 오픈소스로 공개하는 동기와 효과. 8주 결과물을 외부 공개로 잇는 자극제.

### 2. [카카오 오픈소스 가이드 — 참여하기](https://kakao.github.io/docs/contribute/participate/)
**카카오 / 읽기 15분**
기업 관점의 오픈소스 공개·참여 가이드(라이선스, 기여 절차). 공개 전 점검 체크리스트로 활용.

### 3. [개발자의 강력한 무기: 사이드 프로젝트 — 원티드](https://www.wanted.co.kr/events/21_12_s01_b02)
**원티드 / 읽기 15분**
사이드 프로젝트를 결과물·커리어 자산으로 만드는 관점. 발표 후 "그래서 이걸로 뭘 할 것인가" 정리에 참고.

### 4. [Week 8 참고 자료 — 최종 발표 가이드 (시즌 1)](study-materials.md)
**스터디 내부 / 읽기 10분**
시즌 1의 발표 구성(10분: 요약 2 / deep dive 5 / 단위경제 2 / 거버넌스 1)과 고득점·감점 패턴. **숫자로 말하기 / before·after 표**가 핵심.

---

## 🟢 심화 (시간 남으면)

### 1. [Storytelling with Data — Cole Nussbaumer Knaflic](https://www.storytellingwithdata.com/)
**레퍼런스 / 블로그·책**
차트 군더더기 제거, 강조(pre-attentive attributes), 메시지 한 줄. 발표 비주얼 품질을 한 단계 올리는 정석.

### 2. [주목할 만한 'K-오픈소스' 프로젝트 — 요즘IT](https://yozm.wishket.com/magazine/)
**요즘IT / 읽기 15분**
국내 오픈소스 공개 사례 흐름. 본인 도구를 어떤 포지셔닝으로 공개할지 벤치마크.

---

## 📋 발표 준비 체크 (월요일 22:00 세션용)

1. **한 줄 메시지** — 내 8주 결과를 한 문장으로? (예: "PR 단계에서 월 $X 낭비를 자동 차단하는 도구를 만들었다")
2. **임팩트 숫자 3개** — 총 절감액 / 단위경제 변화 / 탐지 시나리오 수
3. **데모 시나리오** — 라이브에서 무엇을, 어떤 입력으로 보여줄지 (실패 대비 녹화본?)
4. **before / after** — 8주 전 도구 vs 지금. 무엇이 가능해졌나?
5. **회고** — 가장 어려웠던 기법(멀티에이전트/FOCUS 등), 다음에 할 것

---

## 🎯 산출물 (발표일까지)

- [ ] **발표 자료** — 10분 구성(요약 → 핵심 deep dive → 단위경제 → 회고/next)
- [ ] **데모** — 라이브 시연(or 녹화). 입력→분석→리포트 end-to-end
- [ ] **최종 README** — 도구 소개·아키텍처·사용법·8주 변화 요약
- [ ] **Report(회고)** — 8주 기법별 적용 결과 + 배운 점 + 한계
- [ ] (옵션) **외부 공개** — 블로그 글 / 오픈소스 repo 공개

---

## 📎 참고

- 시즌 1 최종 발표 가이드: [study-materials.md (시즌1 Week 8)](study-materials.md)
- 시나리오 카탈로그 (요약/상세): [docs/SCENARIOS_S2.md](SCENARIOS_S2.md) · [docs/SCENARIOS_S2_DETAILED.md](SCENARIOS_S2_DETAILED.md)
- 8주 커리큘럼 전체: 레포 [README.md](https://github.com/cloud-club/09th-cloud-diet/blob/main/README.md)
