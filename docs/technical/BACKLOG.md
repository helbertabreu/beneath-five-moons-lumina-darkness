# BACKLOG.md

> Backlog técnico e de produção do projeto Beneath Five Moons / Lumina Darkness.
> O backlog representa o trabalho real necessário para levar o projeto ao estado definido pelo GDD.

---

## PRIORIDADES

- **P0 — BLOQUEADOR:** impede o desenvolvimento ou execução.
- **P1 — CORE:** essencial para o gameplay/MVP.
- **P2 — IMPORTANTE:** necessário para uma versão sólida.
- **P3 — POLISH:** qualidade, refinamento e melhorias.
- **P4 — FUTURO:** fora do escopo atual/MVP.

## STATUS

- TODO
- IN PROGRESS
- BLOCKED
- REVIEW
- DONE
- CANCELLED

---

# 1. SPRINT ATUAL — FASE B: APRESENTAÇÃO VISUAL

**Sprint:** Gate 10 — HUD Minimalista Concluída / Gate 11 — Inventário Visual Concluído / Gate 12 — Mochila & Equipamentos (Sprint 17 / Fase B)

**Objetivo:** Integrar a camada visual do personagem e as interfaces de inventário/equipamentos no bootstrap da Playable Build.

| ID | Tarefa | Tipo | Prioridade | Sprint | Dependência | Status | Critério de aceitação |
|---|---|---|---|---:|---|---|---|
| TASK-401 | Fundação `NetworkTransportService` com `ENetMultiplayerPeer` | Multiplayer | P1 | 17 | TASK-304 | TODO | Host e Client conseguem criar conexão ENet sem acoplamento ao domínio |
| TASK-402 | Listen Server / Host Autoritativo | Multiplayer | P1 | 17 | TASK-401 | TODO | Host mantém autoridade sobre WorldState e valida comandos |
| TASK-403 | Classificação e sincronização de estado | Multiplayer | P1 | 17 | TASK-402 | TODO | Estados autoritativos/replicados/preditivos/locais/persistentes/transitórios implementados |
| TASK-404 | Reconexão de cliente | Multiplayer | P1 | 17 | TASK-403 | TODO | Cliente reconecta em até 60s e recebe snapshot atual |
| TASK-405 | Transações idempotentes multiplayer | Multiplayer | P1 | 17 | TASK-403 | TODO | Trocas não produzem duplicação após falha de conexão |
| TASK-406 | Estrutura oficial de cenas 2D | Technical | P1 | 17 | TASK-401 | DONE | Player2D (`player.gd`) atualizado com sufixos direcionais, lanterna e sombra |
| TASK-407 | UIManager + HUD contextual | UI | P1 | 17 | TASK-406 | DONE | HUD exibe HP, Estamina, Energia, Lanterna e Luz desacoplados com tema gráfico |
| TASK-408 | Inventário visual | UI | P1 | 17 | TASK-407 | DONE | Grid, drag-and-drop, split, atalho 'I' e janelas funcionam no `boot.gd` |
| TASK-409 | Minimap | UI | P2 | 17 | TASK-407 | TODO | Jogador e marcadores definidos aparecem no minimapa |
| TASK-410 | Posto Avançado da Garganta de Ferro | World | P1 | 17 | TASK-406 | TODO | Região possui os elementos mínimos definidos no TIS e LDD |
| TASK-411 | Matriz de testes manuais TM-001/TM-002/TM-003 | QA | P1 | 17 | TASK-410 | IN PROGRESS | Testes manuais executados com evidências registradas |
| TASK-412 | Validação dos critérios da Playable Build | QA | P1 | 17 | TASK-411 | TODO | 100% dos critérios executados e aprovados |

---

# 2. BACKLOG DA FASE 3 (ECONOMIA + PROFISSÕES + SOCIAL)

| ID       | Tarefa                                              | Tipo       | Prioridade | Dependência | Status |
| -------- | --------------------------------------------------- | ---------- | ---------- | ----------- | ------ |
| TASK-301 | Interface Comercial e Integração com PricingService | UI/Systems | P1         | TASK-204    | DONE   |
| TASK-302 | Sistema de Relacionamentos com NPCs e Afinidade     | Social     | P1         | TASK-301    | DONE   |
| TASK-303 | Múltiplas Receitas e Estações de Trabalho           | Crafting   | P1         | TASK-302    | DONE   |
| TASK-304 | Loja do Jogador e Mercado Local                     | Economy    | P1         | TASK-303    | DONE   |

---

# 3. BACKLOG DO MVP (CONCLUÍDO)

| ID       | Tarefa                                               | Tipo        | Prioridade | Dependência | Status |
| -------- | ---------------------------------------------------- | ----------- | ---------- | ----------- | ------ |
| TASK-101 | Input Map Semântico 2D                               | Technical   | P1         | TASK-005    | DONE   |
| TASK-102 | Player `CharacterBody2D` & `MovementComponent2D`     | Gameplay    | P1         | TASK-101    | DONE   |
| TASK-103 | Câmera 2D & Mapeamento de Foco                       | Gameplay    | P1         | TASK-102    | DONE   |
| TASK-104 | `SurvivalComponent` (6 Necessidades)                 | Gameplay    | P1         | TASK-102    | DONE   |
| TASK-105 | Sistema de Interação 2D (`Area2D` / `IInteractable`) | Gameplay    | P1         | TASK-102    | DONE   |
| TASK-106 | Engine de Inventário & Instância de Itens            | Gameplay    | P1         | TASK-105    | DONE   |
| TASK-107 | Coleta de Recurso (Mina de Ferro 2D)                 | Gameplay    | P1         | TASK-106    | DONE   |
| TASK-108 | Estação de Crafting & Profissão Ferreiro             | Gameplay    | P1         | TASK-107    | DONE   |
| TASK-109 | Iluminação 2D (`PointLight2D` & `LightingContext`)   | Gameplay    | P1         | TASK-102    | DONE   |
| TASK-110 | Combate 2D Base & Inimigo Sensível à Luz             | Gameplay    | P1         | TASK-109    | DONE   |
| TASK-111 | NPC Ferreiro, Diálogo & Quest 01                     | Social      | P1         | TASK-105    | DONE   |
| TASK-112 | Integração da Gameplay Vertical Slice 2D             | Integration | P1         | TASK-110    | DONE   |

---

# 4. BUGS

| ID      | Bug                                                                     | Severidade | Prioridade | Sprint | Status |
| ------- | ----------------------------------------------------------------------- | ---------- | ---------- | ------ | ------ |
| BUG-001 | Erro de atribuição de Array não tipado no `test_relationship_system.gd` | MÉDIA      | P1         | 13     | DONE   |
| BUG-002 | `Invalid assignment of property 'name'` no `forge_node.gd`              | ALTA       | P1         | 14     | DONE   |
| BUG-003 | Incompatibilidade de assinatura de sinais no EventBus (`event_emitted`) | ALTA       | P1         | 17     | DONE   |
| BUG-004 | Ausência de cena inicial válida registrada em `project.godot`           | BLOQUEADOR | P0         | 17     | DONE   |
| BUG-005 | Chamada a método inexistente `resume()` do TimeService no `boot.gd`     | ALTA       | P1         | 17     | DONE   |
| BUG-006 | Exceção de cast nulo C++ (`rp_child`) em `add_child()` em `hud.gd`       | BLOQUEADOR | P0         | 17     | DONE   |

---

# 5. DÍVIDA TÉCNICA

_(Nenhuma dívida técnica registrada no momento)_

---

# 6. POLISH

| ID         | Melhoria                                                 | Prioridade | Sistema     | Status |
| ---------- | -------------------------------------------------------- | ---------- | ----------- | ------ |
| POLISH-001 | Iluminação com ilhas bioluminescentes 2D no Setor Escuro | P3         | Lighting 2D | DONE   |

---

# 7. HISTÓRICO RECENTE DE SPRINTS E GATES

## Gate 8 (Player Visual — TASK-406)
- Atualizado o arquivo `res://entities/player/player.gd` com o helper `_get_direction_suffix(dir: Vector2)`.
- Adicionado suporte às animações octodirecionais de caminhada e corrida.
- **Resultado:** GATE 8 CONCLUÍDO E VALIDADO.

## Gate 10 (HUD Contextual — TASK-407)
- Corrigida a tipagem da subjanela de inventário para `CanvasLayer` em `hud.gd`.
- Vinculado o recurso de tema `main_theme.tres` ao nó raiz da HUD.
- **Resultado:** TASK-407 CONCLUÍDA E VALIDADA.

## Gate 11 (Inventário Visual — TASK-408)
- Instanciada a cena `InventoryUI.tscn` no bootstrap do projeto (`boot.gd`) na camada `CanvasLayer 15`.
- Adicionado o sinal `inventory_toggle_requested` no `EventBus` e tratamento do atalho físico/semântico da tecla **"I"**.
- **Resultado:** TASK-408 CONCLUÍDA E VALIDADA.

---

# 8. PRÓXIMA TAREFA

**ID:** GATE 12 — MOCHILA E EXPANSAO VISUAL DE SLOTS

**Objetivo:** Dar sequência à apresentação gráfica de itens, ferramenta de tooltips visuais e slots de equipamento.
