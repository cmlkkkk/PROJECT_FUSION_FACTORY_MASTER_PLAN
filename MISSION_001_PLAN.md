# MISSION 001A — PROJECT FLOW Technical Plan

Version: 1.0
Date: 2026-10-04
Author role: Lead Technical Architect (Claude Code)
Status: PLAN ONLY. Nothing in this document has been implemented.

Source documents:
- `PROJECT_FUSION_FACTORY_MASTER_PLAN 2.md` (master plan v1.0, read in full)
- Filip's Mission 001A brief (2026-10-04), which updates the product direction

---

## 0. What changed vs. the master plan

The master plan's legal, IP, compliance, security, Git, testing and autonomy rules (§0, §2, §3, §9.2, §18–§21, §25) stay in force unchanged. Every architectural decision below is constrained by them.

What changes is the product (master plan §14):

| Master plan §14 (v1.0) | Updated direction (this mission) |
| --- | --- |
| Arena shooter; skating powers guns | Class-based action sports combat; skating, tricks, melee, ranged, magic and mobility are one system |
| 3 weapons + 1 ability | 4 starting classes (Mage, Rogue, Paladin, Gunner), more later |
| FLOW buffs reload/handling | FLOW unlocks options (transitions, abilities); no large raw damage multipliers |
| Trick chain feeds combat | CHAIN is shared: tricks and attacks are links of the same chain |
| Progression unspecified | Progression widens options, not stats; skilled new players can beat veterans |

Retained terminology (still provisional, needs clearance per §2.2): FLOW, CHAIN, BREAK, LINE, OVERDRIVE.

Design references are clean-room only (§2.1). No implementation detail, animation, parameter set, UI or asset from any existing game is reproduced. Where this plan names a mechanic (e.g. "grind", "parry"), it means the generic genre concept.

---

## 1. ENVIRONMENT AUDIT

The audit was run on 2026-10-04 inside the session that wrote this plan. That session is a **cloud Linux container**, not Filip's computer. This matters more than anything else in the audit.

### 1.1 What exists

| Item | State | Evidence |
| --- | --- | --- |
| Git repo `cmlkkkk/PROJECT_FUSION_FACTORY_MASTER_PLAN` | Present, 1 commit (`d882703 Add files via upload`), branch `main` | `git log` |
| Master plan | Present, 1,436 lines, filename `PROJECT_FUSION_FACTORY_MASTER_PLAN 2.md` (note the ` 2` suffix, likely a duplicate-upload artifact) | `wc -l` |
| Any Roblox project files (`*.rbxl`, `*.rbxlx`, `*.luau`, `default.project.json`) | None | `find` |
| `CLAUDE.md`, `/docs`, `/legal`, `/engine`, `/games` | None | `find` |
| OS | Ubuntu 24.04 (x86_64, 4 CPU, 15 GB RAM) | `/etc/os-release` |
| git | 2.43.0 | `git --version` |
| Node / npm | v22.22.0 | `node --version` |
| Python | 3.11.15 | `python3 --version` |
| Rust toolchain (cargo/rustc) | Present | `command -v cargo` |
| Docker | Present | `command -v docker` |
| crates.io / npm registry reachable | Yes. `rojo 7.7.1` and `stylua 2.5.2` resolve via `cargo search` | `cargo search` |
| GitHub (repo access) | Yes, via GitHub integration, scoped to this one repo | session config |

### 1.2 What is missing

| Item | State | Consequence |
| --- | --- | --- |
| **Roblox Studio** | Not present and **cannot run here**. Studio ships for Windows and macOS only; this is a Linux container. | All Studio work (playtest, console output, instance edits) must happen on Filip's own machine. |
| **Official Roblox Studio MCP server** | Not configured (`~/.claude.json` has no `mcpServers`). The Studio MCP talks to a Studio plugin over localhost, so it must run on the same machine as Studio. | The MCP-driven loop cannot run in a cloud session. |
| Rojo, StyLua, Selene, luau-lsp, Lune, Rokit/Aftman/Foreman, Wally | None installed | Toolchain must be pinned in-repo and installed on the device (and in CI). |
| Network to `api.github.com` releases and `create.roblox.com` docs | **Blocked** by this container's proxy (HTTP 403) | Prebuilt tool binaries and official docs cannot be fetched from here; crates.io works, so `cargo install` is the fallback in the cloud. |
| Filip's device registered for Remote Control | **None** ("Nothing on their device serves Remote Control now") | The Studio side has no execution host yet. |
| `/mnt/project-files` shared folder | Exists, empty | Plan copy goes there. |
| Roblox group/community, test place, Studio account state | Unknown, not inspectable from here | Must be checked on device. |

### 1.3 Facts I could not verify from here (must be re-checked on the device)

Roblox's Studio MCP offering has been changing quickly. Before Mission 001B relies on it, verify on Filip's machine:
1. Whether the official Studio MCP is built into the current Studio release or still the standalone open-source server + plugin.
2. The exact tool list it exposes. The plan assumes at minimum: run Luau in Studio, start/stop playtest, read console output, get Studio mode. If "read console output" or "start/stop play" is missing, the smoke test in §8 needs a fallback (see Risk R1).
3. Whether Studio's native Script Sync is available and stable in the installed version (alternative to Rojo, see §2.3).
4. Whether Roblox's Input Action System and character `ControllerManager` instances are available (they shape §6 and §7).

---

## 2. DEVELOPMENT PIPELINE

### 2.1 The two halves

```
           CLOUD (this kind of session)                     FILIP'S DEVICE (Windows/macOS)
 ┌──────────────────────────────────────────┐   ┌───────────────────────────────────────────────┐
 │ Claude Code (cloud)                      │   │ Claude Code (Remote Control session, local    │
 │  - architecture, docs, pure-Luau modules │   │   folder = repo checkout)                     │
 │  - lint/format/typecheck/unit tests      │   │  - rojo serve  ─────────► Roblox Studio       │
 │  - PRs, reviews, CI fixes                │   │  - official Studio MCP ◄─► Studio plugin      │
 │                                          │   │  - playtest, console, instance edits          │
 └──────────────┬───────────────────────────┘   └──────────────┬────────────────────────────────┘
                │            git push / pull (GitHub = source of truth)       │
                └──────────────────────────► GitHub ◄─────────────────────────┘
                                                │
                                         GitHub Actions CI
                                (stylua --check, selene, luau-lsp analyze,
                                 Lune unit tests for pure modules)
```

Rule: **Git is the source of truth for all code and all hand-authored data.** Studio is a runtime and an editor for world geometry, never the only copy of anything.

### 2.2 Exact loop for a Studio-touching task

1. Claude (on device) pulls the branch, starts `rojo serve` for `games/project_flow/default.project.json`.
2. Studio has the place open with the Rojo plugin connected (or Script Sync, see §2.3). Code in `src/` appears live in Studio.
3. Claude edits `.luau` files in the repo. Rojo syncs them into Studio within a second.
4. Claude uses the Studio MCP to start a playtest, wait, read console output, stop the playtest.
5. Output is parsed for the test markers (`[FLOW_TEST] PASS/FAIL <name>`) and for any `error`/stack trace.
6. On failure: fix files, repeat 3–5. On pass: run local `stylua`, `selene`, `luau-lsp analyze`, then commit and push.
7. CI re-runs the static checks and pure unit tests. The PR is the review record.

World geometry (greybox arenas, rails) is the one thing authored in Studio. It is saved back to Git as `.rbxm` model files under `games/project_flow/assets/` and mapped by Rojo, or better, **generated from code/data** (rail splines and arena blocks defined in Luau tables) so it diffs cleanly. Default: generate greybox from data; only hand-sculpted art becomes `.rbxm`.

### 2.3 Rojo vs. Script Sync vs. MCP-only

The master plan (§7) says prefer the official MCP first unless a concrete limitation justifies another tool. The concrete limitation: **MCP edits land inside the open place, not in Git.** An MCP-only workflow makes Studio the source of truth and requires exporting scripts back out after every change, which breaks §4.8 and §7 ("keep all production code in Git").

Recommendation:
- **MCP** for what only Studio can do: playtest control, console output, querying the live DataModel, building/inspecting geometry, running diagnostic Luau.
- **Rojo 7.x** for code sync (filesystem → Studio). Mature, open source (MPL-2.0), and lets CI see the same files Studio runs.
- **Script Sync** as the alternative if Filip prefers no third-party Studio plugin. Decide in Mission 001B after testing both for 10 minutes.

Rojo's Studio plugin is a third-party plugin, so per master plan §21 it needs Filip's explicit OK before install. That is decision D1 in §9.

### 2.4 Toolchain, pinned in the repo

- `rokit.toml` pins `rojo`, `stylua`, `selene`, `luau-lsp`, `lune` versions (Rokit installs per-repo; falls back to `cargo install --locked` where binaries cannot be downloaded, as in this container).
- `stylua.toml`, `selene.toml`, `.luaurc` (`--!strict` default for `shared/`).
- `.github/workflows/ci.yml` running the static checks and Lune unit tests.
- `CLAUDE.md` summarizing the master plan's hard rules and this pipeline (master plan §26 step 4).

### 2.5 Where a Remote Control session fits

When a task needs Studio, the cloud thread starts a Remote Control session in Filip's local repo folder. That session runs steps 1–6 of §2.2 and reports back. Filip has to approve the folder once and keep Studio open with the place loaded. Nothing is published; the place stays a local/unpublished file or a private, unpublished test place.

---

## 3. PROPOSED RUNTIME ARCHITECTURE

### 3.1 Repository structure

Adapted from master plan §8, trimmed to what the first vertical slice needs. Folders marked *(later)* are created only when their milestone arrives.

```
/
  CLAUDE.md
  README.md
  PROJECT_FUSION_FACTORY_MASTER_PLAN.md      (renamed from "... 2.md")
  MISSION_001_PLAN.md
  rokit.toml  stylua.toml  selene.toml  .luaurc
  .github/workflows/ci.yml
  docs/       TECH_ARCHITECTURE.md  ACTION_GRAPH.md  NETWORKING.md
  legal/      IP_RULES.md  ASSET_PROVENANCE.md  NAME_CLEARANCE.md  (templates)
  engine/                                   reusable across games
    Net/            typed remotes, validation, rate limits
    Signal/  Maid/  small utilities (written in-house)
    Config/         versioned config loader
    Testing/        in-Studio test runner + Lune adapter
    Analytics/      (thin stub now, real later)
    PolicyGate/     (stub per master plan §9.4; no monetization yet)
    Data/           (later)
  games/project_flow/
    default.project.json
    GAME.md  DIFFERENTIATION.md  REFERENCE_ABSTRACTION.md
    src/
      shared/       → ReplicatedStorage.Flow
        Vocabulary/     Intents, Tags, Postures (enums, no logic)
        ActionGraph/    Graph, Node, Resolver, Phases, Validator
        Motor/          pure kinematics math (shared so server can sanity-check)
        Chain/          ChainTracker (pure)
        Flow/           FlowModel (pure)
        Actions/Core/   traversal nodes: Ollie, Flip, Grab, Spin, Manual, Grind, Transfer, Bank, Carve
        Classes/        Mage/ Rogue/ Paladin/ Gunner/   (one folder each)
        RailGraph/      rail data model + queries (pure)
        Config/         tunables as data
      client/       → StarterPlayer.StarterPlayerScripts
        InputService/   device → Intents
        MotorRunner/    runs Motor against the character each step
        ActionRunner/   runs ActionGraph locally (prediction)
        Presentation/   animation, VFX, camera, HUD (CHAIN/FLOW display)
      server/       → ServerScriptService
        ActionAuthority/  validates action requests, owns FLOW
        CombatService/    hits, damage, HP, rewind buffer
        MovementGuard/    position/velocity plausibility
        MatchService/     (minimal round loop)
        ClassService/     assigns class, builds per-player graph
    tests/          unit (Lune) + playtest (in-Studio) specs
    world/          greybox arena + rails as data
  tools/          scripts for test output parsing, graph validation
```

### 3.2 Ownership boundaries

| Module | Owns | Must NOT |
| --- | --- | --- |
| `Vocabulary` | Names of intents, tags, postures | contain logic |
| `Motor` | Kinematics: speed, carve, gravity, impulses, rail attachment, manual balance, bank | know about classes, combat, input devices |
| `ActionGraph` | Which action is active, its phase, legal transitions | apply physics directly (asks Motor via primitives) |
| `Actions/Core` | Shared traversal nodes | reference any class |
| `Classes/*` | Class nodes, class rules, class FLOW abilities | edit Motor or Core nodes |
| `ChainTracker` | CHAIN state from action events | grant rewards (server does) |
| `FlowModel` | FLOW gain/decay/spend math | decide authority (server does) |
| `InputService` | Device mapping, buffering | know what an action does |
| `ActionAuthority` (server) | Accept/reject actions, authoritative FLOW, cooldowns | trust client FLOW, cooldowns or damage |
| `CombatService` (server) | Hit resolution, HP, damage | trust client damage numbers |
| `MovementGuard` (server) | Detect impossible movement | re-simulate every frame (too costly) |
| `Presentation` (client) | Everything visual/audio | change game state |

Pure modules (`Motor` math, `ActionGraph`, `Chain`, `Flow`, `RailGraph`) have no Roblox service dependencies beyond math types, so they run under Lune in CI and on both client and server.

---

## 4. ACTION GRAPH ARCHITECTURE

The core problem: dozens of actions across shared traversal and many classes, all chainable. Explicit edges between every pair grow quadratically and force core code to know about every class. So transitions are **mostly rule-based on tags**, with explicit edges only for special cases.

### 4.1 Two layers: Posture and Action

- **Posture** (owned by Motor): what the body is physically doing. Small fixed set: `Grounded`, `Airborne`, `Grinding`, `Manual`, `WallRide` *(later)*, `Bailed`. Motor computes it from physics each step.
- **Action** (owned by ActionGraph): at most one active action node, which runs in phases. Actions can be performed in any posture they declare as legal. An attack while grinding is just an action whose `postures` include `Grinding`; the grind continues underneath.

This is what removes "skate mode vs combat mode". There is only posture plus the current action.

### 4.2 Action node definition (data, not subclasses)

```lua
-- illustrative shape, not final code
type ActionNode = {
    id: string,                     -- "core.kickflip", "mage.fireball"
    owner: string,                  -- "core" | "mage" | ...
    tags: { Tag },                  -- {"Trick","Flip"} / {"Attack","Ranged","Spell"}
    intent: IntentPattern,          -- e.g. { press = "Trick", dir = "Left" }
    postures: { Posture },          -- where it may start
    requires: Predicate?,           -- extra conditions (speed, FLOW tier, near rail)
    phases: {                       -- time-based, in seconds
        startup: number,
        active: number,
        recovery: number,
    },
    cancels: {                      -- what this action may be cancelled INTO, by phase
        startup: { Tag }?,
        active: { Tag }?,
        recovery: { Tag }?,         -- typical: {"Trick","Attack","Mobility","Defensive"}
    },
    motor: { MotorCall }?,          -- primitives requested at phase boundaries
    flow: { gain: number?, cost: number?, tierRequired: number? },
    chain: { links: boolean, weight: number },
    priority: number,
    serverValidated: boolean,       -- needs ActionAuthority approval to have effect
}
```

### 4.3 Resolving a transition

On each step, the Resolver takes the buffered intents and asks: which nodes are **legal right now**?

A node N is a candidate if all hold:
1. `N.intent` matches a buffered intent (buffer window ~120–150 ms, tunable).
2. Current posture ∈ `N.postures`.
3. No action is active, **or** the active action's current phase lists a tag in `cancels` that N has.
4. `N.requires` passes (FLOW tier, cooldown, context like "rail within reach").
5. N is in this player's composed graph (core + their class + their unlocked options).

Highest `priority` wins; ties go to the most specific intent match. Explicit edges (`graph:link("rogue.launcher", "rogue.air_grab", {window = ...})`) can add a transition the tag rules would not allow, or forbid one they would.

The example chain from the brief works with no special-casing:
Ollie (Grounded→Airborne) → Kickflip (Trick, recovery cancels into Trick/Attack) → Grind (Motor attaches to rail, posture Grinding) → Fireball (legal in Grinding) → Rail Transfer (Mobility, Grinding) → Melee Launcher (Attack, lands into Grounded) → Grab (Trick, Airborne) → Quickshot (Attack, Airborne) → Manual (posture Manual) → Bank.

### 4.4 Phase timing and determinism

- Actions run on a fixed simulation step (start at 60 Hz, driven from `RunService` with an accumulator) so timing is identical on client and server checks.
- Phase durations are data. No animation-event timing drives gameplay; animations follow the state, not the other way round. That keeps server validation independent of animation assets.

### 4.5 Graph validation tool

`tools/validate_graph` (Lune) loads core + every class and checks:
- every node has at least one exit (recovery ends or cancels);
- no node is unreachable from `Grounded` idle;
- no two nodes in the same composed graph claim the same intent+posture at the same priority;
- every `tierRequired` is satisfiable;
- tag names exist in `Vocabulary`.

Runs in CI. This is how adding the 10th class stays safe.

---

## 5. CLASS ARCHITECTURE

### 5.1 A class is a package of data plus small hooks

```
Classes/Paladin/
  init.luau          -- ClassDefinition
  Nodes/             -- ActionNode tables
  Rules.luau         -- explicit links/forbids, posture extensions
  Abilities.luau     -- FLOW-powered signature
  Server.luau        -- server-side effect handlers (damage, block resolution)
  Client.luau        -- presentation only (VFX, sounds, anims)
  Tuning.luau        -- numbers
```

```lua
-- illustrative
type ClassDefinition = {
    id: string,
    nodes: { ActionNode },
    rules: { Rule }?,
    flowAbilities: { ActionNode },     -- nodes with flow.cost / tierRequired
    effects: { [string]: EffectHandler }, -- server handlers keyed by node id
    traversalModifiers: TraversalModifiers?, -- bounded, see 5.3
}
```

`ClassService` composes a per-player graph at spawn: `Core ∪ Class ∪ Unlocks`. Adding a class means adding a folder and registering it. No edits to `Motor`, `ActionGraph` or `Actions/Core`.

### 5.2 How the four starting classes map

| Class | Nodes it adds | Motor primitives it uses |
| --- | --- | --- |
| Mage | Bolt (Ranged), Movement spell (Mobility), Blink (Defensive+Mobility), Signature (FLOW) | `Impulse`, `Teleport` (server-validated, short range) |
| Rogue | Fast strike chain (Melee ×3), Dagger throw (Ranged), Dash (Mobility), Evade/Parry (Defensive) | `Impulse`, `SpeedBurst` |
| Paladin | Strike (Melee), Shield raise/Block (Defensive, holdable), Parry window, Charge (Mobility) | `Impulse`, `SpeedBurst`, `Brace` (reduces knockback) |
| Gunner | Primary fire (Ranged), Quickshot (Ranged, cancels from tricks), Dodge (Defensive), FLOW weapon mode | `Impulse` (recoil hop) |

Every class has the same traversal set because Core nodes are always in the composed graph.

### 5.3 Bounded traversal influence

Classes may tune feel within bounds (e.g. ±10% air control, ±0.1 s on a cancel window) through `traversalModifiers`, which Motor reads from a validated, clamped table. They cannot replace Motor code. This keeps the "classes change combat language, not movement foundation" law enforceable, and the clamp is checked by the graph validator.

### 5.4 Progression as options, not stats

Unlocks are **graph additions**: a new node, a new cancel tag on an existing node, an explicit link, or a FLOW ability slot. Stat growth is capped and small. The server's composed graph is the record of what a player can do, so a veteran has more *edges*, not bigger numbers. A new player with good execution can still win because the core edges are always present.

### 5.5 Future classes

Sniper, Berserker, Engineer, Monk and Necromancer fit the same shape. Two may need new Motor **primitives** (Engineer placing a rail segment; Necromancer summons as separate entities). Those become additions to the Motor primitive list and the Rail Graph API, reviewed as engine changes, still without class code inside Motor.

---

## 6. CLIENT/SERVER MODEL

### 6.1 Principle

Movement feel must be instant, so the client predicts. Anything that changes another player's state, the economy, or progression is server-authoritative (master plan §9.2). The server validates plausibility rather than re-simulating every frame.

### 6.2 Authority table

| Concern | Client | Server |
| --- | --- | --- |
| Own character movement (Motor) | **Simulates** (network owner of own character) | Plausibility checks: speed caps per posture, rail proximity, teleport distance, ground contact. Corrects or rubber-bands on violation. |
| Action start (tricks, attacks, spells) | **Predicts** immediately (anim, VFX, Motor primitives) | Receives `ActionRequest{nodeId, seq, clientTime, aim}`; accepts or rejects (node in player's graph, posture plausible, cooldown, FLOW). Rejection rolls back client effects. |
| FLOW value | Displays predicted value | **Authoritative.** Computed from accepted actions. Client reconciles to server snapshots. |
| CHAIN | Displays predicted chain | **Authoritative** for anything it feeds (FLOW, score, rewards). |
| Cooldowns | Displays | **Authoritative** |
| Hits and damage | Shows hit VFX optimistically only for hitscan/melee confirmations it sent | **Authoritative.** See 6.3. |
| HP, knockback on others, deaths | Never | **Authoritative** |
| Projectiles | Spawns cosmetic copy instantly | Simulates the real projectile; resolves hits |
| Rail Graph | Has a copy for Motor | Has the same copy for validation |
| Match state, rewards, progression, data | Never | **Authoritative** |

### 6.3 Combat hit resolution

- Server keeps a short history (~300 ms) of each character's hitbox transforms each step (rewind buffer).
- **Hitscan (Quickshot, Gunner primary):** client reports `{target, hitPoint, clientTime}`. Server rewinds the target to that time (clamped to a max rewind), re-casts, accepts if within tolerance.
- **Melee (Rogue/Paladin):** server runs the hitbox query at the attacker's reported time with the same rewind clamp.
- **Projectiles (Fireball, Dagger):** server-simulated; the client copy is visual only.
- **Parry/Block:** resolved server-side by comparing the defender's accepted defensive phase against the hit's server time.

### 6.4 Exploit surface to design for now

FLOW farming via fake trick requests (rate-limit per node, require posture plausibility, diminish repeated identical tricks in `ChainTracker`), speed hacks (MovementGuard caps), teleport abuse (server checks Blink/Teleport distance and line of sight), and remote spam (`engine/Net` rate limits and type validation on every remote, per master plan §9.2).

### 6.5 Experiment before locking

Roblox has been developing native server-authoritative movement with client prediction. If it is usable in the installed Studio, it could replace the custom plausibility layer for movement. This is Risk R3; until proven, the plan assumes client-owned movement + server validation, which is known to work on Roblox today.

---

## 7. INPUT ABSTRACTION

### 7.1 One vocabulary

Every device produces the same **Intents**. Gameplay code only ever sees intents.

| Intent | Meaning |
| --- | --- |
| `Move` (vec2) | Steer/carve, push |
| `Aim` (vec3 dir / screen point) | Camera and targeting |
| `Ollie` | Jump / pop |
| `Trick` (+ dir) | Flip family; direction picks the variant |
| `Grab` (+ dir) | Grab family |
| `Spin` (+ dir) | Rotation |
| `Manual` | Balance on two wheels |
| `Grind` | Attach to nearby rail (also auto-assist) |
| `Primary` / `Secondary` | Class attacks |
| `Mobility` | Class movement ability |
| `Defend` | Class block / parry / dodge |
| `Signature` | FLOW ability |

### 7.2 Device mapping

| Intent | Keyboard + mouse | Gamepad | Touch |
| --- | --- | --- | --- |
| Move | WASD | Left stick | Virtual stick (left) |
| Aim | Mouse | Right stick + aim assist | Drag on right half + aim assist |
| Ollie | Space | A / Cross | Big button |
| Trick + dir | Shift + WASD | X + left stick | Swipe on trick pad (swipe dir = variant) |
| Grab + dir | E + WASD | Y + left stick | Hold + swipe on trick pad |
| Spin | Q/E held in air | Shoulder buttons in air | Two-finger rotate or auto-spin on trick |
| Manual | Ctrl | Left stick press or B | Auto on landing with forward tilt toggle |
| Grind | Auto-snap near rail; F to force | Auto-snap; RB to force | Auto-snap |
| Primary / Secondary | LMB / RMB | RT / LT | Two attack buttons |
| Mobility | R | RB | Button |
| Defend | C or MMB | LB | Button |
| Signature | G | Both shoulders | Button appears when FLOW tier reached |

Touch has fewer buttons, so it relies on **context resolution**: the same intent resolves to different nodes by posture (e.g. `Trick` while grinding = rail trick). That logic already lives in the Action Graph, so input does not need special cases.

### 7.3 Implementation

- Use Roblox's Input Action System (`InputContext`/`InputAction`/`InputBinding`) if available in the installed Studio; else `ContextActionService` + `UserInputService`. `InputService` hides which one.
- **Input buffer** (~120–150 ms) so chained presses are not dropped between phases.
- **Assist profiles** per device (aim assist strength, rail snap radius, trick timing leniency). They change tolerances, never the vocabulary or what actions exist.
- Rebinding stored client-side first; persisted later with player data.

---

## 8. FIRST TECHNICAL SMOKE TEST

Goal: prove, end to end, that Claude can **modify Studio, run the game, read output, fix a failure and commit**. No gameplay.

Runs on Filip's machine in a Remote Control session (Mission 001B).

### 8.1 Setup (once)
1. Filip opens a Remote Control session in a local clone of this repo.
2. Install pinned toolchain (`rokit install`), install/verify the official Studio MCP and register it with Claude Code on that machine.
3. Open a new **unpublished** baseplate place in Studio. Connect Rojo (or enable Script Sync, per decision D1).

### 8.2 Content
A minimal `games/project_flow/default.project.json` and:
- `src/server/Smoke.server.luau`: prints `[FLOW_TEST] BOOT <git short sha>` and requires `shared/SmokeMath`, asserting `SmokeMath.add(2, 2) == 4`, printing `[FLOW_TEST] PASS smoke_math` or erroring.
- `src/shared/SmokeMath.luau`: **deliberately wrong** on first commit (`return a - b`).
- `tests/smoke.spec.luau` (Lune) testing the same function, so CI sees the same failure.

### 8.3 Steps and pass criteria
| # | Step | Pass when |
| --- | --- | --- |
| 1 | `rojo serve`; MCP queries DataModel | MCP returns that `ServerScriptService.Smoke` exists (proves sync + MCP read) |
| 2 | MCP creates a Part `SmokeRail` in Workspace via run-code | MCP query confirms it exists (proves MCP write) |
| 3 | MCP starts playtest, waits, reads console, stops | Console shows `BOOT` and an assertion error from `SmokeMath` |
| 4 | Claude fixes `SmokeMath.luau` (`a + b`) | Rojo syncs; file diff is the only change |
| 5 | MCP re-runs playtest and reads console | `[FLOW_TEST] PASS smoke_math`, no errors |
| 6 | `stylua --check`, `selene`, `luau-lsp analyze`, `lune run tests` | All green |
| 7 | Commit + push to a branch, open draft PR | CI green on the PR |
| 8 | Claude deletes `SmokeRail`, closes playtest | Studio left clean; nothing published |

Failure handling: if the MCP cannot read console output, fall back to a plugin-free route: the test script writes results into a `StringValue` under `ReplicatedStorage.TestResults`, which MCP can read via run-code after stopping play. Record whichever worked in `docs/TECH_ARCHITECTURE.md`.

### 8.4 Output
`STATUS.md` (master plan §26 format) with what worked, exact tool names the MCP exposed, timings, and any fallback used.

---

## 9. RISKS

Technical assumptions that need an experiment before we commit to them.

| # | Assumption | Why it might be wrong | Experiment | Kill/pivot signal |
| --- | --- | --- | --- | --- |
| R1 | Official Studio MCP can start/stop play and read console output | Tool set has changed across releases | Smoke test steps 3 and 5 | No console access → use `TestResults` value fallback |
| R2 | Rojo + MCP coexist cleanly (no fighting over the same scripts) | MCP edits to a Rojo-managed script get overwritten | Edit a synced script via MCP during smoke test, observe | Rule: MCP never edits Rojo-managed instances; write in Git only |
| R3 | Client-owned movement + server plausibility is "fair enough" for melee/parry at Roblox latencies | 100–200 ms pings make parry windows feel bad for one side | 2-client test with simulated latency (Studio network sim) on Paladin parry | Widen windows, move parry to client-confirmed with server veto, or evaluate native server authority |
| R4 | A custom skate Motor on Roblox physics feels good and is stable on rails at speed | Humanoid fights custom forces; high-speed rail snap jitter | Motor spike: `ControllerManager` vs. `Humanoid` PlatformStand + `VectorForce`/`LinearVelocity`, on one rail, 60 s of grinding at max speed | Pick whichever stays jitter-free on mobile |
| R5 | 60 Hz fixed-step action timing holds on low-end mobile | Frame drops desync phase timing | Run phase logic on accumulator; test on a mid/low Android device | Drop to 30 Hz sim with interpolation |
| R6 | Tag-based transitions stay understandable at 4+ classes | Emergent illegal or degenerate combos | Graph validator + combo fuzzer (random intent streams) in Lune | Add explicit forbid rules; tighten cancel tags |
| R7 | Touch can express the trick vocabulary without overload | Too many buttons | Paper + greybox test with context resolution and swipe pad | Simplify: auto-tricks on touch, keep depth on gamepad/PC |
| R8 | FLOW-as-options (not damage) still feels powerful | Players may not feel the reward | Playtest: FLOW tier unlocks vs. small damage buff A/B | Tune unlock visibility, add feedback, small capped buff |
| R9 | Rail Graph as data (splines) is cheap enough server-side for proximity checks | Many rails + many players | Spatial hash over rail segments; profile 12 players | Coarser grid, client-claimed rail ID + server verify |
| R10 | Remote traffic stays within budget at 8–12 players | Per-action requests + hit reports | Measure in a 4-client local server test | Batch action requests per step |
| R11 | A cloud session can do meaningful work without Studio | Most validation needs a running game | Keep pure modules testable in Lune | — (accepted: Studio work moves to device) |

---

## 10. IMPLEMENTATION ORDER

Each mission is one PR, playtested where it touches Studio, with a `STATUS.md` update. Do not start a later step to work around a failing earlier one.

| # | Mission | Depends on | Delivers | Where it runs |
| --- | --- | --- | --- | --- |
| 001B | Toolchain + smoke test (§8) | Filip's device online, decision D1 | Rojo/MCP loop proven, CI, `CLAUDE.md`, rename master plan file, legal templates (master plan §26 steps 3–5) | Device + cloud |
| 002 | Project skeleton | 001B | `engine/Net`, `Signal`, `Config`, `Testing`, `Vocabulary`; stub `Analytics` and `PolicyGate` (master plan §26 steps 8–10, thin) | Cloud, verified on device |
| 003 | Input layer | 002 | Intents, buffer, KB/M + gamepad bindings, debug overlay of live intents | Device |
| 004 | Motor v0 + greybox | 002 | Accelerate, carve, ollie, land, bail on a flat data-generated test yard. Risk R4/R5 spike happens here | Device |
| 005 | Action Graph core + traversal | 003, 004 | Graph, resolver, phases, validator; Flip, Grab, Spin, Manual, Bank nodes; client-only CHAIN + FLOW + HUD numbers | Device + Lune |
| 006 | Rail Graph v0 | 005 | Rail splines as data, grind, transfer, auto-snap. Risk R9 | Device |
| 007 | Server authority | 005, 006 | `ActionAuthority`, authoritative FLOW/CHAIN, `MovementGuard`, rate limits, rejection rollback. Risk R10 | Device (2 clients) |
| 008 | Combat core + first class (Gunner) | 007 | HP, rewind buffer, hitscan validation, Quickshot cancelling from tricks. Proves the brief's "trick → attack → trick" chain | Device (2 clients) |
| 009 | Second class (Paladin) | 008 | Melee, block, parry, charge. Proves classes add melee + defensive nodes without touching Motor/Core. Risk R3 | Device (2 clients) |
| 010 | Minimal match loop | 009 | Small arena from data, respawn, round, score. First 5-minute loop playable (master plan §26 step 19) | Device |
| 011 | Touch controls | 010 | Touch layout + context resolution. Risk R7 | Device + phone |
| 012 | Mage + Rogue | 010 | Projectile pipeline, Blink/Teleport primitive, fast cancel chains. Risk R6 fuzzer | Device |
| later | Player data, analytics events, progression-as-unlocks, cosmetics, PolicyGate wiring | GATE C passed | Per master plan §9, §10 | — |

Explicitly **not** in the first slice: player data persistence, shop, loot, battle pass, lobby, more than one arena, wall rides, future classes, real analytics backend. All stay as stubs or nothing until the greybox is fun (master plan Gate C).

---

## BLOCKERS

1. **No machine that can run Roblox Studio is connected.** This session is a Linux cloud container; Studio is Windows/macOS only, and the Studio MCP must run next to Studio. Filip's device is not registered for Remote Control yet.
2. **Studio MCP version and tool set unverified.** Roblox docs are blocked from this container. Check on device during 001B.
3. **Decision D1 (Filip):** allow the Rojo Studio plugin (third-party, open source), or use Studio's native Script Sync instead. Recommendation: Rojo.
4. Minor: the master plan file is named `PROJECT_FUSION_FACTORY_MASTER_PLAN 2.md`. Plan: rename to drop the ` 2` in Mission 001B.

None of these block the plan itself. Blocker 1 blocks executing Mission 001B.

## RECOMMENDED NEXT EXECUTION STEP

Mission 001B on Filip's computer: with Roblox Studio installed and signed in, start a Remote Control session in a local clone of `cmlkkkk/PROJECT_FUSION_FACTORY_MASTER_PLAN`, then run the smoke test in §8 exactly as written (toolchain install, MCP registration, deliberately failing `SmokeMath`, fix, re-run, commit, draft PR). Nothing published, no money spent.

STOP. Plan only; nothing implemented.

MISSION 001A: READY FOR EXECUTION
