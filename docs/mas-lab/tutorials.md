# MAS-Lab — Tutorials and Demos

<p class="eyebrow">Getting a MAS-Lab run on the ground</p>

!!! info "In preparation"
    The guided walkthroughs below are being written. The quickstart on this page
    works today.

## Quickstart

The sample applications run against a mock model, so this executes without an LLM
key.

```bash
pip install mas-lab mas-library-standard mas-library-samples
mas-lab init
mas-ctl run-mas library-samples/apps/trip-planner/mas.yaml \
  --infra-ref standard:mock-llm -q "Plan a trip from Celestia to Verdantia"
mas-lab telemetry show library-samples/apps/trip-planner/traces/events.jsonl
```

`standard:mock-llm` selects the mock infrastructure bundle. Replacing it with a
real bundle is the only change required to run against a live model.

## Sample applications

The labs run over sample multi-agent systems shipped in `library-samples/apps`.
They are also the fastest way to see the runtime execute.

| Application | Used by |
|---|---|
| `trip-planner` | Topology experiments; the quickstart application |
| `qa-mas` | Design-pattern experiments |

## Reproducing the published labs

```bash
task reproduce
```

Runs the experiments in sequence. To run a single lab:

```bash
mas-lab benchmark run labs/design-space.lab/01-design-patterns/experiment.yaml --progress
mas-lab benchmark show last plots
```

Completed runs are cached, so re-running refreshes the reports without repeating
model calls when the inputs are unchanged.

[:octicons-arrow-right-24: What each lab contains](labs.md)

## Walkthroughs

| Walkthrough | Status |
|---|---|
| Environment setup and first run | In preparation |
| Declaring a multi-agent system in YAML | In preparation |
| Building an experiment and reading its artifacts | In preparation |
| Adding an overlay to vary policy under a fixed specification | In preparation |
| Inspecting a run in the Web UI | In preparation |
