# Beneath Five Moons — Balance Database
## Planilha de Balanceamento em Markdown

**Versão:** 2.1.0  
**Status:** Atualizado com Parâmetros de Economia Dinâmica, Oferta/Demanda e Descontos de Reputação (Sprint 9)  
**Fonte:** GDD, TDD e especificações do PricingService / InventoryService / SurvivalComponent  

---

# 1. Controle de Versão

| Versão | Data | Autor | Alterações |
|---|---|---|---|
| 1.0.0 | 2026-08-18 | Equipe de Desenvolvimento | Base inicial para expansão |
| 1.1.0 | 2026-08-20 | Tech Lead | Atualização das taxas do SurvivalComponent |
| 1.2.0 | 2026-08-21 | Tech Lead | Adicionados parâmetros da TASK-106 e custos da TASK-107/108 |
| 1.3.0 | 2026-08-21 | Tech Lead | Adicionados parâmetros da TASK-109 e valores de combate da TASK-110 |
| 1.4.0 | 2026-08-21 | Tech Lead | Adicionadas recompensas da Quest 01 e tabela de quests |
| 2.0.0 | 2026-08-21 | Tech Lead | Expansão da Fase 2: Tabela de Profissões, Tiers de Maestria e XP Base |
| 2.1.0 | 2026-08-21 | Tech Lead | Parâmetros da Sprint 9 (TASK-202): Limites de Flutuação Econômica e Margens de Venda |

---

# 2. Economia Dinâmica & Parâmetros do PricingService (Sprint 9)

$$\text{Preço Final} = \text{Preço Base} \times \text{Multiplicador de Reputação} \times \left(1 + \frac{\text{Demanda} - \text{Estoque}}{\text{Estoque Mínimo}}\right) \times (1 + \text{Taxa de Imposto})$$

| Parâmetro Econômico | Valor Inicial / Regra | Limite Mínimo (Clamp) | Limite Máximo (Clamp) | Descrição / Função |
|---|---:|---:|---:|---|
| Base Price Multiplier | 1.00 | 0.25x | 3.00x | Trava de segurança global para flutuações de preços |
| Player Sell Margin | 60% (0.60) | N/A | N/A | Jogadores vendem itens por 60% do valor de compra calculado |
| Supply/Demand Factor | Dinâmico | 0.25x | 3.00x | Sensibilidade da variação pelo estoque versus demanda local |
| Max Village Tax Rate | 0%–25% (0.00–0.25) | 0.00 | 0.25 | Imposto mercantil adicionado ao valor final de compra |

---

# 3. Profissões & Tiers de Maestria (Fase 2)

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

# 4. Quests & Recompensas

| ID | Nome da Quest | Tipo | Requisito de Item | Recompensa em Moedas | Recompensa em Reputação Local | XP Recompensa |
|---|---|---|---|---:|---:|---:|
| QUEST-001 | A Providência do Ferro | Local | 1x Lingote de Ferro (`item.material.iron_ingot`) | 100 Moedas | +50.0 (Vilarejo Inicial) | +100.0 XP |

---

# 5. Itens

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

# 6. Reputação & Facções (Fase 2)

O GDD define a escala de reputação local de 0 a 10.000.

| Pontuação | Rank / Postura | Desconto Comercial | Multiplicador de Preço |
|---:|---|---:|---:|
| 0–999 | Desconhecido / Neutro | 0% | 1.00 |
| 1.000–2.999 | Reconhecido | 5% | 0.95 |
| 3.000–5.999 | Respeitado | 10% | 0.90 |
| 6.000–8.999 | Ilustre | 15% | 0.85 |
| 9.000–10.000 | Elegível / Aliado Máximo | 20% | 0.80 |

---

# 7. Combate & Inimigos

| ID | Entidade / Inimigo | HP | Dano Base Melee | Multiplicador em Penumbra | Multiplicador sob Luz Plena (>= 0.70) | XP Recompensa |
|---|---|---:|---:|---:|---:|---:|
| PLR-001 | Player (Ataque Básico) | 100.0 | 15.0 | 1.0x | 1.0x | N/A |
| ENM-001 | Lobo Esfomeado (`hungry_wolf_node.gd`) | 40.0 | 12.0 | 1.0x | 2.0x (Dano Recebido Dobrado) | +50.0 XP |

---

# 8. Custos de Ações de Gameplay (Energy & Survival)

| Ação | Custo de Energia | Custo de Fome | Quantidade de Recurso Gerada | XP de Profissão | Cooldown |
|---|---:|---:|---|---|---:|
| Coleta de Minério de Ferro | -10.0 Energia | -0.5 Fome | 1 a 2 Minérios | +10.0 XP (Miner) | 1.0s |
| Forjar Lingote de Ferro | -15.0 Energia | -1.0 Fome | 1 Lingote | +25.0 XP (Blacksmith) | 2.5s |
| Descanso no Leito (1 hora) | +30.0 Energia | -2.0 Fome | N/A | N/A | Instantâneo |

---

# 9. Sobrevivência (Valores do SurvivalComponent)

| Parâmetro | Valor Máximo | Taxa de Variação (Por Minuto de Jogo) | Efeito ao Esgotar |
|---|---:|---:|---|
| Vida (Health) | 100.0 | 0.0 | Morte / Game Over |
| Fome (Hunger) | 100.0 | -0.5 (Decaimento) | Aplica 1.0 de dano contínuo à Vida (Starvation) |
| Fadiga (Fatigue) | 100.0 | +0.2 (Acúmulo) | Penalidade de velocidade/ações |
| Energia (Energy) | 100.0 | Consumo por Ação (-10.0 / -15.0) | Impede ações pesadas/coleta/crafting |
| Temperatura | 0.0 (Neutro) | Dependente do Clima/Região | Penalidades térmicas |
| Conforto | 100.0 | Recuperado ao descansar | Modificador de fadiga |
