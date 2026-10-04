# CLAUDE.md — PROJECT FUSION FACTORY

Operating constraints for Claude Code in this repository. The full rules live in
`PROJECT_FUSION_FACTORY_MASTER_PLAN.md`; this file is the short, binding summary.
Current status: `STATUS.md`. Technical direction: `MISSION_001_PLAN.md`, `docs/TECH_ARCHITECTURE.md`.

## Source of truth
- Git is the source of truth for all code and hand-authored data.
- Studio is a runtime/editor. Never leave the only copy of anything inside Studio.
- Environment: local Windows machine, PowerShell/Git Bash, Roblox Studio + official Studio MCP.
- No Rojo. Native Studio Script Sync only, unless a human approves Rojo later.

## Autonomy loop
inspect -> plan -> smallest coherent change -> playtest -> read output -> fix -> repeat -> commit -> update docs.
Do not stop merely because code compiled. "Done" needs observed evidence from a real playtest.
Never claim success without it; record failures faithfully in `STATUS.md`.

## STOP and get a human before
- publishing a place or game; spending money or Robux;
- installing any third-party Studio plugin (no plugin is trusted automatically);
- accepting a license or legal agreement; changing account/group ownership, payouts or tax settings;
- uploading third-party assets; deleting production data or any irreversible action.

## Legal / IP (non-negotiable)
- Clean-room design only. Record abstract mechanics notes, never copy implementation, assets, UI, text or code.
- No decompiled/ripped/leaked material. No DRM or anti-cheat circumvention.
- Every production asset needs a provenance record in `legal/ASSET_PROVENANCE.md`.
- Names are provisional until cleared (`legal/NAME_CLEARANCE.md`). Never use third-party franchise names publicly.
- AI output is a production tool: document human creative direction and review for accidental similarity.

## Security / compliance
- Server authority for currency, items, loot, inventory, damage, progression, purchases, rewards.
- Validate every remote input; never trust client price, reward, damage, currency, ownership or cooldown.
- No secrets in the repo or in ReplicatedStorage. Admin/dev tools are role-gated, server-validated, logged.
- Paid random items only via a compliance-safe design (published odds, PolicyService gate). None in greybox.
- Assume many players are minors: no pressure tactics, fake scarcity or fake timers.

## Product principles
Fun before monetization. Original expression, not cloning. Server authority. Compliance by architecture.
Mobile matters. Each prototype answers one question. Do not over-engineer before the first playable.

## Git hygiene
Never commit credentials, tokens, machine-specific secrets, caches or unrelated generated files.
Review `git diff` before every commit. Commit messages: clear and specific.
