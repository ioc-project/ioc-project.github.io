# SCOPE — Architecture

![SCOPE architecture](../assets/diagrams/scope-architecture.png)

## The shape

SCOPE is the platform that turns raw OTel spans into curated insights.
It is composed of a set of engines organised in an ingestion pipeline and periodic workers.
A central **knowledge graph** sits at its core:
every engine writes into it, and every consumer reads from it.

The diagram above depicts the logical flow of a MAS session, from the OTel spans
through to actionable insights. The sections below take each stage in turn.

## The ingestion pipeline

The ingestion pipeline runs **once per completed session**.
This pipeline is composed of chained workers, through RabbitMQ queues:
each worker's output queue is the next worker's input queue.

The table below present the workers that compose the ingestion pipeline,
and in which order they are called.

| Order | Worker | Does |
|---|---|---|
| 1 | **norm** | Transforms OTel spans into a normalized trace in the knowledge graph, following the MAS execution ontology |
| 2 | **mce** ‖ **embedding** | In parallel: computes the configured metric set for the session; computes an embedded vector for each state in the trajectory |
| 3 | **grouping** | Uses the embeddings computed in the previous step to assign the session to a semantic group, if one fits. The available semantic groups are computed via the `hierachical-grouping` worker|
| 4 | **analysis** | Anomaly detection, consistency and normal-behaviour analysis, run together over the group |

!!! note "Step 4 is conditional"
    A session only reaches analysis if grouping could assign it to a semantic
    group. `analysis-worker` is itself a bundle of three independent analyses; it
    fans the same grouped-session input out to all three and persists whatever
    reports come back.

## Periodic operations

The periodic operations are composed of workers that are not chained to one another.
Instead, each worker is triggered on its own schedule — by default
every ten minutes — and connects to the rest of the platform only through the
knowledge-graph state it reads and writes.

The table belows presents the workers triggered periodically.

| Worker | Reads | Writes |
|---|---|---|
| **hierarchical-grouping** | Session input embeddings | The updated semantic-group hierarchy, re-emitting changed groups for re-analysis |
| **intelligence** | Semantic groups, anomaly and normal-behaviour reports, metrics | `Insight` nodes, rendered from templates in the intelligence catalog |

## Extensible by design

The ingestion pipeline is modular and extensible by design.
This allows to add new analysis engine without touching what already runs.
Every worker is:

- **A separate package** — its own build, CLI entry point and container image, so
  shipping or rolling back one worker never touches the others.
- **A queue consumer and producer, not a caller** — it knows the names of the
  queues it reads from and writes to, and holds no reference to the workers
  upstream or downstream of it.
- **Runnable two ways** — long-running queue mode in production, or single-message
  mode for local testing and workflow steps.

Adding a stage means writing a worker that subscribes to an existing output queue
and publishes its own results. No existing worker is modified.

## The knowledge graph

The graph is layered, and **every stage writes its own layer** — which is what
makes the analysis composable: a later stage reads the layer an earlier one
produced rather than re-deriving it from raw spans. The layers are the five
bundled ontologies.

| Layer | Written by | Holds |
|---|---|---|
| **MAS** | norm | Structural types — MAS, Agent, LLM, Tool, Processing — their execution instances, and the normalized State/Transition trajectory under a single session identity |
| **Semantic** | embedding | Embeddings linked to State and Execution nodes |
| **Metrics** | mce | Metric and MetricResult nodes, on a definition–observation split |
| **Analysis** | analysis, grouping | Group-scoped consistency, anomaly and normal-behaviour reports |
| **Insight** | intelligence | Rendered, catalog-templated insights attached to a target node |

## The boundary with CF

The division of responsibility between the two components is as follows.

| Concern | Owner |
|---|---|
| Ingestion, normalization, the graph, enrichment, insight production | **SCOPE** |
| Fabric runtime, the three-tier API surface, CE routing and chaining, the protocol interaction plane | **CF** |
| The **Cognition Store** — publish / retrieve-notify, CE findings | *Open question* — ownership between CF and SCOPE is not yet settled |

The **Analytics CF API** is the read-only tier CEs consume; it is served through
SCOPE's API layer, which exists precisely so that backends can swap behind it
without breaking upstream clients.

## Ingestion contract

Ingestion is **per session**. The pipeline is triggered by a session-completion
notification rather than by spans arriving, which is a deployment integration
rather than an automatic consequence of exporting telemetry.

!!! warning "Partial-session analysis is an IoC requirement, not a shipped property"
    The protocol trigger loop needs signal *while a session is still running*, not only
    after it terminates. The pipeline as it stands is triggered on completion.
    Closing that gap is on the IoC side of the SCOPE integration work.

## Current implementation

!!! note "Implementation, not architecture"
    The choices below are the current deployment. The architecture is agnostic to
    them, and replacing them is an open work item rather than a hypothetical.

| Concern | Current choice |
|---|---|
| Raw telemetry store | **ClickHouse** |
| Knowledge graph | **Neo4j** |
| Queueing | **RabbitMQ** |
| Deployment | **Helm charts** for Kubernetes; Docker Compose for a full local stack |
| Reference instrumentation | **AGNTCY Observe SDK** |
| Repository | the SCOPE repository, Apache 2.0 |
