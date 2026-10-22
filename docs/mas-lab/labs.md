# MAS-Lab — Labs

A **lab** (`*.lab/`) holds the experiment manifests for one investigation. Each
`experiment.yaml` lists its **scenarios**, its **dataset**, and an **embedded
pipeline** that builds figures directly from the `events.jsonl` logs — so a lab
produces its charts, metrics and comparison reports with no separate plotting
scripts.

```bash
mas-lab benchmark run labs/<name>.lab/experiment.yaml --progress
```

## The paper labs

MAS-Lab ships **three reproducible labs**, one per experimental section of
*MAS-Lab: A Specification-Driven Validation Framework for Reliable Multi-Agent
Systems* (Augé, Carofiglio, Grassi, Samain — Cisco Systems / Outshift).

| Lab | Paper § | What it explores |
|---|---|---|
| `design-space.lab` | §5.1 | Design patterns and team topologies |
| `lifecycle-control.lab` | §5.2 | Governance **overlays** across the lifecycle |
| `extensions.lab` | §5.3 | Memory and context **overlays** |

Note what the second and third have in common: both vary **overlays**, not
application logic. That is the axis separation doing its job — governance and
memory are changed, audited and measured independently of the MAS being studied.

### Named experiments

| `experiment.name` | Output path |
|---|---|
| `lab1-exp1.1-design-patterns-qa` | `$XDG_DATA_HOME/mas/labs/lab1-exp1.1-design-patterns-qa/` |
| `lab1-exp1.2-topologies-trip-planner` | `$XDG_DATA_HOME/mas/labs/lab1-exp1.2-topologies-trip-planner/` |
| `lifecycle-control` | `$XDG_DATA_HOME/mas/labs/lifecycle-control/lifecycle-control/` |
| `memory-extension-reproducibility` | `$XDG_DATA_HOME/mas/labs/memory-extension-reproducibility/` |

## Running them

The labs run over the sample applications shipped with MAS-Lab, and reproduce with
a single command.

[:octicons-arrow-right-24: Quickstart and reproduction steps](tutorials.md)

## IoC labs

Labs specific to IoC protocol validation live in the IoC repositories rather than
upstream.

### `sre-triage`

The lab behind the first measured [CONCORD](../cognition-protocols/concord/design.md#worked-example)
evidence. Several role-specialised agents — security, cost, latency, network —
must converge on a single remediation for an incident. Each agent is correct from
its own role, and the conflict between them is structural rather than a fault.

**Layout** (`ioc-core-l9-main/mas-lab/sre-triage/`):

| Path | Contents |
|---|---|
| `mas.yaml` · `infra.yaml` | Base MAS definition and infrastructure bundle |
| `experiment.yaml` | Scenario matrix and run configuration |
| `agents/` · `prompts/` | Agent definitions and versioned prompts |
| `skills/` · `tools/` | CONCORD orchestrator / receiver skills and the protocol engine tools |
| `datasets/` · `data/` | Incident items, each carrying a `correct_action` ground truth |
| `overlays/` · `scenario-overlays/` · `pattern-overlays/` · `prompt-overlays/` | The variation axes |
| `hybrid-regression.yaml` · `run_eval.py` | Regression configuration and evaluation entry point |

**What it measures** — two independent metrics, and **both must be reported**:

| Metric | Question |
|---|---|
| **Certification** | Did every agent clear its satisfaction floor? |
| **Correctness** | Did the run choose the `correct_action` ground truth? |

CONCORD certifies that all agents cleared their floor; it says nothing about
whether the action is right. Reporting only the first would let a confident wrong
answer read as success.

**Comparators** — the lab runs the protocol against owner-decides, llm-picks,
plurality, best-average, unanimity, and `llm-writes-one` (an LLM commander given
every plan and every score and asked to synthesise). `llm-writes-one` is the
strongest non-protocol comparator; it produces a viable plan but does not verify
whether the plan clears every agent's floor.

!!! danger "The A/B overlay is currently a no-op"
    `overlays/with-consensus-protocol.yaml` is `spec: {}`. The CONCORD skills were
    authored but wired into the **base** `mas.yaml` agents instead of the overlay,
    so `protocol-enabled` and `protocol-disabled` in `experiment.yaml` describe the
    same system.

    **No live A/B measurement of CONCORD is possible until the skills and tools
    move out of the base agents into the overlay.** The results published today
    come from replaying a recorded run. Tracked as **G-1** in the
    [CONCORD gap list](../cognition-protocols/concord/evaluation.md#threshold-calibration).

!!! warning "TODO"
    ACCORD intent-alignment labs, and labs covering the remaining protocol concerns, are
    not yet defined. Owners to add.

## Source material

- the MAS-Lab repository, under `labs/`
- Paper map — `docs/paper/`
- Tutorial 3 — Run an experiment
- `ioc-core-l9-main/mas-lab/sre-triage/` · the CONCORD implementation review
