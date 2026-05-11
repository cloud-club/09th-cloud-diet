# Week 4 — Live 환경 분석 (정적 파일 졸업)

> 이 문서는 [시즌 2 시나리오 카탈로그](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md)의 **Week 4** 섹션입니다.
> 전체 카탈로그는 General 탭의 "시즌 2 시나리오 카탈로그 (전체)" 자료를 참고하세요.

---

## Week 4 — Live 환경 분석 (정적 파일 졸업)

> 정적 Terraform/JSON 분석으로는 풀 수 없는, **실시간 API 호출이 필수**인 시나리오.
> boto3 / Cost Explorer / CUR 2.0 / Pricing API / Trusted Advisor / Compute Optimizer 활용.

| ID | 시나리오 | 월 낭비 | 난이도 | 필요 API |
|----|----------|---------|--------|----------|
| LV-001 | 어제부터 비용 30% 폭증 — 원인 서비스/태그 동적 추적 | varies | ⭐⭐ | Cost Explorer + Anomaly Detection |
| LV-002 | Region/AZ별 가격 차이로 인스턴스 배치 재최적화 | $400~ | ⭐⭐ | Pricing API |
| LV-003 | CUR 2.0 일별 ETL — 어제까지 전체 trends 자동 추출 | n/a (insight) | ⭐⭐⭐ | CUR 2.0 + Athena |
| LV-004 | RI utilization 실시간 추적 + 미활용분 권장 | $600~ | ⭐⭐ | RI Coverage/Utilization API |
| LV-005 | Spot interruption 패턴 학습 후 워크로드별 family 추천 | $1,200~ | ⭐⭐⭐ | Spot Advisor + 워크로드 매핑 |
| LV-006 | Trusted Advisor cost checks 동기화 → 자동 ticket | varies | ⭐ | Trusted Advisor |
| LV-007 | Compute Optimizer 권장사항 자동 반영 PR 생성 | $800~ | ⭐⭐ | Compute Optimizer + PR bot |
| LV-008 | Cost Anomaly Detection alert → 자동 root-cause 분석 | varies | ⭐⭐ | Anomaly Detection + CE |
| LV-009 | Last 24h CloudWatch 메트릭 기반 idle 인스턴스 detection | $300~ | ⭐ | CloudWatch GetMetricData |
| LV-010 | 현재 가격 + 사용량 결합 → "지금 변경하면 X 절감" 동적 추천 | varies | ⭐⭐ | Pricing + CE 결합 |

---