# Beneath Five Moons — Balance Database
## Planilha de Balanceamento em Markdown

**Versão:** 1.1.0  
**Status:** Atualizado para a Sprint 2 / Sprint 3  
**Fonte:** GDD existente + parâmetros propostos para expansão[cite: 16]

---

# 1. Controle de Versão

| Versão | Data | Autor | Alterações |
|---|---|---|---|
| 1.0.0 | 2026-08-18 | Equipe de Desenvolvimento | Base inicial para expansão |
| 1.1.0 | 2026-08-20 | Tech Lead | Atualização dos parâmetros de movimentação e velocidade 2D |

---

# 2. Movimentação do Player (2D Top-Down)

| Parâmetro | Valor Base | Unidade | Observações | Status |
|---|---:|---|---|---|
| Move Speed (Andar) | 120.0 | px/s | Velocidade normal de deslocamento | MVP |
| Sprint Speed (Correr) | 200.0 | px/s | Velocidade com a tecla Shift pressionada | MVP |
| Acceleration | 800.0 | px/s² | Taxa de aceleração da movimentação | MVP |
| Friction | 1000.0 | px/s² | Taxa de desaceleração ao soltar os controles | MVP |
| Camera Smoothing Speed | 5.0 | px/s | Taxa de suavização de acompanhamento da Camera2D | MVP |

---

# 3. Itens

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

# 4. Reputação

O GDD define reputação local de 0 a 10.000[cite: 16].

| Pontuação | Rank | Desconto | Multiplicador |
|---:|---|---:|---:|
| 0–999 | Desconhecido | 0% | 1.00 |
| 1.000–2.999 | Reconhecido | 5% | 0.95 |
| 3.000–5.999 | Respeitado | 10% | 0.90 |
| 6.000–8.999 | Ilustre | 15% | 0.85 |
| 9.000–10.000 | Elegível (Líder) | 20% | 0.80 |

---

# 5. Monstros

| ID | Nome | HP | Dano | Velocidade | XP | Drops | Status |
|---|---|---:|---:|---:|---:|---|---|
| ENM-001 | Lobo Esfomeado | 40 | 12 | 110 | TBD | Carne, Couro | MVP |
| ENM-002 | Salteador da Noite | 60 | 15 | 120 | TBD | Moedas, Equipamento | MVP |
| ENM-003 | Goblin | 80 | 18 | 95 | TBD | Moedas, Material | Expand |
| ENM-004 | Orc | 180 | 30 | 70 | TBD | Arma, Couro | Expand |
| ENM-005 | Troll | 450 | 55 | 45 | TBD | Material Raro | Expand |
| ENM-006 | Wraith | 250 | 40 | 100 | TBD | Essência Sombria | Expand |
| ENM-007 | Basilisk | 700 | 65 | 55 | TBD | Veneno, Escama | Expand |
| ENM-008 | Warlord | 2.500 | 100 | 65 | TBD | Artefato | Boss |

---

# 6. Sobrevivência (6 Necessidades)

| Sistema | Base Máxima | Parâmetro de Decaimento/Ação | Status |
|---|---:|---|---|
| Vida (Health) | 100 | Regeneração por descanso / Dano por combate ou starvation | MVP |
| Fome (Hunger) | 100 | -1.0 por minuto virtual / -3 em combate / -5 em viagem | MVP |
| Fadiga (Fatigue) | 100 | Aumenta ao correr ou minerar / Reduz ao descansar | MVP |
| Energia (Energy) | 100 | Consumo por atividades de coleta (-10 por mineração) | MVP |
| Temperatura | 0 (Neutro) | Escala de -50 (Frio Extremo) a +50 (Calor Extremo) | MVP |
| Conforto | 100 | Reduz exposição a intempéries / Aumenta recuperação de sono | MVP |

---

# 7. Convenções

- IDs em `UPPER_SNAKE_CASE`[cite: 16].
- Dados em `Resource`[cite: 16].
- Estado persistente separado de dados estáticos[cite: 16].
- Nenhum valor crítico deve ser hardcoded em scripts quando for balanceável[cite: 16].
