# MA-006 RDS Fleet Diagnosis Report

## 1. Scenario summary

MA-006 is a FinOps diagnosis scenario for an RDS fleet with related backup and application connection-management issues. The scenario data includes Terraform, an aggregate cost report, a qualitative metrics summary, and a hint file.

The four target patterns are:

1. `L1-004`: dev RDS Multi-AZ enabled
2. `L1-013`: excessive backup retention
3. `L2-020`: unused read replicas
4. `L3-040`: Lambda concurrency plus missing production RDS Proxy plus possible DB downsizing

Raw `metrics.json` was unavailable, so `metrics_summary.md` was used only as qualitative evidence.

## 2. Framework selection

The experiment used a file-mediated multi-agent workspace. Each agent worked through isolated files under `ma-006/workspaces/`, and the Orchestrator merged the specialist outputs into final artifacts.

The automated script attempted to run Codex non-interactively, but the run was interrupted during `app_agent`. The remaining outputs were completed by directly instructing the active Codex session rather than running nested Codex subprocesses.

## 3. Multi-agent structure

Agents:

- `single_agent`: baseline that analyzed all files together.
- `db_agent`: RDS topology, Multi-AZ, read replicas, RDS Proxy target, and DB sizing.
- `backup_agent`: backup retention, final snapshots, backup policy, and backup waste.
- `app_agent`: Lambda concurrency, production/staging environment, RDS Proxy presence or absence, and connection exhaustion risk.
- `orchestrator`: merged specialist findings and prepared optimized Terraform.
- `evaluator_agent`: compared baseline and orchestrator results against ground truth.
- `report_agent`: produced this report.

## 4. Split criterion

The split criterion was AWS service/domain-based:

- DB domain: RDS topology and sizing.
- Backup/DR domain: backup policy and snapshot behavior.
- Application domain: Lambda concurrency and RDS Proxy connection management.

This matched the scenario hint, which emphasized DB, Backup/DR, and Application specialists.

## 5. Context isolation strategy

Specialist input files were restricted to their own domains:

- DB Agent received RDS topology, Multi-AZ, read replicas, primary/replica resources, app DB identifiers, and RDS Proxy target context.
- Backup Agent received `backup_retention_period`, `skip_final_snapshot`, and backup cost/policy context.
- Application Agent received Lambda functions, `reserved_concurrent_executions`, production/staging context, app DB identifiers, and RDS Proxy presence/absence.

The goal was to reduce context size and force cross-domain synthesis through the Orchestrator.

## 6. Single-agent baseline result

The single-agent baseline found all four target patterns:

- Dev RDS Multi-AZ on two dev-tagged Component 1 instances.
- Excessive 35-day backup retention on two Component 2 instances.
- Three Component 3 read replicas that are unjustified from available evidence, plus an invalid replica source reference.
- Five production Lambdas with 200 reserved concurrency each, no production RDS Proxy, and conditional `app-db-prod` downsizing after proxy introduction.

Single-agent recall: `4 / 4 = 1.00`.

## 7. Multi-agent result

The multi-agent flow also found all four target patterns:

- DB Agent found L1-004 and L2-020.
- Backup Agent found L1-013.
- Application Agent found L3-040.
- Orchestrator connected L3-040 across application and DB domains by tying Lambda connection pressure to RDS Proxy introduction and possible `app-db-prod` downsizing.

Multi-agent recall: `4 / 4 = 1.00`.

## 8. Evaluation table

| Pattern | Ground truth | Single-agent | Multi-agent |
| --- | --- | --- | --- |
| `L1-004` | dev RDS Multi-AZ enabled | Found | Found |
| `L1-013` | excessive backup retention | Found | Found |
| `L2-020` | unused read replicas | Found | Found |
| `L3-040` | Lambda concurrency plus missing production RDS Proxy plus possible DB downsizing | Found | Found |

| Run | Found patterns | Recall | L3-040 found | Token usage | Token cost |
| --- | ---: | ---: | --- | --- | --- |
| Single-agent | 4 / 4 | 1.00 | Yes | unavailable | unavailable |
| Multi-agent | 4 / 4 | 1.00 | Yes | unavailable | unavailable |

Token usage was unavailable because the local Codex CLI run did not expose exact token counts.

## 9. Findings and root causes

`L1-004`: two dev-tagged RDS instances have `multi_az = true`. Root cause is environment-inappropriate HA configuration.

`L1-013`: two Component 2 instances use `backup_retention_period = 35` without environment or compliance justification in Terraform. Root cause is ungoverned retention policy.

`L2-020`: three `db.r5.xlarge` read replicas are present without exact evidence of read demand, and their Terraform source reference points to missing `aws_db_instance.primary`. Root cause is stale or invalid replica topology.

`L3-040`: five production Lambda functions each reserve 200 concurrent executions, but only a staging RDS Proxy exists. Root cause is missing production connection pooling; the large `app-db-prod` instance may be compensating for connection pressure.

## 10. Optimized Terraform summary

`final/optimized_main.tf` proposes:

- Disabling Multi-AZ for the two dev RDS instances.
- Reducing Component 2 excessive retention from 35 to 7 days.
- Removing unused read replicas from active configuration.
- Fixing invalid replica and RDS Proxy target references.
- Adding a production RDS Proxy for `app-db-prod`.
- Routing production Lambda DB traffic through the production proxy.
- Conservatively downsizing `app-db-prod` from `db.r6g.4xlarge` to `db.r6g.2xlarge` after proxy introduction and validation.

The proposal avoids inventing missing IAM roles, security groups, secrets, variables, or Lambda application code.

## 11. Estimated monthly savings

Estimated monthly savings: `2173` USD.

This is the aggregate `estimated_monthly_waste_usd` provided in `cost_report.json`. The data does not provide a per-resource savings breakdown, so the report does not allocate exact dollar savings by finding.

## 12. Limitations

- Raw `metrics.json` was unavailable.
- `metrics_summary.md` was used qualitatively only.
- Exact CPU, memory, database connection, read IOPS, replica lag, backup storage, and RDS Proxy utilization values are unavailable.
- Token usage and token cost are unavailable.
- The automated run was interrupted during `app_agent`; remaining outputs were completed directly in the active Codex session.
- The Terraform extract omits several referenced IAM, security group, secret, variable, and Lambda endpoint details.

## 13. Reflection

The file-mediated multi-agent split made the cross-domain L3-040 dependency explicit: application connection pressure must be found before DB downsizing is a safe recommendation. In this scenario, both the single-agent and multi-agent approaches reached full recall, but the multi-agent structure produced clearer ownership boundaries and a cleaner final synthesis path.
