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
- **Ponto de Entrada Atual:** `res://boot.gd` (Cena de Boot / Testes Integrados) [cite: 18, 27]
- **Status geral:** FASE B — APRESENTAÇÃO VISUAL | INVENTÁRIO VISUAL E ATALHO 'I' FUNCIONAIS (GATE 11) [cite: 21, 23, 24, 27]
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
Evoluir a Playable Build Vertical Slice no Posto Avançado da Garganta de Ferro, integrando o Inventário Visual e HUD à árvore de nós do bootstrap e preparando o ambiente para validação manual cooperativa.

---

## 3. ESTADO DA SPRINT

- **Sprint anterior:** Gate 11 — Inventário Visual (Sprint 17 / Fase B)
  - **Status:** CONCLUÍDA COM SUCESSO (Janela InventoryUI.tscn instanciada e operando via atalho "I").
- **Nova fase:** Gate 12 — Mochila e Expansão Visual / Gate 13 — Equipamentos (FASE B)
  - **Status:** A INICIAR.
  - **Objetivo:** Dar sequência ao polimento visual e à apresentação dos slots de equipamento e itens visuais no ambiente 2D.

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
| EventBus | FUNCIONAL | ALTA | Suporte a event_emitted e sinais de janela (inventory_toggle_requested) |
| Bootstrap / Time | FUNCIONAL | ALTA | Sequência de boot validada com chamada corrigida a resume_time() |
| Inventário Visual | FUNCIONAL | ALTA | Grid de slots, drag-and-drop, atalho 'I' e divisão de stacks (GATE 11 / TASK-408) [cite: 21, 23, 24, 28] |
| Multiplayer Core | ARQUITETURA DEFINIDA | — | ENetMultiplayerPeer + Listen Server / Host Autoritativo |
| Navegação 2D | ARQUITETURA DEFINIDA | — | NavigationServer2D + regiões/agentes + NavigationService |
| World Streaming | ARQUITETURA DEFINIDA | — | Grid-Based Chunks + Offline/Abstract Simulation |
| UI / HUD | FUNCIONAL EM BOOT | MÉDIA | HUDView e InventoryUI instanciados no boot.gd |
| Player Visual | ESPECIFICADO | — | Auditoria visual realizada |
| Minimap | ESPECIFICADO | — | Implementação visual pendente |
| Primeiro Local | ESPECIFICADO | — | Posto Avançado da Garganta de Ferro |
| Testes Manuais | PLANEJADOS (TM-001/004) | NOT TESTED | Passo a passo definido; aguardando FASE B/C/D [cite: 27] |
| Playable Build | EM PREPARAÇÃO | — | Critérios definidos, revalidação em progresso |

---

## 5. ARQUITETURA ATUAL

### Autoloads

| Autoload | Função | Status |
| :--- | :--- | :--- |
| EventBus | Barramento de eventos desacoplados com suporte a event_emitted e atalhos de janela | FUNCIONAL |
| TimeService | Relógio lógico e agendador de ticks do mundo via resume_time() | FUNCIONAL |
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

- **GATE 11 Concluído:** InventoryUI.tscn instanciado e adicionado à SceneTree pelo boot.gd no CanvasLayer 15.
- **Atalho Semântico 'I':** Conectado via EventBus (inventory_toggle_requested) para exibição/ocultação reativa do inventário visual [cite: 21, 23].
- **Boot TimeService Fix:** Corrigida a chamada no boot.gd para utilizar a API pública oficial TimeService.resume_time().
- **BUG-003 e BUG-004:** Resolvidos com sucesso em fases anteriores.

---

## 7. RISCOS ATUAIS

| Risco | Severidade | Mitigação |
| :--- | :--- | :--- |
| Desacoplamento de UI sem UIManager | MÉDIA | Organização explícita de CanvasLayer (HUD layer 10, Janelas layer 15) |
| Complexidade multiplayer | ALTA | Implementação incremental Host/Client na Fase D [cite: 27, 33] |
| Desync de estado | ALTA | Autoridade central, classificação de estado e reconciliação [cite: 27, 33] |
| Duplicação de itens | ALTA | TransactionId idempotente + rollback [cite: 27, 33] |
| Performance | MÉDIA | Metas de 60 FPS e profiling contínuo [cite: 27, 33] |

---

## 8. PRÓXIMOS MARCOS

1. Gate 12 / 13 — Visualização da Mochila, Slots de Equipamento e Dicas Contextuais.
2. Gate 21 — Minimapa.
3. Gate 22 a 25 — LDD e Construção do Posto Avançado da Garganta de Ferro [cite: 27, 33].
4. Gate 28 a 34 — Fundação Multiplayer Cooperativa (ENet Host/Client) [cite: 27, 33].
5. Gate 35 a 39 — Release Interno e Playable Build Final [cite: 27, 33].
