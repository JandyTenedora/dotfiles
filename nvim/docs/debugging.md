# Debugging in Neovim

## What is DAP?

DAP (Debug Adapter Protocol) is a standard protocol created by Microsoft that allows editors to communicate with debuggers. Instead of each editor implementing its own debugger integration, DAP defines a common interface — so Neovim, VS Code, and others can all use the same debug adapters.

In this config, DAP is provided by `nvim-dap` with `nvim-dap-ui` for the visual interface.

### Keymaps

| Keymap | Action |
|--------|--------|
| `\dt` | Toggle breakpoint on current line |
| `\dc` | Continue / start debug session |
| `\dx` | Terminate debug session |
| `\do` | Step over |
| `\du` | Toggle dapui open/close |

### How it works

1. Set a breakpoint with `\dt` on a line you want to pause at
2. Start the session with `\dc` — dapui opens showing scopes, breakpoints, stacks, watches
3. When execution hits your breakpoint, inspect variables in the scopes panel
4. Use `\do` to step over lines
5. `\dc` again to continue to the next breakpoint
6. `\dx` to terminate

---

## Remote Debugging with JDWP

JDWP (Java Debug Wire Protocol) is built into the JVM and allows any DAP-compatible debugger to attach to a running JVM process over a network port.

### Starting a JVM with JDWP

```bash
-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005
```

- `suspend=n` — JVM starts immediately, doesn't wait for debugger
- `suspend=y` — JVM pauses until a debugger attaches (useful for debugging startup)
- `address=5005` — port to expose (change as needed)

### Spark

```bash
spark-submit \
  --driver-java-options "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005" \
  your-job.jar
```

Only the **driver** is debuggable this way. Executors run as separate JVMs across the cluster and are ephemeral — attaching to them is impractical.

For debugging distributed logic, prefer:
- Running locally with `--master local` (single JVM, fully debuggable)
- Unit testing transformations in isolation
- Structured logging + OpenTelemetry for production issues

### Kubernetes

Port-forward the debug port before attaching:

```bash
kubectl port-forward pod/my-pod 5005:5005
```

Then attach from Neovim DAP as if it were local.

### Project-local DAP config

Copy `.nvim.lua` from this repo root into your project and uncomment the attach configuration. Neovim loads it automatically via `exrc`. This lets each project define its own debug targets without touching the global config.

---

## DAP vs OpenTelemetry

These tools solve different problems and complement each other:

| | DAP | OpenTelemetry |
|---|---|---|
| **When** | Development | Production |
| **What** | Step through code, inspect variables | Traces, metrics, logs across services |
| **Where** | Local / single JVM | Distributed systems |
| **Why** | Find why code is wrong | Find where problems occur |

### Typical workflow

1. **Write code** → use DAP locally to debug logic and fix bugs
2. **Deploy** → OpenTelemetry observes behaviour across services in production
3. **Production issue** → traces show *where* the problem is, then reproduce locally and use DAP to find *why*

### OpenTelemetry on GCP

Since this stack uses GCP, OpenTelemetry integrates natively with:
- **Cloud Trace** — distributed tracing
- **Cloud Monitoring** — metrics and dashboards
- **Dataflow** — already emits metrics automatically for Beam pipelines

For JVM services, OTel supports zero-code auto-instrumentation via a Java agent, so you don't need to modify your Scala/Java code to get traces.
