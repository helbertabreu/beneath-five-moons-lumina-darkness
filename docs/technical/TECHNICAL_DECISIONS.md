# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto.
> O objetivo é evitar que decisões previamente aprovadas sejam alteradas ou esquecidas sem justificativa.

---

# COMO REGISTRAR UMA DECISÃO

Para cada decisão importante, utilize:

```text
ID:
Data:
Título:
Status:

Contexto:
Problema:

Alternativas consideradas:

Decisão:

Motivo:

Consequências positivas:

Trade-offs / consequências negativas:

Impactos no projeto:

Arquivos ou sistemas afetados:

Plano de migração, se aplicável:

Responsável pela decisão:
STATUS POSSÍVEIS
PROPOSTA

ATIVA

SUPERADA

CANCELADA

DECISÕES ATIVAS
ADR-001 — Adoção da Perspectiva 2D Top-Down para a Vertical Slice MVP
Data: 2026-08-18 | Status: ATIVA

ADR-012 — Padrão MVVM/Presentation Model para a Interface de Comércio (TASK-301)
Data: 2026-08-21 | Status: ATIVA

ADR-013 — Implementação do Sistema de Relacionamentos e Afinidade com NPCs (TASK-302)
Data: 2026-08-21 | Status: ATIVA

ADR-014 — Padronização dos Campos Data-Driven da RecipeDefinition (TASK-303 / BUG-002)
Data: 2026-08-23 | Status: ATIVA

ADR-015 — Implementação do PlayerMarketService para a Loja do Jogador (TASK-304)
Data: 2026-08-23 | Status: ATIVA

ADR-016 — Componente de Flora Bioluminescente e Ilhas de Luz Ambientais (POLISH-001)
Data: 2026-08-23

Status: ATIVA

Contexto
O ambiente do Setor Escuro do jogo exige pontos de iluminação estáticos/ambientais que funcionem como refúgio tático seguro contra criaturas hostis sem gastar combustível de lanternas do jogador.

Problema
Inexistência de um nó interativo ambiental capaz de emitir iluminação pulsante e elevar dinamicamente o estado de iluminação do jogador (LightingContext) via LightingService de forma desacoplada.

Decisão
Criar o nó BioluminescentFloraNode estendendo Area2D, equipado com um PointLight2D alimentado por uma textura radial de gradiente gerada dinamicamente. O nó calcula uma pulsação senoidal de luz no _process e monitora a entrada/saída de entidades (Player), atualizando o LightingService para Luz Plena (0.75) enquanto presente na ilha bioluminescente e restaurando para Penumbra (0.20) ao sair.

Motivo
Proporcionar profundidade ambiental e tática de sobrevivência no Setor Escuro de acordo com as especificações do GDD/TDD, mantendo o total desacoplamento com os sistemas de combate e IA.

Consequências Positivas
Permite criar ilhas bioluminescentes em qualquer mapa Top-Down 2D apenas adicionando o nó.

Totalmente coberto por testes unitários e de integração (test_bioluminescent_lighting.gd).

Arquivos afetados
res://entities/environment/bioluminescent_flora_node.gd

res://tests/unit/test_bioluminescent_lighting.gd

res://boot.gd
```


---

# DECISÕES MULTIPLAYER E MUNDO — 2026-08-24

## ADR-017 — Transporte de Rede com ENet

**Data:** 2026-08-24  
**Status:** ATIVA

**Contexto:** início da fase de Multiplayer Cooperativo.

**Decisão:** utilizar `ENetMultiplayerPeer` nativo do Godot 4.7.1, encapsulado por `NetworkTransportService`.

**Motivo:** integração nativa com MultiplayerAPI, baixo overhead e possibilidade de substituição futura por adaptadores sem alterar o domínio.

**Impactos:** infraestrutura de rede, comandos, sincronização e testes Host/Client.

---

## ADR-018 — Listen Server / Host Autoritativo

**Data:** 2026-08-24  
**Status:** ATIVA

**Decisão:** Listen Server / Host Autoritativo para Coop.

**Autoridade:** Host sobre WorldState, NPCs, spawning, economia, inventários e transações. Cliente possui predição da física local e recebe reconciliação do Host.

**Impactos:** rede, persistência, economia, inventário, NPCs, combate e reconexão.

---

## ADR-019 — Navegação 2D via NavigationServer2D

**Data:** 2026-08-24  
**Status:** ATIVA

**Decisão:** `NavigationServer2D` + `NavigationRegion2D` + `NavigationAgent2D`, acessados pela IA através de `NavigationService`. Obstáculos dinâmicos usam `NavigationObstacle2D`.

**Motivo:** desacoplamento da IA em relação à implementação concreta de navegação.

---

## ADR-020 — Grid-Based Chunks e Offline Simulation

**Data:** 2026-08-24  
**Status:** ATIVA

**Decisão:** streaming por Grid-Based Chunks 2D. Regiões ativas usam Full Simulation; regiões inativas usam Offline/Abstract Simulation.

**Motivo:** permitir expansão do mundo sem exigir simulação completa de todas as regiões simultaneamente.

---

## ADR-021 — Save/Load Multiplayer e Idempotência

**Data:** 2026-08-24  
**Status:** ATIVA

**Decisão:** WorldState persistido pelo Host; PlayerState individual preservado para o jogador. Transações de itens utilizam `TransactionId` idempotente e rollback em falha.

**Reconexão:** reserva do jogador por até 60 segundos e restauração via snapshot atual.

---

## ADR-022 — Baseline Visual da Playable Build

**Data:** 2026-08-24  
**Status:** ATIVA

**Decisão:** Pixel Art Neons/Chiaroscuro, resolução-base `640 × 360`, tiles `16 × 16`, Player `32 × 32`, Pixel Snap e iluminação 2D nativa.

**Impactos:** pipeline de assets, UI, cenas, minimapa e construção do Posto Avançado da Garganta de Ferro.

---

## ADR-023 — Critérios da Playable Build

**Data:** 2026-08-24  
**Status:** ATIVA

**Decisão:** os critérios de aceite estão definidos, mas ainda não são considerados validados.

**Regra:** nenhum critério pode ser marcado como aprovado sem execução, resultado registrado e evidência.

**Impactos:** QA, testes manuais, distribuição interna e Definition of Done.

