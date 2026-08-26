# PROJECT_STATE.md

> Documento de estado atual do projeto Godot 4.
> Este arquivo deve refletir o estado REAL do projeto e ser atualizado ao final de Sprints, mudanças arquiteturais relevantes e correções importantes.

---

## 1. IDENTIFICAÇÃO DO PROJETO

- **Nome do projeto:** Beneath Five Moons / Lumina Darkness
- **Versão atual:** 0.2.1-ALPHA.1
- **Versão da Godot:** Godot 4.7.1
- **Plataformas alvo:** PC (Windows / Linux / macOS)
- **Gênero:** RPG de Ação Sandbox 2D / Survival Leve / Simulação Social / Progressão por Uso
- **Perspectiva:** Top-Down 2D
- **Status geral:** PÓS-MVP / PREPARAÇÃO DA PLAYABLE BUILD / FUNDAÇÃO MULTIPLAYER
- **Última atualização:** 2026-08-26

---

## 2. VISÃO GERAL

### Descrição

RPG de ação sandbox 2D em mundo aberto focado em identidade emergente, sobrevivência leve, profissões, relacionamentos, iluminação sistêmica e economia local.

### Core Loop

```text
VIVER → EXPLORAR → COLETAR → PRODUZIR → NEGOCIAR → DESENVOLVER → RELACIONAR-SE → INFLUENCIAR O MUNDO
```

### Objetivo atual do projeto

Transformar a base pós-MVP em uma primeira Playable Build multiplayer cooperativa, visualmente jogável e testável, tendo como primeira região o Posto Avançado da Garganta de Ferro.

---

## 3. ESTADO DA SPRINT

- **Sprint anterior:** Sprint 16 — Polimento da Iluminação 2D no Setor Escuro
  - **Status:** CONCLUÍDA E VALIDADA.
- **Nova fase:** Sprint 17 — Fundação Multiplayer + Preparação da Playable Build
  - **Status:** EM EXECUÇÃO (Gates de Infraestrutura da Playable Build).
  - **Objetivo:** estabelecer o baseline multiplayer oficial, iniciar a apresentação visual e preparar o Posto Avançado da Garganta de Ferro para testes manuais cooperativos.

---

## 4. SISTEMAS DO JOGO

| Sistema | Estado | Qualidade | Observações |
| :--- | :--- | :--- | :--- |
| Player | FUNCIONAL | ALTA | CharacterBody2D com composição de componentes |
| Movimento | FUNCIONAL | ALTA | MovementComponent2D baseado em Input Map semântico |
| Combate | FUNCIONAL | ALTA | Ação tática desacoplada via IDamageable |
| Inimigos / IA | FUNCIONAL | ALTA | Lobo Esfomeado reativo à luz |
| Inventário | FUNCIONAL | ALTA | InventoryService transacional com stacks e instâncias |
| Progressão | FUNCIONAL | ALTA | ProfessionService com 17 profissões e 5 tiers |
| Relacionamentos | FUNCIONAL | ALTA | RelationshipService, afinidade de -100 a +100 |
| Economia / Pricing | FUNCIONAL | ALTA | Oferta, demanda e impostos |
| Loja do Jogador | FUNCIONAL | ALTA | PlayerMarketService |
| Iluminação / Flora | FUNCIONAL | ALTA | BioluminescentFloraNode com pulso suave |
| Save/Load | FUNCIONAL | ALTA | Persistência atômica e versionada |
| Multiplayer | ARQUITETURA DEFINIDA | — | ENetMultiplayerPeer + Listen Server / Host Autoritativo |
| Navegação 2D | ARQUITETURA DEFINIDA | — | NavigationServer2D + regiões/agentes + NavigationService |
| World Streaming | ARQUITETURA DEFINIDA | — | Grid-Based Chunks + Offline/Abstract Simulation |
| UI / HUD | ARQUITETURA DEFINIDA | — | MVVM-like / Presentation Model |
| Inventário Visual | FUNCIONAL | ALTA | `inventory_ui.tscn` instanciado programmaticamente no Boot |
| Minimap | CONCLUÍDO | ALTA | `minimap.tscn` (GATE 25.1) instanciado e vinculado ao `target_player` |
| Farol do Alinhamento | PENDENTE | — | Objeto interativo de Save/Respawn no mundo (GATE 25.2) |
| Atalhos Save/Load | PENDENTE | — | Atalhos diretos de teclado F5/F9 para Save/Load (GATE 25.2) |
| Primeiro Local | ESPECIFICADO | — | Posto Avançado da Garganta de Ferro |
| Testes Manuais | ESPECIFICADOS | — | Execução pendente (Gate 26) |
| Playable Build | EM PREPARAÇÃO | — | Critérios definidos, aguardando GATE 25.2 e Gate 26 |

---

## 5. ARQUITETURA ATUAL

### Autoloads

| Autoload | Função | Status |
| :--- | :--- | :--- |
| EventBus | Barramento de eventos desacoplados da engine | FUNCIONAL |
| TimeService | Relógio lógico e agendador de ticks do mundo | FUNCIONAL |
| GameState | Estado global persistente serializável | FUNCIONAL |
| SaveService | Persistência atômica, backup e migração | FUNCIONAL |
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

### Baseline de Mundo
- **Navegação:** NavigationServer2D → NavigationRegion2D → NavigationAgent2D → NavigationService.
- **Obstáculos dinâmicos:** NavigationObstacle2D.
- **Streaming:** Grid-Based Chunks.
- **Regiões ativas:** Full Simulation.
- **Regiões inativas:** Offline/Abstract Simulation.

### Baseline Visual
- Pixel Art Neons/Chiaroscuro.
- **Resolução-base:** 640 × 360.
- **Tiles:** 16 × 16.
- **Player:** 32 × 32.
- Pixel Snap.
- Iluminação 2D nativa.

---

## 6. DECISÕES IMPORTANTES RECENTES

- **XP geral:** modelo híbrido baseado em Ações e Milestones.
- **Curva:** XP_req = 100 × Nível^1.5.
- **Atributos:** Força, Agilidade, Vigor, Inteligência, Sabedoria e Carisma com responsabilidades separadas.
- **ProficiencyDecayPolicy:** NONE.
- **Primeiro local:** Posto Avançado da Garganta de Ferro.
- **HUD:** Contextual Minimalista.
- **Direção visual:** Pixel Art Neons/Chiaroscuro.
- **Multiplayer:** ENet + Listen Server / Host Autoritativo.
- **Navegação:** NavigationServer2D + NavigationService.
- **Streaming:** Grid-Based Chunks + Offline/Abstract Simulation.
- **GATE 25.1 Concluído:** Cena física do minimapa (`minimap.tscn`) criada e integrada visualmente ao orquestrador do Boot.
- **Critérios da Playable Build:** DEFINIDOS, mas ainda NÃO EXECUTADOS.

---

## 7. RISCOS ATUAIS

| Risco | Severidade | Mitigação |
| :--- | :--- | :--- |
| Complexidade multiplayer | ALTA | Implementação incremental e testes Host/Client desde o início |
| Desync de estado | ALTA | Autoridade central, classificação de estado e reconciliação |
| Duplicação de itens | ALTA | TransactionId idempotente + rollback |
| Escopo visual excessivo | ALTA | Foco no Posto Avançado da Garganta de Ferro |
| UI acoplada ao domínio | MÉDIA | MVVM-like + ViewModels + EventBus |
| Performance | MÉDIA | Metas de 60 FPS e profiling contínuo |
| World Streaming prematuro | MÉDIA | Validar primeiro uma região pequena antes de expandir |

---

## 8. PRÓXIMOS MARCOS

1. Execução do GATE 25.2 (Script do Farol do Alinhamento + Atalhos F5/F9 de Save/Load).
2. Fundação da camada de rede.
3. Validação Host/Client.
4. Implementação da reconexão.
5. Estruturação das cenas 2D oficiais.
6. Construção visual do Posto Avançado da Garganta de Ferro.
7. Execução da Matriz de Testes Manuais (Gate 26).
8. Correção de bugs e regressão (Gate 27).
9. Validação dos critérios da Playable Build.

---

## 9. REGRAS DE GOVERNANÇA

1. Este arquivo deve refletir o estado real.
2. Nenhuma funcionalidade deve ser marcada como concluída apenas porque foi especificada.
3. Critérios de aceite definidos permanecem pendentes até execução e evidência.
4. Mudanças arquiteturais relevantes exigem atualização deste arquivo.
5. O histórico de decisões deve permanecer rastreável em `TECHNICAL_DECISIONS.md`.
