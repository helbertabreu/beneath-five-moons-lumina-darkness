# BACKLOG.md

> Backlog técnico e de produção do projeto Beneath Five Moons / Lumina Darkness.
> O backlog representa o trabalho real necessário para levar o projeto ao estado definido pelo GDD[cite: 28, 30].

---

## PRIORIDADES

- **P0 — BLOQUEADOR:** impede o desenvolvimento ou execução[cite: 28, 30].
- **P1 — CORE:** essencial para o gameplay/MVP[cite: 28, 30].
- **P2 — IMPORTANTE:** necessário para uma versão sólida[cite: 28, 30].
- **P3 — POLISH:** qualidade, refinamento e melhorias[cite: 28, 30].
- **P4 — FUTURO:** fora do escopo atual/MVP[cite: 28, 30].

## STATUS

- TODO
- IN PROGRESS
- BLOCKED
- REVIEW
- DONE
- CANCELLED

---

# 1. SPRINT ATUAL — FASE B: APRESENTAÇÃO VISUAL

**Sprint:** Gate 11 — Inventário Visual Concluído / Gate 12 — Mochila & Equipamentos (Sprint 17 / Fase B)[cite: 21, 28]

**Objetivo:** Integrar a camada visual da interface de inventário e equipamentos no bootstrap da Playable Build[cite: 21, 24, 28].

| ID | Tarefa | Tipo | Prioridade | Sprint | Dependência | Status | Critério de aceitação |
|---|---|---|---|---:|---|---|---|
| TASK-401 | Fundação `NetworkTransportService` com `ENetMultiplayerPeer` | Multiplayer | P1 | 17 | TASK-304 | TODO | Host e Client conseguem criar conexão ENet sem acoplamento ao domínio[cite: 28, 30] |
| TASK-402 | Listen Server / Host Autoritativo | Multiplayer | P1 | 17 | TASK-401 | TODO | Host mantém autoridade sobre WorldState e valida comandos[cite: 28, 30] |
| TASK-403 | Classificação e sincronização de estado | Multiplayer | P1 | 17 | TASK-402 | TODO | Estados autoritativos/replicados/preditivos/locais/persistentes/transitórios implementados[cite: 28, 30] |
| TASK-404 | Reconexão de cliente | Multiplayer | P1 | 17 | TASK-403 | TODO | Cliente reconecta em até 60s e recebe snapshot atual[cite: 28, 30] |
| TASK-405 | Transações idempotentes multiplayer | Multiplayer | P1 | 17 | TASK-403 | TODO | Trocas não produzem duplicação após falha de conexão[cite: 28, 30] |
| TASK-406 | Estrutura oficial de cenas 2D | Technical | P1 | 17 | TASK-401 | IN PROGRESS | Player/NPC/Enemy/ResourceNode/Region seguem contratos do TIS[cite: 28] |
| TASK-407 | UIManager + HUD contextual | UI | P1 | 17 | TASK-406 | IN PROGRESS | HUD exibe HP, Estamina, Energia, Lanterna e Luz desacoplados[cite: 19, 28] |
| TASK-408 | Inventário visual | UI | P1 | 17 | TASK-407 | DONE | Grid, drag-and-drop, split, atalho 'I' e janelas funcionam via comandos no boot.gd[cite: 21, 23, 24, 28] |
| TASK-409 | Minimap | UI | P2 | 17 | TASK-407 | TODO | Jogador e marcadores definidos aparecem no minimapa[cite: 28, 30] |
| TASK-410 | Posto Avançado da Garganta de Ferro | World | P1 | 17 | TASK-406 | TODO | Região possui os elementos mínimos definidos no TIS e LDD[cite: 28, 30] |
| TASK-411 | Matriz de testes manuais TM-001/TM-002/TM-003 | QA | P1 | 17 | TASK-410 | IN PROGRESS | Testes manuais executados com evidências registradas[cite: 28] |
| TASK-412 | Validação dos critérios da Playable Build | QA | P1 | 17 | TASK-411 | TODO | 100% dos critérios executados e aprovados[cite: 28, 30] |

---

# 2. BACKLOG DA FASE 3 (ECONOMIA + PROFISSÕES + SOCIAL)

| ID       | Tarefa                                              | Tipo       | Prioridade | Dependência | Status |
| -------- | --------------------------------------------------- | ---------- | ---------- | ----------- | ------ |
| TASK-301 | Interface Comercial e Integração com PricingService | UI/Systems | P1         | TASK-204    | DONE[cite: 28, 30]   |
| TASK-302 | Sistema de Relacionamentos com NPCs e Afinidade     | Social     | P1         | TASK-301    | DONE[cite: 28, 30]   |
| TASK-303 | Múltiplas Receitas e Estações de Trabalho           | Crafting   | P1         | TASK-302    | DONE[cite: 28, 30]   |
| TASK-304 | Loja do Jogador e Mercado Local                     | Economy    | P1         | TASK-303    | DONE[cite: 28, 30]   |

---

# 3. BACKLOG DO MVP (CONCLUÍDO)

| ID       | Tarefa                                               | Tipo        | Prioridade | Dependência | Status |
| -------- | ---------------------------------------------------- | ----------- | ---------- | ----------- | ------ |
| TASK-101 | Input Map Semântico 2D                               | Technical   | P1         | TASK-005    | DONE[cite: 28, 30]   |
| TASK-102 | Player `CharacterBody2D` & `MovementComponent2D`     | Gameplay    | P1         | TASK-101    | DONE[cite: 28, 30]   |
| TASK-103 | Câmera 2D & Mapeamento de Foco                       | Gameplay    | P1         | TASK-102    | DONE[cite: 28, 30]   |
| TASK-104 | `SurvivalComponent` (6 Necessidades)                 | Gameplay    | P1         | TASK-102    | DONE[cite: 28, 30]   |
| TASK-105 | Sistema de Interação 2D (`Area2D` / `IInteractable`) | Gameplay    | P1         | TASK-102    | DONE[cite: 28, 30]   |
| TASK-106 | Engine de Inventário & Instância de Itens            | Gameplay    | P1         | TASK-105    | DONE[cite: 28, 30]   |
| TASK-107 | Coleta de Recurso (Mina de Ferro 2D)                 | Gameplay    | P1         | TASK-106    | DONE[cite: 28, 30]   |
| TASK-108 | Estação de Crafting & Profissão Ferreiro             | Gameplay    | P1         | TASK-107    | DONE[cite: 28, 30]   |
| TASK-109 | Iluminação 2D (`PointLight2D` & `LightingContext`)   | Gameplay    | P1         | TASK-102    | DONE[cite: 28, 30]   |
| TASK-110 | Combate 2D Base & Inimigo Sensível à Luz             | Gameplay    | P1         | TASK-109    | DONE[cite: 28, 30]   |
| TASK-111 | NPC Ferreiro, Diálogo & Quest 01                     | Social      | P1         | TASK-105    | DONE[cite: 28, 30]   |
| TASK-112 | Integração da Gameplay Vertical Slice 2D             | Integration | P1         | TASK-110    | DONE[cite: 28, 30]   |

---

# 4. BUGS

| ID      | Bug                                                                     | Severidade | Prioridade | Sprint | Status |
| ------- | ----------------------------------------------------------------------- | ---------- | ---------- | ------ | ------ |
| BUG-001 | Erro de atribuição de Array não tipado no `test_relationship_system.gd` | MÉDIA      | P1         | 13     | DONE[cite: 28, 30]   |
| BUG-002 | `Invalid assignment of property 'name'` no `forge_node.gd`              | ALTA       | P1         | 14     | DONE[cite: 28, 30]   |
| BUG-003 | Incompatibilidade de assinatura de sinais no EventBus (`event_emitted`) | ALTA       | P1         | 17     | DONE[cite: 28]   |
| BUG-004 | Ausência de cena inicial válida registrada em `project.godot`           | BLOQUEADOR | P0         | 17     | DONE[cite: 28]   |
| BUG-005 | Chamada a método inexistente `resume()` do TimeService no `boot.gd`     | ALTA       | P1         | 17     | DONE[cite: 25]   |

---

# 5. DÍVIDA TÉCNICA

_(Nenhuma dívida técnica registrada no momento)_[cite: 28, 30]

---

# 6. POLISH

| ID         | Melhoria                                                 | Prioridade | Sistema     | Status |
| ---------- | -------------------------------------------------------- | ---------- | ----------- | ------ |
| POLISH-001 | Iluminação com ilhas bioluminescentes 2D no Setor Escuro | P3         | Lighting 2D | DONE[cite: 28, 30]   |

---

# 7. HISTÓRICO RECENTE DE SPRINTS E GATES

## Gate 11 (Inventário Visual — TASK-408)
- Instanciada a cena `InventoryUI.tscn` no bootstrap do projeto (`boot.gd`) na camada `CanvasLayer 15`[cite: 21, 24].
- Adicionado o sinal `inventory_toggle_requested` no `EventBus` e tratamento do atalho físico/semântico da tecla **"I"**[cite: 21, 23].
- Corrigida a instrução de simulação de tempo para `TimeService.resume_time()`[cite: 25].
- **Resultado:** TASK-408 CONCLUÍDA E VALIDADA[cite: 21, 28].

---

# 8. PRÓXIMA TAREFA

**ID:** GATE 12 — MOCHILA E EXPANSAO VISUAL DE SLOTS

**Objetivo:** Dar sequência à apresentação gráfica de itens, ferramenta de tooltips visuais e slots de equipamento[cite: 21, 28].
