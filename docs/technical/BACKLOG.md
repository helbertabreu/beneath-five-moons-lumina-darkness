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

**Sprint:** Sprint 12 — Interface Comercial e Precificação Dinâmica

**Objetivo:** Conclusão, correção de runtime e validação atômica da TASK-301 (Interface Comercial 2D e Integração com PricingService).

| ID | Tarefa | Tipo | Prioridade | Sprint | Dependência | Status | Critério de aceitação |
|---|---|---|---|---|---|---|---|
| TASK-301 | Interface Comercial e Integração com PricingService | UI/Systems | P1 | 12 | TASK-204 | DONE | Criar a janela de loja de NPCs consumindo preços calculados pelo PricingService, descontos de reputação e validada via `test_shop_system.gd` com `[TEST PASSED]`. |

---

# 2. BACKLOG DA FASE 3 (ECONOMIA + PROFISSÕES + SOCIAL)

| ID | Tarefa | Tipo | Prioridade | Dependência | Status |
|---|---|---|---|---|---|
| TASK-301 | Interface Comercial e Integração com PricingService | UI/Systems | P1 | TASK-204 | DONE |
| TASK-302 | Sistema de Relacionamentos com NPCs e Afinidade | Social | P1 | TASK-301 | TODO |
| TASK-303 | Múltiplas Receitas e Estações de Trabalho | Crafting | P1 | TASK-302 | TODO |
| TASK-304 | Loja do Jogador e Mercado Local | Economy | P1 | TASK-303 | TODO |

---

# 3. BACKLOG DA FASE 2 (CONCLUÍDO)

| ID | Tarefa | Tipo | Prioridade | Dependência | Status |
|---|---|---|---|---|---|
| TASK-201 | Engine de Profissões e Maestria | Systems | P1 | TASK-112 | DONE |
| TASK-202 | Economia Dinâmica e Cálculo de Preços | Economy | P1 | TASK-201 | DONE |
| TASK-203 | Reputação Multidimensional e Facções | Social | P1 | TASK-202 | DONE |
| TASK-204 | World Streaming e Simulação Offline | World | P1 | TASK-203 | DONE |

---

# 4. BACKLOG DO MVP (CONCLUÍDO)

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

# 5. BUGS

*(Nenhum bug registrado no momento)*

---

# 6. DÍVIDA TÉCNICA

*(Nenhuma dívida técnica registrada no momento)*

---

# 7. POLISH

| ID | Melhoria | Prioridade | Sistema | Status |
|---|---|---|---|---|
| POLISH-001 | Iluminação com ilhas bioluminescentes 2D | P3 | Lighting 2D | TODO |

---

# 8. FUTURO / NICE TO HAVE

| ID | Funcionalidade | Prioridade | Motivo para não implementar agora | Status |
|---|---|---|---|---|
| FUT-001 | Mecânica de Sede | P4 | Removido do MVP conforme decisão ADR-008 | DEFERRED |
| FUT-002 | Multiplayer Cooperativo Ativo | P4 | Exige validação prévia do Single-Player | DEFERRED |
| FUT-003 | Governança de Vilarejos e Guerras | P4 | Recurso de Endgame (Fase 5) | DEFERRED |

---

# 9. DEFINITION OF DONE

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

# 10. HISTÓRICO DE SPRINTS

## Sprint 0 — Auditoria
**Objetivo:** compreender o estado atual do projeto e alinhar o escopo da Vertical Slice 2D.  
**Resultado:** Aprovado. Decidido transição para perspectiva 2D Top-Down e remoção do parâmetro de Sede do MVP.

## Sprint 1 a 7 — MVP 1.0 (Vertical Slice 2D)
**Objetivo:** Construção e integração de todos os sistemas base de movimentação, sobrevivência, iluminação, coleta, forja, combate, quests e Save/Load.  
**Resultado:** CONCLUÍDAS COM SUCESSO. Todos os testes de integração e persistência aprovados com 100% de sucesso.

## Sprint 8 — Engine de Profissões e Maestria (Fase 2)
**Objetivo:** Implementar o `ProfessionService`, o Resource `ProfessionDefinition` e a classe `ProfessionState` para suportar 17 profissões em 5 Tiers.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-201 validada com a execução de `test_profession_system.gd` e retorno `[TEST PASSED]` no Output!

## Sprint 9 — Economia Dinâmica e Cálculo de Preços (Fase 2)
**Objetivo:** Implementar o `PricingService` e `MarketDefinition` para calcular flutuações de preços baseados em oferta/demanda, reputação e impostos.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-202 validada com a execução de `test_pricing_system.gd` e retorno `[TEST PASSED]` no Output!

## Sprint 10 — Reputação Multidimensional e Facções (Fase 2)
**Objetivo:** Implementar o `FactionService` e `FactionDefinition` para gerenciar reputações de 0 a 10.000, posturas e penalidades de rivalidades cruzadas.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-203 validada com a execução de `test_faction_system.gd` e retorno `[TEST PASSED]` no Output!

## Sprint 11 — World Streaming e Simulação Offline (Fase 2)
**Objetivo:** Implementar o `WorldRegionManager` e `RegionDefinition` para descarregar regiões mantendo simulação temporal e persistência.  
**Resultado:** CONCLUÍDA COM SUCESSO. TASK-204 validada com a execução de `test_world_streaming.gd` e retorno `[TEST PASSED]` no Output!

## Sprint 12 — Interface Comercial e Integração com PricingService (Fase 3 / TASK-301)
**Objetivo:** Implementar a interface `shop_interface.gd`, a cena `ShopInterface.tscn` e integrar atomicamente a compra e venda de itens com `PricingService`, `InventoryService` e `FactionService`.  
**Resultado:** CONCLUÍDA E VALIDADA. A suíte `test_shop_system.gd` executou com sucesso imprimindo `[TEST PASSED]` no Output sem exceções de runtime!

---

# 11. PRÓXIMA TAREFA

**ID:** TASK-302

**Tarefa:** Sistema de Relacionamentos com NPCs e Afinidade.

**Motivo da prioridade:** Expandir o engajamento social e diálogos com NPCs após a consolidação da infraestrutura comercial.
