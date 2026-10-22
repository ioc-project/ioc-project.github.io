---
title: Getting Started
---

# Getting Started

<p class="eyebrow">Adoption, not migration</p>

IoC Core is consumed **incrementally**. Nothing here asks you to move a
multi-agent system onto a new platform: the entry point is a pair of Cognition
Protocol skills, placed either in the agents or in the AgentBridge, and each
further mode adds one component and establishes one property.

The three **consumption modes** are cumulative. Modes 1 and 2 are production
insertion paths; mode 3 is the experimentation and validation path. The agent
harness is optional in modes 1 and 2 &mdash; insertion is per agent either way.

## Explore the modes

Pick a mode and the architecture dims to just the components it puts in play.
Hovering a block in the staircase highlights the matching element on the canvas.

<div class="ioc-explorer" markdown="0">
  <div>
    <h4>Choose a mode</h4>
    <p class="ioc-group">Run MAS in production</p>
    <ul class="ioc-modes" id="ioc-modes-prod"></ul>
    <p class="ioc-group second">Experiment, benchmark and verify cognitive coverage</p>
    <ul class="ioc-modes" id="ioc-modes-lab"></ul>
    <p class="ioc-reading" style="margin-top:1rem">The harness is optional in modes 1 and 2 and has no
      counterpart on the canvas &mdash; insertion is per agent either way.</p>
  </div>

  <div>
    <div class="ioc-bar">
      <h4>IoC architecture</h4>
      <button class="ioc-toggle" id="ioc-dim" aria-pressed="true" type="button">dim inactive</button>
    </div>
    <div class="ioc-canvas">
      <svg id="ioc-arch" viewBox="0 0 900 566" role="img" aria-labelledby="archTitle">
                <title id="archTitle">IoC architecture with the components of the selected consumption mode highlighted</title>

                <defs>
                  <marker id="ah-amber" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="8" refX="10" refY="4" orient="auto">
                    <path d="M0.5 0.5 L10 4 L0.5 7.5 z" fill="var(--c-amb-ln)"/>
                  </marker>
                  <marker id="ah-blue" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="8" refX="10" refY="4" orient="auto">
                    <path d="M0.5 0.5 L10 4 L0.5 7.5 z" fill="var(--c-blue-ln)"/>
                  </marker>
                  <marker id="ah-pur" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="8" refX="10" refY="4" orient="auto">
                    <path d="M0.5 0.5 L10 4 L0.5 7.5 z" fill="var(--c-pur-ln)"/>
                  </marker>
                </defs>

                <!-- ============ MAS-LAB SPINE ============ -->
                <g data-group="maslab">
                  <rect x="10" y="22" width="26" height="520" rx="8" fill="var(--c-lab)" opacity="0.18" stroke="var(--c-lab)" stroke-width="1.4"/>
                  <text x="23" y="282" text-anchor="middle" font-size="12" font-weight="700" fill="var(--c-lab)" letter-spacing="2.4" transform="rotate(-90 23 282)">MAS-LAB</text>
                </g>

                <!-- ============ FEDERATION (context) ============ -->
                <g data-group="peer">
                  <rect x="52" y="26" width="196" height="58" rx="8" fill="var(--c-amb-bg)" stroke="var(--c-amb-ln)" stroke-width="1.3"/>
                  <text x="150" y="50" text-anchor="middle" font-size="11" fill="var(--c-amb-ink)">Cognition Fabric nodes</text>
                  <text x="150" y="68" text-anchor="middle" font-size="10" fill="var(--c-amb-ink)" opacity="0.72">other domains / organisations</text>
                </g>

                <!-- ============ COGNITION ENGINES (context) ============ -->
                <g data-group="engines">
                  <rect x="268" y="26" width="620" height="58" rx="8" fill="var(--c-pur-bg)" stroke="var(--c-pur-ln)" stroke-width="1.3"/>
                  <text x="578" y="50" text-anchor="middle" font-size="11" font-weight="600" fill="var(--c-pur-ink)">Cognition Engines &mdash; COGs &middot; GATs</text>
                  <text x="578" y="68" text-anchor="middle" font-size="10" fill="var(--c-pur-ink)" opacity="0.72">bind the API tiers their function requires</text>
                  <path d="M430 88 L430 108" stroke="var(--c-pur-ln)" stroke-width="1.4" marker-end="url(#ah-pur)"/>
                  <path d="M578 88 L578 108" stroke="var(--c-pur-ln)" stroke-width="1.4" marker-end="url(#ah-pur)"/>
                  <path d="M726 88 L726 108" stroke="var(--c-pur-ln)" stroke-width="1.4" marker-end="url(#ah-pur)"/>
                </g>

                <!-- ============ COGNITION FABRIC ============ -->
                <g data-group="fabric">
                  <rect x="52" y="112" width="836" height="150" rx="9" fill="var(--c-amb-bg)" stroke="var(--c-amb-ln)" stroke-width="1.5"/>
                  <text x="66" y="130" font-size="10" font-weight="700" fill="var(--c-amb-ink)" letter-spacing="1.1">COGNITION FABRIC</text>
                  <rect x="66" y="138" width="808" height="26" rx="6" fill="none" stroke="var(--c-amb-ln)" stroke-width="1"/>
                  <text x="470" y="156" text-anchor="middle" font-size="10.5" fill="var(--c-amb-ink)">CF APIs &middot; management plane &middot; sync &amp; routing</text>
                </g>

                <g data-group="scope">
                  <rect x="66" y="172" width="396" height="78" rx="7" fill="var(--c-blue-lt)" stroke="var(--c-blue-ln)" stroke-width="1.4"/>
                  <text x="264" y="196" text-anchor="middle" font-size="12" font-weight="600" fill="var(--c-blue-ink)">SCOPE</text>
                  <text x="264" y="215" text-anchor="middle" font-size="10" fill="var(--c-blue-ink)" opacity="0.78">knowledge graph &middot; Cognition Store</text>
                  <text x="264" y="234" text-anchor="middle" font-size="10" fill="var(--c-blue-ink)" opacity="0.78">normalization &middot; analysis &middot; insight</text>
                </g>

                <g data-group="pe">
                  <rect x="478" y="172" width="396" height="78" rx="7" fill="var(--c-amb-bg)" stroke="var(--c-amb-ln)" stroke-width="1.6"/>
                  <text x="676" y="196" text-anchor="middle" font-size="12" font-weight="600" fill="var(--c-amb-ink)">Platform Engine</text>
                  <text x="676" y="215" text-anchor="middle" font-size="10" fill="var(--c-amb-ink)" opacity="0.8">detects the cognitive failure</text>
                  <text x="676" y="234" text-anchor="middle" font-size="10" fill="var(--c-amb-ink)" opacity="0.8">and fires the protocol response</text>
                </g>

                <!-- ============ COGNITION PROTOCOLS ============ -->
                <g data-group="protocols">
                  <rect x="52" y="290" width="836" height="74" rx="9" fill="var(--c-blue-lt)" stroke="var(--c-blue-ln)" stroke-width="1.5"/>
                  <text x="66" y="308" font-size="10" font-weight="700" fill="var(--c-blue-ink)" letter-spacing="1.1">COGNITION PROTOCOLS</text>
                  <rect x="66" y="316" width="396" height="36" rx="6" fill="none" stroke="var(--c-blue-ln)" stroke-width="1"/>
                  <text x="264" y="339" text-anchor="middle" font-size="11" fill="var(--c-blue-ink)">ACCORD &mdash; shared intent</text>
                  <rect x="478" y="316" width="396" height="36" rx="6" fill="none" stroke="var(--c-blue-ln)" stroke-width="1"/>
                  <text x="676" y="339" text-anchor="middle" font-size="11" fill="var(--c-blue-ink)">CONCORD &mdash; deciding under conflict</text>
                </g>

                <!-- ============ TRANSPORT ============ -->
                <g data-group="band">
                  <rect x="52" y="378" width="836" height="30" rx="7" fill="var(--c-band)"/>
                  <text x="470" y="398" text-anchor="middle" font-size="11" font-weight="700" fill="#fff" letter-spacing="1.6">A2A &middot; SLIM GROUP CHANNELS &middot; MCP</text>
                </g>

                <!-- ============ AGENTBRIDGE (option) ============ -->
                <g data-group="bridges">
                  <rect x="52" y="420" width="836" height="26" rx="6" fill="var(--c-amb-bg)" stroke="var(--c-amb-ln)" stroke-width="1.4" stroke-dasharray="5 3"/>
                  <text x="470" y="437" text-anchor="middle" font-size="10.5" fill="var(--c-amb-ink)">AgentBridge &mdash; one per agent or per harness, carrying the protocol on the wire</text>
                </g>

                <!-- ============ MAS ============ -->
                <g data-group="agents-own">
                  <rect x="52" y="458" width="396" height="84" rx="9" fill="none" stroke="var(--c-neu-ln)" stroke-width="1.4" stroke-dasharray="6 4"/>
                  <text x="66" y="476" font-size="10" font-weight="700" fill="var(--c-neu-ln)" letter-spacing="1.1">AGENTS YOU OWN</text>
                  <rect x="66" y="486" width="112" height="44" rx="6" fill="var(--c-agent)" opacity="0.9"/>
                  <text x="122" y="513" text-anchor="middle" font-size="11" fill="#fff">Agent 1</text>
                  <rect x="190" y="486" width="112" height="44" rx="6" fill="var(--c-agent)" opacity="0.9"/>
                  <text x="246" y="513" text-anchor="middle" font-size="11" fill="#fff">Agent n</text>
                  <rect x="314" y="486" width="120" height="44" rx="6" fill="none" stroke="var(--c-blue-ln)" stroke-width="1.2"/>
                  <text x="374" y="508" text-anchor="middle" font-size="10" fill="var(--c-blue-ink)">protocol</text>
                  <text x="374" y="521" text-anchor="middle" font-size="10" fill="var(--c-blue-ink)">skill</text>
                </g>

                <g data-group="agents-3p">
                  <rect x="464" y="458" width="424" height="84" rx="9" fill="none" stroke="var(--c-neu-ln)" stroke-width="1.4" stroke-dasharray="6 4"/>
                  <text x="478" y="476" font-size="10" font-weight="700" fill="var(--c-neu-ln)" letter-spacing="1.1">THIRD-PARTY AGENTS</text>
                  <rect x="478" y="486" width="124" height="44" rx="6" fill="var(--c-agent3p)" opacity="0.9"/>
                  <text x="540" y="513" text-anchor="middle" font-size="11" fill="#fff">partner agent</text>
                  <rect x="614" y="486" width="124" height="44" rx="6" fill="var(--c-agent3p)" opacity="0.9"/>
                  <text x="676" y="513" text-anchor="middle" font-size="11" fill="#fff">partner agent</text>
                </g>

                <g data-group="gateway">
                  <rect x="750" y="486" width="124" height="44" rx="6" fill="var(--c-amb-bg)" stroke="var(--c-amb-ln)" stroke-width="1.2"/>
                  <text x="812" y="508" text-anchor="middle" font-size="10" fill="var(--c-amb-ink)">Agent</text>
                  <text x="812" y="521" text-anchor="middle" font-size="10" fill="var(--c-amb-ink)">Gateway</text>
                </g>

                <!-- ============ THE TWO LOOPS ============ -->
                <g data-group="telemetry">
                  <path d="M905 452 L905 268" stroke="var(--c-amb-ln)" stroke-width="1.6" marker-end="url(#ah-amber)" fill="none"/>
                  <text x="897" y="360" text-anchor="middle" font-size="10" fill="var(--c-amb-ink)" transform="rotate(-90 897 360)">telemetry</text>
                </g>

                <g data-group="trigger">
                  <path d="M30 268 L30 384" stroke="var(--c-blue-ln)" stroke-width="1.6" marker-end="url(#ah-blue)" fill="none"/>
                  <text x="42" y="326" text-anchor="middle" font-size="10" fill="var(--c-blue-ink)" transform="rotate(-90 42 326)">protocol trigger</text>
                </g>
              </svg>
    </div>
    <p class="ioc-reading"><b>In play:</b> <span id="ioc-inplay"></span></p>

    <section class="ioc-detail" aria-live="polite">
      <h3 id="ioc-d-title"></h3>
      <p class="tag" id="ioc-d-tag"></p>
      <div class="ioc-facts">
        <div class="ioc-fact"><h5>What you get</h5><p id="ioc-d-get"></p></div>
        <div class="ioc-fact"><h5>What it costs</h5><p id="ioc-d-cost"></p></div>
        <div class="ioc-fact pro"><h5>Pros</h5><p id="ioc-d-pro"></p></div>
        <div class="ioc-fact con"><h5>Cons</h5><p id="ioc-d-con"></p></div>
        <div class="ioc-fact gate"><h5>Hard gate</h5><p id="ioc-d-gate"></p></div>
      </div>
    </section>
  </div>
</div>

**Cognition Engines** and **peer CF nodes** stay faded in every mode. They are
platform context, not part of the Core consumption choice.

## The three modes

| Mode | Stack added | What you get | What it costs |
|---|---|---|---|
| **1** | Cognition Protocol skills, **either** in the agents **or** in the AgentBridge | Coordination protocol in the MAS | In the agents: edit each agent. In the bridge: A2A, and one bridge per agent or per harness |
| **2** | + observability, detection and trigger &mdash; SCOPE and the Platform Engine | The same, plus visibility of cognitive failure and the **closed loop** that acts on it | OTel instrumentation |
| **3** | + MAS-Lab | Reproducible labs, benchmarks, automated coverage | Run the MAS under `mas-runtime` |

Mode 1 is a **choice of placement**, not two steps: the same skills live either in
the agents or in the AgentBridge, and a MAS can mix the two. Mode 2 adds
observability and the engine on top of whichever placement is in use.

## Where to start

| If you&hellip; | Start at |
|---|---|
| own the agents and want coordination benefit today | **Mode 1**, skills in the agents |
| integrate third-party or vendor agents | **Mode 1**, skills in the AgentBridge |
| must justify adoption with numbers, or already run OTel | **Mode 2** |
| want the failure to be acted on, not just reported | **Mode 2** |
| are validating IoC, or gating a release on coordination quality | **Mode 3** |

The modes are **non-exclusive**, and so are the two placements. One MAS can carry
the skills in the agents it owns and in the AgentBridge for the ones it does not,
and can be lifted into mode 3 for a benchmark run without changing how it is
consumed in production.

## The two hard gates

Everything else is additive; these two are prerequisites you either have or must
put in place.

<div class="grid cards" markdown>

-   :material-transit-connection-variant: **A2A**

    ---

    Required by the **AgentBridge placement**. The bridge is a declared A2A/SLIM
    endpoint; without A2A on the agent there is nothing for it to join, and
    insertion falls back to skills in the agents.

    [:octicons-arrow-right-24: Insertion options](https://ioc-project.github.io/cognition-protocols/protocols/installation/)

-   :material-chart-timeline-variant: **OpenTelemetry instrumentation**

    ---

    Required by **modes 2 and 3**. Any OTel semantic-convention-compliant
    emitter works, through a SCOPE schema adapter &mdash; AGNTCY Observe is the
    reference, not a precondition.

    [:octicons-arrow-right-24: SCOPE](../scope/platform.md)

</div>

## The modes in full

### 1. Cognition Protocol skills &mdash; the simplest thing that works

The ACCORD and CONCORD **skills** are added to the MAS. A skill is a
natural-language protocol definition supplied at session start: the phase sequence,
what to broadcast, what to merge, what to verify &mdash; with no SDK, no
message-schema dependency and no recompile. Insertion is **per agent**, so a MAS can
be converted one agent at a time, with or without a harness.

The skills live in one of two places, and the choice is independent per agent.

=== "In the agents"

    The skill is installed on the agent itself, which selects it on its own
    trigger.

    - **Pros.** Lowest possible adoption cost. Nothing but the agent's own
      instruction surface changes, and no new component is deployed.
    - **Cons.** Invocation is an **LLM decision**: determinism on protocol
      mechanics is weak, because nothing outside the model enforces phase order.

=== "In the AgentBridge"

    Agents that cannot be modified get the same skills through the
    **[AgentBridge](https://shadi.agntcy.org/agentbridge/)**: a declared A2A/SLIM
    endpoint deployed per agent or per harness, carrying the protocol machinery on
    the wire instead of inside the agent.

    - **Pros.** No modification to agent code. The bridge owns the deterministic
      part &mdash; envelope, sequence, phase barriers, merge, commit &mdash; while
      the agent only generates payloads, which is the one part that could never
      have been deterministic. This is the **preferred** placement where it is
      available.
    - **Cons.** A2A is required, and the bridge is an extra deployed component.

Either way, mode 1 has **no observability**: nothing measures whether the protocol
ran or whether it helped, so a run yields a transcript rather than a rate. That is
what mode 2 adds.

### 2. Cognition Protocols plus observability, detection and trigger

**OpenTelemetry-based instrumentation** feeds **SCOPE**, which recomposes the
per-agent spans into a single multi-agent trajectory and knowledge graph. The
**Platform Engine** reads that trajectory, names the cognitive failure by
**function and locus**, attributes it to the originating event, and fires the
matching protocol response.

Detection and triggering are the same engine, so this mode closes the loop rather
than only reporting: a detected divergence re-opens alignment among the agents
while the session is still running. Where the skills are deployed in the
AgentBridge, that is what the engine fires into, because the bridge already owns
the protocol machinery.

- **Pros.** Observability of the agentic system **as a whole**, and specifically
  the cognitive-failure detection that latency and error-rate monitoring
  structurally cannot see. This is what turns a claim of benefit into a measurable
  before and after &mdash; and the benefit is observable in the same telemetry that
  raised the signal.
- **Cons.** Requires observability instrumentation, and the engine is deployed
  alongside SCOPE.

### 3. MAS-Lab &mdash; experimentation and validation runtime

The question changes from *how do I run this in production* to *how do I prove
it*. **MAS-Lab** provides a repeatable, observable, governed runtime in which the
existing Labs &mdash; cognitive-failure detection and analysis, the protocol
benchmark &mdash; are reproduced against **your own MAS**: the system is declared in
YAML, executed under `mas-runtime` with contracts enforced at the boundaries, and
measured by the benchmarking layer.

- **Pros.** Extensive automated coverage and testing; quantitative
  before-and-after on your own system instead of a reference scenario;
  integration regressions caught rather than discovered.
- **Cons.** The MAS has to be expressible as a MAS-Lab specification and run under
  its runtime. This is a lab posture, not a production one &mdash; note that the
  harness drops out of the picture entirely.

## Related reading

- [Overview &rarr; Architecture](../overview/architecture.md) &mdash; the components in full
- [Cognition Protocols](https://ioc-project.github.io/cognition-protocols/protocols/installation/) &mdash; the two insertion options and their determinism
- [MAS-Lab &rarr; Labs](../mas-lab/labs.md) &mdash; what mode 3 reproduces
