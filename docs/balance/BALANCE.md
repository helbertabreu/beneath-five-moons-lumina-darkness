---

# BALANCE.md

> Planilha e base central de dados de balanceamento em Markdown.

---

# 1. Controle de Versão

| Versão | Data | Autor | Alterações |
|---|---|---|---|
| 1.1.0 | 2026-08-20 | Tech Lead | Atualizado para 2D e removido parâmetro de Sede do MVP |
| 1.0.0 | 2026-08-18 | Equipe de Desenvolvimento | Base inicial para expansão |

---

# 2. Sobrevivência (Valores Base do MVP)

| Parâmetro | Valor Inicial | Taxa de Decaimento (por minuto de jogo) | Efeito ao Zerar | Status |
|---|---:|---:|---|---|
| Vida (Health) | 100.0 | 0.0 | Morte / Game Over | MVP |
| Fome (Hunger) | 100.0 | -0.5 | Inicia dano à Vida (-1 HP/tick) | MVP |
| Fadiga (Fatigue) | 0.0 | +0.2 (Aumenta com ações) | Impede corrida e reduz acerto | MVP |
| Energia (Energy) | 100.0 | -0.1 | Bloqueia ações de trabalho/coleta | MVP |
| Temperatura (Temp) | 37.0 (Celsius) | Variável por clima/região | < 30°C: Frio extremo / > 42°C: Calor | MVP |
| Conforto (Comfort) | 50.0 | 0.0 (Baseado em abrigo) | Modifica regeneração de Energia | MVP |

---

# 3. Itens do MVP

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

# 4. Monstros (Ajustados para 2D)

| ID | Nome | HP | Dano | Velocidade (px/s) | XP | Drops | Status |
|---|---|---:|---:|---:|---:|---|---|
| ENM-001 | Lobo Esfomeado | 40 | 12 | 110 | 25 | Carne, Couro | MVP |
| ENM-002 | Salteador da Noite | 60 | 15 | 120 | 45 | Moedas, Equipamento | MVP |
| ENM-003 | Goblin | 80 | 18 | 95 | 60 | Moedas, Material | Expand |
| ENM-004 | Orc | 180 | 30 | 70 | 120 | Arma, Couro | Expand |
| ENM-005 | Troll | 450 | 55 | 45 | 350 | Material Raro | Expand |
| ENM-006 | Wraith | 250 | 40 | 100 | 200 | Essência Sombria | Expand |
| ENM-007 | Basilisk | 700 | 65 | 55 | 500 | Veneno, Escama | Expand |
| ENM-008 | Warlord | 2.500 | 100 | 65 | 2000 | Artefato | Boss |

---

# 5. Balanceamento de Drop

## 5.1 Raridade

| Raridade | Chance Base | Multiplicador de Valor |
|---|---:|---:|
| Common | 60.00% | 1.00 |
| Uncommon | 25.00% | 1.50 |
| Rare | 10.00% | 3.00 |
| Epic | 4.00% | 7.50 |
| Legendary | 1.00% | 20.00 |

## 5.2 Drop Tables

| Drop Table ID | Inimigo/Origem | Item | Quantidade Min | Quantidade Max | Chance | Peso | Condição |
|---|---|---|---:|---:|---:|---:|---|
| DROP-WOLF-01 | ENM-001 | Carne | 1 | 3 | 75% | 75 | Sempre |
| DROP-WOLF-02 | ENM-001 | Couro | 1 | 2 | 40% | 40 | Sempre |
| DROP-WOLF-03 | ENM-001 | Presa | 1 | 2 | 15% | 15 | Sempre |
| DROP-BANDIT-01 | ENM-002 | Gold | 5 | 20 | 80% | 80 | Sempre |
| DROP-BANDIT-02 | ENM-002 | Consumable | 1 | 1 | 25% | 25 | Sempre |
| DROP-BANDIT-03 | ENM-002 | Equipment | 1 | 1 | 8% | 8 | Elite/variante |

---

# 6. Economia Básica

| Parâmetro | Valor Inicial | Limite Mínimo | Limite Máximo | Status |
|---|---:|---:|---:|---|
| Base Price Multiplier | 1.00 | 0.25 | 3.00 | Proposto |
| Reputation Multiplier | 1.00 | 0.80 | 1.00 | GDD |
| Supply Modifier | 1.00 | 0.30 | 2.50 | Proposto |
| Demand Modifier | 1.00 | 0.50 | 3.00 | Proposto |
| Tax Rate | 0% | 0% | 25% | GDD |

---

# 7. Convenções

- IDs em formato de texto estável (`item.categoria.nome`).
- Todos os parâmetros de taxa e combate devem ser lidos a partir de `Resource` ou deste arquivo, nunca hardcoded em scripts GDScript.
