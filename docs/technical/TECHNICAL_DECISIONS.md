# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto.
> O objetivo é evitar que decisões previamente aprovadas sejam alteradas ou esquecidas sem justificativa.

---

# DECISÕES ATIVAS

## ADR-001 — Adoção da Perspectiva 2D Top-Down para a Vertical Slice MVP
**Data:** 2026-08-18 | **Status:** ATIVA

## ADR-012 — Padrão MVVM/Presentation Model para a Interface de Comércio (TASK-301)
**Data:** 2026-08-21 | **Status:** ATIVA

## ADR-013 — Implementação do Sistema de Relacionamentos e Afinidade com NPCs (TASK-302)
**Data:** 2026-08-21 | **Status:** ATIVA

## ADR-014 — Padronização dos Campos Data-Driven da RecipeDefinition (TASK-303 / BUG-002)
**Data:** 2026-08-23 | **Status:** ATIVA

## ADR-015 — Implementação do PlayerMarketService para a Loja do Jogador (TASK-304)
**Data:** 2026-08-23 | **Status:** ATIVA

## ADR-016 — Componente de Flora Bioluminescente e Ilhas de Luz Ambientais (POLISH-001)
**Data:** 2026-08-23 | **Status:** ATIVA

---

## ADR-017 — Transporte de Rede com ENet
**Data:** 2026-08-24 | **Status:** ATIVA  
**Contexto:** Início da preparação para o modo Multiplayer Cooperativo.  
**Decisão:** Utilizar `ENetMultiplayerPeer` nativo do Godot 4.7.1, encapsulado por `NetworkTransportService`.

---

## ADR-018 — Listen Server / Host Autoritativo
**Data:** 2026-08-24 | **Status:** ATIVA  
**Decisão:** Listen Server / Host Autoritativo para o modo coop. Host mantém autoridade absoluta sobre WorldState, NPCs, spawning, economia, inventários e transações.

---

## ADR-019 — Navegação 2D via NavigationServer2D
**Data:** 2026-08-24 | **Status:** ATIVA  
**Decisão:** `NavigationServer2D` + `NavigationRegion2D` + `NavigationAgent2D`, acessados pela IA exclusivamente através do `NavigationService`.

---

## ADR-020 — Grid-Based Chunks e Offline Simulation
**Data:** 2026-08-24 | **Status:** ATIVA  
**Decisão:** Streaming por Grid-Based Chunks 2D. Regiões ativas usam Full Simulation; regiões inativas usam Offline/Abstract Simulation.

---

## ADR-021 — Save/Load Multiplayer e Idempotência
**Data:** 2026-08-24 | **Status:** ATIVA  
**Decisão:** WorldState persistido pelo Host; PlayerState individual preservado para o jogador com validação HMAC e transações com `TransactionId` idempotente.

---

## ADR-022 — Baseline Visual da Playable Build
**Data:** 2026-08-24 | **Status:** ATIVA  
**Decisão:** Direção artística Pixel Art Neons/Chiaroscuro, resolução-base `640 × 360`, tiles `16 × 16`, Player `32 × 32`, Pixel Snap e iluminação 2D nativa.

---

## ADR-023 — Critérios da Playable Build
**Data:** 2026-08-24 | **Status:** ATIVA  
**Decisão:** Critérios de aceite definidos e vinculados à execução de testes manuais com evidências obrigatórias antes da marcação como DONE.

---

## ADR-024 — Alinhamento de Contrato do EventBus e Ponto de Boot Principal
**Data:** 2026-08-25 | **Status:** ATIVA  
**Contexto:** Identificados os bugs `BUG-003` (ausência do sinal genérico `event_emitted` no `EventBus`) e `BUG-004` (caminho quebrado de cena inicial em `project.godot`).  
**Decisão:** 
1. Adicionar o sinal `signal event_emitted(event_name: StringName, payload: Dictionary)` e a função de despacho desacoplado `emit_event` no `event_bus.gd`.
2. Reconfigurar o parâmetro `run/main_scene` no `project.godot` apontando oficialmente para `res://tests/Boot.tscn`.  
**Motivo:** Reestabelecer a comunicação desacoplada com componentes de interface (`HUDView`) e garantir a inicialização automatizada de Boot e testes de regressão (`boot.gd`).  
**Impactos:** `res://autoload/event_bus.gd`, `project.godot`, `res://tests/Boot.tscn`, `res://ui/hud/hud.gd`.
