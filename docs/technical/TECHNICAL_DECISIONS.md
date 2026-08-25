# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto.
> O objetivo é evitar que decisões previamente aprovadas sejam alteradas ou esquecidas sem justificativa.

---

## 1. COMO REGISTRAR UMA DECISÃO

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
```

### STATUS POSSÍVEIS
- PROPOSTA
- ATIVA
- SUPERADA
- CANCELADA

---

## 2. DECISÕES ATIVAS

### ADR-001 — Adoção da Perspectiva 2D Top-Down para a Vertical Slice MVP
- **Data:** 2026-08-18 | **Status:** ATIVA

### ADR-012 — Padrão MVVM/Presentation Model para a Interface de Comércio (TASK-301)
- **Data:** 2026-08-21 | **Status:** ATIVA

### ADR-013 — Implementação do Sistema de Relacionamentos e Afinidade com NPCs (TASK-302)
- **Data:** 2026-08-21 | **Status:** ATIVA

### ADR-014 — Padronização dos Campos Data-Driven da RecipeDefinition (TASK-303 / BUG-002)
- **Data:** 2026-08-23 | **Status:** ATIVA

### ADR-015 — Implementação do PlayerMarketService para a Loja do Jogador (TASK-304)
- **Data:** 2026-08-23 | **Status:** ATIVA

### ADR-016 — Componente de Flora Bioluminescente e Ilhas de Luz Ambientais (POLISH-001)
- **Data:** 2026-08-23 | **Status:** ATIVA
- **Contexto:** O ambiente do Setor Escuro do jogo exige pontos de iluminação estáticos/ambientais que funcionem como refúgio tático seguro contra criaturas hostis sem gastar combustível de lanternas do jogador.
- **Problema:** Inexistência de um nó interativo ambiental capaz de emitir iluminação pulsante e elevar dinamicamente o estado de iluminação do jogador (`LightingContext`) via `LightingService` de forma desacoplada.
- **Decisão:** Criar o nó `BioluminescentFloraNode` estendendo `Area2D`, equipado com um `PointLight2D` alimentado por uma textura radial de gradiente gerada dinamicamente. O nó calcula uma pulsação senoidal de luz no `_process` e monitora a entrada/saída de entidades (`Player`), atualizando o `LightingService` para Luz Plena (0.75) enquanto presente na ilha bioluminescente e restaurando para Penumbra (0.20) ao sair.
- **Motivo:** Proporcionar profundidade ambiental e tática de sobrevivência no Setor Escuro de acordo com as especificações do GDD/TDD, mantendo o total desacoplamento com os sistemas de combate e IA.
- **Consequências Positivas:** Permite criar ilhas bioluminescentes em qualquer mapa Top-Down 2D apenas adicionando o nó. Totalmente coberto por testes unitários e de integração (`test_bioluminescent_lighting.gd`).
- **Arquivos afetados:**
  - `res://entities/environment/bioluminescent_flora_node.gd`
  - `res://tests/unit/test_bioluminescent_lighting.gd`
  - `res://boot.gd`

---

## 3. DECISÕES MULTIPLAYER E MUNDO — 2026-08-24

### ADR-017 — Transporte de Rede com ENet
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** utilizar `ENetMultiplayerPeer` nativo do Godot 4.7.1, encapsulado por `NetworkTransportService`.

### ADR-018 — Listen Server / Host Autoritativo
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** Listen Server / Host Autoritativo para Coop. Host possui autoridade sobre `WorldState`, NPCs, spawning, economia, inventários e transações.

### ADR-019 — Navegação 2D via NavigationServer2D
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** `NavigationServer2D` + `NavigationRegion2D` + `NavigationAgent2D`, acessados pela IA através de `NavigationService`.

### ADR-020 — Grid-Based Chunks e Offline Simulation
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** streaming por Grid-Based Chunks 2D. Regiões ativas usam Full Simulation; regiões inativas usam Offline/Abstract Simulation.

### ADR-021 — Save/Load Multiplayer e Idempotência
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** `WorldState` persistido pelo Host; `PlayerState` individual preservado para o jogador. Transações utilizam `TransactionId` idempotente.

### ADR-022 — Baseline Visual da Playable Build
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** Pixel Art Neons/Chiaroscuro, resolução-base 640 × 360, tiles 16 × 16, Player 32 × 32, Pixel Snap e iluminação 2D nativa.

### ADR-023 — Critérios da Playable Build
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** os critérios de aceite estão definidos, mas ainda não são considerados validados sem execução e evidência.

### ADR-024 — Injeção de Apresentação Visual do Player em Runtime
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** Injetar e gerenciar nós de apresentação visual (`Sprite2D`, `ShadowSprite`, `LanternAnchor`) via script estendido no `player.gd`, garantindo compatibilidade retroativa com a cena física `Player.tscn`.

### ADR-025 — Extensão da Câmera 2D via Script Anexado em Runtime/Cena
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Decisão:** Extender o comportamento do nó `Camera2D` na cena do Player através do script `player_camera_extension.gd`, aplicando `position_smoothing_speed = 5.0` e Camera Shake desacoplado por eventos do `EventBus`.

### ADR-026 — Integração e Instanciação do HUD no Boot Loader
- **Data:** 2026-08-24 | **Status:** ATIVA
- **Contexto:** Necessidade de instanciar e exibir a interface de usuário (HUD) na camada superior da tela sem violar a separação entre domínio e apresentação visual.
- **Decisão:** Instanciar a cena de texto nativa `res://ui/hud/hud.tscn` (vinculada ao script `HUDView` / `res://ui/hud/hud.gd`) dentro do método `_instantiate_ui()` no script `res://boot.gd`. A interface é adicionada à árvore como um nó `CanvasLayer` e responde reativamente a eventos do `EventBus` (`HealthChanged`, `EnergyChanged`, `HungerChanged`, `FatigueChanged`, `LightLevelChanged`).
- **Impactos:** Permite a visualização clara dos indicadores de sobrevivência e iluminação em tela sem acoplar a lógica de domínio do `SurvivalComponent`.

---

## 4. BASELINE DE BALANCEAMENTO (`BALANCE.md`)

# Beneath Five Moons — Balance Database
## Planilha de Balanceamento em Markdown

**Versão:** 5.1.0  
**Status:** Atualizado com a Tabela de Parâmetros da Flora Bioluminescente 2D do Setor Escuro (Sprint 16 / POLISH-001)  
**Fonte:** GDD, TDD, TIS e especificações do FactionService / PricingService / QuestService / ShopInterface / RelationshipService / PlayerMarketService / LightingService  

---

### 4.1. Controle de Versão

| Versão | Data | Autor | Alterações |
|---|---|---|---|
| 1.0.0 | 2026-08-18 | Equipe de Desenvolvimento | Base inicial para expansão |
| 1.1.0 | 2026-08-20 | Tech Lead | Atualização das taxas do SurvivalComponent |
| 1.2.0 | 2026-08-21 | Tech Lead | Adicionados parâmetros da TASK-106 e custos da TASK-107/108 |
| 1.3.0 | 2026-08-21 | Tech Lead | Adicionados parâmetros da TASK-109 e valores de combate da TASK-110 |
| 1.4.0 | 2026-08-21 | Tech Lead | Adicionadas recompensas da Quest 01 e tabela de quests |
| 2.0.0 | 2026-08-21 | Tech Lead | Expansão da Fase 2: Tabela de Profissões, Tiers de Maestria e XP Base |
| 2.1.0 | 2026-08-21 | Tech Lead | Parâmetros da Sprint 9 (TASK-202): Limites de Flutuação Econômica e Margens de Venda |
| 2.2.0 | 2026-08-21 | Tech Lead | Parâmetros da Sprint 10 (TASK-203): Ranks de Reputação Multidimensional e Matriz de Rivalidade |
| 3.0.0 | 2026-08-21 | Tech Lead | Parâmetros da Sprint 12 (TASK-301): Matriz de Compra/Venda da ShopInterface, Impostos de Mercado e Reembolso |
| 4.0.0 | 2026-08-21 | Tech Lead | Parâmetros da Sprint 13 (TASK-302): Tiers de Afinidade Individual, Reação a Presentes e Bônus Comerciais |
| 4.1.0 | 2026-08-23 | Tech Lead | Parâmetros da Sprint 14 (TASK-303): Custos, Insumos e XP de Profissão das Receitas de Crafting |
| 5.0.0 | 2026-08-23 | Tech Lead | Parâmetros da Sprint 15 (TASK-304): Taxa de Anúncio de Mercado (5%) e Regras de Precificação na Loja do Jogador |
| 5.1.0 | 2026-08-23 | Tech Lead | Parâmetros da Sprint 16 (POLISH-001): Raio de Cobertura, Nível de Luz Elevação e Frequência do Pulso Bioluminescente |

---

### 4.2. Parâmetros de Iluminação Bioluminescente do Setor Escuro (Sprint 16 / POLISH-001)

| Parâmetro de Iluminação | Valor / Configuração | Efeito Gameplay / Função |
|---|---:|---|
| Raio de Alcance da Flora (`light_radius`) | 80.0 pixels | Área de cobertura da ilha de luz emitida pela planta bioluminescente |
| Elevação de Iluminação (`illumination_value`) | 0.75 (Luz Plena) | Valor de iluminação enviado ao `LightingService` enquanto o jogador permanecer na área |
| Frequência de Pulsação (`pulse_speed`) | 2.0 rad/s | Velocidade da oscilação orgânica de brilho da planta |
| Faixa de Energia da Luz (`PointLight2D`) | 0.8x a 1.3x | Variação senoidal suave de iluminação emitida para sensação de flora viva |

---

### 4.3. Economia da Loja do Jogador & Mercado Local (Sprint 15 / TASK-304)

| Parâmetro Econômico | Valor / Regra | Aplicação / Função |
|---|---:|---|
| Taxa de Anúncio (`listing_fee`) | 5% (0.05) | Cobrada em moedas do jogador no ato da publicação do anúncio baseada no valor total do lote |
| Preço Mínimo por Item | 1 Moeda | Limite inferior para evitar anúncios com valor nulo |
| Tolerância de Compras por NPCs | $\le 200\%$ do Preço Base | NPCs compram com probabilidade proporcional ao preço. Preços acima de 2.0x o valor base são ignorados |

---

### 4.4. Facções Principais & Matriz de Rivalidades (Sprint 10)

| ID da Facção | Nome Visível | Reputação Inicial Padrão | Facções Rivais Diretas | Fator de Penalidade Cruzada |
|---|---|---:|---|---:|
| `faction.alignment_guardians` | Os Guardiões do Alinhamento | 0.0 | `faction.umbra_syndicate` | 0.5x (-50% do ganho) |
| `faction.umbra_syndicate` | O Sindicato de Umbra | 0.0 | `faction.alignment_guardians` | 1.0x (-100% do ganho) |
| `faction.bronze_brotherhood` | A Irmandade de Bronze | 1000.0 | N/A | 0.0x |
| `faction.fifth_moon_devotees` | Os Devotos da Quinta Lua | 0.0 | `faction.alignment_guardians` | 0.8x (-80% do ganho) |

---

### 4.5. Economia Dinâmica & Parâmetros do PricingService (Sprint 12)

$$	ext{Preço Final} = 	ext{Preço Base} 	imes 	ext{Multiplicador de Reputação} 	imes \left(1 + rac{	ext{Demanda} - 	ext{Estoque}}{	ext{Estoque Mínimo}}
ight) 	imes (1 + 	ext{Taxa de Imposto})$$

| Parâmetro Econômico | Valor Inicial / Regra | Limite Mínimo (Clamp) | Limite Máximo (Clamp) | Descrição / Função |
|---|---:|---:|---:|---|
| Base Price Multiplier | 1.00 | 0.25x | 3.00x | Trava de segurança global para flutuações de preços |
| Player Sell Margin | 60% (0.60) | N/A | N/A | Jogadores vendem itens por 60% do valor de compra calculado |
| Supply/Demand Factor | Dinâmico | 0.25x | 3.00x | Sensibilidade da variação pelo estoque versus demanda local |
| Max Village Tax Rate | 5% (0.05) | 0.00 | 0.25 | Imposto mercantil adicionado ao valor final de compra |

---

### 4.6. Escala de Afinidade Individual de NPCs (Sprint 13 / TASK-302)

$$	ext{Afinidade} = 	ext{Clamp}(	ext{Afinidade Atual} + \Delta	ext{Afinidade}, -100.0, +100.0)$$

| Intervalo Numérico | Stance Enum | Postura Social | Modificador Comercial na Loja |
|---:|---|---|---:|
| -100.0 a -60.1 | `Stance.HATE` | Hostil / Ódio | 1.25x (+25% no custo de compra) |
| -60.0 a -10.1 | `Stance.DISLIKE` | Frio / Desafeto | 1.10x (+10% no custo de compra) |
| -10.0 a +10.0 | `Stance.NEUTRAL` | Neutro | 1.00x (Sem alteração) |
| +10.1 a +35.0 | `Stance.LIKE` | Simpático | 0.95x (5% de desconto) |
| +35.1 a +65.0 | `Stance.FRIENDSHIP` | Amigo | 0.90x (10% de desconto) |
| +66.0 a +100.0 | `Stance.LOVE` | Devoto / Aliado Íntimo | 0.85x (15% de desconto) |

---

### 4.7. Tabela de Variação de Afinidade por Ações e Presentes (Sprint 13 / TASK-302)

| Ação / Presente | Variação de Afinidade ($\Delta$) | Observação |
|---|---:|---|
| Doação de Item Amado (`loved_item_ids`) | +20.0 | Definido na `RelationshipDefinition` do NPC |
| Doação de Item Gostado (`liked_item_ids`) | +10.0 | Item útil ou apreciado pela profissão do NPC |
| Doação de Item Neutro | +2.0 | Presente genérico |
| Doação de Item Odiado (`hated_item_ids`) | -15.0 | Lixo ou item ofensivo |
| Conclusão de Quest Pessoal | +15.0 | Aplicado via `QuestService` ao entregar a missão |
| Conversa Diária | +2.0 | Limite de 1 vez por dia de jogo |

---

### 4.8. Profissões & Tiers de Maestria (Fase 2)

| ID da Profissão | Nome Visível | Foco / Categoria | Tiers | XP por Tier | Bônus de Eficiência por Tier |
|---|---|---|---:|---:|---:|
| `profession.blacksmith` | Ferraria | Crafting / Equipamentos | 5 | 100.0 | +10% velocidade de forja / +5% qualidade |
| `profession.miner` | Mineração | Extração / Minérios | 5 | 100.0 | +10% rendimento de minério / -5% gasto de energia |
| `profession.alchemist` | Alquimia | Processamento / Poções | 5 | 100.0 | +10% chance de poção dupla |
| `profession.cook` | Culinária | Alimentos / Buffs | 5 | 100.0 | +15% duração de buffs alimentares |
| `profession.fisherman` | Pescaria | Recursos Aquáticos | 5 | 100.0 | +10% velocidade de fisgada |
| `profession.herbalist` | Herborismo | Coleta / Plantas | 5 | 100.0 | +10% rendimento de ervas raras |
| `profession.leatherworker` | Couraria | Crafting / Armaduras de Couro | 5 | 100.0 | +5% durabilidade de armaduras de couro |
| `profession.skinner` | Esfolamento | Materiais Animais | 5 | 100.0 | +10% obtenção de couros e presas |
| `profession.jeweler` | Joalheria | Lapidação / Gemas | 5 | 100.0 | +5% atributos bônus em engates |
| `profession.farmer` | Agricultura | Cultivo / Alimentos | 5 | 100.0 | -15% tempo de crescimento de safras |
| `profession.carpenter` | Carpintaria | Madeira / Estruturas | 5 | 100.0 | +10% resistência de construções |
| `profession.engineer` | Engenharia | Infraestrutura / Trapos | 5 | 100.0 | +10% eficiência de utilitários |
| `profession.doctor` | Medicina | Cura / Primeiros Socorros | 5 | 100.0 | +20% eficácia de curativos |
| `profession.merchant` | Comércio | Mercado / Arbitragem | 5 | 100.0 | +5% valor de venda / -5% taxas de mercado |
| `profession.navigator` | Navegação | Transporte / Rotas | 5 | 100.0 | -10% tempo de viagem rápida |
| `profession.diplomat` | Diplomacia | Relações / Reputação | 5 | 100.0 | +15% ganho de reputação |
| `profession.strategist` | Estratégia Militar | Defesa / Guerra | 5 | 100.0 | +5% defesa de guardas contratados |

---

### 4.9. Quests & Recompensas

| ID | Nome da Quest | Tipo | Requisito de Item | Recompensa em Moedas | Recompensa em Reputação Local | XP Recompensa |
|---|---|---|---|---:|---:|---:|
| QUEST-001 | A Providência do Ferro | Local | 1x Lingote de Ferro (`item.material.iron_ingot`) | 100 Moedas | +50.0 (Vilarejo Inicial) | +100.0 XP |

---

### 4.10. Itens

| ID | Nome | Tipo | Custo Base | Atributo | Multiplicador Resource | Stack Máximo | Status |
|---|---|---|---:|---|---:|---:|---|
| ITEM-001 | Minério de Cobre | Material | 10 | Refinável | 1.00 | 99 | MVP |
| ITEM-002 | Minério de Ferro | Material | 20 | Refinável | 1.00 | 99 | MVP |
| ITEM-003 | Lingote de Cobre | Material Refinado | 35 | Crafting | 1.00 | 99 | MVP |
| ITEM-004 | Lingote de Ferro | Material Refinado | 70 | Crafting | 1.00 | 99 | MVP |
| ITEM-005 | Cobalto | Material | 120 | Raro | 1.00 | 99 | MVP/Expand |
| ITEM-006 | Mithril | Material | 500 | Muito Raro | 1.00 | 99 | MVP/Expand |
| ITEM-007 | Adamantita | Material | 750 | Muito Raro | 1.00 | 99 | MVP/Expand |
| ITEM-008 | Peixe Comum | Food | 12 | Fome | 1.00 | 20 | MVP |
| ITEM-009 | Erva Comum | Alchemy | 8 | Ingrediente | 1.00 | 99 | MVP |
| ITEM-010 | Lótus do Setor Escuro | Alchemy | 300 | Ingrediente Raro | 1.00 | 50 | Expand |
| ITEM-011 | Carvão | Fuel | 15 | Forja | 1.00 | 99 | MVP |
| ITEM-012 | Poção de Energia | Consumable | 80 | +30 Energia | 1.00 | 10 | MVP |

---

### 4.11. Reputação & Ranks de Postura (Stances)

O GDD define a escala de reputação local de 0 a 10.000.

| Pontuação (0–10.000) | Enum / Stance | Status Social / Postura | Desconto Comercial | Comportamento dos Guardas |
|---:|---|---|---:|---|
| 0–999 | `Stance.HATED` | Odiado / Hostil | 0% | Atacam à vista |
| 1.000–2.999 | `Stance.NEUTRAL` | Neutro / Desconhecido | 0% | Indiferente |
| 3.000–5.999 | `Stance.RECOGNIZED` | Reconhecido | 5% | Tolerante |
| 6.000–8.999 | `Stance.RESPECTED` | Respeitado / Ilustre | 10%–15% | Proteção prioritária |
| 9.000–10.000 | `Stance.ALLIED` | Aliado Máximo / Líder | 20% | Acesso a aposentos e quests da elite |

---

### 4.12. Combate & Inimigos

| ID | Entidade / Inimigo | HP | Dano Base Melee | Multiplicador em Penumbra | Multiplicador sob Luz Plena (>= 0.70) | XP Recompensa |
|---|---|---:|---:|---:|---:|---:|
| PLR-001 | Player (Ataque Básico) | 100.0 | 15.0 | 1.0x | 1.0x | N/A |
| ENM-001 | Lobo Esfomeado (`hungry_wolf_node.gd`) | 40.0 | 12.0 | 1.0x | 2.0x (Dano Recebido Dobrado) | +50.0 XP |

---

### 4.13. Custos de Ações de Gameplay (Energy & Survival)

| Ação | Custo de Energia | Custo de Fome | Quantidade de Recurso Gerada | XP de Profissão | Cooldown |
|---|---:|---:|---|---|---:|
| Coleta de Minério de Ferro | -10.0 Energia | -0.5 Fome | 1 a 2 Minérios | +10.0 XP (Miner) | 1.0s |
| Forjar Lingote de Ferro | -15.0 Energia | -1.0 Fome | 1 Lingote | +25.0 XP (Blacksmith) | 2.5s |
| Descanso no Leito (1 hora) | +30.0 Energia | -2.0 Fome | N/A | N/A | Instantâneo |

---

### 4.14. Sobrevivência (Valores do SurvivalComponent)

| Parâmetro | Valor Máximo | Taxa de Variação (Por Minuto de Jogo) | Efeito ao Esgotar |
|---|---:|---:|---|
| Vida (Health) | 100.0 | 0.0 | Morte / Game Over |
| Fome (Hunger) | 100.0 | -0.5 (Decaimento) | Aplica 1.0 de dano contínuo à Vida (Starvation) |
| Fadiga (Fatigue) | 100.0 | +0.2 (Acúmulo) | Penalidade de velocidade/ações |
| Energia (Energy) | 100.0 | Consumo por Ação (-10.0 / -15.0) | Impede ações pesadas/coleta/crafting |
| Temperatura | 0.0 (Neutro) | Dependente do Clima/Região | Penalidades térmicas |
| Conforto | 100.0 | Recuperado ao descansar | Modificador de fadiga |

---

### 4.15. Progressão Geral — Decisões Aprovadas (Sprint 17)

#### XP de Nível Geral

- **Modelo:** Híbrido baseado em Ações e Milestones.
- **Fontes:**
  - combate;
  - coleta;
  - crafting;
  - descobertas de mapa;
  - conclusão de quests.
- **Curva de XP requerida:** $	ext{XP}_{	ext{req}} = 100 	imes 	ext{Nível}^{1.5}$
- **Efeito por nível:**
  - aumento fixo de HP máximo;
  - Talent Points utilitários gerais.
- **Integração com Progressão por Uso:** A XP geral recebe um subproduto percentual da XP obtida em proficiências/profissões.

---

### 4.16. Atributos — Funções Oficiais

| Atributo | Aplicação |
|---|---|
| Força | Carga e dano físico |
| Agilidade | Estamina e mobilidade/execução física |
| Vigor | Defesa e resistência física |
| Inteligência | Potencial mágico, aprendizado de receitas e refinamento |
| Sabedoria | Percepção, sanidade/pânico no Setor Escuro e eficiência de luz |
| Carisma | Preços, afinidade, facções e contratação |

*Todos os atributos utilizam o sistema genérico de Modifier.*

---

### 4.17. Direção Visual — Parâmetros de Produção

- **Resolução-base:** 640 × 360.
- **Tile:** 16 × 16.
- **Player:** 32 × 32.
- **Pixel Snap:** ativo.
- **Pixel Art:** Filter Nearest.
- **Mipmaps:** desativados para pixel art.
- **Iluminação:** 2D nativa da Godot.
