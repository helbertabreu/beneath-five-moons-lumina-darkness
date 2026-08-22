# BACKLOG.md

> Backlog técnico e de produção do projeto.
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

**Sprint:** Sprint 13 — Sistema de Relacionamentos com NPCs e Afinidade

**Objetivo:** Conclusão, integração e validação atômica da TASK-302 (RelationshipService, Afinidade e Modificadores Comerciais por Afinidade).

| ID | Tarefa | Tipo | Prioridade | Sprint | Dependência | Status | Critério de aceitação |
|---|---|---|---|---|---|---|---|
| TASK-302 | Sistema de Relacionamentos com NPCs e Afinidade | Social | P1 | 13 | TASK-301 | DONE | Criar `RelationshipService`, escala de -100 a +100, doação de presentes e validação via `test_relationship_system.gd` com `[TEST PASSED]`. |

---

# 2. BACKLOG DA FASE 3 (ECONOMIA + PROFISSÕES + SOCIAL)

| ID | Tarefa | Tipo | Prioridade | Dependência | Status |
|---|---|---|---|---|---|
| TASK-301 | Interface Comercial e Integração com PricingService | UI/Systems | P1 | TASK-204 | DONE |
| TASK-302 | Sistema de Relacionamentos com NPCs e Afinidade | Social | P1 | TASK-301 | DONE |
| TASK-303 | Múltiplas Receitas e Estações de Trabalho | Crafting | P1 | TASK-302 | TODO |
| TASK-304 | Loja do Jogador e Mercado Local | Economy | P1 | TASK-303 | TODO |

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

| ID | Bug | Severidade | Prioridade | Sprint | Status |
|---|---|---|---|---|---|
| BUG-001 | Erro de atribuição de Array não tipado no `test_relationship_system.gd` | MÉDIA | P1 | 13 | DONE |

---

# 5. DÍVIDA TÉCNICA

*(Nenhuma dívida técnica registrada no momento)*

---

# 6. POLISH

| ID | Melhoria | Prioridade | Sistema | Status |
|---|---|---|---|---|
| POLISH-001 | Iluminação com ilhas bioluminescentes 2D no Setor Escuro | P3 | Lighting 2D | TODO |

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

- [x] implementação concluída;
- [x] integração concluída;
- [x] comportamento esperado validado;
- [x] edge cases considerados;
- [x] bugs relevantes corrigidos;
- [x] testes realizados;
- [x] critérios de aceitação cumpridos;
- [x] documentação atualizada quando necessário;
- [x] nenhuma regressão conhecida introduzida.

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

## Sprint 1 a 7 — MVP 1.0 (Vertical Slice 2D)
**Objetivo:** Construção e integração de todos os sistemas base de movimentação, sobrevivência, iluminação, coleta, forja, combate, quests e Save/Load.  
**Resultado:** CONCLUÍDAS COM SUCESSO. Todos os testes de integração e persistência aprovados.

## Sprint 8 — Engine de Profissões e Maestria (Fase 2)
**Objetivo:** Implementar o `ProfessionService` e suportar 17 profissões em 5 Tiers.  
**Resultado:** CONCLUÍDA COM SUCESSO.

## Sprint 9 — Economia Dinâmica e Cálculo de Preços (Fase 2)
**Objetivo:** Implementar o `PricingService` para calcular flutuações de preços baseados em oferta/demanda.  
**Resultado:** CONCLUÍDA COM SUCESSO.

## Sprint 10 — Reputação Multidimensional e Facções (Fase 2)
**Objetivo:** Implementar o `FactionService` para gerenciar reputações de 0 a 10.000.  
**Resultado:** CONCLUÍDA COM SUCESSO.

## Sprint 11 — World Streaming e Simulação Offline (Fase 2)
**Objetivo:** Implementar o `WorldRegionManager` e `RegionDefinition`.  
**Resultado:** CONCLUÍDA COM SUCESSO.

## Sprint 12 — Interface Comercial e Precificação Dinâmica (TASK-301)
**Objetivo:** Implementar `shop_interface.gd` e `ShopInterface.tscn`.  
**Resultado:** CONCLUÍDA COM SUCESSO.

## Sprint 13 — Sistema de Relacionamentos com NPCs e Afinidade (TASK-302)
**Objetivo:** Implementar `RelationshipService`, doação de presentes e descontos por afinidade individual.  
**Resultado:** CONCLUÍDA E VALIDADA com a suíte `test_relationship_system.gd` retornando `[TEST PASSED]` no Output!

---

# 11. PRÓXIMA TAREFA

**ID:** TASK-303

**Tarefa:** Múltiplas Receitas e Estações de Trabalho.

**Motivo da prioridade:** Expandir as opções de crafting e encadeamento de produção após consolidar o mercado e as relações sociais.
