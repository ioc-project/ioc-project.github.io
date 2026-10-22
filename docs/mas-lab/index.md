# MAS-Lab

<p class="eyebrow">The validation vehicle</p>

**Multi-agent systems are easy to build and hard to trust.** MAS-Lab is an
open-source toolkit for building, running and validating multi-agent workflows
with engineering discipline rather than demo luck.

It is developed in the open at
its own repository, with its own documentation.
This section covers what IoC uses it for; the upstream docs are the reference for
the framework itself.

## The problem

Agent logic, orchestration, observability and control are usually entangled in
prompts, ad hoc code and runtime behaviour. The result is a system that is hard
to validate, reproduce or predict beyond the demo path. What a team learns from
experimentation is weak evidence of how the system will behave under real
conditions — production budgets, stricter policies, unpredictable failures.

??? example "A trip planner — what goes wrong between demo and production"

    A coordinator receives a request, breaks it into subtasks, and delegates to
    agents that fetch schedules, compute routes and estimate cost. Over a few
    queries the demo behaves as intended: structured output, visible reasoning,
    clean tool calls.

    Preparing it for production introduces memory for user preferences, tightened
    reasoning patterns and a budget cap. Each change is individually small and
    defensible; their combined effect is not.

    The same query now returns different results. Handoffs become inconsistent.
    Latency and cost drift. Repeating the experiment produces another outcome, and
    rolling back a change does not fully restore the previous behaviour.

    There is no obvious place to debug, because there is no single system
    definition to inspect. Instead there is a web of prompts, tool calls,
    implicit rules and interactions that only emerge when the workflow runs end
    to end.

This is not a missing dashboard or a better prompt template. It is structural:
multi-agent workflows need **explicit intent, controlled execution, and evidence
that carries from development into production**.

## Three coupled building blocks

MAS-Lab is not another agent framework. It is a layer that makes workflows
explicit, execution controlled and results reproducible, so guarantees
accumulate from design through production.

| Layer | What it is | The question it answers |
|---|---|---|
| **Specification** | A versioned definition of agents, roles, tools, delegation, constraints and policies | *What is this workflow, and which version is under evaluation?* |
| **Runtime** | Controlled execution that enforces the definition, protects state and resources, and records what happens | *How is that definition enforced during execution, including failures and contention?* |
| **Labs** | Repeatable experiments that vary one factor at a time and produce comparable, reusable evidence | *What changes when a design choice or policy is varied under controlled conditions?* |

What sets MAS-Lab apart is not a feature but a **separation**. In most systems
today, logic, orchestration, governance and observability are entangled, there
are no clear boundaries, and small changes propagate unpredictably. The three
layers are what break that entanglement.

### Specification comes first

MAS-Lab starts from the specification, not from a loose collection of agents.
That choice is foundational. A specification gives a workflow a **stable
identity**: an object that can be versioned, compared and referenced in results. It
anchors observability, because traces attach to defined roles, tools and
delegation paths rather than to an ad hoc prompt. And it enables analysis, since
experiments depend on a declared baseline.

A specification defines, at minimum:

- the agents and their roles
- delegation patterns and state flow
- allowed tools and external resources
- constraints and policies

This follows a broader shift in the ecosystem — Agent Cards, OASF, AgentSpec —
towards standardising boundaries so implementations can evolve without breaking
the system. MAS-Lab extends that principle beyond interfaces to the full workflow
lifecycle.

!!! note "Inferred specifications are an on-ramp, not the end state"
    Teams can bootstrap by inferring specs from existing systems. That eases
    adoption but **weakens guarantees** — implicit intent is harder to version,
    govern and benchmark. The end state is explicit specifications with
    frameworks and tools plugged in, not reconstructed afterwards.

### Runtime enforces it

Once intent is declared, execution must enforce it. The runtime treats every
meaningful action as part of a controlled lifecycle: validated against policy,
executed with guardrails, recorded with context. It mediates access to internal
state and external resources, and protects workflows from concurrency issues,
partial failures and timing drift.

This is where operations gain confidence: **the workflow that passed review is
the one that runs**, with traces explaining who did what, under which policy, and
with what outcome.

### Labs produce evidence

Labs apply controlled, declarative variations — changing one parameter at a time,
whether policy, topology or configuration, while holding the specification and
runtime constant. Each run produces artifacts built for comparison, regression
detection and readiness assessment, not just a final score.

## Cognitive and coordination failures

This is where MAS-Lab and IoC meet directly.

Not every failure announces itself as a tool error or a policy violation. Some
are silent: **wrong delegation that still returns an answer, stale memory that
sounds plausible, coordination drift that only appears under load.** These cannot
be ruled out when writing the specification, and they do not trigger a clean
error signal at runtime.

In the IoC framing these are **cognitive system failures**. Diagnosing one
requires comparing *intended behaviour* — the specification — against *actual
execution* — the trace — with enough context to attribute the cause. MAS-Lab
closes that loop: observability provides the signals, and the shared system
identity makes them actionable, so a failure traces back to the exact workflow
version, policy and interaction pattern that produced it.

Remediation then feeds back into the same lifecycle — updating the specification,
refining policies, extending experiments — instead of remaining a one-off patch.

[:octicons-arrow-right-24: What IoC detects, and how](../overview/motivation.md)

## Who it is for

The same foundations serve three audiences differently.

<div class="grid cards" markdown>

-   :material-code-braces: **Developers**

    ---

    Change one thing without breaking everything else. The specification is a
    versioned system identity that can be diffed, branched and benchmarked; the
    runtime isolates workflow structure from incidental prompt changes; labs turn
    "it worked once" into comparable runs. Iteration becomes systematic rather
    than anecdotal.

-   :material-shield-check-outline: **Operations**

    ---

    Control and governance. The specification is the contract — which agents
    exist, what they can access, which policies apply. The runtime enforces it
    before actions reach external systems, producing auditable traces. Labs
    generate readiness evidence that supports release review.

-   :material-flask-outline: **Researchers and reviewers**

    ---

    Attribution. The specification makes the independent variable explicit, the
    runtime preserves causal traces across agent interactions, and labs hold
    other factors stable while varying one dimension — so outcomes tie to design
    choices rather than being dismissed as noise.

</div>

## Continuity across the lifecycle

A common drawback of agentic development today is **rebuilding the workflow
between development, test and production**. Validation on a toy graph does not
predict behaviour on the deployment graph.

MAS-Lab uses one specification as the thread. Developers edit and version it,
labs benchmark variants of it, operations deploy and monitor executions of it. A
failing lab run or a drifted trace refers back to the same identity operators saw
in change review. Design choices, runtime enforcement and experimental evidence
attach to **one workflow definition instead of three incompatible copies**.

That is also where systematic learning belongs. When workflows are observable
under control, trade-offs become visible: richer context may help recall but hurt
precision; stricter governance may add latency but reduce risk; more agents may
not improve outcomes. Those insights feed the next specification revision rather
than another round of prompt guessing.

## What IoC uses it for

| Role | What it means |
|---|---|
| **Support platform** | For Cognition Protocol authors who need repeatable, observable, governed test environments |
| **Evidence lab** | Produces quantitative before-and-after measurements of IoC motivation in realistic scenarios |

Its problem statement, from IoC's side, is blunt: without a common lab, protocol
claims remain informal, integration regressions go undetected, and IoC motivation
is hard to communicate with hard numbers.

!!! note "MAS-Lab is not an application"
    It is a vehicle for *deploying* IoC applications with deep observability and
    audit that ad-hoc test setups cannot achieve.

## How it fits the ecosystem

Teams already rely on agent frameworks (LangGraph, CrewAI, AutoGen), protocols
(MCP, A2A) and a wide range of observability and evaluation platforms (LangSmith,
Braintrust, Phoenix, Langfuse, Humanloop). Each layer solves a real problem — but
they are usually assembled around workflows that have **no shared system
definition**, so intent, execution and validation fragment.

MAS-Lab does not compete with that ecosystem; it complements and unifies it.
Around one explicit, versioned specification — agnostic to how agents are
implemented or which framework they run on — existing tools attach as plugins:

- observability platforms provide traces and signals
- governance layers enforce policies and access controls
- context/memory and tool systems contribute capabilities
- evaluation and experimentation tools generate comparative evidence

The shift is from **tool-centric to system-centric**: tools are no longer
loosely stitched together, they attach to a common workflow identity that
persists from development through production. Adoption does not require a clean
slate — brownfield systems can be imported or inferred, whether built with coding
agents, orchestration frameworks or custom stacks.

## The paper

*MAS-Lab: A Specification-Driven Validation Framework for Reliable Multi-Agent
Systems* — Jordan Augé, Giovanna Carofiglio, Giulio Grassi, Jacques Samain
(Cisco Systems / Outshift). Section 5's experiments are shipped as three runnable
labs; `task reproduce` regenerates the figures.

[:octicons-arrow-right-24: The paper labs](labs.md#the-paper-labs)

## In this section

<div class="grid cards" markdown>

-   **[Architecture](architecture.md)** — the five-stage pipeline, the variation axes, the control plane, the packages
-   **[Labs](labs.md)** — the three reproducible paper labs, and the IoC `sre-triage` lab
-   **[Tutorials and Demos](tutorials.md)** — quickstart, sample applications, reproducing the labs

</div>

## Source material

- Introducing MAS-Lab: Bringing Reliability and Engineering Discipline to Multi-Agent Systems
  — the v0.1 release post, by Giovanna Carofiglio, Jordan Augé and Mayank Gupta.
  Most of this page follows it.
- The MAS-Lab repository
- The MAS-Lab documentation
- `diagrams/mas-lab-architecture.md` — the IoC-side architecture write-up
