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

**Sprint:** Sprint 3 — Survival & Interaction Systems

**Objetivo:** Implementar a mecânica de sobrevivência (6 necessidades essenciais) e o sistema de detecção e disparo de interações 2D via `Area2D`.

| ID | Tarefa | Tipo | Prioridade | Sprint | Dependência | Status | Critério de aceitação |
|---|---|---|---|---|---|---|---|
| TASK-104 | `SurvivalComponent` (6 Necessidades) | Gameplay | P1 | 3 | TASK-102 | DONE | Gerenciar necessidades vitais e decair Fome/Fadiga via `TimeService` sem erros. |
| TASK-105 | Sistema de Interação 2D (`Area2D` / `IInteractable`) | Gameplay | P1 | 3 | TASK-102 | IN PROGRESS | Detectar áreas e corpos interagíveis no raio do jogador e responder à tecla 'E'. |

---

# 2. BACKLOG DO MVP

| ID | Tarefa | Tipo | Prioridade | Dependência | Status |
|---|---|---|---|---|---|
| TASK-101 | Input Map Semântico 2D | Technical | P1 | TASK-005 | DONE |
| TASK-102 | Player `CharacterBody2D` & `MovementComponent2D` | Gameplay | P1 | TASK-101 | DONE |
| TASK-103 | Câmera 2D & Mapeamento de Foco | Gameplay | P1 | TASK-102 | DONE |
| TASK-104 | `SurvivalComponent` (6 Necessidades) | Gameplay | P1 | TASK-102 | DONE |
| TASK-105 | Sistema de Interação 2D (`Area2D` / `IInteractable`) | Gameplay | P1 | TASK-102 | IN PROGRESS |
| TASK-106 | Engine de Inventário & Instância de Itens | Gameplay | P1 | TASK-105 | TODO |
| TASK-107 | Coleta de Recurso (Mina de Ferro 2D) | Gameplay | P1 | TASK-106 | TODO |
| TASK-108 | Estação de Crafting & Profissão Ferreiro | Gameplay | P1 | TASK-106 | TODO |
| TASK-109 | Iluminação 2D (`PointLight2D` & `LightingContext`) | Gameplay | P1 | TASK-102 | TODO |
| TASK-110 | Combate 2D Base & Inimigo Sensível à Luz | Gameplay | P1 | TASK-109 | TODO |
| TASK-111 | NPC Ferreiro, Diálogo & Quest 01 | Social | P1 | TASK-105 | TODO |
| TASK-112 | Integração da Gameplay Vertical Slice 2D | Integration | P1 | TASK-110 | TODO |

---

# 3. BUGS

*(Nenhum bug registrado no momento)*

---

# 4. DÍVIDA TÉCNICA

*(Nenhuma dívida técnica registrada no momento)*

---

# 5. POLISH

| ID | Melhoria | Prioridade | Sistema | Status |
|---|---|---|---|---|
| POLISH-001 | Iluminação com ilhas bioluminescentes 2D | P3 | Lighting 2D | TODO |

---

# 6. FUTURO / NICE TO HAVE

| ID | Funcionalidade | Prioridade | Motivo para não implementar agora | Status |
|---|---|---|---|---|
| FUT-001 | Mecânica de Sede | P4 | Removido do MVP conforme decisão ADR-008 | DEFERRED |
| FUT-002 | Multiplayer Cooperativo Ativo | P4 | Exige validação prévia do Single-Player | DEFERRED |
| FUT-003 | Governança de Vilarejos e Guerras | P4 | Recurso de Endgame | DEFERRED |

---

# 7. DEFINITION OF DONE

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

# 8. REGRAS DO BACKLOG

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

# 9. HISTÓRICO DE SPRINTS

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

**Resultado:** EM ANDAMENTO. TASK-104 (Fome/Tempo) corrigida e testada com sucesso. TASK-105 em validação de colisão física.

---

# 10. PRÓXIMA TAREFA

**ID:** TASK-105

**Tarefa:** Validação do sistema de interação 2D (`InteractionDetector2D` & `IInteractable`) com o baú de teste.

**Motivo da prioridade:** Necessário para permitir a coleta de recursos, abertura de containers e conversas com NPCs na próxima Sprint.
