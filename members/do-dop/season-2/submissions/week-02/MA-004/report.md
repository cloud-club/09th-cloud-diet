# Week 2 Multi-Agent Report

## Baseline Result

- Single-agent issues: 4
- Estimated monthly savings: $1,280.00
- Confidence score: 85%
- Single-agent LLM calls: 1
- Single-agent estimated tokens: 4,463
- Single-agent wall-clock: 41.14s

## Multi-Agent Result

- Detected domains: kinesis, lambda, s3, athena, governance
- Rule-based domain issues: 9
- Cross-domain query exchanges: 4
- Cross-service findings: 3
- Extra LLM calls: 1
- Extra estimated tokens: 2,485
- Multi-agent wall-clock: 18.02s
- Total token ratio vs single: 1.56x
- Token delta: +2,485

## Issues Found

- comp1_kinesis-stream-consumer-jkt61h, comp1_kinesis-stream-consumer-db6im2 (rate_unoptimized, high): $437.00/month
- comp2_lambda-function-4rcx9y, comp2_lambda-function-neikhx (overprovisioned, high): $360.00/month
- comp3_s3-bucket-replication-configuration-qlwap6 (overprovisioned, medium): $368.00/month
- comp4_s3-bucket-17yx3p (rate_unoptimized, medium): $115.00/month

## Domain Analyzer Findings

### kinesis
- `unnecessary_enhanced_fanout` on `comp1_kinesis-stream-consumer-jkt61h`: 저부하 스트림에 EFO 적용 - shard-hour + 데이터 검색 추가 비용 발생
- `unnecessary_enhanced_fanout` on `comp1_kinesis-stream-consumer-db6im2`: 저부하 스트림에 EFO 적용 - shard-hour + 데이터 검색 추가 비용 발생

### lambda
- `excessive_timeout` on `comp2_lambda-function-4rcx9y`: P99 6084ms 대비 timeout 900s - 에러 시 최대 900s 과금
- `excessive_timeout` on `comp2_lambda-function-neikhx`: P99 6080ms 대비 timeout 900s - 에러 시 최대 900s 과금

### s3
- `unfiltered_cross_region_replication` on `comp3_s3-bucket-replication-configuration-qlwap6`: 전체 버킷 (0.0TB) 복제 - 임시/로그 데이터까지 포함 가능
- `unfiltered_cross_region_replication` on `comp3_s3-bucket-replication-configuration-5cpqfg`: 전체 버킷 (0.0TB) 복제 - 임시/로그 데이터까지 포함 가능
- `s3_bucket_no_lifecycle` on `comp4_s3-bucket-17yx3p`: 용도 'athena-query-results' 버킷에 lifecycle 없음 - 무기한 누적

### athena
- `athena_result_bucket_no_lifecycle` on `comp4_s3-bucket-17yx3p`: 쿼리 결과 369.5GB, trend 190% - 자동 삭제 없이 누적

### governance
- `terraform_default_tags_missing` on `aws_provider`: Terraform provider default_tags가 없어 신규 리소스 태깅 누락 위험이 있음

## Cross-Domain Query Loop

- `kinesis` -> `lambda` (answered)
  - Question: Kinesis consumer/backlog 이슈와 연결된 Lambda timeout, error, duration 패턴이 있는지 확인 필요
  - Reason: streaming backlog가 compute 비용 또는 retry loop를 증폭시키는지 판단
  - Answer: excessive_timeout/comp2_lambda-function-4rcx9y: P99 6084ms 대비 timeout 900s - 에러 시 최대 900s 과금 ; excessive_timeout/comp2_lambda-function-neikhx: P99 6080ms 대비 timeout 900s - 에러 시 최대 900s 과금
- `lambda` -> `kinesis` (answered)
  - Question: Lambda timeout/error가 Kinesis iterator age나 retry/backlog를 증폭시키는지 확인 필요
  - Reason: MA-004 유형의 streaming-compute feedback loop 판단
  - Answer: unnecessary_enhanced_fanout/comp1_kinesis-stream-consumer-jkt61h: 저부하 스트림에 EFO 적용 - shard-hour + 데이터 검색 추가 비용 발생 ; unnecessary_enhanced_fanout/comp1_kinesis-stream-consumer-db6im2: 저부하 스트림에 EFO 적용 - shard-hour + 데이터 검색 추가 비용 발생
- `s3` -> `athena` (answered)
  - Question: S3 lifecycle/CRR 이슈가 Athena result accumulation 또는 large scan 패턴과 결합되는지 확인 필요
  - Reason: storage와 analytics 비용 증폭 관계 판단
  - Answer: athena_result_bucket_no_lifecycle/comp4_s3-bucket-17yx3p: 쿼리 결과 369.5GB, trend 190% - 자동 삭제 없이 누적
- `athena` -> `s3` (answered)
  - Question: Athena 결과 저장/스캔 패턴과 연결된 S3 lifecycle 또는 CRR 이슈가 있는지 확인 필요
  - Reason: analytics output accumulation 판단
  - Answer: unfiltered_cross_region_replication/comp3_s3-bucket-replication-configuration-qlwap6: 전체 버킷 (0.0TB) 복제 - 임시/로그 데이터까지 포함 가능 ; unfiltered_cross_region_replication/comp3_s3-bucket-replication-configuration-5cpqfg: 전체 버킷 (0.0TB) 복제 - 임시/로그 데이터까지 포함 가능 ; s3_bucket_no_lifecycle/comp4_s3-bucket-17yx3p: 용도 'athena-query-results' 버킷에 lifecycle 없음 - 무기한 누적

## Emergent Findings

Kinesis → Lambda → S3 → Athena로 이어지는 스트리밍 분석 파이프라인에서 각 단계의 과잉 프로비저닝과 lifecycle 관리 부재가 결합되어 비용을 연쇄적으로 증폭시키고 있습니다. 특히 Lambda timeout 과잉과 Kinesis EFO 불필요 적용이 에러 재시도 루프를 형성하고, S3 결과 데이터 누적이 분석 비용을 지속적으로 확대시키는 구조적 문제가 발견되었습니다.

### streaming_pipeline_amplification

- Severity: high
- Domains: kinesis, lambda, s3, athena
- Chain: Kinesis EFO 과잉 → Lambda timeout 과잉 → S3 결과 누적 → Athena 스캔 비용 증가
- Root cause: 스트리밍 파이프라인 전체에서 각 단계별 과잉 프로비저닝과 lifecycle 관리 부재
- Amplification: Kinesis EFO 불필요 비용이 Lambda 900초 timeout으로 증폭되고, 처리 결과가 S3에 무기한 누적되어 Athena 스캔 범위와 비용을 지속적으로 확대시킴
- Recommendation: Kinesis 표준 컨슈머 전환 + Lambda timeout 11초 축소 + S3 결과 버킷 7일 lifecycle 적용으로 파이프라인 전체 비용 최적화

### analytics_output_accumulation

- Severity: medium
- Domains: s3, athena
- Chain: S3 CRR 필터 없음 → Athena 결과 lifecycle 없음 → 스토리지 이중 누적
- Root cause: 분석 결과 데이터의 lifecycle 관리 정책 부재로 인한 불필요한 스토리지 비용 누적
- Amplification: S3에서 불필요한 데이터까지 복제하고, Athena 쿼리 결과가 369.5GB에서 190% 증가 추세로 누적되어 스토리지 비용이 기하급수적으로 증가
- Recommendation: S3 CRR에 중요 데이터 prefix 필터 적용 + Athena 결과 버킷에 7-30일 expiration lifecycle 설정

### error_retry_cost_loop

- Severity: high
- Domains: lambda, kinesis
- Chain: Lambda 900초 timeout 과잉 → Kinesis 재시도 증가 → EFO 비용 증폭
- Root cause: Lambda 함수의 과도한 timeout 설정이 Kinesis 스트림 처리 실패 시 비용 폭증을 야기
- Amplification: Lambda 에러 발생 시 900초까지 과금되고, 이로 인한 Kinesis 재시도가 불필요한 EFO 비용을 지속적으로 발생시켜 비용이 연쇄적으로 증폭됨
- Recommendation: Lambda timeout을 11초로 축소하고 DLQ 설정으로 재시도 루프 차단, Kinesis 표준 컨슈머로 전환하여 비용 증폭 고리 해결

## Measurement Notes

- Token counts are estimated from prompt/response text length when provider usage metadata is unavailable.
- Wall-clock is measured locally around the single-agent and multi-agent phases.
- Recall is not auto-scored because the ground-truth issue set is scenario-specific and not encoded in the runner.
