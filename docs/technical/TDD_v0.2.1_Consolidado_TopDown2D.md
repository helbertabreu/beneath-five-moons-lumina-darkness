# Beneath Five Moons / Lumina Darkness

# CONSOLIDAÇÃO TÉCNICA PÓS-MVP — 2026-08-24

> **Decisão aprovada:** a implementação oficial do projeto é **Top-Down 2D** em Godot 4.7.1.
>
> O TDD-base é preservado como referência arquitetural. Esta versão acrescenta o estado pós-MVP e explicita os pontos que ainda dependem de decisão.
>
> A arquitetura continua baseada em composição, Data-Driven Design, Event-Driven Design, serviços, interfaces, identificadores estáveis, persistência versionada e preparação para multiplayer.

## 0.A Estado Real de Implementação

A governança atual registra como funcionais:

- Player 2D;
- MovementComponent2D;
- câmera 2D;
- SurvivalComponent;
- interação 2D;
- inventário;
- itens;
- mineração;
- crafting;
- profissão;
- iluminação 2D;
- combate;
- inimigo sensível à luz;
- NPC/quest;
- relacionamentos;
- múltiplas receitas/estações;
- economia/PricingService;
- PlayerMarketService;
- flora bioluminescente;
- Save/Load.

O TDD não deve declarar como implementado aquilo que não estiver confirmado pelo estado real do projeto.

## 0.B Regra de Arquitetura Pós-MVP

A apresentação 2D deve consumir os sistemas existentes, e não duplicar suas regras.

Fluxo:

```text
Input
  ↓
Command / Application
  ↓
Domain
  ↓
State
  ↓
Event
  ↓
Presentation
  ↓
UI / Visual World
```

## 0.C Multiplayer

A preparação multiplayer permanece arquitetural.

A próxima etapa técnica deve validar:
- autoridade;
- serialização;
- EntityId;
- comandos;
- eventos;
- sincronização;
- persistência;
- idempotência;
- reconexão;
- conflito de estado.

Não considerar multiplayer completo como DONE antes desses critérios.

---


# Technical Design Document (TDD)

**Versão:** 0.2.1-TDD.3
**Status:** Consolidação pós-MVP / Arquitetura Técnica / Baseline Multiplayer e Mundo 2D
**Documento:** Technical Design Document
**Engine:** Godot 4.7.1
**Linguagem principal:** GDScript 2.0
**Plataforma inicial:** PC
**Perspectiva:** Top-Down 2D
**Modo principal:** PvE / Single Player
**Modo secundário planejado:** Cooperative Multiplayer
**PvP:** Em estudo
**Arquitetura:** Modular / Data-Driven / Event-Driven / Preparada para Multiplayer
**Escopo:** MVP + Pós-MVP + Expansões

---

# 0. Objetivo deste TDD

Este documento converte o conceito definido no GDD de **Beneath Five Moons / Lumina Darkness** em uma especificação técnica destinada à equipe de engenharia.

O TDD não deve substituir o GDD.

A separação de responsabilidades é:

```text
GDD
↓
Define O QUE o jogo deve ser.

TDD
↓
Define COMO os sistemas serão implementados.

Código
↓
Implementa o TDD.

Testes
↓
Validam o comportamento implementado.
```

A arquitetura deve permitir que sistemas ainda indefinidos sejam adicionados posteriormente sem exigir reescrita estrutural.

---

# 0.1. Princípios Arquiteturais

A implementação deve seguir:

```text
Composição > Herança profunda

Dados > Lógica hardcoded

Sistemas desacoplados > Dependências diretas

Eventos > Acoplamento entre sistemas

Interfaces/Contratos > Conhecimento interno

Identificadores estáveis > Referências frágeis

Save State > Estado derivado

Determinismo quando necessário > Aleatoriedade não controlada

Testabilidade > Conveniência local
```

---

# 0.2. Regra Fundamental de Arquitetura

Nenhum sistema de gameplay deve assumir conhecimento detalhado da implementação interna de outro sistema.

Exemplo incorreto:

```gdscript
player.get_node("Inventory").items[3].durability -= 1
```

Exemplo preferencial:

```gdscript
inventory_service.consume_item_durability(item_id, amount)
```

Ou, quando apropriado:

```gdscript
event_bus.emit_event(ItemDurabilityChanged.new(...))
```

A comunicação deve ocorrer através de:

- APIs públicas;
- interfaces;
- comandos;
- serviços;
- eventos;
- componentes;
- recursos de dados.

---

# 0.3. Camadas da Arquitetura

A arquitetura lógica será organizada em camadas:

```text
┌─────────────────────────────────────┐
│ Presentation / UI                   │
├─────────────────────────────────────┤
│ Gameplay / Application              │
├─────────────────────────────────────┤
│ Domain Systems                      │
├─────────────────────────────────────┤
│ World / Simulation                  │
├─────────────────────────────────────┤
│ Persistence / Save                  │
├─────────────────────────────────────┤
│ Infrastructure                     │
├─────────────────────────────────────┤
│ Godot Engine / Platform             │
└─────────────────────────────────────┘
```

## Presentation

Responsável por:

- HUD;
- menus;
- inventário;
- equipamentos;
- feedback visual;
- indicadores;
- diálogos.

Não deve conter regras fundamentais de gameplay.

## Gameplay / Application

Responsável por:

- comandos do jogador;
- orquestração de ações;
- workflows;
- transições;
- execução de interações.

## Domain Systems

Contém regras de:

- combate;
- sobrevivência;
- profissões;
- economia;
- reputação;
- relacionamento;
- progressão;
- crafting;
- iluminação;
- quests.

## World / Simulation

Contém:

- tempo;
- clima;
- estações;
- recursos;
- territórios;
- NPCs;
- população;
- eventos.

## Persistence

Responsável por:

- serialização;
- saves;
- carregamento;
- versionamento;
- migração.

## Infrastructure

Responsável por:

- Event Bus;
- logging;
- configuração;
- randomização;
- serviços de áudio;
- recursos;
- networking futuro.

---

# 0.4. Estrutura Inicial de Diretórios

Estrutura recomendada:

```text
res://
├── project.godot
│
├── autoload/
│   ├── game_state.gd
│   ├── event_bus.gd
│   ├── time_service.gd
│   ├── save_service.gd
│   ├── scene_manager.gd
│   └── service_registry.gd
│
├── core/
│   ├── interfaces/
│   ├── events/
│   ├── commands/
│   ├── enums/
│   ├── value_objects/
│   └── utilities/
│
├── gameplay/
│   ├── player/
│   ├── combat/
│   ├── survival/
│   ├── stealth/
│   ├── interaction/
│   └── movement/
│
├── progression/
│   ├── character/
│   ├── skills/
│   ├── professions/
│   ├── weapon_proficiency/
│   └── reputation/
│
├── world/
│   ├── regions/
│   ├── territories/
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

---

# 1. Visão Geral do Projeto

## 1.1. Conceito de Alto Nível

O sistema deve ser construído como um **sandbox sistêmico orientado a estado**.

O personagem não possuirá uma única classe central responsável por determinar sua identidade.

Em vez disso:

```text
Character
├── Attributes
├── Skills
├── Professions
├── Weapon Proficiencies
├── Reputation
├── Relationships
├── Equipment
├── Origin
└── Social State
```

A identidade emergirá da combinação desses estados.

A arquitetura deve evitar:

```text
PlayerClass = Warrior
```

como fonte central de comportamento.

Preferir:

```text
CharacterProfile
    + SkillSet
    + ProfessionState
    + EquipmentState
    + ReputationState
    + RelationshipState
```

---

## 1.2. Fantasia do Jogador

A fantasia de "construir uma vida" exige persistência de estado.

Consequentemente, ações importantes devem produzir efeitos persistentes.

Exemplo:

```text
Player mines resource
        ↓
ResourceNode quantity decreases
        ↓
Territory resource availability changes
        ↓
Market supply changes
        ↓
Price changes
        ↓
NPC behavior may change
        ↓
Quest generator evaluates new condition
```

A arquitetura deve permitir que essa cadeia aconteça sem que o sistema de mineração conheça diretamente o sistema de quests.

A comunicação deve ocorrer por eventos.

---

## 1.3. Gênero

Os diferentes gêneros possuem implicações técnicas:

| Gênero             | Implicação técnica                  |
| ------------------ | ----------------------------------- |
| RPG                | Progressão persistente              |
| Sandbox            | Sistemas desacoplados               |
| Open World         | Streaming e gerenciamento de estado |
| Survival           | Simulação temporal                  |
| Social Simulation  | Estado persistente de NPCs          |
| Progressão por uso | Tracking de ações                   |
| Economia           | Simulação de oferta/demanda         |
| Multiplayer        | Autoridade e sincronização futuras  |

---

# 1.4. Público-Alvo

O público-alvo influencia principalmente a necessidade de:

- liberdade de abordagem;
- feedback sistêmico;
- progressão transparente;
- baixo acoplamento entre atividades;
- múltiplas rotas de progressão.

A arquitetura não deve obrigar o jogador a executar determinada sequência para acessar progressão básica.

---

# 1.5. Pilares de Design

## Pilar 1 — Mundo Vivo

Requer:

- World State;
- Time Service;
- Resource Simulation;
- Territory State;
- NPC State;
- Economy State;
- Event System.

## Pilar 2 — Identidade Emergente

Requer:

- Skill System;
- Profession System;
- Reputation System;
- Relationship System;
- Equipment System;
- Origin System.

## Pilar 3 — Cooperação

Requer:

- sistemas orientados a serviços;
- identificadores estáveis;
- autoridade de estado preparada para networking;
- ausência de lógica exclusivamente local em sistemas persistentes.

---

# 2. Universo e Lore

Lore deve ser tratado como **dados de domínio**, e não como lógica.

Exemplo:

```text
MoonDefinition
├── id
├── display_name
├── celestial_body_type
├── influence_tags
├── gameplay_modifiers
└── lore_reference
```

As cinco luas devem ser representadas através de `Resource` customizados do Godot.

Exemplo conceitual:

```gdscript
class_name MoonDefinition
extends Resource

@export var id: StringName
@export var display_name: String
@export var influence_tags: Array[StringName]
@export var gameplay_modifiers: Dictionary
```

Isso permite adicionar novas luas futuramente sem modificar os sistemas centrais.

---

# 2.1. O Fenômeno das 5 Luas

O sistema astronômico deve possuir uma representação abstrata:

```text
CelestialSystem
        ↓
MoonDefinitions
        ↓
CelestialState
        ↓
WorldSimulation
        ↓
GameplayModifiers
```

O estado celestial não deve depender da renderização.

A representação visual do céu apenas consulta o estado.

---

# 2.2. Quintalia

Quintalia deve ser modelada como:

```text
World
└── Continent
    └── Region
        └── Territory
            ├── Settlement
            ├── Resource Nodes
            ├── NPCs
            ├── Factions
            └── Economy
```

Os IDs dessas entidades devem ser persistentes.

Exemplo:

```text
world.quintalia.region.aligned_lands
world.quintalia.region.dark_sector
territory.port_astraea
territory.aethel_citadel
```

---

# 2.3. Terras Alinhadas

Regiões devem utilizar parâmetros configuráveis:

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

---

# 2.4. Setor Escuro

O Setor Escuro exige um `DarkSectorSimulation`.

Responsabilidades:

- perfil de iluminação;
- clima;
- temperatura;
- fauna;
- modificadores de criatura;
- recursos raros;
- eventos;
- navegação;
- exposição do jogador.

O sistema de iluminação não deve estar diretamente acoplado ao sistema de combate.

Em vez disso:

```text
LightingSystem
        ↓
LightingState
        ↓
Gameplay Modifier Provider
        ↓
Combat / Stealth / Survival
```

---

# 2.5. Muralha das Sombras

A Muralha deve ser representada como uma região navegável com regras específicas.

Pode funcionar como:

- barreira;
- checkpoint;
- zona de transição;
- conteúdo de progressão.

A lógica de bloqueio deve ser baseada em requisitos:

```text
AccessRequirement
├── reputation
├── quest
├── item
├── skill
├── profession
└── world_state
```

Isso evita hardcode:

```gdscript
if player.level >= 20:
```

quando o requisito futuro puder ser reputação, quest ou equipamento.

---

# 2.6. Garganta de Ferro

Deve ser modelada como `StrategicTerritory`.

Suporta futuramente:

- comércio;
- controle;
- eventos;
- conflito;
- facções;
- PvP opcional.

A arquitetura não deve implementar PvP agora, mas deve evitar estruturas que assumam exclusivamente:

```text
DamageTarget = Enemy
```

O domínio deve permitir futuramente:

```text
DamageTarget
├── Enemy
├── NPC
├── Player
├── Structure
└── TerritoryEntity
```

---

# 3. Estrutura do Mundo

## 3.1. Mundo Aberto Reativo

O mundo deve ser dirigido por `WorldState`.

Estrutura:

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
└── simulation_flags
```

O estado atual deve ser serializável.

Dados puramente derivados não precisam necessariamente ser persistidos.

Exemplo:

```text
Persistir:
resource.current_quantity

Derivar:
resource.availability_percentage
```

---

# 3.2. Sistema de Degradação Territorial

Cada recurso deve possuir:

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

Estados:

```text
ABUNDANT
HEALTHY
DEPLETING
SCARCE
DEPLETED
RECOVERING
```

Fluxo:

```text
Collect
 ↓
Decrease Quantity
 ↓
Recalculate State
 ↓
Emit ResourceAvailabilityChanged
 ↓
Economy reacts
 ↓
Quest system reacts
 ↓
NPC simulation may react
```

A mineração não deve chamar diretamente o sistema econômico.

---

# 3.3. Sistema de Estações

Implementação:

```text
SeasonService
├── current_season
├── season_day
├── duration_days
└── modifiers
```

As estações devem produzir um objeto de modificadores:

```text
SeasonModifiers
├── temperature
├── crop_growth
├── fishing
├── hunting
├── resource_spawn
├── npc_activity
└── market_demand
```

---

# 3.4. Sistema de Tempo

O tempo será centralizado em `TimeService`.

Unidades:

```text
Tick
Second
Minute
Hour
Day
Week
Season
Year
```

O sistema não deve depender exclusivamente de `_process(delta)` para representar o tempo do mundo.

Modelo:

```text
Real Time
   ↓
Simulation Clock
   ↓
Game Time
   ↓
Scheduled Events
```

Um relógio lógico permite:

- acelerar tempo;
- pausar;
- dormir;
- avançar horas;
- multiplayer futuro;
- testes automatizados.

---

# 4. Core Loop

O loop deve ser implementado como composição de sistemas.

```text
Player Intent
      ↓
Action Validation
      ↓
Action Execution
      ↓
State Mutation
      ↓
Event Emission
      ↓
Secondary Systems
      ↓
Feedback
```

Exemplo:

```text
Mine Ore
↓
Validate Energy
↓
Validate Tool
↓
Validate Node
↓
Consume Energy
↓
Modify Node
↓
Add Item
↓
Increase Mining XP
↓
Emit Events
↓
Update UI
```

---

# 4.1. Loop de Curto Prazo

As ações devem ser representadas por comandos.

Exemplos:

```text
MoveCommand
InteractCommand
AttackCommand
GatherCommand
CraftCommand
TradeCommand
TalkCommand
RestCommand
```

Um `CommandProcessor` valida e executa os comandos.

---

# 4.2. Loop de Médio Prazo

O sistema de progressão deve observar eventos:

```text
ItemGathered
ItemCrafted
EnemyDefeated
QuestCompleted
TradeCompleted
ProfessionActionPerformed
```

Esses eventos alimentam:

- XP;
- skills;
- reputação;
- estatísticas;
- achievements.

---

# 4.3. Loop de Longo Prazo

Sistemas persistentes devem operar sobre marcos:

```text
Milestone
    ↓
Reputation
    ↓
Access
    ↓
Property
    ↓
Influence
    ↓
Territory Control
```

---

# 5. Sistemas de Sobrevivência

## 5.1. Necessidades Básicas

Criar `SurvivalComponent`.

Estado:

```text
SurvivalState
├── health
├── hunger
├── fatigue
├── energy
├── temperature
└── comfort
```

Cada valor deve possuir:

```text
current
minimum
maximum
rate
modifiers
```

O componente não deve conhecer UI.

---

# 5.2. Fome

Implementação:

```text
HungerSystem
```

Entradas:

- tempo;
- atividade;
- clima;
- temperatura;
- buffs.

Saídas:

- HungerChanged;
- starvation state;
- modifiers.

Exemplo:

```text
Hunger > 70
NORMAL

40–70
MINOR_PENALTY

10–40
MAJOR_PENALTY

0–10
STARVATION

0
CRITICAL
```

Os valores definitivos devem ser definidos no balanceamento.

---

# 5.3. Fadiga

A fadiga deve utilizar um modelo baseado em ações.

```text
FatigueGain =
    BaseActionCost
    × ActivityIntensity
    × ClimateModifier
    × HungerModifier
```

O sistema deve evitar que cada ação implemente manualmente regras de fadiga.

Preferir:

```gdscript
fatigue_service.apply_activity_cost(activity_profile)
```

---

# 5.4. Temperatura

Temperatura deve ser calculada a partir de:

```text
AmbientTemperature
+ WeatherModifier
+ SeasonModifier
+ RegionModifier
+ EquipmentInsulation
+ ShelterModifier
+ ConsumableModifier
```

Resultado:

```text
TemperatureExposure
```

Estados:

```text
EXTREME_COLD
COLD
COMFORTABLE
HOT
EXTREME_HEAT
```

---

# 5.5. Energia

A energia deve possuir recuperação por:

- descanso;
- sono;
- determinados alimentos;
- efeitos especiais.

O consumo deve ser baseado em `ActivityCostDefinition`.

---

# 6. Sistema de Iluminação

O sistema será composto por:

```text
LightingSystem
├── WorldLightProvider
├── LocalLightProvider
├── PlayerLightProvider
├── LightExposureCalculator
└── LightingStateService
```

---

# 6.1. Níveis de Luz

O nível final deve ser calculado a partir de intensidade, não somente de uma enumeração visual.

Modelo:

```text
float illumination_value
```

Depois:

```text
0.00–0.15 → ABSOLUTE_DARKNESS
0.15–0.35 → PENUMBRA
0.35–0.70 → MODERATE
0.70–1.00 → FULL
```

Os thresholds devem ser configuráveis.

Isso permite balanceamento sem alterar código.

---

# 6.2. Fontes de Luz

Cada fonte deve possuir:

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

Uma tocha e uma lanterna serão instâncias do mesmo sistema.

---

# 6.3. Integração com Gameplay

A iluminação gera:

```text
LightingContext
├── level
├── intensity
├── source_type
├── visibility_modifier
├── stealth_modifier
└── creature_modifier
```

Combat e stealth apenas consomem esse contexto.

---

# 7. Exploração

## 7.1. Exploração por Risco

Cada região possuirá:

```text
DangerProfile
├── danger_level
├── enemy_density
├── resource_value
├── environmental_risk
├── visibility
└── reward_multiplier
```

Não deve existir uma relação obrigatória:

```text
Level → Region Access
```

A região pode ser acessível fisicamente, mas perigosa.

---

# 7.2. Transporte

Criar `TravelSystem`.

Tipos:

```text
ON_FOOT
CARAVAN
FAST_TRAVEL
ALIGNMENT_BEACON
```

Cada método possui:

```text
TravelMethodDefinition
├── cost
├── duration
├── requirements
├── risks
└── availability
```

Fast travel deve ser validado por:

```text
DestinationUnlocked
AND
TravelPointActivated
AND
NoBlockingWorldCondition
```

---

# 8. Profissões

## 8.1. Filosofia

Profissões serão implementadas como `ProfessionDefinition` + `ProfessionState`.

Separar:

```text
Definition
```

de:

```text
Runtime State
```

Exemplo:

```text
ProfessionDefinition
├── id
├── display_name
├── max_mastery
├── allowed_actions
├── recipes
└── progression_rules
```

```text
ProfessionState
├── profession_id
├── mastery_level
├── experience
├── rank
└── unlocked_features
```

---

# 8.2. Profissões Potenciais

Cada profissão deve ser registrada por dados.

Não criar:

```text
BlacksmithSystem
MinerSystem
CookSystem
...
```

como sistemas completamente independentes quando compartilharem infraestrutura.

Preferir:

```text
ProfessionSystem
```

com especializações por definição.

---

# 8.3. Progressão Profissional

Modelo:

```text
mastery_level: 1..5
experience: 0..100
```

Transição:

```text
XP >= 100
↓
experience -= 100
mastery_level += 1
```

O comportamento exato de overflow deve ser definido pelo sistema de balanceamento.

---

# 8.4. Limitação por Local

Utilizar `ProgressionGate`.

```text
ProgressionGate
├── requirement_type
├── required_value
├── location_id
└── unlock_source
```

Exemplos:

```text
RequiresMaster
RequiresWorkshop
RequiresQuest
RequiresReputation
RequiresProperty
```

---

# 8.5. Dependência entre Profissões

As dependências devem ser representadas como dados.

```text
Recipe
├── inputs
├── outputs
├── profession_requirement
└── station_requirement
```

Exemplo:

```text
Iron Sword

Inputs:
- Iron Ingot x3
- Leather Grip x1

Profession:
Blacksmith >= 2
```

---

# 9. Progressão do Personagem

## 9.1. Princípio

Criar um `CharacterProgressionComponent`.

```text
CharacterProgression
├── level
├── experience
├── attributes
├── skills
├── professions
├── weapon_proficiencies
└── achievements
```

Reputação deve permanecer em sistema separado devido à sua natureza social.

---

# 9.2. Nível de Personagem

O sistema deve permitir diferentes fontes de XP.

Criar:

```text
ExperienceSource
```

Exemplos:

```text
COMBAT
EXPLORATION
PROFESSION
QUEST
SOCIAL
DISCOVERY
```

O GDD não define ainda a regra definitiva.

Portanto, a arquitetura deve suportar múltiplas estratégias:

```text
IExperienceProvider
```

---

# 9.3. Progressão por Uso

Cada ação relevante pode emitir:

```text
SkillUsageEvent
```

Exemplo:

```text
SkillUsageEvent
├── actor_id
├── skill_id
├── action_id
├── intensity
└── context
```

O `SkillProgressionSystem` converte o evento em XP.

Isso evita que combate, mineração e crafting conheçam internamente o algoritmo de progressão.

---

# 9.4. Atributos

Criar enum/data definition:

```text
STRENGTH
AGILITY
VITALITY
INTELLIGENCE
WISDOM
CHARISMA
```

Os três atributos ainda pendentes devem possuir regras configuráveis.

Evitar criar dependências irreversíveis como:

```text
Charisma = VendorDiscount
```

até o design ser finalizado.

---

# 9.5. Classes

Nenhuma classe rígida deve ser necessária no MVP.

Arquétipos emergentes podem ser derivados:

```text
ArchetypeEvaluator
```

Exemplo:

```text
Sword proficiency > threshold
Heavy armor usage > threshold
Strength > threshold

→ Warrior tendency
```

Esses arquétipos devem ser **informativos**, não controladores do personagem.

---

# 10. Proficiência em Armas

Cada categoria terá:

```text
WeaponProficiencyState
├── weapon_type_id
├── level
├── experience
└── decay
```

A proposta de decaimento deve ser implementada através de uma estratégia configurável.

```text
ProficiencyDecayPolicy
```

Possíveis políticas:

```text
NONE
SLOW_DECAY
RELATIVE_DECAY
SOFT_DECAY
```

A política definitiva permanece pendente.

---

# 11. Combate

## 11.1. Direção

Arquitetura:

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

---

## 11.2. Máquina de Estados

O combatente deve possuir estados:

```text
IDLE
ATTACKING
BLOCKING
PARRYING
DODGING
STAGGERED
HIT
DEAD
```

Transições devem ser explícitas.

---

## 11.3. Defesa

Cada ação deve possuir:

```text
ActionDefinition
├── stamina_cost
├── startup
├── active_window
├── recovery
├── invulnerability
└── interrupt_rules
```

Isso permite balancear combate sem hardcode.

---

# 11.4. Stealth

Criar:

```text
StealthSystem
```

Com:

```text
DetectionScore =
    Visibility
    × LightModifier
    × DistanceModifier
    × NoiseModifier
    × EquipmentModifier
    × MovementModifier
```

NPCs possuem:

```text
PerceptionProfile
├── vision
├── hearing
├── awareness
├── detection_speed
└── memory_duration
```

---

# 11.5. Combate Baseado em Luz

Criaturas podem possuir:

```text
LightReactionProfile
├── darkness_multiplier
├── penumbra_multiplier
├── moderate_multiplier
├── full_light_multiplier
├── fear_threshold
└── flee_behavior
```

O sistema de combate apenas consulta o modificador.

---

# 12. Equipamentos

## 12.1. Categorias

Todos os equipamentos devem utilizar uma arquitetura baseada em:

```text
ItemDefinition
+
EquipmentDefinition
+
EquipmentInstance
```

---

# 12.2. Durabilidade

A durabilidade pertence à instância:

```text
EquipmentInstance
├── instance_id
├── definition_id
├── durability
├── quality
└── modifiers
```

Itens empilháveis não devem possuir instância individual quando isso não for necessário.

---

# 12.3. Evolução de Equipamentos

Separar:

```text
Base Item Definition
```

de:

```text
Runtime Item Instance
```

Isso permite:

```text
Iron Sword
```

ser uma definição, enquanto:

```text
Iron Sword #839102
Durability: 37
Quality: Fine
Modifier: +2 Strength
```

é uma instância.

---

# 13. Loot

## 13.1. Recursos

Recursos devem utilizar tabelas de loot:

```text
LootTable
├── entries
├── weight
├── quantity_range
├── conditions
└── rarity
```

---

# 13.2. Loot de Inimigos

Cada inimigo possui:

```text
LootProfile
```

O resultado deve ser gerado pelo `LootService`.

O inimigo não deve possuir código específico de criação de itens.

---

# 14. Crafting

Crafting será baseado em:

```text
RecipeDefinition
CraftingStationDefinition
ProfessionRequirement
MaterialRequirement
```

Fluxo:

```text
Player Request
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
Consume Materials
↓
Produce Output
↓
Grant Profession XP
↓
Emit CraftCompleted
```

O processo deve ser transacional.

Se uma etapa falhar, nenhuma alteração parcial deve permanecer.

---

# 15. Economia

## 15.1. Economia Local

Cada território possuirá:

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

O preço deve ser calculado através de um `PricingService`.

Modelo inicial:

```text
Price =
BasePrice
× SupplyModifier
× DemandModifier
× SeasonModifier
× TerritoryModifier
× EventModifier
```

Os coeficientes devem ser configuráveis.

---

# 15.2. Economia Global

O sistema global deve funcionar como camada superior.

```text
Local Markets
      ↓
Regional Aggregation
      ↓
Global Indicators
```

O MVP deve evitar implementar uma economia global completa.

Entretanto, APIs devem permitir sua adição.

---

# 15.3. Loja do Jogador

A loja deve ser modelada como:

```text
PlayerMarketListing
├── listing_id
├── seller_id
├── item_instance_id
├── quantity
├── price
├── currency
├── tax
└── expiration
```

O servidor futuro deve ser a autoridade sobre:

- saldo;
- item;
- preço;
- venda;
- taxa.

---

# 15.4. Sistema de Leilão

Arquitetura futura:

```text
AuctionService
├── create_listing()
├── place_bid()
├── cancel_listing()
├── finalize_auction()
└── collect_result()
```

As operações devem ser transacionais e idempotentes.

---

# 15.5. Mercado Negro

O Mercado Negro deve possuir:

```text
BlackMarketDefinition
├── currency_id
├── access_requirements
├── item_pool
├── refresh_policy
└── reputation_requirements
```

A moeda deve ser tratada como uma `CurrencyDefinition`, permitindo múltiplas moedas sem alterar o inventário.

---

# 16. Crenças e Religiões

Religiões devem ser dados:

```text
ReligionDefinition
├── id
├── deity
├── beliefs
├── faction_affinity
├── social_modifiers
└── gameplay_effects
```

O sistema não deve presumir que religião é exclusivamente reputação.

Pode haver:

```text
BeliefState
```

se futuramente houver adesão religiosa do personagem.

---

# 16.1. Conflito Religioso

Conflitos devem utilizar um sistema genérico:

```text
ConflictSystem
```

com severidade:

```text
SOFT
HARD
```

Isso permitirá reutilização para:

- religião;
- facções;
- política;
- territórios.

---

# 17. Facções

## 17.1. Facções Principais

Cada facção deve possuir:

```text
FactionDefinition
├── id
├── ideology
├── territory_ids
├── relationships
├── services
├── access_rules
└── reputation_rules
```

---

# 17.2. Reputação

A reputação será implementada como:

```text
ReputationEntry
├── subject_id
├── value
├── tier
├── last_change
└── history
```

O `subject_id` pode representar:

```text
Faction
Settlement
Religion
NPC
Profession
Territory
```

---

# 17.3. Reputação Multidimensional

A estrutura deve ser:

```text
ReputationComponent
└── Dictionary<ReputationSubjectId, ReputationEntry>
```

Não utilizar uma única variável:

```gdscript
player.reputation = 500
```

---

# 18. Relacionamentos com NPCs

Cada NPC deve possuir:

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

A escala apresentada no GDD pode ser derivada de valores contínuos.

Exemplo:

```text
-100 → Hate
-50  → Dislike
0    → Neutral
25   → Like
60   → Friendship
85   → Love
```

Os valores exatos são balanceáveis.

---

# 19. Quests

## 19.1. Categorias

Todas as quests devem utilizar uma estrutura comum:

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

Tipos:

```text
MAIN
ORIGIN
PROFESSION
FACTION
LOCAL
NPC
DYNAMIC
WORLD_EVENT
```

---

# 19.2. Máquina de Estado de Quest

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

Ou:

```text
FAILED
ABANDONED
EXPIRED
```

---

# 19.3. Quests Emergentes

O sistema deve ser orientado por condições:

```text
WorldCondition
```

Exemplo:

```text
ResourceAvailability < 20%
```

pode ativar:

```text
QuestGenerator
```

O gerador deve consultar templates.

```text
DynamicQuestTemplate
├── trigger
├── objectives
├── target
├── reward_formula
└── narrative_template
```

---

# 20. Territórios

Cada território deve possuir:

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

---

# 20.1. Governo

O governo deve ser implementado como um serviço futuro:

```text
GovernanceSystem
```

Com:

```text
Policy
TaxPolicy
SecurityPolicy
TradePolicy
ResourcePolicy
```

Cada política produz modificadores no território.

---

# 20.2. Exército Local

Forças militares:

```text
DefenseForceState
├── manpower
├── training
├── equipment
├── morale
├── budget
└── readiness
```

A capacidade de defesa deve ser derivada de múltiplos fatores.

---

# 21. Conflitos Territoriais

O `ConflictSystem` deve ser genérico.

Tipos futuros:

```text
ECONOMIC
POLITICAL
RELIGIOUS
MILITARY
TERRITORIAL
```

Estado:

```text
ConflictState
├── participants
├── territory
├── intensity
├── start_time
├── objectives
├── current_score
└── resolution
```

A guerra territorial é Pós-MVP.

---

# 22. Habitação

Habitação deve ser modelada como propriedade:

```text
PropertyDefinition
├── property_id
├── location
├── capacity
├── quality
├── facilities
├── rent
├── purchase_price
└── ownership_rules
```

O jogador possui:

```text
PropertyState
├── property_id
├── owner_id
├── upgrades
├── condition
└── storage
```

---

# 23. Origens

Cada origem será um `OriginDefinition`.

```text
OriginDefinition
├── id
├── starting_location
├── starting_items
├── starting_relationships
├── faction_modifiers
├── initial_quest
└── narrative_flags
```

A origem não deve modificar código do jogador.

Ela deve configurar estado inicial.

---

# 24. Sistema de Achievements

Achievements serão dirigidos por eventos.

```text
AchievementDefinition
├── id
├── trigger_conditions
├── progress_type
├── target_value
└── rewards
```

Exemplo:

```text
Mine 1000 units of ore
```

O sistema observa:

```text
ResourceGatheredEvent
```

e atualiza progresso.

---

# 25. HUD

A UI seguirá padrão **MVVM-like / Presentation Model**, evitando lógica de domínio dentro dos componentes visuais.

Exemplo:

```text
HUD
↓
ViewModel
↓
Gameplay Service
```

A HUD recebe dados:

```text
Health
Energy
Fatigue
Hunger
Temperature
Light
LanternFuel
Panic
Sanity
```

A UI não altera diretamente o estado do jogador.

---

# 26. Multiplayer Cooperativo

## 26.1. Filosofia

A arquitetura será **multiplayer-ready**, mas o MVP não precisa possuir toda a experiência multiplayer.

A principal regra arquitetural é:

```text
Gameplay Core
```

não pode depender de:

```text
Single Player Assumption
```

---

# 26.2. Modelo de Autoridade

A arquitetura futura deve suportar:

```text
Server / Host
      ↓
Authoritative World State
      ↓
Clients
```

O cliente deve enviar intenção:

```text
MoveRequest
AttackRequest
InteractRequest
CraftRequest
TradeRequest
```

O lado autoritativo valida.

---

# 26.3. Identidade

Toda entidade persistente multiplayer deve possuir:

```text
EntityId
```

Nunca depender de:

```text
NodePath
```

como identidade persistente.

---

# 26.4. Sincronização

Separar:

```text
Persistent State
```

de:

```text
Transient State
```

Persistente:

- inventário;
- profissão;
- reputação;
- propriedade;
- quests;
- personagem.

Transitório:

- posição;
- animação;
- efeitos temporários;
- partículas.

---

# 26.5. Idempotência

Operações econômicas e de inventário devem ser idempotentes quando possível.

Exemplo:

```text
TransactionId
```

permite impedir duplicação de item ou moeda caso uma mensagem seja reenviada.

---

# 27. PvP

O PvP permanece fora do núcleo.

Porém, APIs de combate devem utilizar uma abstração:

```text
IDamageable
```

em vez de:

```text
IEnemy
```

Isso permite futuramente:

```text
Player vs Enemy
Player vs Player
Enemy vs NPC
Enemy vs Structure
```

sem reescrever `DamageSystem`.

---

# 28. Matriz de Escopo

A arquitetura deve distinguir:

```text
Implemented
Prototype
Stub
Future Extension
```

## MVP

Prioridade técnica:

```text
1. Player
2. Movement
3. World
4. Time
5. Survival
6. Inventory
7. Items
8. Gathering
9. Crafting
10. Combat
11. Enemies
12. Lighting
13. NPC
14. Quest
15. One Profession
16. Basic Reputation
17. One City
18. One Village
19. Save/Load
```

Multiplayer:

```text
Architecture Ready
Gameplay Deferred
```

---

# 29. Pós-MVP

Os sistemas pós-MVP devem consumir as interfaces existentes.

Não criar uma segunda arquitetura para:

- economia;
- multiplayer;
- profissões;
- reputação;
- facções.

A arquitetura MVP deve possuir pontos de extensão.

---

# 30. Expansões / DLC

Expansões devem ser adicionáveis através de conteúdo:

```text
Content Pack
├── Definitions
├── Scenes
├── Quests
├── Items
├── NPCs
├── Regions
└── Scripts específicos quando necessário
```

O core não deve possuir:

```gdscript
if dlc_enabled:
```

espalhado pelo código.

Preferir registradores:

```text
ContentRegistry
```

---

# 31. Roadmap Macro

## FASE 0 — Fundação

Entregáveis:

- projeto Godot;
- arquitetura base;
- Event Bus;
- Game State;
- Time Service;
- Save Service;
- Entity IDs;
- logging;
- testes.

## FASE 1 — MVP

Implementar:

```text
Movement
World
Time
Survival
Inventory
Gathering
Crafting
Combat
NPC
Quest
Profession
Reputation
Lighting
```

## FASE 2 — Sandbox

Adicionar:

- degradação;
- regeneração;
- clima;
- economia;
- eventos.

## FASE 3 — Social

Adicionar:

- múltiplas profissões;
- facções;
- relacionamentos;
- religiões;
- propriedades.

## FASE 4 — Multiplayer

Adicionar:

- networking;
- authority;
- replication;
- matchmaking/session layer;
- persistent multiplayer state.

## FASE 5 — Territories

Adicionar:

- governance;
- defense;
- territorial conflicts.

## FASE 6 — Endgame

Adicionar:

- world-scale simulation;
- advanced governance;
- global events.

## FASE 7 — Expansions

Adicionar conteúdo modular.

---

# 32. Sistemas que Devem Permanecer como Decisões de Design

As seguintes decisões devem ser representadas tecnicamente como configurações ou interfaces, e não como regras rígidas:

| Decisão                        | Estratégia técnica                  |
| ------------------------------ | ----------------------------------- |
| Progressão linear/não linear   | `IProgressionPolicy`                |
| Classe fixa                    | Não assumir no core                 |
| Classes emergentes             | `ArchetypeEvaluator`                |
| Inteligência/Sabedoria/Carisma | Data-driven                         |
| PvP                            | `IDamageable`                       |
| Sede                           | `SurvivalNeedDefinition` extensível |
| Multiplayer                    | Interfaces de autoridade            |
| Guerra territorial             | `ConflictSystem`                    |
| Governo                        | `GovernanceSystem`                  |
| Religiões                      | `ReligionDefinition`                |
| Outros planetas                | `WorldRegion` extensível            |
| Profissões                     | `ProfessionDefinition`              |
| Cidades                        | `SettlementDefinition`              |
| Moedas                         | `CurrencyDefinition`                |

---

# 33. Princípios de Balanceamento

O balanceamento deve ser dirigido por dados.

Nenhum valor fundamental deve ficar espalhado pelo código.

Evitar:

```gdscript
energy -= 13.5
```

Preferir:

```text
ActivityDefinition.energy_cost
```

---

# 33.1. Configuração de Balanceamento

Criar recursos:

```text
BalanceConfig
├── survival
├── combat
├── economy
├── progression
├── professions
├── loot
└── world
```

Isso permite modificar balanceamento sem alterar lógica.

---

# 33.2. Economia Controlada

Criar mecanismos futuros:

```text
Currency Sink
Currency Source
Item Sink
Item Source
Tax
Repair Cost
Crafting Cost
Listing Fee
Auction Fee
Property Cost
```

O sistema econômico deve permitir medir:

```text
Currency Generated / Day
Currency Destroyed / Day
Items Generated / Day
Items Destroyed / Day
Average Player Wealth
Wealth Distribution
```

---

# 33.3. Profissão com Valor Real

Cada profissão deve possuir métricas:

```text
Production Volume
Demand
Average Profit
Input Cost
Output Value
Dependency Count
Player Adoption
```

Isso será importante para balanceamento futuro.

---

# 34. Experiência Desejada do Jogador

A experiência emergente exige que sistemas emitam eventos observáveis.

Exemplo:

```text
Player becomes homeless
↓
PropertySystem
↓
Employment opportunity
↓
NPC relationship
↓
Profession opportunity
↓
Income
↓
Property acquisition
↓
Reputation
```

Nenhum desses sistemas deve precisar conhecer toda a cadeia.

---

# 35. Definição do Core Game

O core técnico pode ser representado como:

```text
INPUT
↓
PLAYER ACTION
↓
DOMAIN VALIDATION
↓
STATE CHANGE
↓
EVENT
↓
SIMULATION
↓
SECONDARY EFFECTS
↓
PERSISTENCE
↓
PRESENTATION
```

Exemplo:

```text
Player mines ore
        ↓
GatherCommand
        ↓
GatheringSystem
        ↓
ResourceNodeState
        ↓
InventoryState
        ↓
ProfessionProgression
        ↓
TerritoryResourceState
        ↓
Economy
        ↓
Quest Conditions
        ↓
Save
        ↓
HUD
```

---

# 36. Diretriz Central de Design

A arquitetura deve preservar tecnicamente:

> **O personagem não deve ser definido por uma classe central rígida.**

Sua identidade deve ser composta por dados:

```text
Character Identity
=
Origin
+
Skills
+
Professions
+
Equipment
+
Reputation
+
Relationships
+
Choices
+
World State
```

Isso significa que o sistema de personagem deve ser **compositivo**.

---

# 37. Próxima Etapa do GDD / TDD

A próxima etapa de engenharia deve transformar este TDD conceitual em especificações implementáveis.

Para cada sistema, deve ser produzido:

1. Objetivo técnico;
2. Responsabilidade;
3. Escopo;
4. Dependências;
5. Interfaces;
6. Classes;
7. Resources;
8. Nodes;
9. Autoloads;
10. Signals;
11. Events;
12. Commands;
13. Estruturas de dados;
14. Estados;
15. Máquinas de estado;
16. Fluxos;
17. Persistência;
18. Serialização;
19. Regras de autoridade;
20. Regras multiplayer;
21. Testes unitários;
22. Testes de integração;
23. Casos extremos;
24. Critérios de aceitação;
25. Riscos técnicos.

---

# 38. Arquitetura de Sistemas

A implementação inicial deve seguir a seguinte topologia:

```text
                         ┌──────────────────┐
                         │      UI          │
                         └────────┬─────────┘
                                  │
                                  ▼
                       ┌────────────────────┐
                       │ Application Layer  │
                       └─────────┬──────────┘
                                 │
              ┌──────────────────┼──────────────────┐
              ▼                  ▼                  ▼
       ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
       │ Gameplay    │   │ Progression │   │ Social      │
       └──────┬──────┘   └──────┬──────┘   └──────┬──────┘
              │                 │                  │
              └─────────────────┼──────────────────┘
                                ▼
                       ┌──────────────────┐
                       │   Domain State   │
                       └────────┬─────────┘
                                │
                 ┌──────────────┼──────────────┐
                 ▼              ▼              ▼
          ┌────────────┐ ┌────────────┐ ┌────────────┐
          │ World      │ │ Economy    │ │ Persistence│
          └────────────┘ └────────────┘ └────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │   Event Bus      │
                       └──────────────────┘
```

---

# 39. Padrões de Projeto

## 39.1. Composition

Principal padrão para entidades de gameplay.

Exemplo:

```text
Player
├── CharacterController
├── SurvivalComponent
├── InventoryComponent
├── EquipmentComponent
├── CombatComponent
├── StealthComponent
├── ProgressionComponent
└── InteractionComponent
```

---

## 39.2. Observer / Event Bus

Utilizado para comunicação desacoplada.

Exemplo:

```text
ResourceDepleted
```

pode ser consumido por:

- EconomySystem;
- QuestSystem;
- WorldEventSystem;
- UI;
- AchievementSystem.

---

## 39.3. Strategy

Utilizado para regras variáveis:

```text
XP Strategy
Pricing Strategy
Loot Strategy
Progression Strategy
Proficiency Decay Strategy
Travel Strategy
AI Strategy
```

---

## 39.4. Factory

Utilizado para criação de:

- itens;
- inimigos;
- NPCs;
- quests;
- efeitos;
- entidades.

---

## 39.5. State Machine

Obrigatório para sistemas com estados comportamentais complexos:

- combate;
- IA;
- quests;
- NPC;
- interação;
- mundo.

---

## 39.6. Data-Driven Design

Conteúdo deve estar em `Resource`.

Exemplo:

```text
ItemDefinition.tres
EnemyDefinition.tres
RecipeDefinition.tres
ProfessionDefinition.tres
QuestDefinition.tres
FactionDefinition.tres
```

---

# 40. Event Bus

O projeto deve possuir um Event Bus central.

Exemplos:

```text
PlayerLevelChanged
HealthChanged
EnergyChanged
HungerChanged
TemperatureChanged
ItemAdded
ItemRemoved
ItemCrafted
ItemDurabilityChanged
ResourceGathered
ResourceDepleted
EnemyDefeated
QuestStarted
QuestCompleted
ReputationChanged
RelationshipChanged
ProfessionXPChanged
TerritoryChanged
MarketPriceChanged
TimeChanged
SeasonChanged
```

Os eventos devem ser pequenos e sem lógica.

---

# 41. Game State

O estado global deve ser separado em:

```text
GameState
├── WorldState
├── PlayerState
├── QuestState
├── EconomyState
├── SocialState
└── SessionState
```

Não colocar tudo em um único objeto monolítico.

---

# 42. Save System

O save deve utilizar um formato versionado.

Exemplo:

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

Cada versão deve possuir migrador:

```text
SaveVersion 1
↓
Migration
↓
SaveVersion 2
```

Nunca assumir que saves antigos possuem os campos atuais.

---

# 43. Persistência

Devem ser persistidos:

- posição quando necessário;
- inventário;
- equipamentos;
- atributos;
- skills;
- profissão;
- reputação;
- relacionamentos;
- quests;
- propriedades;
- mundo alterado;
- recursos alterados;
- economia persistente.

Não devem necessariamente ser persistidos:

- partículas;
- animações;
- estados visuais;
- objetos puramente temporários.

---

# 44. Identidade das Entidades

Toda entidade persistente deverá possuir:

```text
EntityId
```

Formato recomendado:

```text
StringName
```

ou identificador numérico estável quando a infraestrutura futura justificar.

Nunca utilizar posição da cena como identidade.

---

# 45. Resource vs Node

## Node

Utilizar para:

- comportamento;
- presença no mundo;
- interação;
- física;
- animação;
- visual.

## Resource

Utilizar para:

- definições;
- configuração;
- dados estáticos;
- receitas;
- itens;
- inimigos;
- quests;
- profissões;
- facções.

## Runtime State

Utilizar objetos/componentes para:

- estado mutável;
- progresso;
- inventário;
- durabilidade;
- reputação.

---

# 46. IA

A IA deve ser modular.

Estrutura:

```text
AIController
├── Perception
├── Memory
├── Decision
├── StateMachine
└── ActionExecutor
```

Estados iniciais:

```text
IDLE
PATROL
INVESTIGATE
SEARCH
CHASE
ATTACK
FLEE
RETURN
SLEEP
WORK
SOCIALIZE
```

---

# 47. Navegação

O mundo deve utilizar os sistemas de navegação do Godot de forma desacoplada da IA.

A IA solicita:

```text
NavigationService.request_path(origin, destination)
```

O NPC não deve conhecer a implementação interna do `NavigationServer`.

---

# 48. Interação

Criar uma interface:

```text
IInteractable
```

Possíveis interações:

```text
Talk
Gather
Open
Loot
Craft
Sleep
Trade
Travel
Use
```

Fluxo:

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

---

# 49. Sistema de Inventário

Inventário deve ser independente da UI.

Estrutura:

```text
InventoryState
├── slots
├── capacity
├── weight
└── filters
```

Item stack:

```text
ItemStack
├── item_definition_id
├── quantity
└── instance_data
```

Itens com durabilidade individual devem usar `instance_data`.

---

# 50. Sistema de Status Effects

Criar sistema genérico:

```text
StatusEffect
├── effect_id
├── duration
├── stacks
├── source
└── modifiers
```

Pode representar:

- fome;
- frio;
- buffs;
- debuffs;
- veneno;
- medo;
- pânico;
- efeitos mágicos.

---

# 51. Sistema de Modificadores

Todos os sistemas que alteram atributos devem utilizar uma camada comum:

```text
Modifier
├── stat
├── operation
├── value
├── source
└── duration
```

Operações:

```text
ADD
MULTIPLY
OVERRIDE
```

Exemplo:

```text
Base Stealth = 1.0

Armor = -0.20
Light = +0.10
Skill = +0.30

Final = 1.20
```

---

# 52. Sistema de Tags

Utilizar `StringName`/tags para categorizar entidades.

Exemplos:

```text
weapon
metal
rare
dark_sector
undead
light_sensitive
profession_blacksmith
faction_guardians
```

Tags devem ser usadas para regras genéricas.

---

# 53. Sistema de Configuração

Configurações devem ficar separadas de estado.

```text
GameConfig
BalanceConfig
WorldConfig
CombatConfig
EconomyConfig
NetworkConfig
```

Durante prototipagem, valores podem ser alterados rapidamente.

---

# 54. Logging e Diagnóstico

Criar logger central:

```text
GameLogger
```

Categorias:

```text
SYSTEM
COMBAT
AI
ECONOMY
QUEST
SAVE
NETWORK
PERFORMANCE
ERROR
```

Logs detalhados devem poder ser desativados em build final.

---

# 55. Telemetria de Desenvolvimento

Durante desenvolvimento, registrar métricas:

```text
Average Session Duration
Death Causes
Most Used Profession
Most Used Weapon
Average Wealth
Resource Depletion
Quest Completion
NPC Interaction
Travel Frequency
```

Esses dados devem ser opcionais e inicialmente locais.

---

# 56. Performance

Objetivos iniciais:

- evitar `_process()` desnecessário;
- evitar buscas repetidas por NodePath;
- evitar criação excessiva de objetos temporários;
- usar sinais/eventos quando apropriado;
- processar simulação em intervalos;
- atualizar UI apenas quando houver alteração.

Sistemas de mundo devem possuir diferentes frequências:

```text
Frame:
Input / Rendering

High Frequency:
Combat / Movement

Medium:
AI / Interaction

Low:
Economy / World Simulation

Very Low:
Long-term regeneration
```

---

# 57. World Simulation Tick

A simulação do mundo deve possuir tick próprio.

Exemplo:

```text
1 Game Minute
↓
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

Nem todos os sistemas precisam executar a cada frame.

---

# 58. Streaming do Mundo

O mundo deve poder evoluir de:

```text
Single Scene
```

para:

```text
World
├── Region A
├── Region B
├── Region C
└── Region D
```

A arquitetura deve permitir carregamento por região.

O estado da região deve sobreviver ao unload.

---

# 59. Testes

A estratégia de testes será composta por:

```text
Unit Tests
Integration Tests
Simulation Tests
Save/Load Tests
Gameplay Tests
Performance Tests
Network Tests
```

---

# 60. Testes Unitários

Prioridade:

- XP;
- reputação;
- preços;
- loot;
- crafting;
- durabilidade;
- fome;
- temperatura;
- iluminação;
- progressão;
- requisitos.

Exemplo:

```text
Given:
Iron x3
Leather x1
Blacksmith Level 2

When:
Craft Iron Sword

Then:
Iron -3
Leather -1
Sword +1
Profession XP +X
```

---

# 61. Testes de Integração

Exemplo:

```text
Gathering
+
Inventory
+
Profession
+
Resource Node
+
Event Bus
```

Outro:

```text
Quest
+
World State
+
Reputation
+
NPC
```

---

# 62. Testes de Persistência

Cada sistema persistente deve possuir:

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

O resultado deve ser equivalente.

---

# 63. Testes de Regressão

Toda correção de bug relevante deve gerar um teste.

Regra:

```text
Bug
↓
Reproduce
↓
Test
↓
Fix
↓
Test passes
```

---

# 64. Critérios de Aceitação do MVP

O MVP técnico será considerado funcional quando:

- o jogador puder criar personagem;
- escolher origem;
- movimentar-se;
- explorar;
- coletar recursos;
- possuir itens;
- utilizar equipamentos;
- sofrer necessidades de sobrevivência;
- lutar;
- enfrentar inimigos;
- utilizar iluminação;
- realizar uma profissão;
- completar quests;
- alterar reputação;
- interagir com NPCs;
- utilizar uma cidade;
- utilizar um vilarejo;
- salvar;
- carregar;
- atravessar um ciclo temporal;
- experimentar uma progressão básica completa.

---

# 65. Critérios de Qualidade Arquitetural

O MVP não deve ser considerado tecnicamente concluído se:

- sistemas dependerem diretamente da UI;
- regras críticas estiverem hardcoded em cenas;
- save depender de NodePaths;
- sistemas principais forem monolíticos;
- lógica de domínio estiver duplicada;
- conteúdo estiver codificado diretamente em scripts;
- multiplayer futuro exigir reescrita completa;
- não houver testes para sistemas críticos;
- não for possível carregar e salvar estado confiavelmente.

---

# 66. Riscos Técnicos

## Risco 1 — Escopo

O maior risco do projeto é tentar implementar simultaneamente:

```text
Open World
+
Survival
+
Economy
+
Social Simulation
+
Combat
+
Professions
+
Governance
+
Multiplayer
```

Mitigação:

```text
Vertical Slice
↓
MVP
↓
Validation
↓
Expansion
```

---

## Risco 2 — Economia Excessivamente Complexa

Mitigação:

Começar com:

```text
Base Price
+
Supply
+
Demand
```

e adicionar complexidade somente quando necessária.

---

## Risco 3 — Multiplayer Prematuro

Mitigação:

Preparar:

- IDs;
- estado;
- comandos;
- autoridade;
- persistência.

Mas não implementar toda a camada multiplayer antes da validação do core.

---

## Risco 4 — Acoplamento

Mitigação:

- Event Bus;
- interfaces;
- serviços;
- composição;
- Resources.

---

## Risco 5 — Save Corrompido

Mitigação:

- versionamento;
- atomic save;
- backup;
- validação;
- migração.

---

## Risco 6 — Simulação Excessiva

Mitigação:

Simular somente aquilo que produz consequência observável.

NPCs distantes podem utilizar simulação abstrata:

```text
Offline Simulation
```

em vez de executar IA completa.

---

# 67. Estratégia de Simulação de NPCs

NPCs próximos:

```text
Full Simulation
```

NPCs distantes:

```text
Abstract Simulation
```

Exemplo:

```text
NPC Farmer

Near Player:
Navigation
Animation
AI
Interaction

Far from Player:
Work Progress
Inventory Change
Schedule
Relationship Events
```

Isso será essencial para escalar o mundo.

---

# 68. Offline Simulation

Quando uma região não estiver carregada:

```text
RegionUnload
↓
Capture Simulation State
↓
Advance Logical Time
↓
Apply Abstract Simulation
↓
Store New State
```

Ao carregar:

```text
RegionLoad
↓
Restore State
↓
Spawn Entities
↓
Apply State
```

---

# 69. Determinismo

Sistemas econômicos, loot e simulação devem utilizar RNG controlado quando necessário.

Criar:

```text
RandomService
```

em vez de espalhar chamadas aleatórias.

Isso facilita:

- testes;
- reprodução de bugs;
- multiplayer;
- debugging.

---

# 70. Command Architecture

Ações relevantes devem poder ser representadas por comandos.

Exemplos:

```text
GatherCommand
CraftCommand
AttackCommand
EquipCommand
TradeCommand
TravelCommand
TalkCommand
RestCommand
```

Um comando deve possuir:

```text
CommandId
ActorId
Timestamp
Payload
```

Isso prepara o sistema para replay, networking e debugging.

---

# 71. Event Architecture

Eventos representam fatos já ocorridos.

Diferença:

```text
Command:
"Faça X."

Event:
"X aconteceu."
```

Exemplo:

```text
CraftSwordCommand
```

gera:

```text
ItemCraftedEvent
```

---

# 72. Regra Command/Event

Não confundir:

```text
Command
```

com:

```text
Event
```

Commands podem falhar.

Events representam alterações confirmadas.

---

# 73. Transaction Architecture

Operações que alteram múltiplos sistemas devem possuir transação lógica.

Exemplo de compra:

```text
Validate Seller
Validate Buyer
Validate Item
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

Nunca:

```text
Remove Money
↓
Hope Item Transfer Works
```

---

# 74. Dependency Injection

Serviços globais devem ser acessados por uma camada de registro.

Exemplo:

```text
ServiceRegistry
├── TimeService
├── SaveService
├── EconomyService
├── InventoryService
├── QuestService
└── EventBus
```

Evitar transformar todos os sistemas em Autoloads.

Autoload deve ser utilizado somente quando a natureza global for justificável.

---

# 75. Autoloads Planejados

Inicialmente:

```text
EventBus
TimeService
GameState
SaveService
SceneManager
ServiceRegistry
```

Evitar:

```text
CombatManager
PlayerManager
NPCManager
InventoryManager
QuestManager
...
```

todos como singletons globais sem necessidade.

---

# 76. Cenas

Cenas devem representar composição física.

Exemplo:

```text
Player.tscn
├── CharacterBody2D
├── CollisionShape2D
├── Visual
├── Camera2D / CameraController
├── InteractionDetector
├── CombatComponent
├── SurvivalComponent
└── Audio
```

As regras de domínio não devem depender da estrutura exata da cena.

---

# 77. Componentes

Componentes devem possuir responsabilidade única.

Exemplo:

```text
HealthComponent
```

não deve controlar:

- inventário;
- XP;
- quests;
- UI.

---

# 78. Interfaces

Interfaces conceituais:

```text
IDamageable
IInteractable
IUsable
ICollectable
IContainer
IProgressionSource
IRequirement
ISaveable
IStatusEffectTarget
```

Godot/GDScript pode implementar essas abstrações por contratos convencionais e classes-base leves quando necessário.

---

# 79. Sistema de Requisitos

Criar:

```text
RequirementEvaluator
```

Requisitos compostos:

```text
AND
OR
NOT
```

Exemplo:

```text
CanEnterDarkSector

Requires:
    Reputation >= 20
    AND
    HasLightSource
    AND
    QuestCompleted("dark_gate")
```

Isso elimina condições espalhadas pelo código.

---

# 80. Sistema de Recompensas

Recompensas devem ser declarativas:

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

Quests, achievements e eventos podem reutilizar o mesmo sistema.

---

# 81. Sistema de Flags

Flags de mundo:

```text
WorldFlag
```

Exemplos:

```text
dark_gate_opened
village_rebuilt
ancient_ruin_discovered
faction_war_started
```

Flags devem possuir IDs estáveis e ser persistíveis.

---

# 82. Sistema de Schedules

NPCs e eventos devem possuir schedules:

```text
ScheduleEntry
├── start_time
├── end_time
├── activity
├── location
└── conditions
```

Isso permite:

```text
08:00 → Work
12:00 → Eat
13:00 → Work
18:00 → Tavern
22:00 → Sleep
```

---

# 83. Sistema de Clima

Arquitetura:

```text
ClimateSystem
├── WeatherState
├── RegionClimate
├── SeasonModifiers
├── Forecast
└── WeatherEvents
```

Clima gera modificadores consumidos por:

- sobrevivência;
- agricultura;
- pesca;
- NPC;
- combate;
- navegação.

---

# 84. Sistema de Eventos Mundiais

```text
WorldEventDefinition
├── trigger
├── duration
├── affected_regions
├── modifiers
├── rewards
└── consequences
```

Eventos devem alterar estado, não somente apresentar uma mensagem.

---

# 85. Sistema de Áudio

Áudio deve reagir a estados do mundo.

Exemplo:

```text
Dark Sector
↓
Ambient Audio Profile
```

Combate:

```text
Combat State
↓
Music State
```

O sistema de áudio não deve conter regras de gameplay.

---

# 86. Sistema de Câmera

A câmera deve ser independente do sistema de combate.

Pode possuir modos:

```text
Exploration
Combat
Dialogue
Interaction
```

O `CameraController` recebe estados e muda comportamento.

---

# 87. Input System

Inputs devem ser mapeados através do Input Map do Godot.

A camada de gameplay deve consumir ações sem conhecer teclas.

Exemplo:

```text
move_forward
attack
block
dodge
interact
inventory
```

Nunca:

```gdscript
if Input.is_key_pressed(KEY_W)
```

dentro de gameplay.

---

# 88. Accessibility

A arquitetura de input/UI deve permitir futuramente:

- remapeamento;
- tamanho de UI;
- contraste;
- legendas;
- intensidade de efeitos;
- filtros visuais.

---

# 89. Localização

Textos visíveis ao jogador devem utilizar IDs de tradução.

Exemplo:

```text
quest.dark_gate.title
item.iron_sword.name
faction.guardians.name
```

Nunca hardcodear textos de gameplay diretamente em scripts.

---

# 90. Dados de Conteúdo

Conteúdo deve possuir IDs estáveis.

Exemplo:

```text
item.weapon.iron_sword
profession.blacksmith
faction.alignment_guardians
quest.origin.orphan
territory.port_astraea
```

IDs não devem ser alterados depois que saves forem distribuídos sem um mecanismo de migração.

---

# 91. Controle de Versão

Todo sistema deve possuir:

```text
Owner
Version
Status
Dependencies
```

Mudanças arquiteturais importantes devem ser registradas em:

```text
TECHNICAL_DECISIONS.md
```

O estado atual do projeto deve ser registrado em:

```text
PROJECT_STATE.md
```

O trabalho pendente deve ser registrado em:

```text
BACKLOG.md
```

---

# 92. Definition of Done Técnica

Uma funcionalidade somente será considerada concluída quando:

- implementação realizada;
- testes realizados;
- integração validada;
- persistência validada quando aplicável;
- UI integrada quando aplicável;
- documentação atualizada;
- riscos conhecidos registrados;
- nenhum erro crítico conhecido;
- critérios de aceitação satisfeitos.

---

# 93. Estratégia de Desenvolvimento

Cada sistema deve seguir:

```text
Design
↓
Contract
↓
Data Model
↓
Prototype
↓
Unit Tests
↓
Integration
↓
Gameplay Validation
↓
Optimization
↓
Documentation
```

Não implementar sistemas complexos diretamente na versão final.

---

# 94. Vertical Slice

Antes de expandir o mundo, deve existir um vertical slice contendo:

```text
1 pequena região
1 personagem
1 NPC
1 profissão
1 recurso
1 receita
1 inimigo
1 arma
1 fonte de luz
1 quest
1 ciclo de dia
1 ciclo de sobrevivência
1 fluxo de save/load
```

Esse slice deve provar a arquitetura.

---

# 95. MVP Técnico Recomendado

O primeiro MVP técnico deve ser menor que o escopo conceitual total.

```text
Player
↓
Movement
↓
Small World
↓
Gathering
↓
Inventory
↓
One Profession
↓
Crafting
↓
Combat
↓
Enemy
↓
Lighting
↓
Survival
↓
NPC
↓
Quest
↓
Reputation
↓
Save
```

Somente após esse fluxo ser estável devem ser adicionados sistemas econômicos e sociais mais complexos.

---

# 96. Critério de Arquitetura Preparada para Multiplayer

A arquitetura será considerada preparada quando:

- entidades possuem IDs estáveis;
- estado não depende de NodePath;
- comandos representam ações;
- eventos representam fatos;
- operações críticas são validáveis;
- inventário possui transações;
- economia possui autoridade conceitual;
- save state é separado de apresentação;
- sistemas não dependem diretamente de `_process()`;
- lógica de domínio pode ser executada sem depender da UI.

Isso **não significa que o multiplayer estará implementado**.

---

# 97. Critério de Expansibilidade

Adicionar uma nova profissão deverá exigir principalmente:

```text
New ProfessionDefinition
+
Recipes
+
Stations
+
Progression Data
+
Localization
```

e não:

```text
Alterar 15 sistemas centrais.
```

Adicionar uma nova facção deverá seguir princípio semelhante.

Adicionar uma nova região deverá ser predominantemente uma operação de conteúdo.

---

# 98. Critério de Manutenção

O código deve privilegiar:

- nomes explícitos;
- funções pequenas;
- responsabilidades únicas;
- dependências visíveis;
- dados externos;
- testes;
- documentação;
- logs.

Evitar abstrações prematuras.

Uma abstração deve existir porque existe uma necessidade real de variação, não simplesmente porque "pode ser reutilizada".

---

# 99. Prioridade Arquitetural

A prioridade de engenharia será:

```text
1. Correção
2. Integridade do estado
3. Testabilidade
4. Modularidade
5. Persistência
6. Performance
7. Multiplayer readiness
8. Extensibilidade
9. Conveniência de implementação
```

Performance prematura não deve justificar arquitetura excessivamente complexa.

---

# 100. Conclusão Técnica

**Beneath Five Moons / Lumina Darkness** deve ser construído como um **sandbox sistêmico orientado a dados, eventos e estado persistente**, utilizando Godot 4.7.1.

A arquitetura central deverá permitir que:

```text
O jogador execute ações
        ↓
ações alterem sistemas
        ↓
sistemas alterem o estado do mundo
        ↓
o mundo gere consequências
        ↓
as consequências criem novas oportunidades
        ↓
o jogador tome novas decisões
```

A arquitetura não deve tentar prever todas as futuras mecânicas.

Ela deve, entretanto, estabelecer **pontos de extensão claros** para:

- novas profissões;
- novas armas;
- novas criaturas;
- novas regiões;
- novas facções;
- novas religiões;
- novas economias;
- governo;
- conflitos;
- multiplayer;
- PvP;
- expansões.

O princípio fundamental da implementação é:

```text
DADOS DEFINEM O CONTEÚDO

SISTEMAS DEFINEM AS REGRAS

EVENTOS CONECTAM OS SISTEMAS

ESTADO REPRESENTA O MUNDO

COMANDOS REPRESENTAM INTENÇÕES

PERSISTÊNCIA PRESERVA CONSEQUÊNCIAS

UI APRESENTA O ESTADO

NETWORKING FUTURO DISTRIBUI A AUTORIDADE
```

E, principalmente:

```text
NÃO CONSTRUIR O JOGO COMO UMA COLEÇÃO DE QUESTS.

CONSTRUIR O JOGO COMO UM CONJUNTO DE SISTEMAS
QUE, QUANDO COMBINADOS, PRODUZEM HISTÓRIAS.
```

> **O personagem não deve ser definido pelo que o código diz que ele é.**
>
> **Ele deve ser definido pelo estado que suas ações construíram.**

---

# 101. Próximo Documento Técnico

O próximo passo recomendado é produzir uma segunda camada do TDD, denominada:

**Technical Specification / System Specification**

Cada sistema deverá então receber um documento próprio no seguinte formato:

```text
SYSTEM SPECIFICATION

1. Purpose
2. Scope
3. Responsibilities
4. Non-Responsibilities
5. Dependencies
6. Architecture
7. Data Model
8. Runtime State
9. Classes
10. Components
11. Resources
12. Signals
13. Events
14. Commands
15. Interfaces
16. State Machines
17. Algorithms
18. Persistence
19. Save/Load
20. Multiplayer Considerations
21. Error Handling
22. Performance
23. Unit Tests
24. Integration Tests
25. Edge Cases
26. Acceptance Criteria
27. Debugging Tools
28. Future Extensions
```

A ordem de detalhamento recomendada é:

```text
01. Core Architecture
02. Entity / Component Architecture
03. Game State
04. Time System
05. Save / Load
06. Player
07. Movement
08. Interaction
09. Inventory
10. Items / Equipment
11. Survival
12. Lighting
13. Gathering
14. Crafting
15. Progression
16. Combat
17. Enemy AI
18. NPC AI
19. Quest System
20. Profession System
21. Reputation
22. Relationship System
23. World Simulation
24. Economy
25. Territory
26. Multiplayer Foundation
```

Essa especificação deve ser produzida **antes da implementação de cada sistema complexo**, permitindo que o projeto permaneça tecnicamente rastreável, testável e evolutivo.

---

# 93.1. Baseline Arquitetural Oficial Pós-Decisões

As escolhas abaixo deixam de ser alternativas e passam a ser o baseline oficial:

- **Multiplayer:** `ENetMultiplayerPeer` + `NetworkTransportService` + Listen Server / Host Autoritativo.
- **Navegação:** `NavigationServer2D` → `NavigationRegion2D` → `NavigationAgent2D` → `NavigationService`.
- **World Streaming:** Grid-Based Chunks 2D + Full Simulation nas regiões ativas + Offline/Abstract Simulation nas regiões inativas.
- **Apresentação:** MVVM-like / Presentation Model.
- **UI:** `UIManager` com HUD/Window/Overlay Layers.
- **Persistência multiplayer:** Host autoritativo para WorldState + PlayerState individual.
- **Reconexão:** reserva do jogador por até 60 segundos, com snapshot atual do mundo após reconexão válida.

Qualquer substituição futura exige nova ADR, análise de impacto e atualização sincronizada da documentação.

# 94. Decisões Técnicas a Tomar / Confirmar

## ADR-TDD-001 — Top-Down 2D

**Estado:** APROVADA.

A perspectiva oficial é Top-Down 2D.

**Impactos:**
- `CharacterBody2D`;
- `CollisionShape2D`;
- câmera 2D;
- iluminação 2D;
- navegação 2D;
- cenas 2D;
- pipeline de assets 2D.

---

## ADR-TDD-002 — Camada de Apresentação

**Estado:** APROVADA.

**Padrão:** MVVM-like / Presentation Model. A UI consome dados via ViewModel intermediário, que escuta `EventBus` e/ou consulta `GameState`; a UI não altera diretamente domínio/serviços.

**Estrutura:** `UIManager.tscn` → `HUDLayer`, `WindowLayer`, `OverlayLayer`.

**Tema:** Theme Resource global com tipografia, 9-slices, paleta retro/neon e estados de hover/foco.

## ADR-TDD-003 — Multiplayer Authority

**Estado:** APROVADA.

**Decisão:** Listen Server / Host Autoritativo para Coop, com abstração para Dedicated Server pós-MVP.

**Servidor/Host:** autoridade absoluta sobre `WorldState`, NPCs, spawning, transações econômicas e inventários.

**Cliente:** autoridade sobre física local de movimento (`MovementComponent2D`), enviando `MoveCommand` preditivo e recebendo reconciliação/correção quando necessário.

## ADR-TDD-004 — World Streaming 2D

**Estado:** APROVADA.

**Decisão:** Grid-Based Chunks 2D com Offline / Abstract Simulation.

Regiões ativas executam renderização, física e IA completas. Regiões inativas executam `WorldSimulationTick` para tempo, recursos, rotinas de NPCs e preços. O estado é preservado no unload e reaplicado no retorno.

## ADR-TDD-005 — Save/Load no Multiplayer

**Estado:** APROVADA.

Persistência do mundo centralizada no Host + persistência individual do personagem.

O Host mantém o `WorldState`. O cliente recebe cópia serializada e assinada por HMAC do `PlayerState`. Transações usam `TransactionId` idempotente e rollback local em falhas durante trocas.

## ADR-TDD-006 — Navegação

**Estado:** APROVADA.

**Decisão:** `NavigationServer2D` + `NavigationRegion2D` + `NavigationAgent2D`.

A IA consulta exclusivamente `NavigationService.request_path(origin, destination)`. Obstáculos dinâmicos utilizam `NavigationObstacle2D`.

## ADR-TDD-007 — Performance da Playable Build

**Estado:** APROVADA.

Metas: 60 FPS em `1920 × 1080` em PC intermediário, orçamento de lógica de gameplay ≤ `4 ms/frame` e até 100 NPCs/inimigos com IA ativa na tela como meta inicial.

Movimento/combate em `_physics_process()`; Survival, TimeService, regeneração e economia no `WorldSimulationTick`. As metas devem ser comprovadas por profiling.

## ADR-TDD-008 — UI e Inventário

**Estado:** APROVADA / IMPLEMENTAÇÃO VISUAL.

Inventário visual com `GridContainer`, drag-and-drop nativo, `SwapSlotsCommand`/`MoveItemCommand`, split de stacks, equipamento e tooltip contextual. A UI nunca executa regras de domínio.

