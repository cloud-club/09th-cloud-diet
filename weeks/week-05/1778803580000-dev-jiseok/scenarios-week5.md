# Week 5 — AI 워크로드 (L4)

> 이 문서는 [시즌 2 시나리오 카탈로그](https://github.com/cloud-club/09th-cloud-diet/blob/main/docs/SCENARIOS_S2.md)의 **Week 5** 섹션입니다.
> 전체 카탈로그는 General 탭의 "시즌 2 시나리오 카탈로그 (전체)" 자료를 참고하세요.

---

## Week 5 — AI 워크로드 (L4)

> 시즌 1에 없던 신규 카테고리. AI/ML 워크로드의 비용 구조는 일반 인프라와 완전히 다름.
> 실제 LLM 운영 / RAG / 학습 파이프라인에서 자주 새는 비용 패턴.

| ID | 시나리오 | 월 낭비 | 난이도 | 도메인 |
|----|----------|---------|--------|--------|
| L4-001 | Bedrock Provisioned Throughput 과잉 (활용률 5%, 평소 5MTU만 필요) | $4,800 | ⭐⭐ | LLM serving |
| L4-002 | SageMaker Endpoint Auto Scaling 미설정 → 야간/주말 24/7 idle | $1,500 | ⭐⭐ | LLM serving |
| L4-003 | GPU 인스턴스 (p4d.24xlarge) 야간 미정지 — 학습 종료 후 살아있음 | $13,200 | ⭐⭐ | Training |
| L4-004 | LLM API 토큰 과금 vs 자체 호스팅 TCO 미비교 (월 100M 토큰) | $3,600 | ⭐⭐⭐ | TCO 판단 |
| L4-005 | 임베딩 캐시 부재 — 동일 텍스트 매번 재호출 | $720 | ⭐⭐ | RAG |
| L4-006 | SageMaker training data가 다른 region → cross-region transfer | $480 | ⭐⭐ | Data locality |
| L4-007 | Bedrock invocation 결과 무한 S3 저장 (lifecycle 없음) | $290 | ⭐ | Output 위생 |
| L4-008 | RAG vector DB OpenSearch 과잉 (m5.4xl x6 → m5.large x3로 충분) | $2,100 | ⭐⭐ | Vector store |
| L4-009 | Multi-modal API — 이미지 base64로 매번 전송 (vision API + cache 미사용) | $1,800 | ⭐⭐ | Multi-modal cost |
| L4-010 | 학습 데이터셋이 여러 S3 location에 중복 (Lake Formation 미사용) | $850 | ⭐⭐ | Data lake |
| L4-011 | Fine-tuning job이 매번 base model 다운로드 (체크포인트 캐시 없음) | $450 | ⭐⭐ | Training optimization |
| L4-012 | Inference batch 미사용 — 단일 요청씩 처리 (Batch Transform 가능한데) | $1,200 | ⭐⭐ | Batch vs realtime |

---