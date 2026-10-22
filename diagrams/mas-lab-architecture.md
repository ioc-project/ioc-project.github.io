# MAS-Lab — architecture

*Source: [outshift-open/mas-lab](https://github.com/outshift-open/mas-lab), `main`. Drawn from `docs/overview.md`, `docs/glossary.md`, `docs/references/contracts.md`, `docs/packages-reference.md` and the manifest references.*

## 1. What problem the architecture solves

Multi-agent systems are easy to prototype and hard to trust. The reason is structural: logic, orchestration and control are typically interwoven in the same code, so behaviour cannot be reproduced and failures cannot be attributed. When a result changes, there is no way to tell whether the cause was the thing you changed or drift somewhere else in the stack.

MAS-Lab's response is to make **intent, execution, observability and governance four separate artifacts** rather than four concerns tangled in one program. Everything that can vary is declared outside the code, so a difference in outcome is attributable to the variable that changed.

This single idea generates the whole architecture. Each element below exists because something had to be pulled out of application code to make attribution possible.

## 2. Shape of the system

The system is a five-stage pipeline from declaration to result, driven by an experiment control plane:

```
LAB  ──────────────────────────────────────────────────────────────►
  │                                                                 ▲
  ▼                                                                 │
SPECIFY ──► COMPOSE ──► EXECUTE ──► OBSERVE ──► ANALYSE ────────────┘
manifests   mas-ctl     mas-runtime  events      pipeline DAG
```

Each stage hands the next a well-defined artifact — manifests, a runnable configuration, events, run artifacts, results. Nothing is passed implicitly.

## 3. Stage 1 — Specify

Everything is a YAML manifest. There is no imperative glue.

**Application intent**

| Manifest | Declares |
|---|---|
| `Agent` (`agent.yaml`) | A single LLM actor: tools, skills, plugins, design pattern, models |
| `MAS` (`mas.yaml`) | `agency.agents[]`, the workflow graph (entry, nodes, edges), transport, shared tools, memory stores, infra refs, telemetry path, and a top-level `intent` |

**Variation axes** — the three-way split is the load-bearing design decision:

| Manifest | Question it answers | Contents |
|---|---|---|
| `Overlay` | **What varies** | An RFC 7396-style merge patch onto an Agent, MAS or Flavour. Patches design patterns, agent config and tools, workflow topology, parameters, scenario-injected tools. Later overlays in a stack win. |
| `Flavour` | **How it deploys** | Observability export, transport mode (local / gRPC / hybrid), tool policy, mocking, RAG backend |
| `Infra` (`infra/v1`) | **Where it resolves** | `LLMProxy`, `LLMLocal`, `ToolRegistry`, `ToolServerRegistry`, `PersonalSecrets`, `Application`, composed via `InfraBundle` |

The prohibitions matter as much as the permissions. An overlay **cannot** patch model endpoints, API keys or raw system prompts — those live in the agent role and infra manifests. A flavour **cannot** carry model API URLs. Without these rules the axes would leak into each other and a "scenario" could silently change the model it runs against, which would destroy attribution.

**Experiment**

| Manifest | Declares |
|---|---|
| `Experiment` (`experiment.yaml`) | `applications`, `scenarios` (each an overlay stack over the **logic / control / infra** axes), `dataset`, `run.n_runs`, `pipeline`, `evaluation`, typed `artifacts` |
| `Dataset` | Input items and expected fields |
| `Pipeline` | Ordered analysis steps |

A **lab definition** is a folder `*.lab/` under `labs/` bundling an experiment with its datasets, overlays and any custom pipeline steps.

## 4. Stage 2 — Compose (`mas-ctl`)

`mas-ctl` resolves specifications into something runnable, and does so *before* execution:

1. **Resolve overlays** — RFC 7396 merge onto the target resource, later overlays winning on conflicting keys
2. **Bind flavour** — observability, transport, tool policy, mocking
3. **Resolve infra refs** — proxies, registries, secrets, endpoints
4. **Validate** — schema and contract checks

Output: **one fully-resolved runnable configuration per (scenario, dataset item, repeat index)**. Nothing about the topology, tooling or policy is decided during the run. This is what makes a run reproducible from its configuration alone.

`mas-ctl` also owns compose, session and placement, and provides `chat`, `run-mas` and `validate`.

## 5. Stage 3 — Execute (`mas-runtime`)

`mas-runtime` is an embeddable library built on a **Mealy kernel**: input plus current state determines output and next state.

**Execution model.** User input reaches the entry agent, which dispatches `delegate_to_*` tool calls along the workflow's delegation edges to specialist agents. Each agent runs its own design pattern; all share the transport bus. Memory is episodic, semantic or procedural.

**Contracts are the architectural core.** A contract describes what the kernel may call. The kernel never reaches past one. Three families:

| Family | Boundary |
|---|---|
| **Capability** | Tools, models, sessions — access to the outside world |
| **Orchestration** | Workflow, delegation, transport — control flow across agents |
| **Governance** | Budgets, routing, permissions — what is allowed |

Plugins implement contracts. Because the kernel only ever calls a contract, swapping a plugin cannot ripple through the rest of the stack — the property that lets you vary one thing and trust the result.

**The governance gate.** Every tool, model and memory call passes a governance check *before* reaching its capability contract. Policies are declarative YAML matching conditions to actions — `block`, `approve`, `modify`, `log`, `retry`. Parametric profiles supply a fallback posture. Budgets are tracked across turns by stateful plugins.

The consequence: governance is not written into agent logic. It is an overlay, which means it can be varied as an experimental axis like anything else.

## 6. Stage 4 — Observe

Events are emitted **at contract boundaries**, not from agent code. This is why observability coverage does not depend on how carefully an agent was written.

- **`events.jsonl`** — one JSON object per line: model calls, tool calls, governance decisions, routing. Machine-readable by construction, not a log to be parsed.
- **`traces/`** — one directory per run, keyed by scenario, item and repeat index.
- **Trace cache** — reuses completed run logs for identical inputs, so repeats cost nothing in model calls.
- **Exchange log** — a human-readable transcript on `mas-ctl chat --trace`.

Observability is configuration (`spec.observability`, an overlay, or `--events`), never a code change.

## 7. Stage 5 — Analyse (`mas-lab-bench`)

A pipeline of steps forms a DAG ordered by `depends_on`, with cycle detection. Registered steps include `extract_trajectories`, `extract_trace_stats`, `eval_mce` and the `plot_*` family.

Steps exchange **typed artifacts** — `trace`, `metrics`, `plot` — in process, serializing only where an output path is declared. Results land in `results/` as CSV and PNG.

Pipelines are either embedded in `experiment.yaml` (run automatically after the execution phase) or standalone under `lab/pipelines/`, reusable and UI-editable. The two forms are not mixed.

Because analysis reads stored traces, it re-runs without re-executing the MAS.

## 8. The LAB control plane

`mas-lab benchmark run` executes all runs, then the pipeline. It nests four levels, each supporting `pre:` and `post:` pipeline hooks:

| Level | Scope |
|---|---|
| **Application** | The whole experiment — infrastructure allocation, metric aggregation |
| **Scenario** | One overlay stack |
| **Test** | One dataset item across all runs |
| **Run** | One execution for a given (scenario, item, repeat index) → `traces/events.jsonl` |

`n_runs` repeats each (scenario, item) pair, so variance is measured rather than assumed.

## 9. Packages

| Layer | Package | Role |
|---|---|---|
| Runtime | `mas-runtime` | Mealy kernel, contracts, plugins, design patterns |
| Orchestration | `mas-ctl` | Compose, session, placement; chat, run-mas, validate |
| Lab | `mas-lab-core` | Shared contracts and telemetry |
| | `mas-lab-bench` | Benchmark execution and pipelines |
| | `mas-lab-controller` | Daemon with HTTP API |
| | `mas-lab-content` | Markdown rendering with directives |
| | `mas-lab` | Meta-package tying the above together |
| Libraries | `mas-library-standard` | Flavours, overlays, infra bundles, tools |
| | `mas-library-eval` | Evaluation metrics consumed by pipeline steps |
| | `mas-library-samples` | Community applications |

Dependencies layer strictly upward; there are no cycles. Surfaces include `mas-ctl` (CLI and TUI), the Web UI with its overlay builder and run inspection, and the controller's HTTP API.

## 10. Why the architecture holds together

Four properties compound, and each depends on the one before it:

1. **Testable** — contracts give stable boundaries to assert against.
2. **Reproducible** — the full configuration is resolved before execution, so a run is a function of its manifests.
3. **Observable** — events come from contract boundaries, so coverage is structural rather than a matter of instrumentation discipline.
4. **Governable** — policy is an overlay outside application logic, so it can be changed, audited and varied independently.

The experimental claim rests on all four: *observed differences are more likely to reflect the variable you changed, not hidden stack drift.* That claim is only as strong as the separation of the three variation axes, which is why the prohibitions in §3 — no model endpoints in overlays, no API URLs in flavours — are load-bearing rather than stylistic.

## 11. Open points to confirm with the maintainers

- Where `evaluation` (`trace_only` and its alternatives) sits relative to the pipeline — a distinct stage or the first pipeline step.
- Whether the `logic / control / infra` scenario axes are enforced by schema or are a convention.
- Cache invalidation semantics for the trace cache — what exactly constitutes "identical inputs" when a flavour or infra ref changes.
