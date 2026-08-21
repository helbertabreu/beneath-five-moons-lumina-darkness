---

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

# 00. REGRAS DO BACKLOG

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

# 1. SPRINT ATUAL

**Sprint:** Sprint 2 — Player 2D, Input Map Semântico, Movimento & Câmera 2D

**Objetivo:** Implementar o mapa de ações semânticas de input, a cena do jogador (`CharacterBody2D`), o componente de movimento de 8 direções e a câmera de acompanhamento top-down.

| ID | Tarefa | Tipo | Prioridade | Sprint | Dependência | Status | Critério de aceitação |
|---|---|---|---|---|---|---|---|
| TASK-101 | Input Map Semântico 2D | Technical | P1 | 2 | TASK-005 | DONE | Configurar no `project.godot` ações de movimento, corrida e uso de luz. |
| TASK-102 | Player `CharacterBody2D` & `MovementComponent2D` | Gameplay | P1 | 2 | TASK-101 | DONE | Personagem se movimenta suavemente em 8 direções usando vetores semânticos. |
| TASK-103 | Câmera 2D & Mapeamento de Foco | Gameplay | P1 | 2 | TASK-102 | IN PROGRESS | `Camera2D` segue o jogador com suavização (smoothing) configurada. |

---

# 2. BACKLOG DO MVP

| ID | Tarefa | Tipo | Prioridade | Dependência | Status |
|---|---|---|---|---|---|
| TASK-101 | Input Map Semântico 2D | Technical | P1 | TASK-005 | DONE |
| TASK-102 | Player `CharacterBody2D` & `MovementComponent2D` | Gameplay | P1 | TASK-101 | DONE |
| TASK-103 | Câmera 2D & Mapeamento de Foco | Gameplay | P1 | TASK-102 | IN PROGRESS |
| TASK-104 | `SurvivalComponent` (6 Necessidades) | Gameplay | P1 | TASK-102 | TODO |
| TASK-105 | Sistema de Interação 2D (`Area2D` / `IInteractable`) | Gameplay | P1 | TASK-102 | TODO |
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

- [ ] implementação concluída no Godot 4.7.1;
- [ ] integração com a arquitetura e EventBus validada;
- [ ] desacoplamento de UI e NodePath garantido;
- [ ] testes unitários ou de integração realizados;
- [ ] critérios de aceitação cumpridos;
- [ ] documentação atualizada (`PROJECT_STATE`, `BACKLOG`, `TECHNICAL_DECISIONS`);
- [ ] nenhuma regressão conhecida introduzida.

---

# 8. HISTÓRICO DE SPRINTS

## Sprint 0 — Auditoria e Revisão Gate 0

**Objetivo:** Auditar a documentação do projeto e aprovar o planejamento inicial.

**Resultado:** Aprovado. Decidido migração para 2D Top-Down e remoção da Sede do MVP.

## Sprint 1 — Core Architecture & Infrastructure Setup

**Objetivo:** Criar a estrutura base de diretórios, serviços globais, barramento de eventos, relógio lógico e sistema de save atômico.

**Resultado:** CONCLUÍDA COM SUCESSO. Testes atômicos do Core aprovados (`[TEST PASSED]`).

## Sprint 2 — Player 2D, Input Map Semântico, Movimento & Câmera 2D

**Objetivo:** Criar a estrutura do jogador 2D, capturar entradas semânticas e permitir movimentação fluida.

**Resultado:** EM ANDAMENTO. Passos 2.1 e 2.2 concluídos.

---

# 9. PRÓXIMA TAREFA

**ID:** TASK-103

**Tarefa:** Adicionar a Câmera 2D com suavização de movimento no Player.

**Motivo da prioridade:** Necessário para permitir a navegação de tela do jogador em mapas maiores.
