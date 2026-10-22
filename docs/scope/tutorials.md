# SCOPE — Tutorials and Demos

<p class="eyebrow">Instrumenting a system and reading what SCOPE produces</p>

!!! info "In preparation"
    The instrumentation steps below work today. The remaining walkthroughs are
    being written.

## Before starting

SCOPE analyses OpenTelemetry traces from a multi-agent system. It is the
**application running the agents** that is instrumented — SCOPE itself does not
need to be installed alongside them. The SDK sends telemetry to an OTLP/HTTP
collector, which stores the spans for SCOPE to process.

SCOPE can be run **standalone**, without the Cognition Fabric or any other IoC
component, which is the shortest path to a first session.

[:octicons-arrow-right-24: Deployment modes](../how-to/index.md#the-three-modes)

## Instrumenting a multi-agent system

The reference instrumentation is the [AGNTCY Observe SDK](https://github.com/agntcy/observe),
which is decorator-based and supports A2A, SLIM and MCP.

**1. Make a collector reachable.** An OpenTelemetry collector with an OTLP/HTTP
receiver, exporting traces to the span store used by the SCOPE deployment.

**2. Install the SDK** in the application's environment:

```bash
pip install ioa_observe_sdk
export OTLP_HTTP_ENDPOINT=http://localhost:4318
```

**3. Initialise once at startup**, decorate the agent and tool functions to be
observed, and open a session at the entry point of each execution:

```python
import os

from ioa_observe.sdk import Observe
from ioa_observe.sdk.decorators import agent, tool, workflow
from ioa_observe.sdk.tracing import session_start

Observe.init("my_mas", api_endpoint=os.environ["OTLP_HTTP_ENDPOINT"])

@tool(name="lookup")
def lookup(query: str) -> str:
    return search_documents(query)

@agent(name="assistant")
def assistant(question: str) -> str:
    context = lookup(question)
    return answer_question(question, context)

@workflow(name="answer_question")
def run(question: str) -> str:
    return assistant(question)

def handle_request(question: str) -> str:
    with session_start():
        return run(question)
```

Use `@workflow` for the top-level execution, `@agent` for agent work and `@tool`
for tool calls. The PyPI package is `ioa_observe_sdk` while its imports use
`ioa_observe`.

!!! warning "Keep `session_start()` at the entry point"
    It belongs at the execution entry point, not inside each agent, so that all
    related work belongs to one session. SCOPE's analysis is per session, and a
    session split across several identities cannot be reconstructed into one
    trajectory.

!!! note "Exporting spans does not by itself start ingestion"
    The ingestion pipeline begins when the deployment notifies it that a **session
    has completed**. If spans are stored but no session appears in SCOPE, the
    session-completion integration is the thing to check.

Avoid attaching secrets or sensitive prompt and response content to span
attributes unless the retention and access policy permits it.

## Walkthroughs

| Walkthrough | Status |
|---|---|
| Deploying SCOPE standalone | In preparation |
| Ingesting a first session and inspecting the execution model | In preparation |
| Exploring a session in the dashboard | In preparation |
| Reading cognitive-failure findings and their provenance | In preparation |
| Consuming insights through the API | In preparation |

## Related

- [Platform](platform.md) — the components a deployment is made of
- [Architecture](architecture.md) — how a session flows through the pipeline
- [Analysis Engines](analysis-engines.md) — what each analysis produces
