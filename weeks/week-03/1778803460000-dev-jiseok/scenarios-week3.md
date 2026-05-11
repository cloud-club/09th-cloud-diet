# Week 3 — Cross-Service 결합 낭비 (Coupled Waste)

> 이 문서는 [시즌 2 시나리오 카탈로그](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md)의 **Week 3** 섹션입니다.
> 전체 카탈로그는 General 탭의 "시즌 2 시나리오 카탈로그 (전체)" 자료를 참고하세요.

---

## Week 3 — Cross-Service 결합 낭비 (Coupled Waste)

> 단일 도메인 분석에서는 안 보이는, **서비스 경계를 넘나드는** 낭비 패턴.
> 시즌 2의 핵심 신규 카테고리.

| ID | 시나리오 | 월 낭비 | 난이도 | 패턴 |
|----|----------|---------|--------|------|
| XS-001 | Lambda → S3 GET 폭증 (캐시 없음, 동일 키 매 invocation) | $850 | ⭐⭐ | request + transfer 동시 폭증 |
| XS-002 | EC2 종료 후 잔존 자원 (detached EBS + 미연결 EIP + 미사용 snapshot) | $420 | ⭐⭐ | +S1-001, +S1-003, +S1-007 |
| XS-003 | ECS 다운스케일 후 살아남은 ALB / target group / NAT 처리 capacity | $480 | ⭐⭐ | infra가 워크로드를 못 따라감 |
| XS-004 | SageMaker training 종료 후 endpoint 24/7 실행 | $720 | ⭐⭐ | 학습/추론 lifecycle 비동기 |
| XS-005 | S3 → NAT 경유 접근 (VPC Endpoint 미설정) | $360 | ⭐⭐ | +S1-029 |
| XS-006 | API GW throttle 없음 → Lambda 폭주 → DynamoDB throttle → Lambda retry 폭증 | $1,200 | ⭐⭐⭐ | cascade failure → cost explosion |
| XS-007 | Step Functions polling 패턴 (transition 비용 폭증) | $290 | ⭐⭐ | wait state 잘못 씀 |
| XS-008 | EventBridge → fanout (같은 이벤트가 N개 타깃에 중복 처리) | $640 | ⭐⭐ | event amplification |
| XS-009 | Route53 cross-region health check + ELB cross-zone transfer | $180 | ⭐⭐ | DNS layer transfer |
| XS-010 | Glue ETL → S3 → Athena → S3 cycle (중간 결과 영구 저장) | $550 | ⭐⭐ | data lake 위생 |
| XS-011 | RDS Read Replica가 다른 region에 위치 (transfer 폭증) | $470 | ⭐⭐ | replication direction 실수 |
| XS-012 | CloudFront origin이 EC2 (S3가 아님) — origin egress 누적 | $310 | ⭐⭐ | 캐싱 레이어 잘못 배치 |

---