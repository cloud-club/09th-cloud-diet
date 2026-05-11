# Week 2 — 멀티 에이전트 아키텍처 (Multi-domain Fusion)

> 이 문서는 [시즌 2 시나리오 카탈로그](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md)의 **Week 2** 섹션입니다.
> 전체 카탈로그는 General 탭의 "시즌 2 시나리오 카탈로그 (전체)" 자료를 참고하세요.

---

## Week 2 — 멀티 에이전트 아키텍처 (Multi-domain Fusion)

> 단일 에이전트로는 컨텍스트 한계나 도메인 누락이 발생하는 **다중 도메인 동시 발생** 시나리오.
> "오케스트레이터 + 도메인 전문가" 패턴을 검증하기 좋은 케이스들.

| ID | 시나리오 | 월 낭비 | 난이도 | 구성 |
|----|----------|---------|--------|------|
| MA-001 | Lambda 메모리 + S3 lifecycle + DynamoDB 프로비전 동시 과잉 | $1,400 | ⭐⭐ | +S1-014, +S1-011, +S1-010 |
| MA-002 | ECS Fargate vCPU 과잉 + ALB idle + NAT cross-AZ + warmup 미설정 | $2,800 | ⭐⭐⭐ | +S1-016, +S1-005, +S1-025, +S1-017 |
| MA-003 | EKS pod request 과잉 + ECR lifecycle 없음 + 태그 거버넌스 붕괴 | $5,500 | ⭐⭐⭐ | +S1-038, +S1-009, +S1-031 |
| MA-004 | 데이터 파이프라인 (Kinesis EFO + Lambda timeout + S3 CRR + Athena 무제한) | $3,200 | ⭐⭐⭐ | +S1-022, +S1-015, +S1-037, +S1-023 |
| MA-005 | Multi-account RI family 미스매치 + SP coverage gap + 미통합 | $5,800 | ⭐⭐⭐ | +S1-032, +S1-033, +S1-034 |
| MA-006 | DB fleet (RDS Multi-AZ on dev + 백업 35일 + Read Replica 미활용 + RDS Proxy 없음) | $2,200 | ⭐⭐ | +S1-004, +S1-013, +S1-020, +S1-040 |
| MA-007 | 100+ 리소스 컨텍스트 폭발 — 단일 에이전트는 누락 발생 | varies | ⭐⭐⭐ | context-stress test |

### MA-007 상세 — Context-stress 시나리오
- 가상 회사 인프라: EC2 35개, S3 28개, Lambda 47개, RDS 4개, ElastiCache 6개, Kinesis 3개, SQS 12개
- 그 중 18개에 시즌 1 시나리오 중 하나씩 심어둠
- 단일 에이전트(Claude Code 1개 세션)는 평균 12/18 식별 → recall 67%
- 오케스트레이터 + EC2 전문가 + Storage 전문가 + Network 전문가 + DB 전문가 분할시 평균 17/18 → recall 94%

---