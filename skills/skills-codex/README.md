# `skills-codex`

Codex-native mirror and adaptation layer for the main ARIS `skills/` package.

## Scope

- Base mirror coverage: all `80` mainline skills under `skills/`
- Support directory: `shared-references/`, with all `30/30` mainline reference names mirrored
- Default reviewer contract for reviewer-heavy skills:
  - round 1: `spawn_agent`
  - follow-up: `send_input`
  - reasoning effort: `xhigh`
  - base Codex self-review: `review_independence: same-family`,
    `acceptance_status: provisional`
  - deterministic verification: `acceptance_status: accepted`

This package is still an appendage to the Claude mainline, not a separate Codex-first product line.

## Recommended Install

Project-local install is the default path for Codex:

```bash
git clone https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep.git ~/aris_repo
cd ~/your-project

bash ~/aris_repo/tools/install_aris_codex.sh .
```

This creates a flat managed layout:

```text
.agents/skills/<skill-name> -> ~/aris_repo/skills/skills-codex/<skill-name>
.aris/installed-skills-codex.txt
AGENTS.md   # managed Codex block
```

Reconcile after upstream changes:

```bash
cd ~/aris_repo && git pull
bash ~/aris_repo/tools/install_aris_codex.sh ~/your-project --reconcile
```

Uninstall only managed Codex entries:

```bash
bash ~/aris_repo/tools/install_aris_codex.sh ~/your-project --uninstall
```

## G-03 runtime boundary

This checkout ships only the Codex base mirror. Claude/Gemini reviewer
overlays and alternate reviewer MCP servers are intentionally excluded.
Reviewer calls stay on the local `gpt-5.5` + `xhigh` contract; unavailable
review capability is reported as `REVIEW_UNAVAILABLE`.

## Copy Install and Update

If you intentionally use a copied Codex install instead of managed project symlinks:

```bash
mkdir -p ~/.codex/skills
cp -a ~/aris_repo/skills/skills-codex/. ~/.codex/skills/
```

Update copied installs with:

```bash
bash ~/aris_repo/tools/smart_update_codex.sh
bash ~/aris_repo/tools/smart_update_codex.sh --apply
```

For a copied project-local Codex install:

```bash
bash ~/aris_repo/tools/smart_update_codex.sh --project ~/your-project
bash ~/aris_repo/tools/smart_update_codex.sh --project ~/your-project --apply
```

`smart_update_codex.sh` refuses symlink-managed installs and redirects them to `install_aris_codex.sh --reconcile`.

## Non-Degrading Skills

The following Codex skills must not silently degrade when their required capability is missing:

- `comm-lit-review`
- `research-lit`
- `paper-poster-html`
- `pixel-art`

If the required source, reviewer, or local preview capability is unavailable, the skill should stop and tell the user what to configure.
