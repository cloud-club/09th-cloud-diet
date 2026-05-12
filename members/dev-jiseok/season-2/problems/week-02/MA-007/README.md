# MA-007 · Context-stress Test (100+ 리소스)

> 시즌 2 Week 2 · 멤버: **@dev-jiseok** · 배정 노트: _리더 — context-stress 케이스 (가장 복합)_
> 데드라인: 2026-05-18 (월요일 22:00 세션 전까지)

---

## 1. 상황

100+ AWS 리소스 인프라. main.tf 5,000줄, cost_report 100+ services. 다양한 시즌 1 시나리오 18개 무작위 심어둠.

## 2. 시즌 1 결합 패턴

시즌 1 전반 (L1 + L2 + L3 패턴 무작위 18개)

> 시즌 1 단일 시나리오들은 각각 명확한데, 결합되면 단일 에이전트로 발견 어려움. 이번 주차 과제의 핵심 함정.

## 3. 단일 에이전트로 풀 때의 문제

컨텍스트 한계로 누락. main.tf 4,000줄 지나면 토큰 한계. 평균 recall 43% (17/40 발견).

## 4. 멀티 에이전트로 풀어야 할 목표

Orchestrator가 module별/resource type별 chunking + 전문가 5개 (Compute, Storage, Network, Database, AI) 병렬. recall 90% 목표.

### 기대하는 emergent finding

Orchestrator의 chunking 전략 자체가 평가 대상. wall-clock 시간은 병렬 덕에 단일 대비 비슷하지만 토큰 사용량 2.5x.

## 5. 예상 비용 영향

$15K~25K/월 (전체 18개 시나리오 합)

---

## 🎯 본주 과제 (산출물)

본인의 FinOps 도구에 **multi-agent 패턴을 적용**해서 이 시나리오를 풀어 오기.

### 필수 산출물

- [ ] **단일 에이전트 baseline 측정** — 본인 도구의 현재 구조로 이 시나리오 분석. 발견 issue 개수 / 토큰 사용량 / wall-clock 시간 기록.
- [ ] **멀티 에이전트 리팩토링 plan** — orchestrator + 도메인 전문가 N개 설계도. 컨텍스트 분할 전략 명시.
- [ ] **PoC 구현** — 위 plan을 실제 코드로 (full implementation이 어려우면 핵심 부분만이라도). 선택한 framework: Claude Subagent / LangGraph / Strands / AgentCore 중 본인 도구에 맞는 것.
- [ ] **before/after 측정** — recall / 토큰 사용량 / wall-clock 비교 표 + 정성적 차이 (예: emergent finding 잡았나).

### 평가 기준

| 항목 | 배점 | 내용 |
|------|:---:|------|
| 단일 baseline 정직성 | 15 | 단일 에이전트가 잡는 것·놓치는 것 정확히 측정했나 |
| 분할 설계 합리성 | 25 | 도메인 경계가 시나리오 구조와 맞나, 토큰 효율적인가 |
| Emergent finding 재현 | 20 | 본 시나리오의 emergent finding 또는 그에 준하는 cross-domain 통찰 도출했나 |
| 구현 완성도 | 20 | PoC가 실제 작동하나, 외부 dependency 명확한가 |
| Framework 선택 근거 | 10 | 본인 도구 기존 스택 + 시나리오 특성과 매칭되는가 |
| 회고 | 10 | 단일 대비 multi-agent의 trade-off를 솔직히 분석했나 (토큰 15x 비용 정당화) |

### 제출 형식

`members/dev-jiseok/season-2/submissions/week-02/MA-007/` 아래:
- `report.md` — 위 4개 항목을 정리한 보고서
- `architecture.md` (or diagram.png) — 멀티 에이전트 설계도
- `code/` — PoC 코드 (가능한 만큼)
- `measurements.json` — 정량 비교 데이터

---

## 📚 참고 자료

- [Week 2 학습 자료 모음](../../../../../weeks/week-02/) — Materials 페이지 Week 2 탭
- [시나리오 카탈로그 v1.0 (상세본)](../../../../../docs/SCENARIOS_S2_DETAILED.md#ma-007)
- [Anthropic Building Effective Agents](https://www.anthropic.com/research/building-effective-agents) — 5 패턴
- [Anthropic Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system) — 실제 구축 경험
