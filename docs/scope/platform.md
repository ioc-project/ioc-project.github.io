# SCOPE — Platform

The platform is everything between "a MAS emitted a span" and "a Cognition Engine
has an Insight to act on": the intake surface, the stores, the pipeline that fills
them, and the API contract in front.

## Intake surface

### The schema adapter

Every source of telemetry enters through a **SCOPE schema adapter** that maps the
source's fields onto the SCOPE schema. The adapter is what makes the ingestion
contract stable while admitting heterogeneous instrumentation.

| Source | Notes |
|---|---|
| **AGNTCY Observe** | Reference instrumentation. protocol-aware span conventions out of the box; richest signal |
| **Vendor SDKs** | Admissible via the adapter |
| **Framework auto-instrumentation** | Admissible via the adapter |
| **Custom emitters** | Admissible via the adapter |
| **Boundary instrumentation** | Traces propagated at the MAS boundary for a system that was never instrumented |

The rule: **conform via the adapter, not by rewriting the agent.**

### What is carried

Two kinds of signal arrive together:

- **Agent traces** — OTel spans from agents, tool calls and model calls.
- **Protocol phase events** — emitted by the AgentBridges, which is what lets the platform
  reason about protocol phases rather than only about API calls.

## Stores

| Store | Role | Current backend |
|---|---|---|
| **Raw telemetry** | Landing zone for spans as received | ClickHouse |
| **Knowledge graph** | The MAS execution model, embeddings, metrics, reports and insights — the object analysis runs on | Neo4j |
| **Queueing** | Chains the ingestion workers and triggers the periodic ones | RabbitMQ |
| **Cognition Store** | Publish / retrieve-notify of CE findings and insight | *Ownership CF vs SCOPE is an open question* |

## Ingestion pipeline

The pipeline is a chain of standalone workers connected by RabbitMQ queues. Each
worker contributes to the different layers of the knowledge graph.
New analysis is added by subscribing a new worker to an existing queue,
without modifying the ones that already run.

```
norm → ( mce ‖ embedding ) → grouping → analysis
                                        ( anomaly ‖ consistency ‖ normal behaviour )
```

The ingestion is run on a **per session** basis,
triggered by a session-completion notification.

In addition, two periodic workers, **hierarchical grouping** and **intelligence**, run on their own
schedules alongside the pipeline.
They contribute to the KG as well, enriching it with semantic groups and Insights.

!!! warning "Partial-session analysis is not shipped"
    The protocol trigger loop needs signal while a session is still running. The
    pipeline as it stands runs on completion; closing that gap is IoC-side
    integration work, not a property to rely on today.

[:octicons-arrow-right-24: The pipeline in detail](architecture.md#the-ingestion-pipeline)
[:octicons-arrow-right-24: What each worker and engine does](analysis-engines.md)

## API layer

The API layer is **SCOPE's stable contract** — the reason backends can be swapped
without upstream clients noticing. It serves:

- **insights** — curated findings
- **trajectories** — the reconstructed multi-hop execution
- **metrics** — derived quantities

This is what backs the **Analytics CF API**, the read-only tier that Cognition
Engines consume. Two clients sit on the CF side of it: a **management-plane
client** for configuration and lifecycle, and an **SCOPE / shared-memory client**
that reads insight and context.

## Deployment posture

!!! warning "test"
    test

!!! info "The adoption path"
    SCOPE does not have to be deployed as a stack of its own. Because it is agnostic
    to the databases behind the graph and the telemetry store, it can in future
    integrate with the observability platform a customer **already runs**, and
    contribute the cognitive layer on top of it.

Two operating models reach the platform, both architecture of record:

- **White-box** — the application emits via an OTel SDK. Richest signal.
- **Black-box** — traces are propagated at the MAS boundary. Materially less
  semantic content, but it lets an organisation observe and govern a MAS it did
  not write.

### How it is deployed

| Target | How |
|---|---|
| **Kubernetes** | Helm charts covering the API, UI, workers and supporting infrastructure |
| **Local, full stack** | Docker Compose — OTel collector, ClickHouse, Neo4j and the ingestion pipeline together |

!!! warning "Draft — to be completed"
    Scale targets, retention policy, multi-tenancy and the deployment topology for
    distributed environments are not yet captured here.

## Source material

- the SCOPE repository — the platform, Apache 2.0
- Backend architecture and components
- Instrumenting a MAS
