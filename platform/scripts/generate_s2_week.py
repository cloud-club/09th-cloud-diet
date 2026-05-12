#!/usr/bin/env python3
"""Generate season 2 weekly problems (fusion scenarios) for all members.

A season 2 MA-XXX problem fuses multiple season 1 L1/L2/L3 scenarios into ONE
combined infrastructure (main.tf + metrics + cost_report) — forcing single-agent
analysis to hit context limits and rewarding multi-agent decomposition.

Usage:
    python3 platform/scripts/generate_s2_week.py --week 2
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import sys
import tempfile
from pathlib import Path
from typing import Dict, List

import yaml

PLATFORM_DIR = Path(__file__).resolve().parent.parent
ROOT = PLATFORM_DIR.parent
sys.path.insert(0, str(PLATFORM_DIR / "src"))

from finops_sim.generators.orchestrator import _generate_one
from finops_sim.company.profile import generate_company_profile

# ─────────────────────────────────────────────────────────────────────────────
# Week 2 — Multi-Agent fusion scenarios
# Each MA-XXX = list of season 1 scenario IDs to combine in ONE infrastructure
# ─────────────────────────────────────────────────────────────────────────────

FUSION_MAP: Dict[str, Dict] = {
    "MA-001": {
        "title": "Lambda + S3 + DynamoDB 결합 — 컨텍스트 분할 문제",
        "components": ["L2-014", "L1-011", "L1-010"],
        "narrative": (
            "B2C 앱의 주문 처리 인프라를 인수했습니다. "
            "Lambda 함수 다수가 메모리 과잉으로 할당되어 있고, S3 버킷에는 lifecycle 정책이 빠져 있고, "
            "DynamoDB 테이블은 피크 기준 프로비전드로 설정되어 평균 사용률이 10% 수준입니다. "
            "3개 도메인이 동시에 무너진 상태인데, 단일 에이전트로 분석하면 컨텍스트 한계에 부딪힙니다."
        ),
        "multi_agent_hint": "Lambda 전문가 + Storage 전문가 + DynamoDB 전문가 + Orchestrator로 분할하면 cross-domain query가 가능해집니다.",
    },
    "MA-002": {
        "title": "ECS Fargate + ALB + NAT — 네트워크↔컴퓨트 경계",
        "components": ["L2-016", "L1-005", "L3-025", "L3-029", "L2-017"],
        "narrative": (
            "마이크로서비스 30+개를 ECS Fargate에서 운영 중. "
            "분석 워크로드 service-X가 S3를 NAT 경유로 접근하고 있고, ALB 일부는 트래픽 0인데 살아있고, "
            "auto scaling warm-up이 빠져 있어 스케일아웃 진동이 발생합니다. "
            "NAT 비용 폭증과 ALB idle이 모두 service-X에서 비롯됐는데, 단일 에이전트는 두 결론을 연결 못 합니다."
        ),
        "multi_agent_hint": "Network 전문가가 NAT 트래픽을 service별로 attribute → Compute 전문가가 service-X의 task 패턴 확인 → 두 결론을 합쳐야 진짜 root cause가 나옵니다.",
    },
    "MA-003": {
        "title": "EKS + ECR + Tag Governance",
        "components": ["L3-038", "L1-009", "L3-031"],
        "narrative": (
            "EKS 클러스터 다수를 운영 중. pod resource request가 실제 사용의 5~10배로 설정되어 노드 비용이 크고, "
            "ECR에는 lifecycle 정책이 없어 이미지 수백 개가 쌓였고, 리소스의 절반은 cost allocation tag가 빠져 있습니다. "
            "단일 에이전트는 pod over-provision은 잡지만 '왜 그렇게 됐는지' 거버넌스 root cause는 못 찾습니다."
        ),
        "multi_agent_hint": "EKS 전문가 + Registry 전문가 + Governance 전문가. tag 누락 → ECR pull frequency 불명 → lifecycle 설계 불가 같은 chain reasoning이 핵심입니다.",
    },
    "MA-004": {
        "title": "데이터 파이프라인 4-domain Fusion",
        "components": ["L2-022", "L2-015", "L3-037", "L2-023"],
        "narrative": (
            "실시간 분석 파이프라인. Kinesis Enhanced Fan-Out이 켜져 있고, Lambda timeout이 900초로 잡혔고, "
            "S3 Cross-Region Replication이 prefix 필터 없이 전체 적용됐고, Athena 결과 버킷에는 lifecycle이 없습니다. "
            "4 시나리오 각각은 단일로 명확한데, 합쳐서 보면 downstream 영향까지 추적해야 합니다."
        ),
        "multi_agent_hint": "Streaming + Compute + Storage + Analytics 4 전문가. 'Lambda timeout이 backlog 누적시켜 Athena scan 패턴 바꾼다' 같은 chain은 단일 에이전트가 못 잡습니다.",
    },
    "MA-005": {
        "title": "Multi-account RI + SP + 계정 미통합",
        "components": ["L3-032", "L3-033", "L3-034"],
        "narrative": (
            "AWS Organizations 미통합 12개 계정에서 각자 RI/SP를 구매했습니다. "
            "RI family는 m5인데 워크로드가 c5/r5로 이동했고, Compute SP coverage는 60%에 그쳤고, 계정 간 RI sharing이 꺼져 있습니다. "
            "1개 계정만 보면 모든 구매가 정상으로 보입니다."
        ),
        "multi_agent_hint": "계정별 전문가 N개 + Governance orchestrator. 'account-A의 idle RI를 account-B의 on-demand가 가져올 수 있다'는 통찰이 cross-account 분석에서만 나옵니다.",
    },
    "MA-006": {
        "title": "RDS Fleet 진단 (DB + Backup + Application)",
        "components": ["L1-004", "L1-013", "L2-020", "L3-040"],
        "narrative": (
            "dev/staging/prod RDS 인스턴스 12개. dev에 Multi-AZ가 켜져 있고, backup retention이 35일이고, "
            "Read Replica를 만들었는데 미사용이고, Lambda → RDS 연결에 RDS Proxy가 없습니다. "
            "RDS Proxy 부재 영향은 Lambda concurrency 패턴을 같이 봐야 결론이 나옵니다."
        ),
        "multi_agent_hint": "DB + Backup/DR + Application 3 전문가. Application 전문가가 connection pool exhaustion을 발견해야 DB 전문가가 'RDS Proxy 도입 시 다운사이즈 가능' 결론에 도달합니다.",
    },
    "MA-007": {
        "title": "Context-stress Test (100+ 리소스)",
        # 18 random scenarios from across L1/L2/L3
        "components": [
            "L1-001", "L1-005", "L1-008", "L1-010", "L1-011", "L1-013",
            "L2-014", "L2-018", "L2-019", "L2-020", "L2-022",
            "L3-025", "L3-029", "L3-031", "L3-035", "L3-036", "L3-038", "L3-039",
        ],
        "narrative": (
            "100+ AWS 리소스로 구성된 대규모 인프라. 시즌 1에서 다뤘던 18개 시나리오 패턴이 동시에 심어져 있습니다. "
            "main.tf만 5,000줄+, cost_report는 100+ 서비스가 등장합니다. "
            "단일 에이전트는 컨텍스트 한계로 평균 recall 43%, multi-agent 병렬 분석은 recall 90%+가 가능합니다."
        ),
        "multi_agent_hint": (
            "Orchestrator가 main.tf를 module/resource type별로 chunking → "
            "Compute / Storage / Network / Database / Governance 5 전문가 병렬. "
            "chunking 전략 자체가 평가 대상입니다."
        ),
    },
}

# Member → MA-XXX assignment (Week 2)
WEEK2_ASSIGNMENTS = {
    "dev-jiseok":    "MA-007",
    "seoyoungleeme": "MA-001",
    "juanxiu":       "MA-001",
    "7910trio":      "MA-002",
    "jud1thDev":     "MA-003",
    "600gramSik":    "MA-003",
    "do-dop":        "MA-004",
    "m1cks":         "MA-005",
    "weeeeestern":   "MA-006",
}


# ─────────────────────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────────────────────

def compute_seed(username: str, week: int, ma_id: str, salt: str = "season-2") -> int:
    h = hashlib.sha256(f"{username}:{week}:{ma_id}:{salt}".encode()).hexdigest()
    return int(h, 16) % (2**31)


def _prefix_terraform_resources(hcl: str, prefix: str) -> str:
    """Rename every `resource "TYPE" "NAME"` to `resource "TYPE" "PREFIX_NAME"`.

    Also updates references like `aws_instance.NAME.id` → `aws_instance.PREFIX_NAME.id`.
    """
    # Step 1: collect resource names
    rename_map: Dict[str, str] = {}
    for m in re.finditer(r'resource\s+"([^"]+)"\s+"([^"]+)"\s*{', hcl):
        rtype, rname = m.group(1), m.group(2)
        new_name = f"{prefix}{rname}"
        rename_map[(rtype, rname)] = new_name

    # Step 2: replace resource declarations
    def repl_decl(match):
        rtype, rname = match.group(1), match.group(2)
        new_name = rename_map.get((rtype, rname), rname)
        return f'resource "{rtype}" "{new_name}" {{'

    hcl = re.sub(r'resource\s+"([^"]+)"\s+"([^"]+)"\s*{', repl_decl, hcl)

    # Step 3: rewrite references (TYPE.NAME.attr or TYPE.NAME)
    # Only rewrite if a known rename exists.
    for (rtype, rname), new_name in rename_map.items():
        # word-boundary safe: TYPE.OLDNAME → TYPE.NEWNAME
        pattern = re.compile(rf'\b{re.escape(rtype)}\.{re.escape(rname)}\b')
        hcl = pattern.sub(f"{rtype}.{new_name}", hcl)

    return hcl


def _merge_terraform(component_dirs: List[Path], component_ids: List[str], out_path: Path) -> int:
    """Concatenate component main.tf files with prefix renaming. Returns line count."""
    PROVIDER_HEADER = (
        'terraform {\n'
        '  required_providers {\n'
        '    aws = {\n'
        '      source  = "hashicorp/aws"\n'
        '      version = "~> 5.0"\n'
        '    }\n'
        '  }\n'
        '}\n\n'
        'provider "aws" {\n'
        '  region = "us-east-1"\n'
        '}\n\n'
    )

    sections = [PROVIDER_HEADER]
    for i, (cdir, cid) in enumerate(zip(component_dirs, component_ids)):
        tf_file = cdir / "main.tf"
        if not tf_file.exists():
            continue
        tf = tf_file.read_text(encoding="utf-8")

        # Drop everything before the first `resource "..."` declaration
        # (this strips the terraform {} + provider "aws" {} blocks regardless of nesting).
        m = re.search(r'^\s*(resource|data|locals|variable|output|module)\s+', tf, re.MULTILINE)
        if m:
            tf = tf[m.start():]
        tf = tf.strip()

        prefixed = _prefix_terraform_resources(tf, f"comp{i+1}_")
        sections.append(f'# ═══════════════════════════════════════════════════════════════\n'
                        f'# Component {i+1}/{len(component_ids)} · seeded from {cid}\n'
                        f'# ═══════════════════════════════════════════════════════════════\n\n'
                        f'{prefixed}\n')

    merged = "\n".join(sections)
    out_path.write_text(merged, encoding="utf-8")
    return merged.count("\n")


def _merge_metrics(component_dirs: List[Path], component_ids: List[str], out_dir: Path):
    """Combine per-component metrics.json. `resources` is a dict {resource_id: data}.
    Prefix each resource_id with comp{N}_ to keep traceability and avoid collisions.
    """
    merged: Dict = {
        "metadata": {
            "scenario_id": "fusion",
            "period_days": 30,
            "resolution": "hourly",
            "fusion_components": component_ids,
        },
        "resources": {},
    }
    for i, (cdir, cid) in enumerate(zip(component_dirs, component_ids)):
        mfile = cdir / "metrics" / "metrics.json"
        if not mfile.exists():
            continue
        data = json.loads(mfile.read_text(encoding="utf-8"))
        resources = data.get("resources", {})
        # resources is dict {resource_id: {resource_type, is_problem, metrics: {...}}}
        for rid, rdata in resources.items():
            new_rid = f"comp{i+1}_{rid}"
            rdata["_source_scenario"] = cid
            merged["resources"][new_rid] = rdata

    metrics_dir = out_dir / "metrics"
    metrics_dir.mkdir(exist_ok=True)
    (metrics_dir / "metrics.json").write_text(
        json.dumps(merged, indent=2, ensure_ascii=False), encoding="utf-8"
    )


def _merge_cost_report(component_dirs: List[Path], component_ids: List[str], out_path: Path):
    """Sum per-component cost_report.json into one combined 6-month report.

    Per-component schema:
      {scenario_id, currency, period_months, monthly_data: [...], summary: {...}}
    monthly_data items: {month_offset, label, total_spend_usd, waste_usd, waste_pct, services: [{service, spend_usd, contains_waste}]}
    summary: {avg_monthly_total, avg_monthly_waste, waste_services, pricing_note}

    Strategy: keep month structure of first component, sum total_spend/waste across components,
    merge services arrays (sum spend per service), concatenate pricing notes.
    """
    # Collect by month_offset
    months_agg: Dict[int, Dict] = {}
    services_seen_in_waste: set = set()
    pricing_notes: List[str] = []
    avg_total = 0.0
    avg_waste = 0.0

    for i, (cdir, cid) in enumerate(zip(component_dirs, component_ids)):
        cfile = cdir / "cost_report.json"
        if not cfile.exists():
            continue
        data = json.loads(cfile.read_text(encoding="utf-8"))

        for month in data.get("monthly_data", []):
            mo = month.get("month_offset")
            if mo not in months_agg:
                months_agg[mo] = {
                    "month_offset": mo,
                    "label": month.get("label"),
                    "total_spend_usd": 0.0,
                    "waste_usd": 0.0,
                    "services_map": {},  # service → {spend, contains_waste}
                }
            months_agg[mo]["total_spend_usd"] += float(month.get("total_spend_usd", 0))
            months_agg[mo]["waste_usd"] += float(month.get("waste_usd", 0))
            for s in month.get("services", []):
                svc_name = s.get("service")
                if svc_name not in months_agg[mo]["services_map"]:
                    months_agg[mo]["services_map"][svc_name] = {"service": svc_name, "spend_usd": 0.0, "contains_waste": False}
                months_agg[mo]["services_map"][svc_name]["spend_usd"] += float(s.get("spend_usd", 0))
                if s.get("contains_waste"):
                    months_agg[mo]["services_map"][svc_name]["contains_waste"] = True

        summary = data.get("summary", {})
        avg_total += float(summary.get("avg_monthly_total", 0))
        avg_waste += float(summary.get("avg_monthly_waste", 0))
        for svc in summary.get("waste_services", []):
            services_seen_in_waste.add(svc)
        if summary.get("pricing_note"):
            pricing_notes.append(f"[{cid}] {summary['pricing_note']}")

    # Sort months by offset descending (most recent first, label like M-5 ... M-0)
    monthly_data = []
    for mo in sorted(months_agg.keys(), reverse=True):
        m = months_agg[mo]
        services_list = sorted(m["services_map"].values(), key=lambda x: -x["spend_usd"])
        for s in services_list:
            s["spend_usd"] = round(s["spend_usd"], 2)
        total = round(m["total_spend_usd"], 2)
        waste = round(m["waste_usd"], 2)
        monthly_data.append({
            "month_offset": m["month_offset"],
            "label": m["label"],
            "total_spend_usd": total,
            "waste_usd": waste,
            "waste_pct": round((waste / total * 100), 2) if total > 0 else 0,
            "services": services_list,
        })

    merged = {
        "scenario_id": "fusion",
        "currency": "USD",
        "period_months": 6,
        "_fusion_components": component_ids,
        "monthly_data": monthly_data,
        "summary": {
            "avg_monthly_total": round(avg_total, 2),
            "avg_monthly_waste": round(avg_waste, 2),
            "waste_services": sorted(services_seen_in_waste),
            "pricing_note": " · ".join(pricing_notes),
        },
    }
    out_path.write_text(json.dumps(merged, indent=2, ensure_ascii=False), encoding="utf-8")


def _build_readme(ma_id: str, ma_info: Dict, component_ids: List[str], company_name: str,
                  username: str, total_waste: float, line_count: int) -> str:
    """Build the season 1-style README narrative for the fused scenario."""

    component_list = "\n".join([f"- `{cid}`" for cid in component_ids])
    return f"""# {ma_id} · {ma_info['title']}

> **회사**: {company_name} · **인수자**: @{username}
> Week 2 · 데드라인: 2026-05-18 (월요일 22:00 세션 전까지)

## 상황

{ma_info['narrative']}

이번 주차는 **단일 에이전트로는 풀기 어려운 결합 시나리오**를 받았습니다. 분석할 대상이 `main.tf` 한 파일에 모두 들어 있는데, 라인 수가 약 **{line_count:,}줄**이고 여러 도메인이 섞여 있습니다.

## 인프라에 심어진 문제 패턴

이 시나리오는 시즌 1에서 다뤘던 다음 단일 패턴들을 **한 인프라에 동시 발생**시킨 것입니다:

{component_list}

> 단일 패턴은 시즌 1 [scenarios-guide.md](https://github.com/cloud-club/09th-ai-cloud-finops/blob/main/platform/docs/scenarios-guide.md) 에서 정의를 확인할 수 있습니다.

## 데이터 자료

| 파일 | 내용 |
|------|------|
| `main.tf` | 결합된 Terraform (약 {line_count:,}줄, 컴포넌트별 prefix `comp1_` ~ `comp{len(component_ids)}_`) |
| `cost_report.json` | 6개월 비용 히스토리 + 서비스별 breakdown · 월 낭비 추정 약 **${total_waste:,.0f}** |
| `metrics/metrics.json` | 30일 시간별 CloudWatch 메트릭 (모든 컴포넌트 리소스) |
| `hint.txt` | 멀티 에이전트 활용 힌트 |

## 분석 과제

1. **베이스라인 측정** — 본인의 현재 FinOps 도구(단일 에이전트 구조)로 이 시나리오를 분석. 발견 issue 수 / 토큰 사용량 / wall-clock 기록.
2. **멀티 에이전트 적용** — 본인 도구를 multi-agent로 리팩토링(or PoC) 후 같은 분석 재실행. 동일 metric 기록.
3. **결과 분석** — recall 향상 / 토큰 비용 변화 / emergent finding 도출 여부.

## 제출 형식

`Submit Answer` 페이지에서 시나리오 ID `{ma_id}`로 다음을 제출:
- **Analysis** — 발견한 문제, root cause, 권장 해결 (시즌 1 양식)
- **Optimized Terraform** — 결합 시나리오에서 수정한 `main.tf`
- **Estimated Monthly Savings** — 총 절감 추정액 (USD)
- **Report Upload** — `report.md` (단일 vs 멀티 비교 + 측정 데이터 + 회고)

## 힌트

{ma_info['multi_agent_hint']}

평가 기준:
- 발견한 문제 정확성 + 누락 패턴 수
- root cause 분석 깊이
- 권장 해결의 실행 가능성
- (보너스) 단일 vs 멀티 에이전트 측정 데이터 정직성
"""


def _build_hint(ma_id: str, ma_info: Dict, component_ids: List[str]) -> str:
    return f"""# Multi-Agent 분석 힌트

## {ma_id} · {ma_info['title']}

{ma_info['multi_agent_hint']}

## 컴포넌트별 추천 전문가 분담

이 시나리오에 심어진 패턴들:
{chr(10).join([f"- {cid}" for cid in component_ids])}

위 패턴들은 서로 다른 AWS 서비스/도메인에 속해 있어, 도메인별 전문가에게 분담하면
각 전문가의 컨텍스트가 줄고 정확도가 올라갑니다.

## 측정해 봐야 할 metric

1. **Recall** = (찾은 문제 수) / (실제 문제 수). 이 시나리오는 {len(component_ids)}개 패턴이 심어져 있음.
2. **토큰 사용량** = LLM API 호출 시 총 input + output tokens.
3. **Wall-clock 시간** = 분석 시작 → 결과 출력까지 실제 경과 시간.
4. **비용** = 토큰 × 단가. multi-agent는 일반적으로 단일 대비 토큰 ~15x 사용.

## 단일 에이전트 베이스라인 측정 팁

- 본인 도구의 기존 entry point로 main.tf + cost_report + metrics를 그대로 입력
- LLM API 응답에서 input/output token 수 기록
- 분석 결과에서 unique한 문제 항목 수 카운트
- 30일 metric을 봐야 잡히는 패턴(L2)이 잡혔는지 별도 표시

## 멀티 에이전트 설계 시 고려할 것

- **분할 기준**: AWS 서비스별 / 라이프사이클별 / 비용 카테고리별 중 선택
- **컨텍스트 격리**: 각 전문가가 받는 main.tf chunk는 자기 도메인만 (다른 도메인 리소스 노이즈 제거)
- **Orchestrator의 역할**: cross-domain 질문 받아 재분배, 최종 종합
- **Framework 선택**: Claude Code Subagent / LangGraph / Strands SDK / Bedrock AgentCore 중 본인 도구 스택과 가장 맞는 것
"""


# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────

def load_members(config_dir: Path) -> List[str]:
    with open(config_dir / "members.yaml", encoding="utf-8") as f:
        return [m["username"] for m in yaml.safe_load(f)["members"]]


def generate_for_member(username: str, ma_id: str, week: int, output_base: Path,
                        salt: str = "season-2") -> Dict:
    info = FUSION_MAP[ma_id]
    components = info["components"]
    base_seed = compute_seed(username, week, ma_id, salt)
    company = generate_company_profile(base_seed)

    out_dir = output_base / username / "season-2" / "problems" / f"week-{week:02d}" / ma_id
    out_dir.mkdir(parents=True, exist_ok=True)

    # 1. Generate each component into a temp dir
    component_dirs: List[Path] = []
    tmp_root = Path(tempfile.mkdtemp(prefix=f"s2_{username}_"))
    try:
        for i, comp_id in enumerate(components):
            comp_seed = base_seed + (i + 1) * 7919  # prime offset
            comp_out = tmp_root / f"comp{i+1}_{comp_id}"
            _generate_one(comp_id, comp_out, comp_seed, company,
                          generators_override=set())  # core gens only
            component_dirs.append(comp_out)

        # 2. Merge outputs
        line_count = _merge_terraform(component_dirs, components, out_dir / "main.tf")
        _merge_metrics(component_dirs, components, out_dir)
        _merge_cost_report(component_dirs, components, out_dir / "cost_report.json")

        # 3. Compute total monthly waste from summary.avg_monthly_waste
        cost = json.loads((out_dir / "cost_report.json").read_text(encoding="utf-8"))
        total_waste = float(cost.get("summary", {}).get("avg_monthly_waste", 0))

        # 4. README + hint
        (out_dir / "README.md").write_text(
            _build_readme(ma_id, info, components, company.name, username, total_waste, line_count),
            encoding="utf-8",
        )
        (out_dir / "hint.txt").write_text(
            _build_hint(ma_id, info, components), encoding="utf-8",
        )

        # 5. Update assignment.json
        assignment = {
            "season": "2",
            "week": week,
            "type": "fusion-analysis",
            "level": None,
            "scenarios": [ma_id],
            "theme": "멀티 에이전트 아키텍처 도입",
            "ma_id": ma_id,
            "components": components,
            "company": company.name,
            "seed": base_seed,
            "line_count": line_count,
            "expected_monthly_waste_usd": round(total_waste, 2),
            "reveal_date": "2026-05-11",
            "due_date": "2026-05-18",
        }
        assignment_path = out_dir.parent / "assignment.json"
        assignment_path.write_text(json.dumps(assignment, indent=2, ensure_ascii=False), encoding="utf-8")

        return {
            "username": username,
            "ma_id": ma_id,
            "components": components,
            "company": company.name,
            "line_count": line_count,
            "total_waste": total_waste,
        }
    finally:
        shutil.rmtree(tmp_root, ignore_errors=True)


def main():
    parser = argparse.ArgumentParser(description="Generate season 2 weekly fusion problems")
    parser.add_argument("--week", type=int, required=True)
    parser.add_argument("--output", type=str, default=str(ROOT / "members"))
    parser.add_argument("--salt", type=str, default=os.environ.get("GROUP_SALT", "season-2"))
    args = parser.parse_args()

    output_base = Path(args.output)

    if args.week != 2:
        print(f"WARNING: only Week 2 assignments are defined right now (got --week {args.week})")

    assignments = WEEK2_ASSIGNMENTS  # extend per-week as needed
    print(f"=== Season 2 · Week {args.week} fusion generation ===")
    print(f"Members: {len(assignments)}, salt: {args.salt}")
    print()

    summary = []
    for username, ma_id in assignments.items():
        print(f"Generating @{username} → {ma_id} ...")
        try:
            result = generate_for_member(username, ma_id, args.week, output_base, args.salt)
            summary.append(result)
            print(f"  ✓ {result['company']} · {result['line_count']:,} lines · "
                  f"~${result['total_waste']:,.0f}/mo waste · components: {', '.join(result['components'])}")
        except Exception as e:
            print(f"  ✗ FAILED: {type(e).__name__}: {e}")
            import traceback; traceback.print_exc()

    print(f"\nDone! {len(summary)}/{len(assignments)} members generated.")


if __name__ == "__main__":
    main()
