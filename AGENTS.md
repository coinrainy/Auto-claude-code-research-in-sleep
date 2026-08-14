<!-- ARIS-CODEX:BEGIN -->
## ARIS Codex Skill Scope
ARIS Codex packages installed in this project: skills-codex
Managed entries: 83
Manifest: `.aris/installed-skills-codex.txt`
ARIS repo root: `/root/autodl-tmp/G-03/Auto-claude-code-research-in-sleep`
Project skill path: `.agents/skills/<skill-name>`
For ARIS Codex workflows, prefer the project-local skills under `.agents/skills/`.
When a skill needs ARIS helper scripts, resolve the repo root from the manifest or set it explicitly:
`ARIS_REPO=$(awk -F'\t' '$1=="repo_root"{print $2; exit}' "/root/autodl-tmp/G-03/Auto-claude-code-research-in-sleep/.aris/installed-skills-codex.txt")`
Do not edit or delete symlinked skills in place; update upstream or rerun:
`bash /root/autodl-tmp/G-03/Auto-claude-code-research-in-sleep/tools/install_aris_codex.sh "/root/autodl-tmp/G-03/Auto-claude-code-research-in-sleep" --reconcile`
For copied Codex installs, use:
`bash /root/autodl-tmp/G-03/Auto-claude-code-research-in-sleep/tools/smart_update_codex.sh --project "/root/autodl-tmp/G-03/Auto-claude-code-research-in-sleep"`
<!-- ARIS-CODEX:END -->

## G-03 Codex-only execution policy

- Executor and reviewer backend: Codex only. Do not invoke Claude Code,
  Claude/Gemini review overlays, Copilot, Oracle, or arbitrary compatible APIs.
- Pinned model: `gpt-5.5`.
- Pinned reasoning: `reasoning_effort: xhigh` for every Codex call.
- Start sessions with `tools/codex-gpt55-xhigh.sh`; do not rely on an implicit
  user-level model or reasoning setting.
- If the exact `gpt-5.5` + `xhigh` pair is unavailable, stop and report
  `REVIEW_UNAVAILABLE`; never silently downgrade or switch backends.
