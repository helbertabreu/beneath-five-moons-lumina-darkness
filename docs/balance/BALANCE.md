# Beneath Five Moons — Balance Database
## Planilha de Balanceamento em Markdown

**Versão:** 1.4.0  
**Status:** Atualizado com Parâmetros de Quests, Diálogos e Recompensas da Sprint 6  
**Fonte:** GDD e definições do QuestService / InventoryService / SurvivalComponent  

---

# 1. Controle de Versão

| Versão | Data | Autor | Alterações |
|---|---|---|---|
| 1.0.0 | 2026-08-18 | Equipe de Desenvolvimento | Base inicial para expansão |
| 1.1.0 | 2026-08-20 | Tech Lead | Atualização das taxas do SurvivalComponent |
| 1.2.0 | 2026-08-21 | Tech Lead | Adicionados parâmetros da TASK-106 e custos da TASK-107/108 |
| 1.3.0 | 2026-08-21 | Tech Lead | Adicionados parâmetros da TASK-109 e valores de combate da TASK-110 |
| 1.4.0 | 2026-08-21 | Tech Lead | Adicionadas recompensas da Quest 01 e tabela de quests |

---

# 2. Quests & Recompensas

| ID | Nome da Quest | Tipo | Requisito de Item | Recompensa em Moedas | Recompensa em Reputação Local | XP Recompensa |
|---|---|---|---|---:|---:|---:|
| QUEST-001 | A Providência do Ferro | Local | 1x Lingote de Ferro (`item.material.iron_ingot`) | 100 Moedas | +50.0 (Vilarejo Inicial) | +100.0 XP |

---

# 3. Itens

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

# 4. Combate & Inimigos

| ID | Entidade / Inimigo | HP | Dano Base Melee | Multiplicador em Penumbra | Multiplicador sob Luz Plena (>= 0.70) | XP Recompensa |
|---|---|---:|---:|---:|---:|---:|
| PLR-001 | Player (Ataque Básico) | 100.0 | 15.0 | 1.0x | 1.0x | N/A |
| ENM-001 | Lobo Esfomeado (`hungry_wolf_node.gd`) | 40.0 | 12.0 | 1.0x | 2.0x (Dano Recebido Dobrado) | +50.0 XP |

---

# 5. Custos de Ações de Gameplay (Energy & Survival)

| Ação | Custo de Energia | Custo de Fome | Quantidade de Recurso Gerada | XP de Profissão | Cooldown |
|---|---:|---:|---:|---:|---:|
| Coleta de Minério de Ferro | -10.0 Energia | -0.5 Fome | 1 a 2 Minérios | N/A | 1.0s |
| Forjar Lingote de Ferro | -15.0 Energia | -1.0 Fome | 1 Lingote | +25.0 XP (Blacksmith) | 2.5s |
| Descanso no Leito (1 hora) | +30.0 Energia | -2.0 Fome | N/A | N/A | Instantâneo |

---

# 6. Sobrevivência (Valores do SurvivalComponent)

| Parâmetro | Valor Máximo | Taxa de Variação (Por Minuto de Jogo) | Efeito ao Esgotar |
|---|---:|---:|---|
| Vida (Health) | 100.0 | 0.0 | Morte / Game Over |
| Fome (Hunger) | 100.0 | -0.5 (Decaimento) | Aplica 1.0 de dano contínuo à Vida (Starvation) |
| Fadiga (Fatigue) | 100.0 | +0.2 (Acúmulo) | Penalidade de velocidade/ações |
| Energia (Energy) | 100.0 | Consumo por Ação (-10.0 / -15.0) | Impede ações pesadas/coleta/crafting |
| Temperatura | 0.0 (Neutro) | Dependente do Clima/Região | Penalidades térmicas |
| Conforto | 100.0 | Recuperado ao descansar | Modificador de fadiga |
