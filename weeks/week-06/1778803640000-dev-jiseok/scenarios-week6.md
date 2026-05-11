# Week 6 — Shift Left (배포 전 자동 비용 검증)

> 이 문서는 [시즌 2 시나리오 카탈로그](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md)의 **Week 6** 섹션입니다.
> 전체 카탈로그는 General 탭의 "시즌 2 시나리오 카탈로그 (전체)" 자료를 참고하세요.

---

## Week 6 — Shift Left (배포 전 자동 비용 검증)

> 배포된 인프라 분석이 아닌, **PR/Terraform plan 단계에서 사전 차단**할 시나리오.
> GitHub Actions PR bot, OPA/Conftest, `terraform plan` 분석.

| ID | 시나리오 | 검증 시점 | 정책 | 권장 액션 |
|----|----------|----------|------|-----------|
| SL-001 | NAT Gateway 신규 추가 (월 $33 + 트래픽) | PR | warn | PR comment에 월 예상 비용 |
| SL-002 | RDS Multi-AZ on dev env (Env=dev 태그) | PR | reject | OPA 정책 위반 |
| SL-003 | EC2 instance family upgrade (m5.4xl → m5.24xl) | PR | warn | 4배 비용 경고 |
| SL-004 | S3 bucket lifecycle 미설정 (신규) | PR | reject | Conftest fail |
| SL-005 | CloudWatch Logs retention 없음 (영구 저장) | PR | reject | retention 90d 기본값 강제 |
| SL-006 | 필수 태그 누락 (Project/Owner/Env/CostCenter) | PR | reject | tag policy |
| SL-007 | RDS backup_retention_period > 14 on non-prod | PR | warn | 환경별 정책 |
| SL-008 | Lambda 메모리 > 4096 (Power Tuning 미수행) | PR | warn | 자동 PR로 Power Tuning 결과 제안 |
| SL-009 | 인터넷 노출 ALB + CloudFront 미설정 | PR | warn | egress 비용 비교 코멘트 |
| SL-010 | Spot 가능 워크로드를 On-Demand로 정의 (batch/dev) | PR | warn | Spot 전환 PR 제안 |
| SL-011 | Reserved Instance / SP 커버리지 < 50%인 family 추가 구매 | PR | warn | 기존 RI에 맞춰 family 변경 권장 |
| SL-012 | DynamoDB Provisioned 모드 신규 (On-Demand가 더 싸도) | PR | warn | 워크로드 패턴 비교 |
| SL-013 | EKS pod resource request > 측정 사용량의 200% | PR | warn | rightsizing |
| SL-014 | GPU 인스턴스 + auto-shutdown 미설정 | PR | reject | nightly shutdown 강제 |
| SL-015 | EBS volume type = gp2 (gp3가 더 싸고 빠름) | PR | warn | gp3 자동 PR |

### Shift Left 결합 시나리오 (난이도 ↑)

| ID | 결합 패턴 | 권장 |
|----|----------|------|
| SL-COMBO-1 | SL-001 + SL-006 + SL-009 (인터넷 노출 새 서비스 + 태그 누락 + NAT 추가) | 신규 서비스 launch checklist 자동 검증 |
| SL-COMBO-2 | SL-002 + SL-007 + SL-014 (dev에 prod급 설정 다수) | env 정책 일괄 검증 |

---