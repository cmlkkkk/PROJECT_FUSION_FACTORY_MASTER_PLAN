# TECH ARCHITECTURE

Last updated: 2026-10-04 (Mission 001B). Supersedes the pipeline and Action sections of
`MISSION_001_PLAN.md` where they differ. Everything under "Observed" was verified on this machine.

## 1. Pipeline (Mission 001B decisions)

```
Git repo (source of truth)
   -> native Studio Script Sync   (NOT Rojo; Rojo needs explicit human approval later)
   -> Roblox Studio (open place "Place1", unpublished)
   <-> official Studio MCP ("Studio MCP Proxy", server name Roblox_Studio)
   -> real playtest -> observe -> fix on disk -> sync -> playtest -> commit
```

Intended mapping (NOT yet verified, because Script Sync could not be enabled; see section 3):

| Repo path | Studio location |
| --- | --- |
| `games/project_flow/src/shared/*.luau` | `ReplicatedStorage.Flow.*` (ModuleScript) |
| `games/project_flow/src/server/*.server.luau` | `ServerScriptService.*` (Script) |

## 2. Observed MCP capabilities (Studio build 0.741.19.7411056, Windows 11)

| Capability | Tool | Result |
| --- | --- | --- |
| List Studio instances | `list_roblox_studios` | PASS: one instance, "Place1" |
| Studio mode / available DataModels | `get_studio_state` | PASS: Edit; Client+Server during Play |
| Inspect DataModel tree | `search_game_tree` | PASS |
| Inspect instance properties | `inspect_instance` | PASS |
| Execute Luau (Edit) | `execute_luau` | PASS |
| Execute Luau (Server, during Play) | `execute_luau` | PASS |
| Create an Instance | `execute_luau` | PASS (MCP_SmokePart) |
| Destroy an Instance | `execute_luau` | PASS |
| Enter Play mode | `start_stop_play` | PASS ("Game Started") |
| Stop Play mode | `start_stop_play` | PASS ("Game Stopped") |
| Read console output | `get_console_output` | PASS: includes script `print` output from `execute_luau` |
| Read a script's source | `script_read` | Loaded, not exercised |
| Send mouse/keyboard input | `user_mouse_input`, `user_keyboard_input` | Schema inspected only. `datamodel_type` accepts only `"Client"`, i.e. input into a running game, not Studio's own UI |

Console output IS available, so `ReplicatedStorage.TestResults` is a secondary machine-readable channel, not the
only one. `Smoke.server.luau` writes both.

Known noise, not caused by this project: a `MaterialManager ... debug.profileEnd()` stack trace appears in the
console at Studio load (built-in Studio plugin).

## 3. Native Script Sync: availability finding

- `game:GetService("InstanceFileSyncService")` and `LiveSyncService` exist in this Studio build (service present).
- No members are readable or scriptable through `execute_luau`, `inspect_instance` (empty property list) or
  `ReflectionService:GetClass` (returned nothing). No setting named ScriptSync/LiveSync exists in `settings().Studio`.
- The only MCP tools that could drive UI accept the `Client` DataModel only, so they cannot operate the Explorer
  context menu, Beta Features or the native folder-picker that Script Sync needs.
- Therefore enabling Script Sync, and choosing the repo folder, needs one manual human step in Studio's UI.
  The exact menu location in this build was NOT verified.
- Rojo was not installed, and no plugin was installed.

## 4. Architectural correction: Action Channels (replaces "Posture + one active Action")

`MISSION_001_PLAN.md` section 4 proposed Posture plus at most one active Action. That is withdrawn. The future
Action Graph must allow compatible simultaneous actions, for example:

- Airborne + Grab + Quickshot
- Grinding + Fireball
- Spin + ranged attack
- Manual + defensive action

Physical **Posture** (Grounded, Airborne, Grinding, Manual, ...) stays separate and is computed by Motor.
Actions occupy **channels** (layers). Minimum set:

| Channel | Examples |
| --- | --- |
| `TRAVERSAL_TRICK` | Ollie, flips, Grab, Spin, Manual, Grind |
| `COMBAT` | Quickshot, Fireball, melee strikes |
| `UTILITY_DEFENSIVE` | Block, parry, dodge, Blink |

Every future action node must declare:

1. `channel`: the channel it occupies;
2. `coexistsWith`: channels it may run alongside;
3. `blocks`: actions or channels it prevents while active;
4. `cancelRules`: when, by phase, and into what it can be cancelled;
5. `cancelledBy`: actions or channels able to cancel it.

Worked examples:
- Grab (`TRAVERSAL_TRICK`) coexists with Quickshot (`COMBAT`).
- Heavy melee (`COMBAT`) blocks any other `COMBAT` action while active.
- Blink may cancel several channels.
- Bail cancels all gameplay channels.

Consequences for the old plan: the Resolver evaluates candidates per channel instead of globally; the validator
must also check channel conflicts (two nodes that block each other with no exit) and that Bail reaches every
channel. Not implemented in Mission 001B, by design.

## 5. Open items
- Enable and verify native Script Sync with a human step (see `STATUS.md`).
- Then run the loop in the mission brief: broken `SmokeMath` -> failing playtest -> disk fix -> passing playtest.
