# BACKLOG.md

> Backlog técnico e de produção do projeto Beneath Five Moons / Lumina Darkness.
> O backlog deve representar o trabalho real necessário para levar o projeto ao estado definido pelo GDD.

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

# 1. SPRINT ATUAL

**Sprint:** Sprint 10 — Reputação Multidimensional e Facções (Fase 2)

**Objetivo:** Implementar o `FactionService` e `FactionDefinition` para gerenciar reputações multidimensionais de 0 a 10.000, posturas sociais e rivalidades cruzadas com testes unitários validados.

| ID | Tarefa | Tipo | Prioridade | Sprint | Dependência | Status | Critério de aceitação |
|---|---|---|---|---|---|---|---|
| TASK-203 | Reputação Multidimensional e Facções | Social | P1 | 10 | TASK-202 | DONE | Criar o FactionService, FactionDefinition e test_faction_system.gd com 100% de sucesso nos testes unitários. |

---

# 2. BACKLOG DA FASE 2 (PÓS-MVP / EXPANSÃO SANDBOX)

| ID | Tarefa | Tipo | Prioridade | Dependência | Status |
|---|---|---|---|---|---|
| TASK-201 | Engine de Profissões e Maestria | Systems | P1 | TASK-112 | DONE |
| TASK-202 | Economia Dinâmica e Cálculo de Preços | Economy | P1 | TASK-201 | DONE |
| TASK-203 | Reputação Multidimensional e Facções | Social | P1 | TASK-202 | DONE |
| TASK-204 | World Streaming e Simulação Offline | World | P1 | TASK-203 | TODO |

---

# 3. BACKLOG DO MVP (CONCLUÍDO)

| ID | Tarefa | Tipo | Prioridade | Dependência | Status |
|---|---|---|---|---|---|
| TASK-101 | Input Map Semântico 2D | Technical | P1 | TASK-005 | DONE |
| TASK-102 | Player `CharacterBody2D` & `MovementComponent2D` | Gameplay | P1 | TASK-101 | DONE |
| TASK-103 | Câmera 2D & Mapeamento de Foco | Gameplay | P1 | TASK-102 | DONE |
| TASK-104 | `SurvivalComponent` (6 Necessidades) | Gameplay | P1 | TASK-102 | DONE |
| TASK-105 | Sistema de Interação 2D (`Area2D` / `IInteractable`) | Gameplay | P1 | TASK-102 | DONE |
| TASK-106 | Engine de Inventário & Instância de Itens | Gameplay | P1 | TASK-105 | DONE |
| TASK-107 | Coleta de Recurso (Mina de Ferro 2D) | Gameplay | P1 | TASK-106 | DONE |
| TASK-108 | Estação de Crafting & Profissão Ferreiro | Gameplay | P1 | TASK-107 | DONE |
| TASK-109 | Iluminação 2D (`PointLight2D` & `LightingContext`) | Gameplay | P1 | TASK-102 | DONE |
| TASK-110 | Combate 2D Base & Inimigo Sensível à Luz | Gameplay | P1 | TASK-109 | DONE |
| TASK-111 | NPC Ferreiro, Diálogo & Quest 01 | Social | P1 | TASK-105 | DONE |
| TASK-112 | Integração da Gameplay Vertical Slice 2D | Integration | P1 | TASK-110 | DONE |

---

# 4. BUGS

*(Nenhum bug registrado no momento)*

---

# 5. DÍVIDA TÉCNICA

*(Nenhuma dívida técnica registrada no momento)*

---

# 6. POLISH

| ID | Melhoria | Prioridade | Sistema | Status |
|---|---|---|---|---|
| POLISH-001 | Iluminação com ilhas bioluminescentes 2D | P3 | Lighting 2D | TODO |

---

# 7. FUTURO / NICE TO HAVE

| ID | Funcionalidade | Prioridade | Motivo para não implementar agora | Status |
|---|---|---|---|---|
| FUT-001 | Mecânica de Sede | P4 | Removido do MVP conforme decisão ADR-008 | DEFERRED |
| FUT-002 | Multiplayer Cooperativo Ativo | P4 | Exige validação prévia do Single-Player | DEFERRED |
| FUT-003 | Governança de Vilarejos e Guerras | P4 | Recurso de Endgame (Fase 5) | DEFERRED |

---

# 8. DEFINITION OF DONE

Uma tarefa somente pode ser marcada como `DONE` quando:

- [ ] implementação concluída;
- [ ] integração concluída;
- [ ] comportamento esperado validado;
- [ ] edge cases considerados;
- [ ] bugs relevantes corrigidos;
- [ ] testes realizados;
- [ ] critérios de aceitação cumpridos;
- [ ] documentação atualizada quando necessário;
- [ ] nenhuma regressão conhecida introduzida.

---

# 9. REGRAS DO BACKLOG

1. Não criar tarefas duplicadas.
2. Antes de criar uma tarefa, verificar se ela já existe.
3. Não marcar tarefas como DONE sem validação.
4. Dependências devem ser registradas.
5. Bugs críticos têm prioridade sobre polish.
6. O backlog deve refletir o estado real do projeto.
7. Funcionalidades fora do MVP devem ser claramente identificadas.
8. Quando uma tarefa crescer demais, dividi-la em tarefas menores.
9. Ao alterar significativamente o escopo, atualizar o backlog.
10. Manter IDs únicos.

---

# 10. HISTÓRICO DE SPRINTS

## Sprint 0 — Auditoria
**Objetivo:** compreender o estado atual do projeto e alinhar o escopo da Vertical Slice 2D.  
**Resultado:** Aprovado. Decidido transição para perspectiva 2D Top-Down e remoção do parâmetro de Sede do MVP.

## Sprint 1 — Core Architecture & Infrastructure Setup
**Objetivo:** Criar a estrutura base de diretórios, serviços globais, barramento de eventos, relógio lógico e sistema de save atômico.  
**Resultado:** CONCLUÍDA COM SUCESSO. Infrastructure e serviços validados (`[TEST PASSED]`).

## Sprint 2 — Player 2D, Input Map Semântico, Movimento & Câmera 2D
**Objetivo:** Criar a estrutura do jogador 2D, capturar entradas semânticas e permitir movimentação fluida com câmera de enquadramento.  
**Resultado:** CONCLUÍDA COM SUCESSO. Movimentação 2D e acompanhamento da Camera2D validados em execução real.

## Sprint 3 — Survival & Interaction Systems
**Objetivo:** Implementar a mecânica de sobrevivência (6 necessidades) e o detector de interação 2D.  
**Resultado:** CONCLUÍDA COM SUCESSO. Decaimento de Fome validado via `TimeService` e interação do baú com a tecla 'E' testada com sucesso.

## Sprint 4 — Inventory Engine & Crafting Systems
**Objetivo:** Construir o sistema de itens Resource-driven, pilhas, durabilidade de equipamentos, `InventoryService`, nó de coleta e estação de forja.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-106, TASK-107 e TASK-108 testadas e validadas no Output com sucesso!

## Sprint 5 — Lighting System & Basic Combat 2D
**Objetivo:** Criar o modelo e serviço de iluminação 2D sistêmica e o combate base 2D reativo à luz.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-109 e TASK-110 testadas e validadas no Output com o combate e sensibilidade do Lobo à luz!

## Sprint 6 — NPC Ferreiro, Sistema de Diálogos & Quest 01
**Objetivo:** Criar o NPC Ferreiro (Gorn), o modelo de diálogos, o serviço de quests e o fluxo da Quest 01.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-111 validada com aceite, cobrança, entrega e recompensas no Output!

## Sprint 7 — Integration & Vertical Slice Consolidation
**Objetivo:** Consolidar a integração da Vertical Slice 2D, validar os testes de regressão/persistência de todo o ciclo (Coleta -> Crafting -> Combate -> Quests -> Save/Load) e garantir o estado estável da versão 1.0 do MVP.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-112 validada com execução da suíte de teste de integração e persistência com 100% de sucesso!

## Sprint 8 — Engine de Profissões e Maestria (Fase 2)
**Objetivo:** Implementar o `ProfessionService`, o Resource `ProfessionDefinition` e a classe `ProfessionState` para suportar 17 profissões em 5 Tiers.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-201 validada com a execução de `test_profession_system.gd` e retorno `[TEST PASSED]` no Output!

## Sprint 9 — Economia Dinâmica e Cálculo de Preços (Fase 2)
**Objetivo:** Implementar o `PricingService` e `MarketDefinition` para calcular flutuações de preços baseados em oferta/demanda, reputação e impostos.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-202 validada com a execução de `test_pricing_system.gd` e retorno `[TEST PASSED]` no Output!

## Sprint 10 — Reputação Multidimensional e Facções (Fase 2)
**Objetivo:** Implementar o `FactionService` e `FactionDefinition` para gerenciar reputações de 0 a 10.000, posturas e penalidades de rivalidades cruzadas.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-203 validada com a execução de `test_faction_system.gd` e retorno `[TEST PASSED]` no Output!

---

# 11. PRÓXIMA TAREFA

**ID:** TASK-204

**Tarefa:** World Streaming e Simulação Offline (`WorldRegionManager`).

**Motivo da prioridade:** Habilitar a simulação abstrata offline de regiões e transição por mapas no ecossistema de Quintalia.
