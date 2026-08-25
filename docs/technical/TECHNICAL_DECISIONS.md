# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto.
> O objetivo é evitar que decisões previamente aprovadas sejam alteradas ou esquecidas sem justificativa[cite: 29, 35].

---

# DECISÕES ATIVAS

## ADR-001 — Adoção da Perspectiva 2D Top-Down para a Vertical Slice MVP
**Data:** 2026-08-18 | **Status:** ATIVA[cite: 29, 35]

## ADR-012 — Padrão MVVM/Presentation Model para a Interface de Comércio (TASK-301)
**Data:** 2026-08-21 | **Status:** ATIVA[cite: 29, 35]

## ADR-013 — Implementação do Sistema de Relacionamentos e Afinidade com NPCs (TASK-302)
**Data:** 2026-08-21 | **Status:** ATIVA[cite: 29, 35]

## ADR-014 — Padronização dos Campos Data-Driven da RecipeDefinition (TASK-303 / BUG-002)
**Data:** 2026-08-23 | **Status:** ATIVA[cite: 29, 35]

## ADR-015 — Implementação do PlayerMarketService para a Loja do Jogador (TASK-304)
**Data:** 2026-08-23 | **Status:** ATIVA[cite: 29, 35]

## ADR-016 — Componente de Flora Bioluminescente e Ilhas de Luz Ambientais (POLISH-001)
**Data:** 2026-08-23 | **Status:** ATIVA[cite: 29, 35]

## ADR-017 — Transporte de Rede com ENet
**Data:** 2026-08-24 | **Status:** ATIVA[cite: 29, 35]

## ADR-018 — Listen Server / Host Autoritativo
**Data:** 2026-08-24 | **Status:** ATIVA[cite: 29, 35]

## ADR-019 — Navegação 2D via NavigationServer2D
**Data:** 2026-08-24 | **Status:** ATIVA[cite: 29, 35]

## ADR-020 — Grid-Based Chunks e Offline Simulation
**Data:** 2026-08-24 | **Status:** ATIVA[cite: 29, 35]

## ADR-021 — Save/Load Multiplayer e Idempotência
**Data:** 2026-08-24 | **Status:** ATIVA[cite: 29, 35]

## ADR-022 — Baseline Visual da Playable Build
**Data:** 2026-08-24 | **Status:** ATIVA[cite: 29, 35]

## ADR-023 — Critérios da Playable Build
**Data:** 2026-08-24 | **Status:** ATIVA[cite: 29, 35]

## ADR-024 — Alinhamento de Contrato do EventBus, Ponto de Boot e Inventário Visual (GATE 11 / TASK-408)
**Data:** 2026-08-25 | **Status:** ATIVA  
**Contexto:** Necessidade de instanciar e conectar a janela de inventário visual (`InventoryUI.tscn`) e corrigir o ciclo de bootstrap do `TimeService` no `boot.gd`[cite: 21, 24, 25].  
**Decisão:** 
1. Adicionar os sinais `inventory_toggle_requested`, `inventory_opened` e `inventory_closed` no `event_bus.gd`[cite: 23].
2. Instanciar programmaticamente a cena `res://ui/inventory/InventoryUI.tscn` no script `boot.gd` na camada `CanvasLayer 15` para habilitar a escuta permanente de inputs[cite: 21, 24].
3. Ajustar a inicialização do relógio no `boot.gd` para utilizar o método oficial `TimeService.resume_time()`[cite: 25].  
**Motivo:** Garantir que a pressionar da tecla **"I"** ative e desative a interface do inventário sem acoplamento direto nem dependência de foco prévio[cite: 21, 23, 24].  
**Impactos:** `res://autoload/event_bus.gd`, `res://boot.gd`, `res://ui/inventory/inventory_ui.gd`, `res://autoload/time_service.gd`[cite: 21, 23, 24, 25].
