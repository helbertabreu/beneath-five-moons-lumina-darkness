# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto.
> O objetivo é evitar que decisões previamente aprovadas sejam alteradas ou esquecidas sem justificativa.

---

# STATUS POSSÍVEIS

- PROPOSTA
- ATIVA
- SUPERADA
- CANCELADA

---

# DECISÕES ATIVAS

## ADR-001 — ServiceRegistry & Injeção de Dependências Desacoplada

**Data:** 2026-08-18

**Status:** ATIVA

### Contexto

Sistemas do jogo precisam se comunicar de forma desacoplada sem que tudo se torne um singleton/Autoload rígido.

### Decisão

Utilizar o `ServiceRegistry` como nó central de registro e obtenção de serviços do sistema no Boot (`TimeService`, `SaveService`, `InventoryService`, `LightingService`, `QuestService`, `ProfessionService`).

---

## ADR-008 — Migração para 2D Top-Down no Godot 4.7.1

**Data:** 2026-08-18

**Status:** ATIVA

### Contexto

GDD original citava 3ª Pessoa 3D, exigindo um volume massivo de assets e complexidade física incompatível com o desenvolvimento solo do MVP.

### Decisão

Migrar a perspectiva e toda a simulação física/renderização para **2D Top-Down**, mantendo todas as mecânicas sistêmicas intactas (`CharacterBody2D`, `PointLight2D`, `Area2D`).

---

## ADR-009 — Contrato Genérico para Interações 2D (`IInteractable`)

**Data:** 2026-08-20

**Status:** ATIVA

### Contexto

A Sprint 3 exigia que o jogador interagisse com múltiplos elementos do mapa (baús, nós de minério, NPCs) sem que o Player precisasse conhecer a classe concreta de cada objeto.

### Decisão

Adotar o padrão de detecção dinâmica via `InteractionDetector2D` baseado em `Area2D`, que valida a existência dos métodos de contrato (`can_interact` e `interact`) nos nós detectados.

---

## ADR-010 — Arquitetura de Inventário Transactional Resource-Driven

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A Sprint 4 exigia a gestão de itens empilháveis e instâncias de equipamentos com durabilidade, sem acoplar regras de itens a nós visuais de UI.

### Decisão

Separar rigorosamente a definição estática (`ItemDefinition` como `Resource`), o estado runtime de pilhas (`ItemStack` como `RefCounted`), as instâncias com durabilidade (`EquipmentInstance`) e o gerenciador transactional (`InventoryService`).

---

## ADR-011 — Iluminação Sistêmica Desacoplada (`LightingContext` & `LightingService`)

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A TASK-109 exigia um sistema de luz que alterasse os estados de visibilidade sem acoplar diretamente nós de renderização com combate ou stealth.

### Decisão

Criar o `LightingContext` (objeto `RefCounted` com normalização de 0.0 a 1.0) e o `LightingService` global. A iluminação transmite alterações categorizadas via `EventBus` (`LightLevelChanged`), permitindo que criaturas e mecânicas de sobrevivência consumam o nível de luz sem acoplamento direto com os nós de luz.

---

## ADR-012 — Sistema de Combate Action 2D e Sensibilidade à Luz (`IDamageable`)

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A TASK-110 exigia a implementação do combate 2D melee e do primeiro inimigo (Lobo Esfomeado) reativo ao nível de luz, sem acoplar o Player diretamente à classe do inimigo.

### Decisão

Implementar o `DamageContext` (dados da intenção de dano) e delegar a recepção ao contrato `receive_damage` no nó do inimigo. O inimigo consulta o `LightingService` no momento do impacto e aplica modificadores defensivos (dobrando o dano recebido caso exposto à Luz Plena).

---

## ADR-013 — Sistema de Quests Transacionais e Recompensas SOCIAIS/FINANCEIRAS

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A TASK-111 exigia um sistema de missões orientado a dados (`QuestDefinition`) e um runtime de controle (`QuestService`) capaz de validar inventários antes da entrega.

### Decisão

Implementar o `QuestService` registrado no `ServiceRegistry`. NPCs avaliam o estado da Quest de forma transacional, consumindo itens requeridos do `InventoryService`, emitindo alterações de reputação via `EventBus` e concedendo moedas sem acoplamento rígido.

---

## ADR-014 — Suporte a Save/Load Payload Genérico no SaveService

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A suíte de testes de integração da Vertical Slice (TASK-112) precisava validar o ciclo atômico de gravação e leitura em disco de dicionários de estado arbitrários do jogo sem desacoplar do objeto `GameStateData`.

### Decisão

Expandir a API pública do `SaveService.gd` adicionando os métodos `save_game_data(payload: Dictionary, slot_name: String)` e `load_game_data(slot_name: String) -> Dictionary`, fazendo com que os métodos de alto nível `save_game()` e `load_game()` consumam essas rotinas utilitárias.

---

## ADR-015 — Engine de Profissões e Maestria Desacoplada (Fase 2)

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A Fase 2 do projeto exige a expansão do sistema para suportar 17 profissões com 5 Tiers de Maestria (1–100 XP por Tier) sem duplicar código para cada profissão concreta.

### Decisão

Criar a arquitetura genérica composta por `ProfessionDefinition` (Resource estático com requisitos e bônus), `ProfessionState` (RefCounted mutável com cálculo de XP/Tier) e `ProfessionService` (Gerenciador global registrado no `ServiceRegistry`).
