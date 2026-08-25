# PROJECT_STATE.md

> Documento de estado atual do projeto Godot 4.
> Este arquivo deve refletir o estado REAL do projeto e ser atualizado ao final de Sprints, mudanças arquiteturais relevantes e correções importantes.

---

## 1. IDENTIFICAÇÃO DO PROJETO

- **Nome do projeto:** Beneath Five Moons / Lumina Darkness
- **Versão atual:** 0.2.1-ALPHA.1
- **Versão da Godot:** Godot 4.7.1 (GL Compatibility / Direct3D12)
- **Plataformas alvo:** PC (Windows / Linux / macOS)
- **Gênero:** RPG de Ação Sandbox 2D / Survival Leve / Simulação Social / Progressão por Uso
- **Perspectiva:** Top-Down 2D
- **Ponto de Entrada Atual:** `res://tests/Boot.tscn` (`boot.gd`)
- **Status geral:** FASE A (AUDITORIA E REGRESSÃO DO MVP) CONCLUÍDA | PRONTO PARA FASE B (APRESENTAÇÃO VISUAL)
- **Última atualização:** 2026-08-25

---

## 2. VISÃO GERAL

### Descrição
RPG de ação sandbox 2D em mundo aberto focado em identidade emergente, sobrevivência leve, profissões, relacionamentos, iluminação sistêmica e economia local.

### Core Loop
```text
VIVER → EXPLORAR → COLETAR → PRODUZIR → NEGOCIAR → DESENVOLVER → RELACIONAR-SE → INFLUENCIAR O MUNDO
```

### Objetivo atual do projeto
Evoluir a Playable Build Vertical Slice no Posto Avançado da Garganta de Ferro, desenvolvendo a camada visual de apresentação (Player, Câmera, HUD e Inventário Visual) e preparando o ambiente para validação manual cooperativa.

---

## 3. ESTADO DA SPRINT

- **Sprint anterior:** Gate 6 (Regressão do MVP) — FASE A
  - **Status:** CONCLUÍDA COM 100% DE APROVAÇÃO AUTOMATIZADA.
- **Nova fase:** Gate 7 (Auditoria Visual) — FASE B — APRESENTAÇÃO VISUAL
  - **Status:** A INICIAR.
  - **Objetivo:** Auditar os nós, texturas, sprites e componentes visuais do Player e da Interface Gráfica (HUD/UI) para iniciar o desenvolvimento da apresentação na engine Godot 4.7.1.

---

## 4. SISTEMAS DO JOGO

| Sistema | Estado | Qualidade | Observações |
| :--- | :--- | :--- | :--- |
| Player Domain | FUNCIONAL | ALTA | CharacterBody2D com composição de componentes |
| Movement 2D | FUNCIONAL | ALTA | MovementComponent2D baseado em Input Map semântico |
| Combate 2D | FUNCIONAL | ALTA | Ação tática desacoplada via IDamageable e luz |
| Inimigos / IA | FUNCIONAL | ALTA | Lobo Esfomeado reativo à iluminação plena/penumbra |
| Inventário Core | FUNCIONAL | ALTA | InventoryService transacional com stacks e instâncias |
| Progressão | FUNCIONAL | ALTA | ProfessionService com 17 profissões e 5 tiers |
| Relacionamentos | FUNCIONAL | ALTA | RelationshipService, afinidade de -100 a +100 |
| Economia / Pricing | FUNCIONAL | ALTA | Oferta, demanda, impostos e multiplicadores |
| Loja do Jogador | FUNCIONAL | ALTA | PlayerMarketService com anúncios e taxas |
| Iluminação / Flora | FUNCIONAL | ALTA | BioluminescentFloraNode com pulso senoidal suave |
| Save/Load | FUNCIONAL | ALTA | Persistência atômica, backup e migração JSON |
| EventBus | FUNCIONAL | ALTA | Sinais fortemente tipados e evento genérico event_emitted |
| Multiplayer Core | ARQUITETURA DEFINIDA | — | ENetMultiplayerPeer + Listen Server / Host Autoritativo |
| Navegação 2D | ARQUITETURA DEFINIDA | — | NavigationServer2D + regiões/agentes + NavigationService |
| World Streaming | ARQUITETURA DEFINIDA | — | Grid-Based Chunks + Offline/Abstract Simulation |
| UI / HUD | REVALIDADO EM BOOT | MÉDIA | HUDView recebendo sinais desacoplados do EventBus |
| Player Visual | ESPECIFICADO | — | Auditoria visual a iniciar no Gate 7 |
| Inventário Visual | ESPECIFICADO | — | Implementação visual pendente |
| Minimap | ESPECIFICADO | — | Implementação visual pendente |
| Primeiro Local | ESPECIFICADO | — | Posto Avançado da Garganta de Ferro |
| Testes Manuais | PLANEJADOS (TM-001/004) | NOT TESTED | Passo a passo definido; aguardando FASE B/C/D |
| Playable Build | EM PREPARAÇÃO | — | Critérios definidos, revalidação em progresso |

---

## 5. ARQUITETURA ATUAL

### Autoloads

| Autoload | Função | Status |
| :--- | :--- | :--- |
| EventBus | Barramento de eventos desacoplados com suporte a event_emitted | FUNCIONAL |
| TimeService | Relógio lógico e agendador de ticks do mundo | FUNCIONAL |
| GameState | Estado global persistente serializável | FUNCIONAL |
| SaveService | Persistência atômica, backup e migração em JSON | FUNCIONAL |
| SceneManager | Carregamento e transição de cenas/regiões | FUNCIONAL |
| ServiceRegistry | Injeção de dependência e localização de serviços | FUNCIONAL |

### Baseline Multiplayer
- **Transporte:** ENetMultiplayerPeer.
- **Topologia:** Listen Server / Host Autoritativo.
- **WorldState:** autoridade do Host.
- **Movimento local:** preditivo no cliente com reconciliação.
- **Transações:** TransactionId idempotente.
- **Reconexão:** janela de 60 segundos.
- **Save do mundo:** Host.
- **Save do personagem:** PlayerState individual com HMAC.

### Baseline Visual
- Pixel Art Neons/Chiaroscuro.
- **Resolução-base:** 640 × 360 (Canvas Stretch).
- **Tiles:** 16 × 16.
- **Player:** 32 × 32.
- Pixel Snap.
- Iluminação 2D nativa (PointLight2D e CanvasModulate).

---

## 6. DECISÕES IMPORTANTES RECENTES

- **BUG-003 corrigido:** adicionado o sinal `event_emitted` e o método `emit_event` ao `event_bus.gd`.
- **BUG-004 corrigido:** parâmetro `run/main_scene` do `project.godot` vinculado à cena oficial `res://tests/Boot.tscn`.
- **FASE A (Auditoria, Testes Automatizados e Regressão):** 100% concluída.
- **FASE B (Apresentação Visual):** pronta para ser iniciada a partir do Gate 7.

---

## 7. RISCOS ATUAIS

| Risco | Severidade | Mitigação |
| :--- | :--- | :--- |
| Desacoplamento de UI sem UIManager | MÉDIA | Implementação da infraestrutura de CanvasLayers no Gate 10 |
| Complexidade multiplayer | ALTA | Implementação incremental Host/Client na Fase D |
| Desync de estado | ALTA | Autoridade central, classificação de estado e reconciliação |
| Duplicação de itens | ALTA | TransactionId idempotente + rollback |
| Performance | MÉDIA | Metas de 60 FPS e profiling contínuo |

---

## 8. PRÓXIMOS MARCOS

1. Gate 7 — Auditoria Visual de Cenas e Componentes.
2. Gate 8 a 10 — Apresentação do Player, Câmera e HUD Contextual.
3. Gate 11 a 13 — Inventário Visual, Mochila e Equipamentos.
4. Gate 22 a 25 — LDD e Construção do Posto Avançado da Garganta de Ferro.
5. Gate 28 a 34 — Fundação Multiplayer Cooperativa (ENet Host/Client).
6. Gate 35 a 39 — Release Interno e Playable Build Final.
