# Beneath Five Moons — Balance Database
## Planilha de Balanceamento em Markdown

**Versão:** 1.1.0  
**Status:** Atualizado com taxas da Sprint 3  
**Fonte:** GDD e definições dos componentes de sobrevivência  

---

# 1. Controle de Versão

| Versão | Data | Autor | Alterações |
|---|---|---|---|
| 1.0.0 | 2026-08-18 | Equipe de Desenvolvimento | Base inicial para expansão |
| 1.1.0 | 2026-08-20 | Tech Lead | Atualização das taxas do SurvivalComponent |

---

# 2. Itens

| ID | Nome | Tipo | Custo Base | Atributo | Multiplicador Resource | Status |
|---|---|---|---:|---|---:|---|
| ITEM-001 | Minério de Cobre | Material | 10 | Refinável | 1.00 | MVP |
| ITEM-002 | Minério de Ferro | Material | 20 | Refinável | 1.00 | MVP |
| ITEM-003 | Lingote de Cobre | Material Refinado | 35 | Crafting | 1.00 | MVP |
| ITEM-004 | Lingote de Ferro | Material Refinado | 70 | Crafting | 1.00 | MVP |
| ITEM-005 | Cobalto | Material | 120 | Raro | 1.00 | MVP/Expand |
| ITEM-006 | Mithril | Material | 500 | Muito Raro | 1.00 | MVP/Expand |
| ITEM-007 | Adamantita | Material | 750 | Muito Raro | 1.00 | MVP/Expand |
| ITEM-008 | Peixe Comum | Food | 12 | Fome | 1.00 | MVP |
| ITEM-009 | Erva Comum | Alchemy | 8 | Ingrediente | 1.00 | MVP |
| ITEM-010 | Lótus do Setor Escuro | Alchemy | 300 | Ingrediente Raro | 1.00 | Expand |
| ITEM-011 | Carvão | Fuel | 15 | Forja | 1.00 | MVP |
| ITEM-012 | Poção de Energia | Consumable | 80 | +30 Energia | 1.00 | MVP |

---

# 3. Sobrevivência (Valores do SurvivalComponent)

| Parâmetro | Valor Máximo | Taxa de Variação (Por Minuto de Jogo) | Efeito ao Esgotar |
|---|---:|---:|---|
| Vida (Health) | 100.0 | 0.0 | Morte / Game Over |
| Fome (Hunger) | 100.0 | -0.5 (Decaimento) | Aplica 1.0 de dano contínuo à Vida (Starvation) |
| Fadiga (Fatigue) | 100.0 | +0.2 (Acúmulo) | Penalidade de velocidade/ações |
| Energia (Energy) | 100.0 | Consumo por Ação (-10.0 Coleta) | Impede ações pesadas |
| Temperatura | 0.0 (Neutro) | Dependente do Clima/Região | Penalidades térmicas |
| Conforto | 100.0 | Recuperado ao descansar | Modificador de fadiga |
