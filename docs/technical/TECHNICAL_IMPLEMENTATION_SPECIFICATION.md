# Technical Implementation Specification (TIS) - Beneath Five Moons / Lumina Darkness

- **Document Type:** Technical Implementation Specification
- **Version:** 0.1.0-TIS.1
- **Status:** Pre-production / Implementation Specification
- **Engine:** Godot 4.7.1
- **Language:** GDScript 2.0
- **Initial Platform:** PC
- **Perspective:** Third Person
- **Primary Mode:** PvE / Single Player
- **Future Mode:** Cooperative Multiplayer
- **PvP:** Deferred / Design Pending

---

## 1. System Overview and Architecture

### 1.1 Architectural Pattern

The implementation shall use a Modular, Data-Driven, Event-Driven, Component-Based architecture, with a layered application/domain model.

The architecture is intentionally not a pure ECS implementation. Godot Nodes remain responsible for scene composition, presentation, physical presence, animation, collision, and engine integration, while gameplay state and rules are isolated into components, services, domain systems, commands, events, and data Resources.

The primary architectural principles are:

- **Composition > Deep Inheritance**
- **Data > Hardcoded Rules**
- **Systems > Direct Cross-System Dependencies**
- **Events > Tight Coupling**
- **Contracts > Internal Knowledge**
- **Stable IDs > NodePaths**
- **Persistent State > Derived State**
- **Deterministic Simulation > Uncontrolled Randomness**
- **Testability > Local Convenience**

These principles are explicitly established by the TDD.

The implementation model is:

```text
                         ┌──────────────────────┐
                         │      Presentation    │
                         │ UI / HUD / Camera    │
                         └──────────┬───────────┘
                                    │
                                    ▼
                         ┌──────────────────────┐
                         │ Application Layer    │
                         │ Commands / Workflows │
                         └──────────┬───────────┘
                                    │
                ┌───────────────────┼───────────────────┐
                ▼                   ▼                   ▼
        ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
        │   Gameplay   │    │ Progression  │    │    Social    │
        │   Systems    │    │   Systems    │    │   Systems    │
        └──────────────┘    └──────────────┘    └──────────────┘
                │                   │                   │
                └───────────────────┼───────────────────┘
                                    ▼
                         ┌──────────────────────┐
                         │    Domain State      │
                         │ Player / World / NPC │
                         └──────────┬───────────┘
                                    │
             ┌──────────────────────┼─────────────────────┐
             ▼                      ▼                     ▼
      ┌─────────────┐       ┌─────────────┐       ┌─────────────┐
      │    World    │       │   Economy   │       │ Persistence │
      └─────────────┘       └─────────────┘       └─────────────┘
             │                      │                     │
             └──────────────────────┼─────────────────────┘
                                    ▼
                         ┌──────────────────────┐
                         │      Event Bus       │
                         └──────────────────────┘
```

This follows the system topology defined in the TDD.

### 1.2 Architectural Layers

| Layer                | Responsibility                                        | Must Not Contain         |
| :------------------- | :---------------------------------------------------- | :----------------------- |
| **Presentation**     | UI, HUD, menus, visual feedback                       | Core gameplay rules      |
| **Application**      | Commands, workflows, orchestration                    | Rendering-specific logic |
| **Domain**           | Gameplay rules and state transitions                  | Godot UI dependencies    |
| **World Simulation** | Time, climate, resources, NPC simulation, territories | UI logic                 |
| **Persistence**      | Serialization, save/load, migrations                  | Presentation state       |
| **Infrastructure**   | Event Bus, logging, RNG, configuration, services      | Game-specific UI         |

The TDD explicitly defines this separation of Presentation, Gameplay/Application, Domain, World/Simulation, Persistence, Infrastructure, and Godot/Platform layers.

### 1.3 Godot Implementation Model

Godot Node objects shall represent runtime composition and physical presence.
Godot Resource objects shall represent definitions and static configuration.
Runtime state shall be stored in dedicated state objects/components.

```text
Resource
    ↓
Definition / Configuration
    ↓
Runtime State
    ↓
Node / Component
    ↓
Presentation
```

**Examples:**

| Definition / Configuration (Resource) | Runtime State       |
| :------------------------------------ | :------------------ |
| `ItemDefinition`                      | `InventoryState`    |
| `RecipeDefinition`                    | `EquipmentInstance` |
| `EnemyDefinition`                     | `ProfessionState`   |
| `ProfessionDefinition`                | `RelationshipState` |
| `QuestDefinition`                     | `ResourceNodeState` |
| `FactionDefinition`                   | `TerritoryState`    |
| `RegionDefinition`                    |                     |

This separation is required by the TDD's Resource/Node/runtime-state model.

### 1.4 Project Directory Structure

The implementation should follow this structure:

```text
res://
│   ├── resources/
│   ├── climate/
│   ├── lighting/
│   ├── navigation/
│   ├── settlements/
│   └── world_events/
│
├── economy/
│   ├── market/
│   ├── pricing/
│   ├── currency/
│   ├── auctions/
│   └── black_market/
│
├── social/
│   ├── npc/
│   ├── relationships/
│   ├── factions/
│   ├── religions/
│   └── dialogue/
│
├── quests/
│   ├── definitions/
│   ├── runtime/
│   ├── objectives/
│   └── events/
│
├── inventory/
│   ├── items/
│   ├── containers/
│   ├── equipment/
│   └── durability/
│
├── crafting/
│   ├── recipes/
│   ├── stations/
│   └── production/
│
├── entities/
│   ├── player/
│   ├── npc/
│   ├── enemies/
│   └── interactables/
│
├── ui/
│   ├── hud/
│   ├── inventory/
│   ├── character/
│   ├── dialogue/
│   ├── crafting/
│   └── menus/
│
├── data/
│   ├── items/
│   ├── enemies/
│   ├── professions/
│   ├── recipes/
│   ├── factions/
│   ├── religions/
│   ├── npcs/
│   ├── quests/
│   ├── regions/
│   └── world/
│
├── scenes/
│   ├── player/
│   ├── npc/
│   ├── enemies/
│   ├── world/
│   └── ui/
│
└── tests/
    ├── unit/
    ├── integration/
    ├── simulation/
    └── save_load/
```

This directory topology is derived directly from the TDD.

### 1.5 Global Services and Autoloads

Only genuinely global services shall be implemented as Autoloads.

**Initial Autoload set:**

- `EventBus`
- `TimeService`
- `GameState`
- `SaveService`
- `SceneManager`
- `ServiceRegistry`

Systems such as Combat, Inventory, Player, NPC and Quest shall not automatically become global singletons.
The TDD explicitly requires avoiding excessive singleton usage and recommends `ServiceRegistry` for dependency access.

### 1.6 Initialization Flow

The startup sequence shall be:

```text
Application Start
       ↓
Godot Engine Initialization
       ↓
Bootstrap / Boot Scene
       ↓
Configuration Load
       ↓
Core Services Registration
       ↓
GameState Initialization
       ↓
EventBus Initialization
       ↓
TimeService Initialization
       ↓
SaveService Initialization
       ↓
Content Registry Initialization
       ↓
Splash Screen
       ↓
Main Menu
       ↓
New Game / Load Game
       ↓
World Initialization
       ↓
Player Initialization
       ↓
Simulation Start
       ↓
Game Loop
```

#### 1.6.1 Boot Responsibilities

The Boot layer shall:

- Initialize required global services.
- Validate configuration.
- Initialize content registries.
- Initialize deterministic/random services.
- Prepare localization.
- Initialize logging.
- Transition to Splash/Main Menu.

_The Boot layer must not instantiate the entire game world._

#### 1.6.2 New Game Flow

```text
New Game
   ↓
Create GameState
   ↓
Select Origin
   ↓
Apply OriginDefinition
   ↓
Create CharacterState
   ↓
Initialize Starting Inventory
   ↓
Initialize Reputation
   ↓
Initialize Relationships
   ↓
Initialize WorldState
   ↓
Initialize Time
   ↓
Spawn Initial Region
   ↓
Spawn Player
   ↓
Start Simulation
```

Origins are configuration data and must modify initial state rather than player code.

#### 1.6.3 Load Game Flow

```text
Load Save
   ↓
Validate Save Header
   ↓
Read Save Version
   ↓
Run Migrations
   ↓
Deserialize GameState
   ↓
Validate State Integrity
   ↓
Register Entities
   ↓
Load Required Region
   ↓
Spawn Runtime Nodes
   ↓
Apply Persistent State
   ↓
Rebuild Derived State
   ↓
Start Simulation
```

---

## 2. Data Structures and State Modeling

### 2.1 Global Game State

`GameState` shall be a composition of domain states rather than a monolithic object.

```text
GameState
├── WorldState
├── PlayerState
├── QuestState
├── EconomyState
├── SocialState
└── SessionState
```

This separation is explicitly required by the TDD.

**Conceptual implementation:**

```gdscript
class_name GameStateData
extends RefCounted

var world: WorldStateData
var player: PlayerStateData
var quests: QuestStateData
var economy: EconomyStateData
var social: SocialStateData
var session: SessionStateData
```

### 2.2 Entity Identity

Every persistent entity shall have a stable `EntityId`.

```gdscript
class_name EntityId
extends RefCounted

var value: StringName
```

**Examples:**

- `player.001`
- `npc.blacksmith.port_astraea.001`
- `resource.iron_mine.001`
- `territory.port_astraea`
- `item.weapon.iron_sword`
- `quest.origin.orphan`

`NodePath` shall never be used as persistent identity.
This is a core multiplayer-readiness requirement.

### 2.3 Character State

The player shall use composition rather than a rigid class hierarchy.

```text
CharacterState
├── identity
├── origin
├── attributes
├── skills
├── professions
├── weapon_proficiencies
├── inventory
├── equipment
├── survival
├── reputation
├── relationships
├── properties
├── achievements
└── world_flags
```

Character identity is therefore:
$$ ext{Character Identity} = ext{Origin} + ext{Skills} + ext{Professions} + ext{Equipment} + ext{Reputation} + ext{Relationships} + ext{Choices} + ext{World State}$$

This directly preserves the central GDD design principle of emergent character identity.

### 2.4 Inventory State

```text
InventoryState
├── slots
├── capacity
├── weight
└── filters
```

Each slot contains an `ItemStack`.

```text
ItemStack
├── item_definition_id
├── quantity
└── instance_data
```

Individual durability belongs to `instance_data`, while stackable items should avoid unnecessary individual instances.

### 2.5 Equipment State

```text
EquipmentInstance
├── instance_id
├── definition_id
├── durability
├── quality
├── modifiers
└── metadata
```

**Static definition:**

```text
EquipmentDefinition
├── id
├── slot
├── category
├── requirements
├── base_stats
├── durability
└── tags
```

This allows `Iron Sword` to remain immutable content data while `Iron Sword #839102` ($ ext{Durability} = 37$, $	ext{Quality} = 	ext{Fine}$, $ ext{Strength} = +2$) remains mutable runtime state.

### 2.6 World State

```text
WorldState
├── calendar
├── climate
├── territories
├── resources
├── settlements
├── factions
├── economy
├── world_events
├── celestial_state
└── simulation_flags
```

Only authoritative mutable state shall be persisted. Derived values shall be recalculated.

**Example:**

- **Persist:** `resource.current_quantity`
- **Derive:** `resource.availability_percentage`

This distinction is explicitly defined in the TDD.

### 2.7 Resource Node State

```text
ResourceNodeState
├── resource_id
├── current_quantity
├── max_quantity
├── regeneration_rate
├── depletion_rate
├── last_interaction_time
└── state
```

**States:** `ABUNDANT`, `HEALTHY`, `DEPLETING`, `SCARCE`, `DEPLETED`, `RECOVERING`.

The state transition is:

```text
Collect
  ↓
Decrease Quantity
  ↓
Recalculate State
  ↓
Emit ResourceAvailabilityChanged
  ↓
Secondary Systems React
```

### 2.8 Save Model

Save files shall be versioned.

```json
{
  "save_version": 1,
  "world": {},
  "player": {},
  "quests": {},
  "economy": {},
  "social": {}
}
```

**Migration:**

```text
Save Version 1
      ↓
Migration 1 → 2
      ↓
Save Version 2
```

Old saves must never be assumed to contain current fields.

---

## 3. Core Mechanics Technical Implementation

### 3.1 Time and World Simulation

#### Purpose

Provide a logical game clock independent of rendering and frame rate.

#### Classes

`TimeService`, `SimulationClock`, `CalendarState`, `SeasonService`, `WorldSimulationService`.

#### Suggested API

```gdscript
func get_game_time() -> GameTime
func advance(minutes: int) -> void
func pause() -> void
func resume() -> void
func sleep(hours: float) -> void
func register_schedule(schedule: ScheduleEntry) -> void
```

#### Time Model

```text
Real Time
   ↓
Simulation Clock
   ↓
Game Time
   ↓
Scheduled Events
```

**Supported units:** Tick, Second, Minute, Hour, Day, Week, Season, Year.

The logical clock must support acceleration, pause, sleep, automated testing and future multiplayer authority.

#### World Tick

A world-minute tick shall execute:

```text
Time Tick
   ↓
Survival Update
   ↓
NPC Schedule Update
   ↓
Resource Simulation
   ↓
Economy Update
   ↓
World Event Evaluation
```

Not every system shall execute every frame.

### 3.2 Player Movement

#### Components

`CharacterBody3D`, `CharacterController`, `MovementComponent`, `CameraController`.

#### Responsibilities

`MovementComponent`:

- consume movement intent;
- calculate desired velocity;
- apply acceleration/deceleration;
- handle movement modes;
- communicate with navigation when required;
- emit movement-related events.

#### API

```gdscript
func set_move_input(input: Vector2) -> void
func set_sprint_enabled(enabled: bool) -> void
func get_velocity() -> Vector3
func is_moving() -> bool
```

_Movement must not read keyboard keys directly._

### 3.3 Input System

Input shall use Godot's Input Map.
Gameplay consumes semantic actions:
`move_forward`, `move_backward`, `move_left`, `move_right`, `attack`, `block`, `parry`, `dodge`, `interact`, `inventory`, `character`, `map`, `sprint`, `crouch`, `use_light`.

Never use `Input.is_key_pressed(KEY_W)` inside gameplay systems. The TDD explicitly requires gameplay to consume actions rather than physical keys.

#### Input Flow

```text
Physical Input
      ↓
Godot Input Map
      ↓
Input Action
      ↓
Input Controller
      ↓
Command
      ↓
Command Processor
      ↓
Domain System
```

This also enables future remapping and accessibility support.

### 3.4 Interaction System

#### Interfaces

`IInteractable`, `IUsable`, `ICollectable`, `IContainer`.

#### Interaction Flow

```text
Player
  ↓
InteractionDetector
  ↓
IInteractable
  ↓
InteractionContext
  ↓
InteractionService
  ↓
Result
```

**Possible interactions:** Talk, Gather, Open, Loot, Craft, Sleep, Trade, Travel, Use.

#### API

```gdscript
func can_interact(context: InteractionContext) -> bool
func execute_interaction(context: InteractionContext) -> InteractionResult
```

The interactable object must not directly modify unrelated systems.

### 3.5 Survival System

#### Components

`SurvivalComponent`, `HungerSystem`, `FatigueSystem`, `TemperatureSystem`, `EnergySystem`, `HealthComponent`, `StatusEffectSystem`.

#### State

```text
SurvivalState
├── health
├── hunger
├── fatigue
├── energy
├── temperature
└── comfort
```

Each value contains: `current`, `minimum`, `maximum`, `rate`, `modifiers`.

#### Hunger

- **Inputs:** Time, Activity, Climate, Temperature, Buffs.
- **Outputs:** `HungerChanged`, `StarvationStateChanged`, `SurvivalModifierChanged`.

**Proposed state thresholds:**

- `70–100`: NORMAL
- `40–70`: MINOR_PENALTY
- `10–40`: MAJOR_PENALTY
- `0–10`: STARVATION
- `0`: CRITICAL

_Exact values remain balance data._

#### Fatigue

$$ ext{FatigueGain} = ext{BaseActionCost} imes ext{ActivityIntensity} imes ext{ClimateModifier} imes ext{HungerModifier}$$

**Implementation:**

```gdscript
func apply_activity_cost(profile: ActivityCostDefinition) -> void
```

Individual gameplay systems must not duplicate fatigue calculations.

#### Temperature

$$ ext{TemperatureExposure} = ext{AmbientTemperature} + ext{WeatherModifier} + ext{SeasonModifier} + ext{RegionModifier} + ext{EquipmentInsulation} + ext{ShelterModifier} + ext{ConsumableModifier}$$

**States:** `EXTREME_COLD`, `COLD`, `COMFORTABLE`, `HOT`, `EXTREME_HEAT`.

### 3.6 Lighting System

Lighting is a core gameplay system rather than merely a rendering system.

#### Architecture

```text
LightingSystem
├── WorldLightProvider
├── LocalLightProvider
├── PlayerLightProvider
├── LightExposureCalculator
└── LightingStateService
```

#### Illumination Model

```gdscript
var illumination_value: float
```

**Thresholds:**

- `0.00–0.15` $
ightarrow$ ABSOLUTE_DARKNESS
- `0.15–0.35` $
ightarrow$ PENUMBRA
- `0.35–0.70` $
ightarrow$ MODERATE
- `0.70–1.00` $
ightarrow$ FULL

_Thresholds must be configurable._

#### Light Source Definition

```text
LightSourceDefinition
├── radius
├── intensity
├── duration
├── fuel_type
├── fuel_consumption
├── stealth_modifier
├── creature_modifier
└── temperature_modifier
```

#### Lighting Context

```text
LightingContext
├── level
├── intensity
├── source_type
├── visibility_modifier
├── stealth_modifier
└── creature_modifier
```

Combat, stealth and survival consume the context rather than querying the lighting implementation directly.

### 3.7 Exploration and Travel

#### Region Definition

```text
RegionDefinition
├── climate_profile
├── light_profile
├── danger_level
├── resource_table
├── enemy_table
├── faction_presence
├── economy_profile
└── travel_profile
```

#### Danger Profile

```text
DangerProfile
├── danger_level
├── enemy_density
├── resource_value
├── environmental_risk
├── visibility
└── reward_multiplier
```

Region accessibility must not be inherently tied to player level.

#### Travel

`TravelSystem`

**Methods:** `ON_FOOT`, `CARAVAN`, `FAST_TRAVEL`, `ALIGNMENT_BEACON`.

Each method uses:

```text
TravelMethodDefinition
├── cost
├── duration
├── requirements
├── risks
└── availability
```

**Fast travel:**
$$ ext{DestinationUnlocked} ext{ AND } ext{TravelPointActivated} ext{ AND } ext{NoBlockingWorldCondition}$$

### 3.8 Resource Gathering

#### Classes

`GatheringSystem`, `ResourceNode`, `ResourceNodeState`, `GatherCommand`, `LootService`, `InventoryService`.

#### Flow

```text
GatherCommand
      ↓
Validate Actor
      ↓
Validate Tool
      ↓
Validate Resource Node
      ↓
Validate Energy
      ↓
Calculate Yield
      ↓
Consume Energy
      ↓
Modify ResourceNodeState
      ↓
Add Items
      ↓
Grant Profession/Skill Progress
      ↓
Emit Events
```

#### Events

`ResourceGathered`, `ResourceAvailabilityChanged`, `ResourceDepleted`, `ItemAdded`, `ProfessionXPChanged`.

The resource system must not directly call Economy, Quest, or NPC systems.

### 3.9 Inventory System

#### Core Service

```gdscript
class_name InventoryService
extends RefCounted
```

#### Suggested API

```gdscript
func add_item(item_definition_id: StringName, quantity: int) -> bool
func remove_item(item_definition_id: StringName, quantity: int) -> bool
func has_item(item_definition_id: StringName, quantity: int) -> bool
func get_quantity(item_definition_id: StringName) -> int
func add_instance(instance: EquipmentInstance) -> bool
func remove_instance(instance_id: StringName) -> bool
func consume_item_durability(instance_id: StringName, amount: float) -> bool
```

Inventory operations must be transactional where multiple state domains are affected.

### 3.10 Equipment and Durability

Durability belongs to `EquipmentInstance`.

```gdscript
func reduce_durability(instance_id: StringName, amount: float) -> Result
```

When durability reaches zero:

```text
Durability <= 0
       ↓
ItemBroken
       ↓
Remove Instance
       ↓
Emit ItemRemoved
```

**Exceptions:** Magic Items, Artifacts.

The GDD specifies that common equipment is discarded at zero durability while magical items/artifacts are exceptions.

### 3.11 Crafting System

#### Data

```text
RecipeDefinition
├── inputs
├── outputs
├── profession_requirement
├── station_requirement
└── activity_cost
```

#### Execution

```text
CraftCommand
    ↓
Recipe Lookup
    ↓
Validate Profession
    ↓
Validate Station
    ↓
Validate Materials
    ↓
Validate Energy
    ↓
Begin Transaction
    ↓
Consume Materials
    ↓
Produce Output
    ↓
Grant Profession XP
    ↓
Commit
    ↓
Emit CraftCompleted
```

Crafting must be atomic. Partial resource consumption is prohibited.

### 3.12 Profession System

#### Data Model

```text
ProfessionDefinition
├── id
├── display_name
├── max_mastery
├── allowed_actions
├── recipes
└── progression_rules
```

**Runtime:**

```text
ProfessionState
├── profession_id
├── mastery_level
├── experience
├── rank
└── unlocked_features
```

#### Progression

$$ ext{mastery_level} = 1..5, \quad ext{experience} = 0..100$$

```text
XP >= 100
   ↓
experience -= 100
   ↓
mastery_level += 1
```

Exact overflow and balance behavior shall remain data-driven.

#### Profession Expansion Rule

Adding a profession should primarily require:
$$ ext{ProfessionDefinition} + ext{Recipes} + ext{Stations} + ext{Progression Data} + ext{Localization}$$
and should not require modifying numerous core systems.

### 3.13 Character Progression

#### Component

```text
CharacterProgressionComponent
├── level
├── experience
├── attributes
├── skills
├── professions
├── weapon_proficiencies
└── achievements
```

Reputation remains independent because it is a social-domain system.

#### XP

The final XP design is intentionally open: `IExperienceProvider`.

**Potential sources:** COMBAT, EXPLORATION, PROFESSION, QUEST, SOCIAL, DISCOVERY.

The implementation shall therefore not hardcode one XP source model.

#### Usage-Based Progression

Actions emit:

```text
SkillUsageEvent
├── actor_id
├── skill_id
├── action_id
├── intensity
└── context
```

`SkillProgressionSystem` consumes these events.

### 3.14 Weapon Proficiency

```text
WeaponProficiencyState
├── weapon_type_id
├── level
├── experience
└── decay
```

**Decay is a strategy:**

```text
ProficiencyDecayPolicy
├── NONE
├── SLOW_DECAY
├── RELATIVE_DECAY
└── SOFT_DECAY
```

The policy remains configurable because the GDD explicitly identifies this mechanic as requiring careful prototyping.

### 3.15 Combat System

#### Architecture

```text
CombatSystem
├── CombatantComponent
├── HealthComponent
├── StaminaComponent
├── AttackSystem
├── DefenseSystem
├── DamageSystem
├── HitDetection
├── StatusEffectSystem
└── CombatStateMachine
```

#### Combat State Machine

```text
IDLE
 ├── ATTACKING
 ├── BLOCKING
 ├── PARRYING
 └── DODGING

ATTACKING
 ├── IDLE
 ├── HIT
 └── STAGGERED

BLOCKING
 ├── IDLE
 └── STAGGERED

PARRYING
 ├── IDLE
 └── ATTACKING

DODGING
 └── IDLE

STAGGERED
 ├── IDLE
 └── DEAD

HIT
 ├── IDLE
 └── DEAD

DEAD
 └── TERMINAL
```

Required states are defined by the TDD.

#### Action Definition

```text
ActionDefinition
├── stamina_cost
├── startup
├── active_window
├── recovery
├── invulnerability
└── interrupt_rules
```

This allows combat balancing to remain data-driven.

### 3.16 Damage System

Combat must operate against `IDamageable` rather than an enemy-specific interface.

**Potential targets:** Enemy, NPC, Player, Structure, TerritoryEntity.

This is required for future PvP and broader combat interactions without rewriting the damage system.

**Suggested contract:**

```gdscript
func can_receive_damage(context: DamageContext) -> bool
func receive_damage(context: DamageContext) -> DamageResult
```

### 3.17 Stealth System

#### Formula

$$ ext{DetectionScore} = ext{Visibility} imes ext{LightModifier} imes ext{DistanceModifier} imes ext{NoiseModifier} imes ext{EquipmentModifier} imes ext{MovementModifier}$$

**NPC perception:**

```text
PerceptionProfile
├── vision
├── hearing
├── awareness
├── detection_speed
└── memory_duration
```

Lighting must modify stealth through `LightingContext`, not through direct coupling.

### 3.18 Light-Reactive Combat

Creatures shall define:

```text
LightReactionProfile
├── darkness_multiplier
├── penumbra_multiplier
├── moderate_multiplier
├── full_light_multiplier
├── fear_threshold
└── flee_behavior
```

**Example:**

- **Darkness:** Creature Strengthened
- **Penumbra:** Normal Behavior
- **Moderate:** Normal / Reduced Modifier
- **Full Light:** Creature Weakened / Repelled

### 3.19 Enemy AI

#### Architecture

```text
AIController
├── Perception
├── Memory
├── Decision
├── StateMachine
└── ActionExecutor
```

**Initial states:** `IDLE`, `PATROL`, `INVESTIGATE`, `SEARCH`, `CHASE`, `ATTACK`, `FLEE`, `RETURN`, `SLEEP`, `WORK`, `SOCIALIZE`.

AI must not directly manipulate navigation internals. `NavigationService.request_path(origin, destination)` shall abstract Godot's `NavigationServer`.

### 3.20 NPC Simulation

NPCs shall support two simulation modes.

#### Near Player (Full Simulation)

- Navigation
- Animation
- AI
- Interaction
- Perception

#### Far From Player (Abstract Simulation)

- Work Progress
- Inventory Changes
- Schedule
- Relationship Events

This prevents the entire world from requiring full AI simulation simultaneously.

### 3.21 NPC Schedules

```text
ScheduleEntry
├── start_time
├── end_time
├── activity
├── location
└── conditions
```

**Example:**

- `08:00` $
ightarrow$ Work
- `12:00` $
ightarrow$ Eat
- `13:00` $
ightarrow$ Work
- `18:00` $
ightarrow$ Tavern
- `22:00` $
ightarrow$ Sleep

### 3.22 Reputation System

Reputation is multidimensional.

```text
ReputationComponent
└── Dictionary<ReputationSubjectId, ReputationEntry>
```

**Each entry:**

```text
ReputationEntry
├── subject_id
├── value
├── tier
├── last_change
└── history
```

**Subjects may include:** Faction, Settlement, Religion, NPC, Profession, Territory.

The system must not use `player.reputation = 500` as a universal reputation model.

### 3.23 Relationship System

NPC relationships use continuous values from which presentation tiers can be derived.

- `-100` $
ightarrow$ Hate
- `-50` $
ightarrow$ Dislike
- `0` $
ightarrow$ Neutral
- `25` $
ightarrow$ Like
- `60` $
ightarrow$ Friendship
- `85` $
ightarrow$ Love

**Runtime state:**

```text
RelationshipState
├── target_id
├── affinity
├── trust
├── respect
├── fear
├── familiarity
└── flags
```

The thresholds are balance data rather than hardcoded domain rules.

### 3.24 Quest System

#### Definition

```text
QuestDefinition
├── id
├── type
├── objectives
├── prerequisites
├── rewards
├── failure_conditions
├── world_effects
└── dialogue_references
```

**Types:** `MAIN`, `ORIGIN`, `PROFESSION`, `FACTION`, `LOCAL`, `NPC`, `DYNAMIC`, `WORLD_EVENT`.

#### Quest FSM

```text
LOCKED
   ↓
AVAILABLE
   ↓
ACCEPTED
   ↓
IN_PROGRESS
   ↓
COMPLETED
```

**Alternative terminal states:** `FAILED`, `ABANDONED`, `EXPIRED`.

#### Dynamic Quest Generation

```text
World Condition
      ↓
QuestGenerator
      ↓
DynamicQuestTemplate
      ↓
QuestDefinition
      ↓
Quest Instance
```

**Example:**
$$ ext{Resource Availability} < 20\% \implies ext{Mining Shortage} \implies ext{Blacksmith Demand Increases} \implies ext{Dynamic Quest Generated}$$

The TDD explicitly defines condition-driven dynamic quest templates.

### 3.25 Loot System

Loot shall be data-driven.

```text
LootTable
├── entries
├── weight
├── quantity_range
├── conditions
└── rarity
```

Enemies reference `LootProfile`. The `LootService` generates results. Enemy scripts shall not manually construct loot.

### 3.26 Economy System

#### Local Economy

```text
EconomyState
├── supply
├── demand
├── prices
├── currency
├── taxes
├── trade_volume
└── modifiers
```

#### Pricing

$$ ext{Price} = ext{BasePrice} imes ext{SupplyModifier} imes ext{DemandModifier} imes ext{SeasonModifier} imes ext{TerritoryModifier} imes ext{EventModifier}$$

The MVP shall use a minimal model:
$$ ext{Base Price} + ext{Supply} + ext{Demand}$$
Additional economic complexity shall only be introduced when justified by gameplay requirements.

### 3.27 Economic Transactions

All operations involving multiple domains shall be logically transactional.

**Example:**

```text
Validate Seller
      ↓
Validate Buyer
      ↓
Validate Item
      ↓
Validate Currency
      ↓
Reserve
      ↓
Transfer Item
      ↓
Transfer Currency
      ↓
Apply Tax
      ↓
Commit
      ↓
Emit Events
```

The system must never remove currency and then assume item transfer will succeed.

### 3.28 Territory System

```text
TerritoryState
├── owner
├── population
├── wealth
├── security
├── resources
├── infrastructure
├── faction_influence
├── religion_influence
├── economy
└── active_conflicts
```

Governance remains a future service (`GovernanceSystem`: Policy, TaxPolicy, SecurityPolicy, TradePolicy, ResourcePolicy). The system shall exist as an extension point but is outside the MVP.

### 3.29 Climate and Seasons

```text
ClimateSystem
├── WeatherState
├── RegionClimate
├── SeasonModifiers
├── Forecast
└── WeatherEvents
```

Climate modifiers are consumed by: Survival, Agriculture, Fishing, NPC, Combat, Navigation.

### 3.30 World Events

```text
WorldEventDefinition
├── trigger
├── duration
├── affected_regions
├── modifiers
├── rewards
└── consequences
```

World events must mutate world state rather than merely display notifications.

---

## 4. Subsystem Integration

### 4.1 Command Architecture

Commands represent player/system intentions.

```text
Command
├── CommandId
├── ActorId
├── Timestamp
└── Payload
```

**Examples:** `MoveCommand`, `InteractCommand`, `GatherCommand`, `CraftCommand`, `AttackCommand`, `EquipCommand`, `TradeCommand`, `TravelCommand`, `TalkCommand`, `RestCommand`.

#### Command Pipeline

```text
Input
 ↓
Command Creation
 ↓
CommandProcessor
 ↓
Validation
 ↓
Execution
 ↓
State Mutation
 ↓
Event
```

### 4.2 Event Architecture

Commands express: _"Do X."_  
Events express: _"X happened."_

**Example:**
$$ ext{CraftSwordCommand} \longrightarrow ext{CraftingSystem} \longrightarrow ext{ItemCraftedEvent}$$

Commands may fail. Events represent confirmed state changes.

### 4.3 Event Bus

The project shall maintain a centralized Event Bus.

**Core events include:**

- `PlayerLevelChanged`, `HealthChanged`, `EnergyChanged`, `HungerChanged`, `TemperatureChanged`
- `ItemAdded`, `ItemRemoved`, `ItemCrafted`, `ItemDurabilityChanged`
- `ResourceGathered`, `ResourceDepleted`, `EnemyDefeated`
- `QuestStarted`, `QuestCompleted`, `ReputationChanged`, `RelationshipChanged`
- `ProfessionXPChanged`, `TerritoryChanged`, `MarketPriceChanged`, `TimeChanged`, `SeasonChanged`

Events shall be small data objects with no business logic.

### 4.4 UI/UX Integration

The UI shall follow an MVVM-like / Presentation Model architecture.

```text
Gameplay State
      ↓
Gameplay Service
      ↓
ViewModel / Presentation Model
      ↓
UI View
```

The HUD must not directly modify player state.
The initial HUD shall consume: Health, Energy, Fatigue, Hunger, Temperature, Light, LanternFuel, Panic, Sanity.

#### UI Update Rule

UI shall react to events rather than polling gameplay state every frame.

**Example:**
$$ ext{HealthChanged} \longrightarrow ext{HealthViewModel} \longrightarrow ext{HealthBar}$$

This reduces unnecessary processing and preserves domain/UI separation.

### 4.5 Audio System

Audio shall react to world and gameplay state.

**Examples:**

- **Dark Sector** $
ightarrow$ `AmbientAudioProfile`
- **Combat State** $
ightarrow$ Music State

Audio systems shall never become authoritative gameplay systems.

#### Suggested architecture

```text
AudioService
├── MusicController
├── AmbienceController
├── SFXController
├── VoiceController
└── AudioStateResolver
```

### 4.6 VFX Integration

VFX shall be triggered by domain events or presentation events.

**Examples:**

- `ItemCrafted` $
ightarrow$ `CraftVFX`
- `EnemyDefeated` $
ightarrow$ `DeathVFX`
- `ResourceDepleted` $
ightarrow$ `ResourceDepletionVFX`
- `LightLevelChanged` $
ightarrow$ `LightingFeedbackVFX`

Gameplay systems should emit the event and remain unaware of the visual implementation.

### 4.7 Camera System

The camera is an independent subsystem.

**Modes:** Exploration, Combat, Dialogue, Interaction.

The `CameraController` receives state/context and changes behavior accordingly. Combat must not directly own the camera implementation.

### 4.8 Localization

All player-visible text must use localization IDs.

**Examples:**

- `quest.dark_gate.title`
- `item.iron_sword.name`
- `faction.guardians.name`
- `profession.blacksmith.name`

Text must not be hardcoded inside gameplay scripts.

---

## 5. Resource Management & Optimization

### 5.1 Godot Resource Loading Strategy

The project shall not use Unity's Addressables system, as Addressables is not a native Godot 4.7.1 subsystem.

The equivalent architecture shall use: `Resource`, `PackedScene`, `ResourceLoader`, `preload()`, `load()`, `ContentRegistry`, `Resource Cache`, `SceneManager`.

#### Loading Policy

- Use `preload()` for small, static, known-at-build-time dependencies.
- Use `ResourceLoader.load()` or asynchronous loading mechanisms for large or dynamic content.
- Use a centralized `ContentRegistry` for stable content definitions.

### 5.2 Content Registry

```text
ContentRegistry
├── Item Definitions
├── Enemy Definitions
├── Profession Definitions
├── Recipe Definitions
├── Quest Definitions
├── Region Definitions
├── Faction Definitions
├── Religion Definitions
└── World Definitions
```

Content IDs must remain stable after saves are distributed. Changing an ID requires a migration strategy.

### 5.3 Scene Management

`SceneManager` shall be responsible for: Load Scene, Unload Scene, Transition Scene, Load Region, Unload Region, Handle Loading State.

Persistent world state must remain independent from loaded scene instances.

### 5.4 World Streaming

The world architecture shall support:

```text
World
├── Region A
├── Region B
├── Region C
└── Region D
```

Regions may be loaded/unloaded independently. The region state must survive unloading.

### 5.5 Offline Simulation

When a region is unloaded:

```text
RegionUnload
    ↓
Capture Simulation State
    ↓
Advance Logical Time
    ↓
Abstract Simulation
    ↓
Store New State
```

When loaded:

```text
RegionLoad
    ↓
Restore State
    ↓
Spawn Entities
    ↓
Apply State
```

### 5.6 Object Pooling

Object pooling shall be used only for high-churn runtime objects where profiling demonstrates allocation pressure.

**Potential pool candidates:** Projectile, Hit Effect, Damage Number, Temporary VFX, Loot Pickup, AI Perception Marker, Particle-Driven Gameplay Object.

Do not introduce pooling universally. The architecture prioritizes correctness and maintainability before premature optimization.

### 5.7 Simulation Frequencies

The simulation shall use different update frequencies:

| Frequency          | Target Systems            |
| :----------------- | :------------------------ |
| **FRAME**          | Input, Rendering          |
| **HIGH FREQUENCY** | Movement, Combat          |
| **MEDIUM**         | AI, Interaction           |
| **LOW**            | Economy, World Simulation |
| **VERY LOW**       | Long-Term Regeneration    |

### 5.8 `_process()` Policy

Avoid using `_process()` for systems that do not require frame-level updates.
Prefer: Signals, Events, Timers, Simulation Ticks, Scheduled Updates, Explicit Commands.

This is particularly important for: Economy, NPC Simulation, Resource Regeneration, Survival, World Events, Quests.

### 5.9 Performance Targets

The following are engineering targets, not values defined by the current GDD/TDD.

#### Initial PC Target

- **Resolution Target:** $1920 	imes 1080$
- **Target Frame Rate:** 60 FPS
- **Minimum Acceptable Gameplay Frame Rate:** 30 FPS
- **Simulation:** Deterministic logical tick where required

#### Frame Budget

For a 60 FPS target: $16.67	ext{ ms / frame}$.
The implementation should initially target:

- **Game Logic:** $\le 4	ext{ ms}$
- **Rendering:** $\le 10	ext{ ms}$
- **Engine/Overhead:** $\le 2	ext{ ms}$

These are optimization targets and shall be validated through profiling rather than treated as absolute architectural requirements.

#### Memory

A practical initial development target is:

- **Recommended RAM:** 16 GB+
- **Runtime target:** 4–6 GB working-set ceiling during MVP

Actual production limits shall be established after the vertical slice and asset pipeline are measurable.

### 5.10 Deterministic Randomness

Randomness shall be centralized in `RandomService` rather than `randf()` or `randi()` being scattered throughout domain systems.

Controlled RNG is required for: Loot, Economy Simulation, World Events, Procedural Behavior, Testing, Bug Reproduction, Future Multiplayer.

---

## 6. Testing and Technical Validation Pipeline

### 6.1 Test Strategy

The project shall use: Unit Tests, Integration Tests, Simulation Tests, Save/Load Tests, Gameplay Tests, Performance Tests, Network Tests.

### 6.2 Unit Tests

The following systems have priority: XP, Reputation, Pricing, Loot, Crafting, Durability, Hunger, Temperature, Lighting, Progression, Requirements.

#### Example

- **Given:** Iron x3, Leather x1, Blacksmith Level 2
- **When:** Craft Iron Sword
- **Then:** Iron -3, Leather -1, Sword +1, Profession XP +X

### 6.3 Integration Tests

- **Gathering:** Gathering + Inventory + Profession + Resource Node + Event Bus
- **Quest:** Quest + World State + Reputation + NPC

### 6.4 Persistence Tests

Every persistent subsystem must pass:

```text
Create State
    ↓
Mutate State
    ↓
Save
    ↓
Destroy Runtime
    ↓
Load
    ↓
Compare
```

The loaded result must be semantically equivalent to the pre-save state.

### 6.5 Save Integrity Tests

The save system shall validate: Save Version, Required Fields, Entity IDs, References, Inventory Integrity, Currency Integrity, Quest Integrity, World State Integrity.

Save corruption mitigation shall include: Versioning, Atomic Save, Backup, Validation, Migration.

### 6.6 Regression Tests

Every significant bug fix must follow:
$$ ext{Bug} \longrightarrow ext{Reproduce} \longrightarrow ext{Write Test} \longrightarrow ext{Fix} \longrightarrow ext{Test Passes}$$

### 6.7 Simulation Tests

Simulation tests shall validate long-running systems without rendering.

**Examples:** Advance World 30 Days, Advance World 1 Season, Deplete Resource, Regenerate Resource, Simulate NPC Schedule, Simulate Economy, Simulate Relationship Changes, Simulate Territory State.

The goal is to detect systemic instability without requiring a full gameplay scene.

### 6.8 Gameplay Tests

The minimum vertical slice must contain:

- 1 Small Region
- 1 Player
- 1 NPC
- 1 Profession
- 1 Resource
- 1 Recipe
- 1 Enemy
- 1 Weapon
- 1 Light Source
- 1 Quest
- 1 Day Cycle
- 1 Survival Cycle
- 1 Save/Load Flow

This vertical slice is specifically recommended by the TDD to validate the architecture before world expansion.

### 6.9 Performance Tests

Performance tests shall measure: Frame Time, CPU Time, GPU Time, Memory, Node Count, Active NPC Count, AI Update Cost, Physics Cost, Draw Calls, Resource Loading Time, Scene Transition Time, Save Time, Load Time, World Tick Time.

The project must optimize based on profiling rather than assumptions.

### 6.10 Debugging Infrastructure

A centralized `GameLogger` shall support: `SYSTEM`, `COMBAT`, `AI`, `ECONOMY`, `QUEST`, `SAVE`, `NETWORK`, `PERFORMANCE`, `ERROR`.

Detailed logs must be disableable in production builds.

### 6.11 In-Game Debug Tools

The development build should provide a debug overlay capable of displaying: FPS, Frame Time, Game Time, Current Region, Current Territory, Player Entity ID, Player Coordinates, Current Light Level, Survival Values, Current Profession, Profession XP, Character Level, Reputation, Active Quests, AI State, AI Target, Resource Node State, Economy Values, Event Log, Command Log, Save Version.

**Optional developer commands:**
`/time set`, `/time advance`, `/player god`, `/player teleport`, `/player give`, `/player set_profession`, `/player set_reputation`, `/world set_weather`, `/world deplete_resource`, `/world regenerate_resource`, `/quest start`, `/quest complete`, `/ai debug`, `/save`, `/load`.

These commands must be compiled or enabled only in development/debug configurations.

### 6.12 Command and Event Debugging

Because commands and events are first-class architecture elements, the debug system should optionally record: Command ID, Actor ID, Timestamp, Payload, Validation Result, Execution Result, Generated Events, State Changes.

This provides a reproducible chain:

$$
	ext{Input}
ightarrow 	ext{Command}
ightarrow 	ext{Validation}
ightarrow 	ext{State Mutation}
ightarrow 	ext{Event}
ightarrow 	ext{Secondary Effects}
ightarrow 	ext{Persistence}
$$

The TDD defines this as the fundamental technical gameplay pipeline.

---

## 7. Implementation Constraints and Acceptance Criteria

### 7.1 Hard Architectural Rules

The implementation shall not:

- Use UI as a source of gameplay truth
- Use NodePath as persistent identity
- Hardcode content definitions into gameplay scripts
- Create unnecessary global singletons
- Couple Economy directly to Gathering
- Couple Quests directly to Mining
- Couple Combat directly to Lighting
- Couple UI directly to domain state
- Duplicate domain calculations
- Depend on frame rate for logical simulation
- Assume Single Player in persistent domain systems

### 7.2 Data-Driven Rules

The following must be data-driven: Items, Weapons, Armor, Loot, Professions, Recipes, Enemies, NPC Profiles, Regions, Climate, Seasons, Light Sources, Quests, Factions, Religions, Currencies, Travel Methods, Requirements, Rewards, Balance Values.

The TDD explicitly requires balance values to remain outside hardcoded gameplay logic.

### 7.3 Requirement System

All complex access conditions should use `RequirementEvaluator` with `AND`, `OR`, `NOT`.

**Example:**

- **`CanEnterDarkSector` Requires:**
  $$ ext{Reputation} \ge 20 ext{ AND } ext{HasLightSource} ext{ AND } ext{QuestCompleted("dark_gate")}$$

This prevents access rules from becoming scattered conditionals.

### 7.4 Reward System

Rewards shall use:

```text
RewardDefinition
├── currency
├── items
├── experience
├── reputation
├── unlocks
├── titles
└── flags
```

Quests, achievements and world events should reuse the same reward infrastructure.

### 7.5 Status Effect System

A generic status system shall support:

```text
StatusEffect
├── effect_id
├── duration
├── stacks
├── source
└── modifiers
```

**Potential applications:** Hunger, Cold, Buffs, Debuffs, Poison, Fear, Panic, Magic.

### 7.6 Modifier System

All attribute modifiers shall use:

```text
Modifier
├── stat
├── operation
├── value
├── source
└── duration
```

**Operations:** `ADD`, `MULTIPLY`, `OVERRIDE`.

This creates a common mathematical layer for: Combat, Survival, Stealth, Equipment, Lighting, Climate, Skills, Buffs, Debuffs.

### 7.7 Multiplayer Readiness

The MVP does not implement the complete multiplayer experience.
The MVP architecture must nevertheless satisfy:
$$ ext{Stable Entity IDs} + ext{Commands} + ext{Events} + ext{Persistent State Separation} + ext{Transaction Boundaries} + ext{Authority-Agnostic Domain Logic} + ext{UI Independence} + ext{NodePath Independence}$$

The TDD explicitly defines this as Architecture Ready / Gameplay Deferred.

#### Future model

```text
                  ┌────────────────────┐
                  │ Server / Host      │
                  │ Authoritative State│
                  └─────────┬──────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
       Client A                       Client B
```

**Clients send intent:** `MoveRequest`, `AttackRequest`, `InteractRequest`, `CraftRequest`, `TradeRequest`.

The authoritative side validates and commits state changes.

### 7.8 Persistence vs Transient State

| Persistent       | Transient                       |
| :--------------- | :------------------------------ |
| Character        | Animation                       |
| Inventory        | Particles                       |
| Equipment        | Temporary Visual State          |
| Profession       | Transient Effects               |
| Skills           | Current Runtime Node References |
| Reputation       |                                 |
| Relationships    |                                 |
| Properties       |                                 |
| Quests           |                                 |
| World Changes    |                                 |
| Resource Changes |                                 |
| Economy State    |                                 |

This distinction is mandatory for both save architecture and future multiplayer synchronization.

### 7.9 Definition of Done

A system is not considered implemented until:

```text
Implementation Complete
        ↓
Unit Tests
        ↓
Integration Tests
        ↓
Persistence Validation
        ↓
Gameplay Validation
        ↓
Performance Validation
        ↓
Documentation Updated
        ↓
Known Risks Recorded
        ↓
Acceptance Criteria Satisfied
```

This follows the TDD's technical Definition of Done.

### 7.10 MVP Technical Acceptance Criteria

The MVP shall be considered technically functional when the player can:

- Create Character
- Choose Origin
- Move
- Explore
- Gather Resources
- Own Items
- Equip Items
- Experience Survival Needs
- Fight
- Defeat Enemies
- Use Lighting
- Perform a Profession
- Complete Quests
- Change Reputation
- Interact with NPCs
- Use a City
- Use a Village
- Save
- Load
- Advance Through Time
- Complete a Basic Progression Loop

These acceptance criteria are defined in the TDD.

### 7.11 Architectural Completion Criteria

The MVP shall not be considered technically complete if:

- Systems depend directly on UI
- Critical rules are hardcoded in scenes
- Save depends on NodePaths
- Core systems are monolithic
- Domain logic is duplicated
- Content is hardcoded into scripts
- Future multiplayer requires complete architectural rewrite
- Critical systems lack tests
- Save/load cannot reliably restore state

---

## 8. Implementation Order

The implementation sequence shall follow dependency risk rather than feature quantity.

```text
01. Core Architecture
        ↓
02. Entity / Component Architecture
        ↓
03. Game State
        ↓
04. Time System
        ↓
05. Save / Load
        ↓
06. Player
        ↓
07. Movement
        ↓
08. Interaction
        ↓
09. Inventory
        ↓
10. Items / Equipment
        ↓
11. Survival
        ↓
12. Lighting
        ↓
13. Gathering
        ↓
14. Crafting
        ↓
15. Progression
        ↓
16. Combat
        ↓
17. Enemy AI
        ↓
18. NPC AI
        ↓
19. Quest System
        ↓
20. Profession System
        ↓
21. Reputation
        ↓
22. Relationship System
        ↓
23. World Simulation
        ↓
24. Economy
        ↓
25. Territory
        ↓
26. Multiplayer Foundation
```

This ordering is consistent with the TDD's recommended technical decomposition.

---

## 9. Final Technical Architecture

The final implementation model is:

```text
                    PLAYER INPUT
                         │
                         ▼
                ┌─────────────────┐
                │ Input System    │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Command Layer   │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ Domain Rules    │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │ State Mutation  │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │    Event Bus    │
                └────────┬────────┘
                         │
        ┌────────────────┼─────────────────┐
        ▼                ▼                 ▼
   Progression        World             Social
        │                │                 │
        └────────────────┼─────────────────┘
                         ▼
                   Persistence
                         │
                         ▼
                  Presentation
                         │
                         ▼
                       UI
```

### The Fundamental Implementation Rules

- **DATA** defines **CONTENT**
- **SYSTEMS** define **RULES**
- **COMMANDS** define **INTENT**
- **EVENTS** define **FACTS**
- **STATE** defines **THE WORLD**
- **PERSISTENCE** preserves **CONSEQUENCES**
- **UI** presents **STATE**
- **NETWORKING** will distribute **AUTHORITY**

This preserves the central architectural conclusion of the TDD.

The game must therefore not be implemented as a collection of quests or isolated features. It shall be implemented as a set of interoperable systems whose interactions generate emergent gameplay:

```text
Player Action
      ↓
System Response
      ↓
World State Change
      ↓
Secondary Consequences
      ↓
New Opportunities
      ↓
Player Decision
      ↓
Persistent World Evolution
```

The ultimate technical objective is to make the player's identity an emergent consequence of persistent state rather than a rigid class definition, while keeping every major subsystem modular, testable, data-driven, persistence-safe, and ready for future cooperative multiplayer.
