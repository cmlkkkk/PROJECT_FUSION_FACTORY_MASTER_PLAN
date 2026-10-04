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

Verified mapping (Script Sync enabled manually by a human in Studio; configured folders are the parents):

| Studio service | Configured folder | Folder Studio actually syncs | Example |
| --- | --- | --- | --- |
| `ReplicatedStorage` | `games/project_flow/src/shared` | `games/project_flow/src/shared/ReplicatedStorage/` | `SmokeMath.luau` -> `ReplicatedStorage.SmokeMath` (ModuleScript) |
| `ServerScriptService` | `games/project_flow/src/server` | `games/project_flow/src/server/ServerScriptService/` | `Smoke.server.luau` -> `ServerScriptService.Smoke` (Script, `RunContext=Server`) |

Files placed directly in the configured folder (outside the service-named subfolder) are NOT synced.
Naming: `Name.luau` -> ModuleScript, `Name.server.luau` -> Script with Server RunContext; the suffix is stripped.

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

## 3. Native Script Sync: observed behavior (build 0.741.19.7411056)

Enabling: not scriptable from Claude Code. `InstanceFileSyncService` / `LiveSyncService` exist but expose no members
through `execute_luau`, `inspect_instance` or `ReflectionService`, and the MCP input tools only reach the `Client`
DataModel. A human enabled it in Studio's UI and chose the two folders above (exact menu path not recorded by Claude).
No Rojo and no third-party plugin were used.

Observed after enabling:
1. Studio itself created the service-named subfolders `shared/ReplicatedStorage/` and `server/ServerScriptService/`
   (both empty, so nothing on disk was overwritten). Fixtures that sat one level above were invisible to Studio
   until moved (`git mv`) into those subfolders. This is a disk-side action, not MCP injection.
2. Disk -> Studio, create: moved files appeared within one MCP round trip, with the right classes.
   Source lengths matched the files on disk (282 / 1010 chars).
3. Disk -> Studio, edit: changing `a - b` to `a + b` in `SmokeMath.luau` was visible in Studio via `script_read`
   with no manual step, before the second playtest.
4. Disk -> Studio, create then delete: a temporary `SyncProbe.luau` appeared as `ReplicatedStorage.SyncProbe`
   (ModuleScript) and disappeared after the file was removed. Verified with `search_game_tree`.
5. Playtest-created objects (`ReplicatedStorage.TestResults`) are not persisted into Edit mode and not written to disk.
6. Not tested: Studio -> disk direction, simultaneous edits on both sides, rename/move, `init.luau` folder modules,
   attribute/property persistence (e.g. `Disabled`), behaviour while the place is unsaved vs saved. Treat the
   direction Studio -> disk as unverified; never edit synced scripts inside Studio or via MCP.

Consequence for the old plan: `MISSION_001_PLAN.md`'s `ReplicatedStorage.Flow` namespace does not exist by default.
To get one, create a `Flow/` folder inside `shared/ReplicatedStorage/` (unverified, needed by Mission 002).

## 3b. Observed smoke loop (real playtests, Server DataModel + console)

| Step | Evidence |
| --- | --- |
| Playtest 1 (broken `a - b`) | Console: `[FLOW_TEST] FAIL smoke_math expected=4 actual=0`; `TestResults.smoke_math = FAIL expected=4 actual=0` |
| Fix on disk, no MCP involvement | `script_read` showed `return a + b` in Studio |
| Playtest 2 | Console: `[FLOW_TEST] PASS smoke_math` (only line); `TestResults.smoke_math = PASS` |

Both evidence channels (console and `TestResults`) agreed in both runs.

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
- Verify Studio -> disk direction and rename/move behaviour before Mission 002 relies on a nested layout.
- Decide the `Flow` namespace layout under `shared/ReplicatedStorage/`.
- Script Sync enablement is a manual, per-machine Studio step; document it in the contributor setup when one exists.
