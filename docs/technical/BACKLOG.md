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

**Sprint:** Sprint 16 — Polimento da Iluminação 2D no Setor Escuro

**Objetivo:** Implementação do nó `BioluminescentFloraNode`, pulsação senoidal orgânica de iluminação 2D e suíte de testes de integração com o `LightingService` no `boot.gd`.

| ID | Tarefa | Tipo | Prioridade | Sprint | Dependência | Status | Critério de aceitação |
|---|---|---|---|---|---|---|---|
| POLISH-001 | Iluminação com ilhas bioluminescentes 2D no Setor Escuro | Polish | P3 | 16 | TASK-109 | DONE | Criar `BioluminescentFloraNode`, configurar efeito de luz pulsante 2D, elevar iluminação do jogador para 0.75 na área e validar no `test_bioluminescent_lighting.gd` com status 100% aprovado no `boot.gd`. |

---

# 2. BACKLOG DA FASE 3 (ECONOMIA + PROFISSÕES + SOCIAL)

| ID | Tarefa | Tipo | Prioridade | Dependência | Status |
|---|---|---|---|---|---|
| TASK-301 | Interface Comercial e Integração com PricingService | UI/Systems | P1 | TASK-204 | DONE |
| TASK-302 | Sistema de Relacionamentos com NPCs e Afinidade | Social | P1 | TASK-301 | DONE |
| TASK-303 | Múltiplas Receitas e Estações de Trabalho | Crafting | P1 | TASK-302 | DONE |
| TASK-304 | Loja do Jogador e Mercado Local | Economy | P1 | TASK-303 | DONE |

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
| BUG-002 | `Invalid assignment of property 'name'` no `forge_node.gd` | ALTA | P1 | 14 | DONE |

---

# 5. DÍVIDA TÉCNICA

*(Nenhuma dívida técnica registrada no momento)*

---

# 6. POLISH

| ID | Melhoria | Prioridade | Sistema | Status |
|---|---|---|---|---|
| POLISH-001 | Iluminação com ilhas bioluminescentes 2D no Setor Escuro | P3 | Lighting 2D | DONE |

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

## Sprint 14 — Múltiplas Receitas e Estações de Trabalho (TASK-303)
**Objetivo:** Refatoração de contrato das receitas da estação da forja (`forge_node.gd`) e validação da suíte integrada de boot.  
**Resultado:** CONCLUÍDA COM SUCESSO (BUG-002 Resolvido).

## Sprint 15 — Loja do Jogador e Mercado Local (TASK-304)
**Objetivo:** Implementar o `PlayerMarketService`, publicação de anúncios e testes unitários de simulação econômica.  
**Resultado:** CONCLUÍDA COM SUCESSO.

## Sprint 16 — Polimento da Iluminação 2D no Setor Escuro (POLISH-001)
**Objetivo:** Implementar `BioluminescentFloraNode`, pulsação senoidal de luz 2D e integração com `LightingService`.  
**Resultado:** CONCLUÍDA COM SUCESSO.

---

# 11. PRÓXIMA TAREFA

**ID:** TASK-401

**Tarefa:** Fundação da Camada de Rede (Multiplayer-Ready Architecture).

**Motivo da prioridade:** Garantir a serialização segura de mensagens e estados para o modo cooperativo futuro.
