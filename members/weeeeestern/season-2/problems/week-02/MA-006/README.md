# MA-006 · RDS Fleet 진단 (DB + Backup + Application)

> 시즌 2 Week 2 · 멤버: **@weeeeestern** · 배정 노트: _단독_
> 데드라인: 2026-05-18 (월요일 22:00 세션 전까지)

---

## 1. 상황

dev/staging/prod RDS 12개. dev Multi-AZ on, backup 35일, Read Replica 미사용, RDS Proxy 없는 Lambda 연결.

## 2. 시즌 1 결합 패턴

시즌 1: S1-004 (dev Multi-AZ) + S1-013 (백업 35일) + S1-020 (Read Replica 미사용) + S1-040 (RDS Proxy 없음)

> 시즌 1 단일 시나리오들은 각각 명확한데, 결합되면 단일 에이전트로 발견 어려움. 이번 주차 과제의 핵심 함정.

## 3. 단일 에이전트로 풀 때의 문제

instance별 진단으로 "Multi-AZ off" 발견은 쉬움. "RDS Proxy 부재 영향"은 Lambda concurrency 같이 봐야 결론.

## 4. 멀티 에이전트로 풀어야 할 목표

DB 전문가 + Backup/DR 전문가 + Application 전문가.

### 기대하는 emergent finding

Application 전문가가 Lambda 로그에서 connection pool exhaustion 발견 → DB 전문가가 "RDS Proxy 도입 시 r6g.4xlarge → r6g.large 다운사이즈 가능" 결론.

## 5. 예상 비용 영향

$548/월 (r6g.4xl→r6g.large)

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

`members/weeeeestern/season-2/submissions/week-02/MA-006/` 아래:
- `report.md` — 위 4개 항목을 정리한 보고서
- `architecture.md` (or diagram.png) — 멀티 에이전트 설계도
- `code/` — PoC 코드 (가능한 만큼)
- `measurements.json` — 정량 비교 데이터

---

## 📚 참고 자료

- [Week 2 학습 자료 모음](../../../../../weeks/week-02/) — Materials 페이지 Week 2 탭
- [시나리오 카탈로그 v1.0 (상세본)](../../../../../docs/SCENARIOS_S2_DETAILED.md#ma-006)
- [Anthropic Building Effective Agents](https://www.anthropic.com/research/building-effective-agents) — 5 패턴
- [Anthropic Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system) — 실제 구축 경험
