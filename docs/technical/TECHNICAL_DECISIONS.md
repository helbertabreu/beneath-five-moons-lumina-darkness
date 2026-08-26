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

## ADR-017 — Transporte de Rede com ENet
**Data:** 2026-08-24 | **Status:** ATIVA

## ADR-018 — Listen Server / Host Autoritativo
**Data:** 2026-08-24 | **Status:** ATIVA

## ADR-019 — Navegação 2D via NavigationServer2D
**Data:** 2026-08-24 | **Status:** ATIVA

## ADR-020 — Grid-Based Chunks e Offline Simulation
**Data:** 2026-08-24 | **Status:** ATIVA

## ADR-021 — Save/Load Multiplayer e Idempotência
**Data:** 2026-08-24 | **Status:** ATIVA

## ADR-022 — Baseline Visual da Playable Build
**Data:** 2026-08-24 | **Status:** ATIVA

## ADR-023 — Critérios da Playable Build
**Data:** 2026-08-24 | **Status:** ATIVA

## ADR-024 — Alinhamento de Contrato do EventBus, Ponto de Boot e Inventário Visual (GATE 11 / TASK-408)
**Data:** 2026-08-25 | **Status:** ATIVA  
**Contexto:** Necessidade de instanciar e conectar a janela de inventário visual (`InventoryUI.tscn`) e corrigir o ciclo de bootstrap do `TimeService` no `boot.gd`.  
**Decisão:** 
1. Adicionar os sinais `inventory_toggle_requested`, `inventory_opened` e `inventory_closed` no `event_bus.gd`.
2. Instanciar programmaticamente a cena `res://ui/inventory/InventoryUI.tscn` no script `boot.gd` na camada `CanvasLayer 15` para habilitar a escuta permanente de inputs.
3. Ajustar a inicialização do relógio no `boot.gd` para utilizar o método oficial `TimeService.resume_time()`.  
**Motivo:** Garantir que o acionamento da tecla **"I"** ative e desative a interface do inventário sem acoplamento direto nem dependência de foco prévio.  
**Impactos:** `res://autoload/event_bus.gd`, `res://boot.gd`, `res://ui/inventory/inventory_ui.gd`, `res://autoload/time_service.gd`.

## ADR-025 — Suporte a Animações Direcionais e Estado Visual no Player (GATE 8 / TASK-406)
**Data:** 2026-08-25 | **Status:** ATIVA  
**Contexto:** Implementação da camada visual de apresentação do personagem 2D no script `player.gd`.  
**Decisão:** 
1. Adicionar a função privada `_get_direction_suffix(dir: Vector2) -> String` para mapear os vetores de entrada nos sufixos `right`, `left`, `down` e `up`.
2. Atualizar a lógica de execução do `AnimationPlayer` em `_update_presentation()` para selecionar dinamicamente entre o prefixo `walk_` ou `sprint_` combinado ao sufixo direcional.
3. Preservar o espelhamento do `Sprite2D` via `flip_h` para direções à esquerda e manter desacoplada a posição da lanterna no `LanternAnchor`.  
**Motivo:** Garantir alinhamento com o asset `SpriteSheetPlayer.png` (`AST-002`) e responder com precisão visual às ações de caminhada e corrida sem violar o `MovementComponent2D`.  
**Impactos:** `res://entities/player/player.gd`, `res://assets/textures/entities/SpriteSheetPlayer.png`.

## ADR-026 — Compatibilização de Tipagem em Controladores de UI para Subjanelas CanvasLayer (GATE 10 / BUG-006)
**Data:** 2026-08-25 | **Status:** ATIVA  
**Contexto:** Ao carregar a subjanela `inventory_ui.tscn` dentro de `hud.gd`, a engine emitia um erro fatal C++ (`rp_child is null`) devido ao cast estrito `as Control` aplicado sobre uma cena com nó raiz do tipo `CanvasLayer`.  
**Decisão:** 
1. Ajustar a declaração da variável `_inventory_ui_instance` em `hud.gd` para o tipo `CanvasLayer` (ou nó base compatível).
2. Adicionar o teste de validação de instância `is_instance_valid()` antes de invocar `add_child()`.
3. Implementar um fallback de instanciação por código via `InventoryUI.new()` em caso de falha de carregamento da cena.  
**Motivo:** Assegurar que janelas flutuantes e sobreposições baseadas em `CanvasLayer` possam ser acopladas na hierarquia de UI sem quebras de cast de tipo em tempo de execução.  
**Impactos:** `res://ui/hud/hud.gd`, `res://ui/inventory/inventory_ui.gd`, `res://ui/inventory/inventory_ui.tscn`.
