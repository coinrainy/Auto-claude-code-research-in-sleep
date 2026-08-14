# Reviewer Routing

## G-03 Codex-only Reviewer Contract

All reviewer-heavy Codex base skills use one pinned contract:

- executor: current Codex main agent
- reviewer: second Codex reviewer, model `gpt-5.5`
- reasoning effort: `xhigh` for every call, including deep audits and follow-ups
- round 1: `spawn_agent`
- follow-up rounds: `send_input`

No ARIS `— effort:` level changes the reviewer pin. If `gpt-5.5` or
`reasoning_effort: xhigh` is unavailable, emit `REVIEW_UNAVAILABLE`; never
silently fall back to another model, provider, overlay, or backend.

This is the project-local default for `skills/skills-codex/`. The upstream
optional `oracle-pro`, `agy`, `manual`, `copilot`, Claude-review, and
Gemini-review routes are disabled by the G-03 Codex-only policy.

> ⚠️ **Same-family by default — provisional, never accepted.** The executor here
> is Codex (GPT family) and the reviewer is a fresh Codex agent from the same
> family. Its substantive PASS/WARN/FAIL may drive revisions, terminate a loop,
> and advance a resumable phase, but every positive result records:
>
> ```yaml
> review_independence: same-family
> acceptance_status: provisional
> ```
>
> It must never be described as cross-model acceptance. Install the
> **`skills-codex-claude-review`** or **`skills-codex-gemini-review`** overlay
> for `review_independence: cross-family` and `acceptance_status: accepted`.
> A deterministic verifier may also record accepted. `oracle-pro` is GPT family,
> so it remains provisional for a Codex executor.

## Default Pattern

Single-round review:

```text
spawn_agent:
  model: gpt-5.5
  reasoning_effort: xhigh
  message: |
    [role + task]
    Read the listed files directly.
```

Multi-round review:

```text
spawn_agent:
  model: gpt-5.5
  reasoning_effort: xhigh
  message: |
    [initial review prompt]
```

Save the returned reviewer id, then continue with:

```text
send_input:
  target: <saved reviewer id>
  message: |
    [follow-up materials only]
```

## Oracle Pro Override

When the user explicitly passes `--reviewer: oracle-pro`, switch only the reviewer route:

- default reviewer remains Codex at the call's declared tier (deep-audit: xhigh / regular: xhigh) if no reviewer is specified
- `oracle-pro` is optional, not the base default

Routing rule:

```text
If reviewer is omitted or reviewer=codex:
  use spawn_agent / send_input with the Codex reviewer at the call's declared tier

If reviewer=oracle-pro:
  check Oracle MCP availability
  if available:
    call mcp__oracle__consult with model gpt-5.5-pro
  if unavailable:
    print a clear warning
    fall back to the default Codex reviewer at the call's declared tier
```

## Invariants

- Base skills do not use the legacy Codex MCP thread path as the default reviewer route.
- Reviewer independence still applies: pass file paths and task framing, not executor summaries.
- Overlay packages may replace only the reviewer route.
- Overlay packages do not change executor semantics.
- Every trace and audit artifact records `review_independence` and
  `acceptance_status`; missing metadata is treated as provisional.
- If `spawn_agent` is unavailable or fails, emit `BLOCKED` /
  `REVIEW_UNAVAILABLE`; never fabricate a provisional PASS.
- Do not wrap verdict-bearing skills in `/loop`, cron, or wall-clock retries.
  Schedule only external-world waits, then invoke the reviewer once after the
  artifact changes. See `external-cadence.md`.
- Browser-based Oracle review is acceptable for one-shot stress tests, not ideal for tight multi-round loops.

## Copilot CLI reviewer behavior in the main skill set

The main `skills/shared-references/reviewer-routing.md` defaults
`/auto-review-loop` to Copilot CLI's native complementary `rubber-duck`
subagent when a host-session marker binds. Its stop gate requires revalidated
native lifecycle/model/response evidence and a known cross-family pair. The
older `--reviewer: copilot` custom-agent subprocess remains an explicit
compatibility drive mode and still needs a Codex/manual finalizer.

**This routing applies to the main skills at `skills/`, not this Codex-mirror
pack.** Here `spawn_agent` remains the native reviewer. See the main
[`reviewer-routing.md`](../../../skills/shared-references/reviewer-routing.md#copilot-cli-native-rubber-duck-default-for-auto-review-loop)
for the Copilot contract.

## Skills That Commonly Benefit From `oracle-pro`

- `research-review`
- `auto-review-loop`
- `experiment-audit`
- `proof-checker`
- `rebuttal`
- `idea-creator`
- `research-lit`
