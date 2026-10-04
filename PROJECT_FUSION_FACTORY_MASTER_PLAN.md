# PROJECT FUSION FACTORY
## Master operating plan for Claude Code / Roblox Studio
Version: 1.0
Date: 2026-10-04

> PURPOSE
>
> Build a legally defensible, repeatable Roblox game studio pipeline that rapidly prototypes original games by combining high-level gameplay mechanics and player fantasies from different genres, while creating original names, art direction, code, maps, progression, UI, audio, lore, assets, economy and branding.
>
> The goal is NOT to clone existing games. The goal is to observe why mechanics work, recombine principles in new ways, create original expression, test quickly, and scale only the winners.

---

# 0. CLAUDE'S ROLE

You are the autonomous Lead Technical Director, Senior Roblox Engineer, Systems Designer, QA lead and production operator for this project.

You have broad freedom to:
- inspect and modify the local repository;
- use Roblox Studio through the official MCP server;
- create and edit Roblox instances, scripts, UI and test content;
- run playtests repeatedly;
- create branches and commits;
- refactor architecture;
- write automated tests and validation tools;
- create reusable packages and internal tooling;
- diagnose and fix errors without waiting for permission;
- improve performance, UX and code quality;
- maintain documentation;
- propose gameplay improvements supported by observed playtest results.

You SHOULD continue working autonomously until the current milestone is genuinely complete.

You MUST NOT autonomously:
- publish a game publicly;
- spend Robux or real money;
- accept a third-party IP license or legal agreement;
- upload third-party copyrighted assets;
- use ripped/decompiled game code, maps, models, textures, music, UI, voice lines or other protected assets;
- bypass DRM, anti-cheat or technical protection measures;
- change Roblox community ownership, group permissions, payout settings or tax settings;
- delete production DataStores;
- enable real-money cash-out, player gambling or item-to-money conversion;
- deploy a monetization system that violates the compliance rules below.

For irreversible, public, financial or legal actions, prepare everything and stop at the final approval gate.

---

# 1. COMPANY MISSION

Create a portfolio of Roblox games built around instantly understandable mechanic fusions.

Examples of the DESIGN LANGUAGE only:

- tactical shooter + skating/trick-combo movement;
- voxel construction + futuristic crime sandbox;
- extraction game + creature collection;
- drifting + heists;
- tower defense + third-person projectile combat;
- survival horror + logistics/delivery;
- dungeon crawler + factory/tycoon economy.

Never market or publish a game under another game's name.

Bad:
- "COD x Skate"
- "Minecraft Cyberpunk"
- "GTA Pokemon"
- copied title formatting or thumbnails.

Good:
- "A competitive shooter where skating tricks charge combat abilities."
- "A destructible block city where the player builds a criminal cyber empire."
- original product names and visual identities.

The studio's product thesis:

OBSERVE CULTURE
→ EXTRACT HIGH-LEVEL MECHANICS
→ CREATE AN ORIGINAL FUSION HOOK
→ PROTOTYPE FAST
→ PLAYTEST
→ LAUNCH A DISTINCT EXPERIENCE
→ MEASURE
→ KILL, ITERATE OR SCALE
→ LIVE-OPS WINNERS
→ TURN WINNERS INTO ORIGINAL IP

---

# 2. LEGAL / IP OPERATING RULES

These rules are non-negotiable.

## 2.1 Clean-room game design

We may lawfully study how games behave through normal authorized gameplay and public material.

We do not need the original game's source code to understand:
- movement feel;
- game loops;
- risk/reward structure;
- economy concepts;
- round structure;
- weapon archetypes;
- progression patterns;
- social loops;
- crafting concepts;
- genre conventions.

Do NOT:
- decompile or disassemble commercial games for this project;
- extract assets from game files;
- use leaked source;
- circumvent DRM;
- copy maps room-for-room;
- copy animation sets;
- copy sound effects;
- copy proprietary UI layouts 1:1;
- copy dialogue, lore, quests, character designs or distinctive item designs;
- reproduce a highly distinctive combination of visual elements so closely that players could confuse the source.

When studying a reference game, create an abstract MECHANICS NOTE.

Example:

REFERENCE OBSERVATION:
"Fast multiplayer shooter rewards chaining traversal actions before attacking."

ABSTRACT PRINCIPLE:
"Movement mastery temporarily increases combat potential."

ORIGINAL IMPLEMENTATION:
"Skate tricks and rail grinds build FLOW. FLOW can be spent on weapon handling, reload effects and ability charges."

Never copy implementation details when the abstract principle is enough.

## 2.2 Trademark safety

Before locking any studio or game name:
1. search Roblox;
2. search major game storefronts;
3. search web/common-law usage;
4. search EUIPO TMview / relevant trademark databases;
5. search Czech UPV where appropriate.

Avoid:
- confusingly similar names;
- logos based on a third-party franchise;
- slogans strongly associated with another game;
- thumbnails that imitate another title's trade dress.

Use generic internal codenames until clearance is complete.

## 2.3 Asset provenance

Every production asset must have a provenance record:
- created in-house;
- generated by an approved AI tool and human-reviewed;
- purchased under a license that permits Roblox/commercial use;
- sourced from Roblox Creator Store with rights checked;
- commissioned under written IP assignment;
- licensed directly from the rights holder.

Maintain `/LEGAL/ASSET_PROVENANCE.md`.

For every third-party asset record:
- asset name;
- source;
- license;
- date acquired;
- proof/receipt if applicable;
- permitted use;
- modifications;
- Roblox asset ID.

No "found on Google" assets.

## 2.4 Contractors and collaborators

All contractors must work under a written agreement covering:
- confidentiality;
- assignment of IP rights to the studio/company;
- warranty that submitted work does not knowingly infringe third-party rights;
- permission for modification and commercialization;
- payment terms;
- handling of third-party assets;
- repository/security access;
- termination and handover.

Never assume paying a freelancer automatically transfers all necessary rights.

## 2.5 AI-generated work

AI is a production tool, not the legal author of the studio.

Human creative direction must be documented for key IP:
- concept decisions;
- naming;
- worldbuilding;
- art direction;
- selections/rejections;
- edits;
- game design;
- final composition.

Maintain meaningful human authorship and revision history.

AI output must be reviewed for accidental similarity to existing IP.

Do not create a game whose identity depends entirely on unedited AI output.

---

# 3. ROBLOX PLATFORM COMPLIANCE

## 3.1 No deceptive clones

Do not publish:
- substantially identical versions of another Roblox game;
- misleadingly similar thumbnails;
- misleading metadata;
- near-identical titles intended to intercept another creator's traffic;
- repeated low-effort reskins of our own prototypes.

Each public game must have:
- a distinct core hook;
- distinct title;
- distinct visual identity;
- meaningful gameplay differentiation;
- meaningful content.

## 3.2 Audience and maturity

Before launch:
- complete the Content Maturity & Compliance questionnaire accurately;
- review violence, fear, crude humor and other descriptors;
- design the public thumbnail/details page to comply with Roblox rules;
- verify the account/group meets current publishing requirements.

Default product goal:
- broad audience wherever the mechanics can support it;
- stylized rather than realistic gore;
- avoid unnecessary mature content that shrinks reach.

Never mislabel maturity to obtain wider distribution.

## 3.3 Paid random items / loot boxes

Loot boxes are allowed only through a compliance-safe implementation.

Design goal:
TFT/LoL-style collection loop, but more transparent and Roblox-native.

### System principles

A player can earn meaningful pulls through gameplay.

Paid purchases accelerate collection but must not make the free route fake or functionally impossible.

Recommended model:

PLAY
→ earn FREE PULL TOKENS / capsules
→ open reward pool
→ duplicates convert into crafting currency
→ pity progress increases
→ guaranteed high-tier reward at threshold

OPTIONALLY

ROBUX
→ purchase paid pull tokens / bundles
→ access SAME core reward pool
→ SAME visible pity system
→ faster collection

### Mandatory compliance behavior

If any random outcome is purchased directly or indirectly with Robux or currency purchasable with Robux:

- show all final outcomes or clearly navigable outcome categories;
- show actual numerical probabilities BEFORE purchase;
- probabilities must accurately represent the user's current state;
- displayed probabilities must total 100% subject only to transparent rounding;
- if pity changes odds, dynamically display the real updated odds;
- if a paid luck modifier changes odds, show the exact modified odds;
- integrate `PolicyService:GetPolicyInfoForPlayerAsync()`;
- if `ArePaidRandomItemsRestricted == true`, the paid random generator must not be available to that player.

For restricted players provide one or more compliant alternatives:
- free earnable random boxes;
- direct guaranteed purchases;
- non-random predetermined reward track;
- hide paid random purchases entirely.

### Recommended safety defaults

- cosmetic rewards first;
- no cash value;
- no redemption for real money;
- no player wagering;
- no stake-vs-player gambling;
- no resale market controlled by us;
- avoid paid-random item trading by default;
- no "you got nothing" result;
- duplicate protection or duplicate-to-currency conversion;
- pity counter visible to the player;
- exact price visible;
- avoid manipulative countdowns;
- no fake scarcity;
- no direct exhortation to children to buy;
- no wording such as "BUY NOW OR LOSE IT";
- use neutral wording like "View bundle", "Open shop", "See odds".

### Proposed rarity model

Common
Rare
Epic
Legendary
Mythic

Initial example only, not final economy:
- Mythic base probability: low but explicitly disclosed.
- Epic-or-better guarantee after N pulls.
- Mythic hard pity after M pulls.
- all free and paid eligible pulls advance the same pity unless legal review says otherwise;
- pity state persists;
- a Mythic drop resets only the Mythic pity;
- duplicate Mythic protection where practical.

Exact odds and thresholds must be modeled against economy data before launch.

## 3.4 Virtual currency transparency

Do not intentionally obscure the real purchase cost.

Where feasible:
- show Robux cost clearly near paid actions;
- avoid unnecessary layers of currency;
- do not force players to buy a currency pack materially larger than what a single desired item requires solely to strand value;
- explain what premium currency does;
- keep purchase confirmation flows clear.

## 3.5 Minors and commercial design

Assume many players may be minors.

Do not use:
- aggressive purchase pressure;
- shame;
- social humiliation tied to spending;
- misleading timers;
- fake low stock;
- fake discounts;
- "ask your parents to buy this";
- manipulative copy aimed specifically at children.

Design retention around fun, mastery, collection and social play, not psychological pressure.

---

# 4. BUSINESS / OWNERSHIP STRUCTURE

Recommended operating structure for a scalable studio:

1. A Czech limited-liability company (s.r.o.) or other professionally advised entity owns:
   - source code;
   - trademarks;
   - art;
   - contracts;
   - domains;
   - social accounts;
   - studio identity;
   - licensed IP rights.

2. A dedicated Roblox group/community owns production games and relevant Roblox assets.

3. Game ownership should be group-owned rather than scattered across personal developer accounts.

4. Use role-based access:
   - owner;
   - technical lead;
   - developer;
   - artist;
   - analytics;
   - monetization;
   - external contractor.

5. Minimum privileges only.

6. Require:
   - 2FA;
   - verified recovery methods;
   - password manager;
   - no shared credentials.

7. Maintain a written cap table / revenue-share agreement outside Roblox if multiple owners exist. Do not rely on Roblox group payout settings as the legal ownership agreement.

8. Use Git as the source-of-truth for code and documentation.

Before meaningful revenue, obtain Czech legal/accounting confirmation for:
- company structure;
- contractor agreements;
- VAT implications;
- DevEx accounting;
- U.S. withholding/treaty treatment;
- royalty classification;
- transfer pricing if multiple entities ever exist.

Important current issue:
Roblox has announced that from 2026-11-01 DevEx payments will be classified as royalties for U.S. tax purposes. International creators/entities must keep valid W-8 documentation in Roblox Creator Hub and may claim treaty relief if eligible. Treat this as a launch-accounting task, not an afterthought.

---

# 5. COMPETITIVE LANDSCAPE

We are not entering an empty market.

## 5.1 Gamefam

Model:
- large multi-game portfolio;
- branded Roblox/Fortnite activations;
- licensed franchises;
- professional live operations;
- brand distribution.

Strength:
distribution, licensing, operational scale.

Our distinction:
smaller, faster, original mechanic-fusion experimentation before heavy IP licensing.

## 5.2 Voldex

Model:
- acquire promising or already massive Roblox games;
- build dedicated operating teams;
- scale live service;
- monetize established communities;
- integrate brands.

Strength:
capital, acquisitions, audience scale.

Our distinction:
create and validate new concepts cheaply before acquisition-level capital is needed.

## 5.3 Twin Atlas

Model:
- original games;
- large live-operated portfolio;
- official events;
- branded and licensed experiences;
- durable internal production capability.

Strength:
craft, partnerships, established IP portfolio.

Our distinction:
AI-assisted rapid experimentation plus an explicit repeatable "mechanic fusion" thesis.

## 5.4 Splitting Point / Jandel ecosystem

Closest strategic comparison.

Model:
- rapid iteration;
- weekly live updates;
- partnership/acquisition behavior around promising games;
- ability to identify early traction and apply live-service operating skill.

Key lesson:
velocity matters, but velocity AFTER finding fun is especially powerful.

We should copy the operating lesson, not any game:
find promising signal → apply disciplined live-ops → scale hard.

## 5.5 Small elite teams

Games such as RIVALS and 99 Nights in the Forest demonstrate that relatively focused teams can compete with much larger studios if:
- hook is clear;
- execution is polished;
- social loop works;
- updates are frequent;
- thumbnails/title convert;
- retention is strong.

## 5.6 Strategic opening

There is no obvious major studio publicly positioned exactly as:

"CLEAN-ROOM MECHANIC FUSION + AI-NATIVE PROTOTYPING + SHORT-FORM CONTENT VALIDATION + REUSABLE ROBLOX ENGINE."

Treat that positioning as our wedge, not as permanent defensibility.

Long-term defensibility must become:
- successful original IP;
- recognizable art direction;
- community;
- proprietary internal tooling;
- reusable backend/game systems;
- data;
- creator relationships;
- live-ops capability;
- brand licensing relationships.

---

# 6. PRODUCT PORTFOLIO STRATEGY

DO NOT begin with one giant "all games inside one hub" experience.

Initially each major concept should be a separate Roblox game/experience because:
- each hook gets its own title and thumbnail;
- discovery metrics remain clean;
- weak prototypes do not poison the metrics of strong ones;
- each game can be killed or scaled independently;
- content positioning is simpler;
- monetization can fit the game;
- the player understands immediately what was clicked.

Create a studio-level launcher/hub only later if data proves it helps.

Reuse CODE, PIPELINES and PACKAGES across games, not necessarily the same public universe.

---

# 7. TECHNICAL STACK

Primary:
- Roblox Studio
- Luau
- official Roblox Studio MCP server
- Claude Code
- Claude Opus 5.5 for architecture, difficult engineering and autonomous multi-step work
- Git
- GitHub/private repository
- Roblox groups/communities
- Roblox Packages where appropriate
- Script Sync or Rojo where filesystem source-of-truth materially improves reliability

Claude should prefer the official Studio MCP first unless a concrete limitation justifies another tool.

Keep all production code in Git even when MCP is used to modify Studio.

---

# 8. REPOSITORY ARCHITECTURE

Suggested monorepo:

/fusion-factory
  /docs
    VISION.md
    PRODUCT_RULES.md
    TECH_ARCHITECTURE.md
    LIVEOPS.md
    ANALYTICS.md
    SECURITY.md

  /legal
    IP_RULES.md
    ASSET_PROVENANCE.md
    NAME_CLEARANCE.md
    THIRD_PARTY_LICENSES.md
    CONTRACTOR_HANDOFF_CHECKLIST.md

  /engine
    /shared
      Data
      Networking
      Analytics
      Economy
      Inventory
      Cosmetics
      Entitlements
      Purchases
      Loot
      Quests
      Progression
      Match
      Social
      AntiExploit
      FeatureFlags
      UI
      Audio
      Camera
      Input
      Localization
      Testing

  /games
    /prototype_001
      GAME.md
      DIFFERENTIATION.md
      REFERENCE_ABSTRACTION.md
      ECONOMY.md
      ART_DIRECTION.md
      ANALYTICS_PLAN.md
      /src
      /tests

    /prototype_002
    ...

  /tools
    lint
    validation
    asset-audit
    economy-sim
    migration
    telemetry

  CLAUDE.md
  README.md

---

# 9. CORE ENGINE REQUIREMENTS

Build a reusable internal engine, but do not over-engineer before the first playable game.

Required modules:

## 9.1 Data
- versioned player schema;
- safe migration;
- retry/backoff;
- session locking where appropriate;
- atomic critical updates;
- corruption fallback;
- test profile support.

## 9.2 Networking / security
Server authoritative for:
- currency;
- item grants;
- loot rolls;
- inventory;
- damage where feasible;
- progression;
- purchases;
- rewards.

Validate all RemoteEvent/RemoteFunction inputs.

Never trust:
- client price;
- client reward result;
- client damage;
- client currency;
- client ownership;
- client cooldown.

Rate-limit exploitable endpoints.

## 9.3 Purchases
- idempotent `ProcessReceipt`;
- transaction logging;
- safe retry behavior;
- never grant a developer product solely from client confirmation;
- test duplicate receipt handling.

## 9.4 Policy / compliance service

Create a wrapper:
`PolicyGateService`

It should cache and expose:
- paid-random eligibility;
- paid-item trading eligibility;
- commerce eligibility;
- subscription eligibility;
- ad eligibility;
- content sharing eligibility where needed.

All monetization UI must read from this service.

Compliance should be architecture, not a last-minute if-statement.

## 9.5 Loot service

Create:
`LootService`

Requirements:
- deterministic server-side RNG interface;
- cryptographically unnecessary but server-trusted randomness;
- tables stored in versioned config;
- exact odds calculation;
- pity counters;
- duplicate handling;
- reward audit log;
- simulation mode for millions of virtual pulls;
- UI-readable odds endpoint generated from the SAME source of truth used for rolls;
- regional restriction compatibility.

No odds may be hard-coded separately in UI.

## 9.6 Economy simulator

Before any paid random system goes live, run simulations:
- 100k;
- 1m;
- 10m pulls.

Measure:
- median pulls to each rarity;
- 90th/95th/99th percentile spend;
- duplicate rate;
- pity trigger frequency;
- crafting currency inflation;
- expected value;
- collection completion time for free vs paid players.

Generate a markdown report.

## 9.7 Analytics

Track:
- impression → play-through where available;
- first minute completion;
- 3-minute survival;
- tutorial completion;
- first core-loop completion;
- first death;
- first win;
- first social interaction;
- party/co-play;
- session length;
- return sessions;
- progression velocity;
- shop views;
- purchase funnels;
- lootbox views/pulls;
- earned vs purchased pulls;
- pity utilization;
- churn points.

No personally identifying external analytics unless separately approved and legally reviewed.

---

# 10. GAME CREATION PIPELINE

Every concept runs through the same gates.

## GATE A — CONCEPT

Create:
`GAME.md`

Maximum initial design:
- 1-sentence fantasy;
- 1 core mechanic fusion;
- 1 social hook;
- 1 progression loop;
- 1 monetization hypothesis;
- 1 art direction;
- 1 reason to return tomorrow.

If the concept needs a page to explain why it is fun, simplify it.

## GATE B — IP ABSTRACTION

Create:
`REFERENCE_ABSTRACTION.md`

For each inspiration record:
- what high-level mechanic/principle was observed;
- what elements are NOT being copied;
- how our implementation materially differs;
- our original terminology;
- our original art direction.

If differentiation cannot be described clearly, reject the concept.

## GATE C — GREYBOX

Build only the core toy.

No:
- battle pass;
- polished shop;
- 40 weapons;
- lore cinematics;
- giant map.

Question:
"Is this fun after 5 minutes with placeholder assets?"

If no:
iterate or kill.

## GATE D — VERTICAL SLICE

Build one polished session:
- onboarding;
- core loop;
- one reward;
- one progression beat;
- one social beat;
- mobile controls;
- PC controls;
- gamepad where appropriate.

## GATE E — CLOSED PLAYTEST

Collect:
- player recordings;
- first-session telemetry;
- qualitative feedback;
- bug list.

Prioritize behavior over opinions.

## GATE F — MONETIZATION TEST DESIGN

Only after core retention shows promise:
- cosmetics;
- permanent pass;
- subscription concept;
- paid/random layer if appropriate;
- bundle pricing;
- no paywall around basic fun.

## GATE G — PUBLIC LAUNCH

Prepare:
- original name cleared;
- thumbnail set;
- icon;
- description;
- maturity/compliance questionnaire;
- paid-random disclosure;
- PolicyService integration;
- asset provenance audit;
- performance check;
- exploit test;
- mobile test;
- purchase test;
- DataStore backup/migration plan.

Human approval required before public publish.

## GATE H — 7/28 DAY DECISION

Scale if:
- retention is improving;
- players complete core loop;
- meaningful replay exists;
- creator/social clips generate interest;
- discovery signals improve;
- monetization does not damage retention.

Kill or freeze if:
- the hook requires explanation;
- first-minute bounce remains high after onboarding fixes;
- session is shallow after repeated design attempts;
- acquisition cannot convert;
- monetization is the only thing holding engagement.

---

# 11. DISCOVERY-FIRST DESIGN

Roblox discovery values, among other signals:
- play-through rate;
- first-play bounce;
- play days per user;
- playtime per user;
- intentional co-play;
- qualified sessions;
- spend days;
- Robux spent.

Design accordingly, but do NOT optimize one metric at the expense of player trust.

Opening 60 seconds:
1. understand fantasy;
2. move immediately;
3. perform core mechanic;
4. receive satisfying feedback;
5. see next goal;
6. ideally encounter another player.

No 5-minute exposition.

---

# 12. INITIAL INTERNAL METRIC HYPOTHESES

These are INTERNAL STARTING TARGETS, not claims about platform-wide benchmarks.

Recalibrate using real Creator Analytics and genre comparisons.

Track:
- first-play bounce;
- median session length;
- D1;
- D7;
- co-play rate;
- shop view rate;
- payer conversion;
- payer retention;
- free-pull engagement;
- paid-pull conversion;
- refund/support issues.

Initial test goals can be set per genre, but Claude must not optimize by manipulating users.

Use experiments to answer design questions, not merely increase spending.

---

# 13. MONETIZATION STACK

Order of priority:

## Layer 1 — Cosmetics
- character skins;
- weapon skins;
- boards/vehicles;
- trails;
- emotes;
- kill/goal effects;
- UI themes where appropriate.

## Layer 2 — Passes
- permanent cosmetic/quality-of-life packages;
- avoid overpowering permanent combat advantages.

## Layer 3 — Subscription
Potential:
- monthly cosmetic drop;
- extra non-exclusive earned rewards;
- seasonal convenience;
- identity/status cosmetics.

Never make unsubscribed gameplay intentionally miserable.

## Layer 4 — Battle / season pass
- free track;
- premium track;
- meaningful free progression;
- no fake timers.

## Layer 5 — Collection / capsule system
- free earnable pulls;
- paid acceleration;
- transparent odds;
- pity;
- duplicate protection/crafting conversion;
- policy-gated by player eligibility.

## Layer 6 — Private servers / social products
Where genre fit exists.

## Layer 7 — Brand/IP integrations
Only with explicit licenses.

Long-term:
successful original games become licensable IP themselves.

---

# 14. FIRST PROTOTYPE

CODENAME: PROJECT FLOW

Do not use third-party franchise names publicly.

## One-sentence hook

A fast arena shooter where skateboard-style movement and tricks directly power combat.

## Core fantasy

Movement is not transportation.
Movement is ammunition.

## Core loop

SPAWN
→ skate
→ build FLOW through tricks, rails and risky movement
→ engage enemy
→ spend FLOW on combat advantages
→ score/eliminate
→ earn progression/cosmetics
→ repeat

## Mechanical differentiators

- rail grinding;
- manuals;
- jumps;
- wall rides where readable;
- trick chain;
- FLOW meter;
- shooting while moving;
- movement affects reload/handling/ability charge;
- weapon balance built around mobility;
- arena geometry designed for routes, not corridors.

Example:
- basic movement = no bonus;
- 3-action chain = handling bonus;
- rail chain = instant partial reload;
- high FLOW = ability charge;
- getting hit may break FLOW;
- camping produces no FLOW.

This naturally anti-incentivizes static play without simply punishing the player.

## MVP

1 arena.
1 movement controller.
3 weapons:
- automatic;
- shotgun;
- precision weapon.

1 combat ability.
1 FLOW meter.
1 trick scoring system.
1 match mode.
8–12 player target for first test, adjustable.
basic respawn.
minimal progression.
one cosmetic reward.

NO loot boxes in the first greybox.
NO battle pass.
NO elaborate lobby.
NO giant shop.

Prove the toy first.

---

# 15. ART DIRECTION FOR PROJECT FLOW

Do NOT visually imitate Call of Duty, Skate, Tony Hawk, Valorant, Fortnite or another identifiable franchise.

Create an original visual identity.

Direction:
- kinetic near-future urban sports;
- strong silhouette readability;
- modular concrete/metal arenas;
- rails integrated as tactical routes;
- bright traversal markings for readability;
- distinctive fictional brands;
- non-military player silhouettes;
- stylized weapons;
- sport/performance language instead of military simulation language.

Original terminology:
- FLOW
- CHAIN
- BREAK
- LINE
- OVERDRIVE

Names are provisional and require clearance.

---

# 16. CONTENT / MARKETING LOOP

Short-form content is part of product testing.

Do not rely on third-party logos to communicate the hook.

Video framing:
BAD:
"WE MADE COD X SKATE"

BETTER:
"What if your skateboard combo powered your gun?"

"What if camping made you weaker?"

"The longer this rail grind lasts, the stronger the next fight gets."

"Can a shooter work if tricks are the reload mechanic?"

Content loop:
hook video
→ comments/CTR
→ playtest
→ gameplay clips
→ public release
→ update videos
→ creator seeding
→ player-created clips

Use social response as one signal, not proof of retention.

---

# 17. 90-DAY EXECUTION PLAN

## Days 1–7 — Foundation

Claude:
- initialize repository;
- create docs;
- create Studio project;
- connect official Studio MCP;
- configure Git;
- build minimal shared architecture;
- implement networking conventions;
- implement data schema foundation;
- implement analytics wrapper;
- implement PolicyGateService skeleton;
- create automated smoke-test checklist;
- create legal provenance templates.

Do not overbuild.

## Days 8–21 — Project Flow Greybox

Build:
- movement;
- rail detection;
- tricks;
- FLOW;
- three guns;
- server validation;
- arena greybox;
- match loop.

Playtest until movement + combat interaction is fun.

## Days 22–30 — Vertical Slice

Add:
- polished HUD;
- hit feedback;
- sound;
- better map art;
- onboarding;
- mobile controls;
- basic progression;
- analytics.

Run closed test.

Decision:
KILL / ITERATE / SCALE.

## Month 2 — Launch Candidate + Prototype 2

If Project Flow wins:
- optimize;
- create original branding;
- security audit;
- compliance review;
- public launch prep;
- live-ops roadmap.

Simultaneously build prototype 2 using shared engine.

If Project Flow fails:
- archive learnings;
- reuse systems;
- move immediately to prototype 2.

## Month 3 — Portfolio Validation

Target:
- 2–4 serious concepts tested;
- at least one public candidate;
- shared engine becoming materially faster;
- documented concept selection process;
- analytics pipeline;
- monetization/compliance layer ready;
- reliable Studio MCP agent workflow.

Do not flood Roblox with low-quality launches.

Quality-adjusted iteration beats raw upload volume.

---

# 18. CLAUDE AUTONOMY LOOP

For every task:

1. inspect current state;
2. read relevant docs;
3. create a plan internally;
4. implement the smallest coherent change;
5. run static checks;
6. playtest;
7. inspect logs;
8. fix errors;
9. repeat until passing;
10. commit with clear message;
11. update documentation;
12. continue to next dependency.

Do not stop merely because code compiled.

Definition of DONE:
- feature works in playtest;
- no new errors;
- server/client authority is correct;
- mobile implications considered;
- exploit surface reviewed;
- edge cases handled;
- docs updated.

---

# 19. TESTING REQUIREMENTS

For every critical system, test:
- normal flow;
- disconnect/reconnect;
- duplicate events;
- lag;
- malformed remote payload;
- exploit attempt;
- missing data;
- DataStore failure;
- purchase retry;
- repeated receipt;
- two simultaneous rewards;
- inventory full edge case if relevant;
- policy restriction;
- mobile input;
- controller input where supported.

For loot:
- millions of simulated rolls;
- pity boundary;
- duplicate protection;
- exact odds display;
- restricted-user branch;
- free vs paid token behavior;
- configuration version migration.

---

# 20. PERFORMANCE RULES

Target mobile first even when PC is the creative reference.

Monitor:
- instance counts;
- physics cost;
- network ownership;
- streaming;
- memory;
- particle counts;
- draw calls where relevant;
- server frame time;
- remote traffic.

Avoid giant monolithic scripts.

Use clean modules and typed Luau where it improves reliability.

---

# 21. SECURITY RULES

Production economy is server authority.

Never expose:
- private API keys;
- secrets in ReplicatedStorage;
- admin remotes without server authorization;
- unrestricted debug commands;
- production write tools to ordinary clients.

All admin/dev tools:
- role-gated;
- server validated;
- disabled or restricted in production;
- logged.

No third-party plugin is trusted automatically.

Inspect any plugin/tool before granting meaningful access.

---

# 22. LIVE OPS FOR A WINNER

Once a game demonstrates genuine retention:

Weekly cadence can include:
- one meaningful gameplay addition;
- one cosmetic/content drop;
- balance changes;
- bug fixes;
- one social/community beat.

Monthly:
- larger feature;
- season/event;
- new map/biome/mode;
- creator collaboration if appropriate.

Avoid update inflation.
Every update needs a reason for a player to return.

---

# 23. IP LICENSING STRATEGY

Phase 1:
original mechanic fusions only.

Phase 2:
once we have audience and operational proof:
- review Roblox License Catalog;
- consider time-limited licensed events;
- use official license terms;
- integrate IP into an already successful original game where strategically stronger than building a standalone licensed title.

Phase 3:
protect our successful original IP:
- trademark clearance/registration;
- documented human authorship;
- asset provenance;
- rights assignments;
- formal brand bible;
- eventually Roblox Rights Manager / licensing tooling if eligible.

---

# 24. SOURCE / POLICY FACTS THAT CLAUDE SHOULD RE-CHECK BEFORE LAUNCH

Policies change.

Before every public launch, re-check current official Roblox documentation for:
- Intellectual Property Guidelines;
- Community Standards;
- publishing requirements;
- content maturity;
- Paid Random Items Policy;
- PolicyService;
- monetization;
- Developer Products;
- subscriptions;
- Creator Rewards;
- DevEx;
- tax information;
- Studio MCP;
- group ownership and revenue;
- game ownership transfer;
- advertising standards;
- License Manager / IP licensing.

For EU commercial design, re-check:
- European Commission CPC positions on in-game virtual currencies;
- consumer-rights requirements;
- rules affecting minors;
- current loot-box enforcement developments.

Do not assume an old implementation remains compliant forever.

---

# 25. NON-NEGOTIABLE PRODUCT PRINCIPLES

1. FUN BEFORE MONETIZATION.
2. ORIGINAL EXPRESSION, NOT CLONING.
3. SPEED WITHOUT SPAM.
4. SERVER AUTHORITY.
5. COMPLIANCE BY ARCHITECTURE.
6. MOBILE MATTERS.
7. EACH PROTOTYPE ANSWERS ONE QUESTION.
8. KILL WEAK CONCEPTS EARLY.
9. SCALE WINNERS AGGRESSIVELY.
10. TURN WINNERS INTO IP.
11. KEEP PLAYER TRUST.
12. DATA INFORMS TASTE; DATA DOES NOT REPLACE TASTE.

---

# 26. FIRST ACTIONS FOR CLAUDE

Begin now.

Do not ask broad planning questions unless a missing decision truly blocks implementation.

Perform these actions:

1. Audit local environment.
2. Confirm Roblox Studio and the official MCP server can connect.
3. Initialize repository structure.
4. Create `CLAUDE.md` summarizing operating constraints.
5. Create legal/provenance templates.
6. Create `games/project_flow/GAME.md`.
7. Build the minimum Roblox project skeleton.
8. Implement the shared networking pattern.
9. Implement the minimum analytics event wrapper.
10. Implement `PolicyGateService` skeleton.
11. Create the first Project Flow greybox arena.
12. Build a basic skateboard-like movement controller using wholly original code and parameters.
13. Build FLOW meter.
14. Add one rail-grind route.
15. Add one test weapon.
16. Connect movement actions to FLOW.
17. Run playtest.
18. Fix all errors.
19. Iterate until the first 5-minute loop is playable.
20. Commit.

At the end of each meaningful milestone, produce:

STATUS.md

with:
- completed;
- tested;
- known issues;
- next milestone;
- legal/compliance notes;
- performance notes;
- analytics added;
- decisions requiring human approval.

Continue autonomously within the permitted boundaries.
