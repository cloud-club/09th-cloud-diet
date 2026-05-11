# Week 2 — 멀티 에이전트 아키텍처 학습 자료

> 이번 주차 목표: Claude Code Subagent / LangGraph / Strands SDK / Bedrock AgentCore 비교 학습 + "오케스트레이터 + 도메인 전문가" 패턴 + 컨텍스트 격리·토큰 효율화 기법.
> 각자 자기 FinOps 도구에 가장 적합한 패턴을 골라 적용하는 것이 산출물.

---

## 🎯 이번 주차에서 가져가야 할 것

1. **5가지 워크플로우 패턴** — Prompt Chaining / Routing / Parallelization / Orchestrator-Worker / Evaluator-Optimizer 의 적용 시점 판단
2. **"왜 멀티 에이전트인가"** — 토큰 사용량 15x 비싸지는데도 쓸 가치가 있는 시점 판단
3. **프레임워크 비교** — Claude Subagent vs LangGraph vs Strands vs AgentCore 의 trade-off
4. **본인 도구 적용 안 (1개)** — 다음 주까지 적용해 올 구체적 plan

---

## 🔴 필수 (이번 주차 토론 베이스, 모두 읽어 오기)

### 1. [Building Effective AI Agents — Anthropic 원전](https://www.anthropic.com/research/building-effective-agents)
**Anthropic 공식 / 2024.12 / 읽기 30분**
멀티 에이전트 시스템 설계의 정전. **5개 워크플로우 패턴** (Prompt Chaining, Routing, Parallelization, Orchestrator-Workers, Evaluator-Optimizer)을 정의. "workflows vs agents" 구분도 여기서 나옴. 복잡한 프레임워크 없이 **simple, composable patterns**로 시작하라는 권고.
> 핵심 인사이트: 멀티 에이전트 = 만능 아님. 단순 patterns 조합으로 충분한 경우가 대다수.

### 2. [How we built our multi-agent research system — Anthropic Engineering](https://www.anthropic.com/engineering/multi-agent-research-system)
**Anthropic 공식 엔지니어링 블로그 / 읽기 25분**
Anthropic이 자기네 Research 기능을 만든 실제 경험담. **토큰 사용량 측정 데이터** 포함 — 일반 chat 대비 agent는 4x, multi-agent는 15x. **80% 분산이 토큰 사용량으로 설명됨**.
> Week 2 출제용 핵심 자료. "Orchestrator(Lead Researcher) + parallel subagents" 패턴이 어떻게 작동하는지 실제 사례로 설명.

### 3. [Effective context engineering for AI agents — Anthropic Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
**Anthropic 공식 / 읽기 20분**
컨텍스트 격리·토큰 효율화의 원전. "find the smallest set of high-signal tokens" 라는 원칙. **compaction / token-efficient tools / just-in-time exploration** 3가지 핵심 기법.
> Week 2 주제 "컨텍스트 격리·토큰 효율화 기법" 가이드.

---

## 🟡 권장 (자기 도구 적용 시 직접 참고)

### Claude Code Subagent

| 자료 | 한 줄 설명 |
|------|-----------|
| [Create custom subagents — Claude Code Docs](https://code.claude.com/docs/en/sub-agents) | Claude Code 안에 subagent 정의·연결하는 공식 가이드. 각 subagent가 별도 컨텍스트 윈도우 + 자체 시스템 프롬프트 + tool/permission 격리. |
| [Subagents in the Agent SDK](https://platform.claude.com/docs/en/agent-sdk/subagents) | API/SDK 레벨에서 subagent 정의하는 방법. Claude Code 안 쓰고 자체 도구에 통합할 때 필수. |
| [Claude Code Advanced Patterns (PDF)](https://resources.anthropic.com/hubfs/Claude%20Code%20Advanced%20Patterns_%20Subagents,%20MCP,%20and%20Scaling%20to%20Real%20Codebases.pdf) | Anthropic 공식 PDF. 실제 large codebase에 subagent + MCP 적용한 사례. |
| [wshobson/agents (GitHub, 인기 repo)](https://github.com/wshobson/agents) | 실전 multi-agent 오케스트레이션 예제 모음. 자기 도구 적용 시 starter로 좋음. |
| [Anthropic Skilljar: Introduction to Subagents (코스)](https://anthropic.skilljar.com/introduction-to-subagents) | 영상 + 실습 코스. 손으로 따라 만들고 싶은 사람용. |

### AWS Strands SDK

| 자료 | 한 줄 설명 |
|------|-----------|
| [Strands Agents 공식 사이트](https://strandsagents.com/) | Python + TypeScript SDK. Quickstart 20분. **model-driven 접근** — 모델 추론 능력 기반으로 도구 호출. |
| [Introducing Strands Agents — AWS Open Source Blog (한국어)](https://aws.amazon.com/ko/blogs/tech/introducing-strands-agents-an-open-source-ai-agents-sdk/) | AWS 공식 한국어 소개. 왜 Strands를 만들었는지 배경 + 다른 SDK와의 차이. |
| [Strands SDK Technical Deep Dive](https://aws.amazon.com/blogs/machine-learning/strands-agents-sdk-a-technical-deep-dive-into-agent-architectures-and-observability/) | architecture + observability 깊게. multi-agent 패턴 + memory management 설명. |
| [strands-agents/sdk-python (GitHub)](https://github.com/strands-agents/sdk-python) | 코드 + 샘플. |

### Bedrock AgentCore

| 자료 | 한 줄 설명 |
|------|-----------|
| [Amazon Bedrock AgentCore 공식](https://aws.amazon.com/bedrock/agentcore/) | AWS 매니지드 에이전트 플랫폼. runtime / memory / identity / observability 다 제공. |
| [Multi-Agent Orchestration with AgentCore + Strands (GitHub, AWS 공식)](https://github.com/aws-solutions-library-samples/guidance-for-multi-agent-orchestration-using-bedrock-agentcore-on-aws) | 실제 multi-agent 시스템을 AgentCore + Strands로 구축한 솔루션 가이드. 코드 + 아키텍처. |
| [bedrock-agentcore-sdk-python (GitHub)](https://github.com/aws/bedrock-agentcore-sdk-python) | Python SDK. framework-agnostic primitives. |

### LangGraph

| 자료 | 한 줄 설명 |
|------|-----------|
| [Workflows and agents — LangChain 공식 docs](https://docs.langchain.com/oss/python/langgraph/workflows-agents) | LangGraph 워크플로우 + agent 패턴 공식 문서. |
| [langgraph-supervisor-py (GitHub)](https://github.com/langchain-ai/langgraph-supervisor-py) | Supervisor pattern 구현체. 코드로 바로 적용 가능. |
| [Multi-Agent Orchestration in LangGraph: Supervisor vs Swarm](https://dev.to/focused_dot_io/multi-agent-orchestration-in-langgraph-supervisor-vs-swarm-tradeoffs-and-architecture-1b7e) | 두 패턴 trade-off 분석 (DEV Community). 어느 쪽이 본인 도구에 맞는지 판단용. |
| [LangGraph Multi-Agent on AWS (Guidance GitHub)](https://github.com/aws-solutions-library-samples/guidance-for-multi-agent-orchestration-langgraph-on-aws) | LangGraph를 AWS에서 운영하는 가이드. |

---

## 🟦 핵심 (도메인 직결 — FinOps Multi-Agent 사례)

> 우리 스터디 주제와 **정확히 같은 도메인** 사례. AWS가 공식으로 만들어 둔 FinOps multi-agent 가이드가 있음. **이번 주차 출제도 이 구조에서 영감 받기 좋음**.

### 1. [Build a FinOps agent using Amazon Bedrock AgentCore — AWS Blog](https://aws.amazon.com/blogs/machine-learning/build-a-finops-agent-using-amazon-bedrock-agentcore/)
**AWS 공식 / 2026 / 읽기 25분**
**FinOps supervisor agent + Cost analysis agent (Cost Explorer 호출) + Cost optimization agent (Trusted Advisor 호출)** 3-agent 구조. AgentCore Runtime + Strands SDK + Claude Sonnet 4.5. 우리가 만들고 있는 도구와 가장 가까운 reference.
> 핵심 패턴: supervisor가 사용자 질의 받아 → cost analysis (현황) / cost optimization (권장) 두 전문가에 분배.

### 2. [Build a FinOps agent with multi-agent + Amazon Nova](https://aws.amazon.com/blogs/machine-learning/build-a-finops-agent-using-amazon-bedrock-with-multi-agent-capability-and-amazon-nova-as-the-foundation-model/)
**AWS 공식 / 읽기 20분**
같은 도메인을 **Nova 모델**로 구현한 버전. 모델 차이 비교용으로 좋음.

### 3. [Cost Analysis & Optimization with Bedrock Agents — AWS Solutions Library GitHub](https://github.com/aws-solutions-library-samples/guidance-for-cost-analysis-and-optimization-with-amazon-bedrock-agents)
**AWS 공식 GitHub / 코드 직접 실행 가능**
위 블로그의 **실제 deploy 가능한 코드**. CloudFormation / Terraform 포함. 이번 주차에 직접 돌려보면서 학습 가능.

### 4. [sample-finops-agent-amazon-bedrock-agentcore (GitHub)](https://github.com/aws-samples/sample-finops-agent-amazon-bedrock-agentcore)
**AWS Samples / GitHub**
multi-account FinOps에 특화된 sample. finance 팀이 multi-account AWS 비용 관리하는 시나리오.

### 5. [sample-finops-bedrock-multiagent-nova (GitHub)](https://github.com/aws-samples/sample-finops-bedrock-multiagent-nova)
**AWS Samples / GitHub**
Nova 모델 버전 sample. 한국 리전에서 비용 최적화 검증할 때 참고.

### 6. [FinOps Agent — A Use-Case for IT Infrastructure and Cost Optimization (arXiv)](https://arxiv.org/html/2510.25914v1)
**학술 논문 / 읽기 40분**
FinOps agent의 형식적 설계 + 평가 방법론. 자기 도구 효과를 정량 측정하고 싶을 때 참고.

---

## 🟩 한국어 사례 (한국어 자료가 편한 사람용)

> 시즌 1 week 4 자료(야놀자 Strands+AgentCore AIOps 사례)는 베이스 컨텍스트로 깔고, 이번 주차에는 그 외 자료들을 본다.

### 1. [프로덕션 Multi-Agent 시스템이 해결해야 할 5가지 문제 — Deep Insight 아키텍처](https://aws.amazon.com/ko/blogs/tech/practical-design-lessons-from-the-deep-insight-arch/)
**AWS 한국 블로그 / 읽기 30분**
실제 프로덕션 multi-agent에서 만나는 함정 5가지 + 해결 방법. 자기 도구 운영 단계 진입 시 필독.

### 2. [에이전틱 AI와 Amazon Bedrock AgentCore를 활용한 전문가 팀 시뮬레이션](https://aws.amazon.com/ko/blogs/tech/simulating-expert-teams-with-agentic-ai-and-amazon-bedrock-agentcore/)
**AWS 한국 블로그 / 읽기 20분**
"여러 분야 전문가" 시뮬레이션 구체 사례. 우리 multi-agent FinOps 시나리오(`MA-001 ~ 007`)와 직접 매칭됨.

---

## 🟢 심화 (시간 남으면)

### 1. [Anthropic Cookbook — Agent Patterns (GitHub)](https://github.com/anthropics/anthropic-cookbook/tree/main/patterns/agents/)
5개 패턴 모두의 **minimal reference 구현**. 코드로 바로 보고 싶을 때.

### 2. [Building Effective AI Agents — Architecture Patterns and Implementation Frameworks (PDF)](https://resources.anthropic.com/hubfs/Building%20Effective%20AI%20Agents-%20Architecture%20Patterns%20and%20Implementation%20Frameworks.pdf)
Anthropic이 publish한 architecture patterns 통합 문서. 1번 블로그의 확장판.

### 3. [Claude Code Agent Teams, Subagents, and MCP: The 2026 Playbook](https://www.developersdigest.tech/blog/claude-code-agent-teams-subagents-2026)
2026년 기준 Claude 생태계 종합 정리. Agent Teams (2026 신규) 포함.

### 4. [Multi-Agent AI Systems for Cloud Cost Optimization in 2026](https://www.msrcosmos.com/blog/scaling-multi-agent-ai-systems-for-cloud-cost-optimization-in-2026/)
업계 전반 trend. 우리 스터디의 외부 동향 컨텍스트.

### 5. [Context Engineering for Multi-Agent LLM Code Assistants (arXiv)](https://arxiv.org/pdf/2508.08322)
컨텍스트 엔지니어링 학술 논문. 코드 어시스턴트 도메인이지만 패턴이 일반화됨.

---

## 📋 토론 토픽 (월요일 22:00 세션용)

읽어 오고 아래 질문 본인 도구에 대입해서 답 준비:

1. **5개 패턴 중** 본인 FinOps 도구에 가장 적합한 것은? 왜?
2. **Orchestrator-Worker** vs **Routing** — 본인 도구 use case에 어느 쪽이 맞나?
3. **컨텍스트 격리**가 의미 있는 시점은? 본인 도구의 main.tf parsing이 컨텍스트 60K tok 넘는가?
4. **15x 토큰 비용** 정당화되려면 본인 도구의 가치 metric이 뭐여야 하나?
5. **Claude Subagent vs Strands vs LangGraph vs AgentCore** 중 본인 도구의 기존 스택과 가장 통합 쉬운 것?
6. AWS FinOps agent 공식 sample (위 🟦 1번)이 우리 도구와 어떻게 다른가? 어떤 점은 따라하고 어떤 점은 차별화할 것인가?

---

## 🎯 산출물 (다음 주까지)

- [ ] 본인 FinOps 도구의 **현재 단일 에이전트 구조**를 다이어그램으로
- [ ] **멀티 에이전트 리팩토링 plan** (어떤 도메인 전문가들을 / 어떻게 분할 / orchestrator는 무엇인지)
- [ ] **선택한 프레임워크 + 이유**
- [ ] **컨텍스트 격리 전략** (각 전문가 입력으로 무엇이 들어가나)
- [ ] (옵션) 실제 리팩토링된 PoC 코드
