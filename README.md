# 클라우드 다이어트하기 고도화 (시즌 2)

Cloud Club 9기 **시즌 2 — AI Cloud FinOps 자동화 고도화** 스터디 레포지토리.

8주간 매주 한 가지 핵심 기법을 도입해 **각자의 FinOps 자동화 도구를 점진적으로 고도화**하는 프로젝트형 스터디입니다.

> 스터디 사이트: **https://cloud-club.github.io/09th-cloud-diet/**
> 로그인 방법(GitHub PAT 발급): **[docs/LOGIN.md](docs/LOGIN.md)**

## 핵심 컨셉

- **각자의 방식대로** — 같은 시스템을 만드는 게 아니라, 각자의 아키텍처와 색깔을 유지하면서 매주 도입하는 핵심 기법을 자기 방식으로 적용
- **매주 한 가지 핵심 기법** — 멀티 에이전트 / MCP / Cross-service / FOCUS 표준 / Live 분석 등을 한 주에 하나씩 깊게
- **고도화 중심** — 새로 만들기가 아니라 이미 가진 도구를 더 똑똑하게 만드는 방향
- **공유 + 비교** — 매주 각자 적용 결과를 공유하고 서로 코드 리뷰

> 환경은 가비아 클라우드 환경의 AWS 시뮬레이션 환경을 사용 예정.

## 진행 방식

```
1. 매주 월요일 22:00 온라인으로 모여 그 주의 핵심 기법을 함께 공부
2. 각자 자기 프로젝트에 해당 기법을 자기 방식으로 적용 (1주일)
3. 다음 주차에 결과 공유 + 상호 코드 리뷰
4. 8주 후 결과물 발표 및 외부 공개 (블로그/밋업/오픈소스)
```

- **스터디 시간**: 매주 월요일 22:00, 온라인
- **소통**: Slack
- **PR/Issue 템플릿**: [cloud-club/template](https://github.com/cloud-club/template)

## 8주 커리큘럼

| 주차 | 주제 | 산출물 |
|------|------|--------|
| Week 1 | FinOps 핵심 + 2026 트렌드 학습 | 개인별 8주 고도화 로드맵 |
| Week 2 | 멀티 에이전트 아키텍처 도입 | 멀티 에이전트로 리팩토링된 자기 프로젝트 |
| Week 3 | Cross-Service 결합 낭비 분석 | cross-service analyzer 모듈 |
| Week 4 | Live 환경 분석 — 정적 파일 졸업 | Live AWS 환경에서 동작하는 자기 도구 |
| Week 5 | AI 워크로드(L4) 시나리오 추가 | AI 워크로드 패턴 카탈로그 |
| Week 6 | Shift Left — 배포 전 자동 비용 검증 | PR 봇 또는 `/review-tf` 모드 |
| Week 7 | 멀티 클라우드 + FOCUS 1.1 표준 | FOCUS 표준 지원 + 추가 클라우드 프로토타입 |
| Week 8 | 결과 발표 | 발표 자료 + 데모 영상 |

### Week 1 — FinOps 핵심 + 2026 트렌드 학습
공통 도메인 지식 다지기. AWS 과금 구조, Unit Economics(cost/order, cost/1k requests), FOCUS 1.1, FinOps 6단계 라이프사이클. State of FinOps 2026 4대 트렌드(Shift Left / AI for FinOps / Unit Economics / Agentic Governance) 정리. 각자 8주간 자기 도구를 어느 방향으로 고도화할지 로드맵 발표.

### Week 2 — 멀티 에이전트 아키텍처 도입
Claude Code Subagent / LangGraph / Strands SDK / Bedrock AgentCore 비교 학습. "오케스트레이터 + 도메인 전문가" 패턴, 컨텍스트 격리, 토큰 효율화 기법. 각자 자기 도구에 가장 적합한 패턴 골라 적용.

### Week 3 — Cross-Service 결합 낭비 분석
단일 도메인 분석은 서비스 경계에서 막힘. Lambda↔S3 GET 폭증, EC2 종료 후 detached EBS, ECS 다운스케일 후 살아남은 ALB/NAT 같은 결합 낭비(coupled waste) 패턴 정리. 각자 자기 도구에 cross-service 분석 단계 추가.

### Week 4 — Live 환경 분석
정적 JSON/Terraform 분석을 넘어 boto3 / AWS Cost Explorer / CUR 2.0 / Pricing API 실시간 호출로 확장. MiniStack·LocalStack 또는 실제 AWS sandbox 활용. 단가도 실시간 갱신.

### Week 5 — AI 워크로드(L4) 시나리오 추가
AI/ML 워크로드 비용 구조 학습 — Bedrock Provisioned Throughput 과잉, SageMaker Endpoint Auto Scaling 미설정, GPU 인스턴스 야간 미정지, LLM API 토큰 과금 vs 자체 호스팅 TCO, 임베딩 캐시 부재 등. 각자 자기 도구에 L4 시나리오 5~7개 추가.

### Week 6 — Shift Left
배포된 인프라 분석에서 → 배포 전 PR 단계 비용 검증으로 이동. GitHub Actions PR 자동 비용 코멘트, Terraform 수정 PR 자동 생성, OPA/Conftest 정책 검증.

### Week 7 — 멀티 클라우드 + FOCUS 1.1 표준
AWS 단일 → GCP / Azure 확장. FOCUS 1.1로 비용 데이터 표준화, 클라우드 추상화 레이어 설계. 각자 도구의 데이터 입력 레이어를 FOCUS 호환으로 리팩토링 + 최소 1개 추가 클라우드 프로토타입.

### Week 8 — 결과 발표
8주간 고도화한 각자 프로젝트 라이브 시연 + 회고.

> 커리큘럼은 참고용이며, 팀원의 방향성에 따라 조정될 수 있습니다.

## 멤버

| 이름 | GitHub | Role |
|------|--------|------|
| 이지석 | [@dev-jiseok](https://github.com/dev-jiseok) | Admin (리더) |
| 이서영(E) | [@seoyoungleeme](https://github.com/seoyoungleeme) | Member |
| 이서영(I) | [@7910trio](https://github.com/7910trio) | Member |
| 정유정 | [@jud1thDev](https://github.com/jud1thDev) | Member |
| 박도연 | [@do-dop](https://github.com/do-dop) | Member |
| 인승진 | [@m1cks](https://github.com/m1cks) | Member |
| 박은서 | [@weeeeestern](https://github.com/weeeeestern) | Member |
| 김연수 | [@juanxiu](https://github.com/juanxiu) | Member |
| 김근식 | [@600gramSik](https://github.com/600gramSik) | Member |

## 출석부

| 멤버 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 |
|------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 이지석 | O |  |  |  |  |  |  |  |
| 이서영(E) | O |  |  |  |  |  |  |  |
| 이서영(I) | O |  |  |  |  |  |  |  |
| 정유정 | O |  |  |  |  |  |  |  |
| 박도연 | O |  |  |  |  |  |  |  |
| 인승진 | O |  |  |  |  |  |  |  |
| 박은서 | O |  |  |  |  |  |  |  |
| 김연수 | O |  |  |  |  |  |  |  |
| 김근식 |  |  |  |  |  |  |  |  |

> 3회 이상 불참 시 9기를 수료할 수 없습니다.

## 프로젝트 구조

```
weeks/                      ← 주차별 스터디 자료 (웹에서 업로드)
members/                    ← 멤버별 데이터 (프로필 + 산출물)
scores/                     ← 채점 결과 (시즌 1 플랫폼 잔재 — 시즌 2에서는 미사용 가능)
platform/                   ← 시즌 1 플랫폼 코드 (재활용 여부 검토)
```

## 시즌 1 플랫폼 코드 안내

이 레포는 시즌 1 [09th-ai-cloud-finops](https://github.com/cloud-club/09th-ai-cloud-finops)
를 베이스로 시작합니다. `platform/` 하위의 문제 자동 생성·채점 코드와 웹 플랫폼은 시즌 1
구조 그대로 남겨두었습니다. 시즌 2는 프로젝트형 스터디이므로, 필요에 따라 일부 기능만
재활용하거나 제거할 수 있습니다.

## 참고

- [Cloud Club](https://github.com/cloud-club)
- [GitHub Template](https://github.com/cloud-club/template)
