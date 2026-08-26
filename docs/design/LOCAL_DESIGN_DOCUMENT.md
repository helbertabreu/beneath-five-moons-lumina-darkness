# LOCATION DESIGN DOCUMENT (LDD)

**Posto Avançado da Garganta de Ferro**  
**Versão:** 1.0.0  
**Status:** AGUARDANDO APROVAÇÃO  
**Local:** Posto Avançado da Garganta de Ferro  
**Perspectiva:** Top-Down 2D  
**Engine:** Godot 4.7.1  

---

## 1. Identificação

O Posto Avançado da Garganta de Ferro é a última fortificação de fronteira entre a vegetação vibrante das Terras Alinhadas e a penumbra fria do Setor Escuro. É um pequeno assentamento fortificado construído ao redor de um Farol do Alinhamento e de uma forja de mineração.  

---

## 2. Função Narrativa

Serve como ponto de entrada do jogador no mundo de Quintalia. Introduz a transição entre a segurança da luz e os perigos da penumbra, além de servir como central de operações inicial para aprendizado de coleta, forja e combate.  

---

## 3. Região

Garganta de Ferro (Zona de Transição de Fronteira).  

---

## 4. Bioma

Estepes Rochosas com transição para Caverna Penumbrosa Bioluminescente.  

---

## 5. Lore

Antigo posto militar erguido pela Irmandade de Bronze para supervisionar a extração de minério de ferro. Com o afastamento das patrulhas, o local sobrevive mantido pelo Ferreiro Gorn e pela energia emanada pelo Farol do Alinhamento.  

---

## 6. Gameplay

Slice Vertical focado na validação do core loop:  

$$	ext{Explorar} ightarrow 	ext{Coletar} ightarrow 	ext{Craftar} ightarrow 	ext{Combater} ightarrow 	ext{Luz} ightarrow 	ext{NPC/Quest} ightarrow 	ext{Save}$$

---

## 7. Layout

- **Norte / Centro:** Área segura do micro-assentamento com o Farol do Alinhamento, Ponto de Save e o NPC Ferreiro Gorn próximo à sua Forja.  
- **Leste:** Posto de mineração com 2 nós de Mina de Ferro e estação de trabalho.  
- **Sudoeste:** Entrada da caverna em Penumbra contendo 1 ponto de Flora Bioluminescente e área de patrulha dos Lobos Esfomeados.  

---

## 8. Escala

- **Dimensões do Mapa:** 40 × 30 Tiles ($640 	imes 480$ pixels totais).  
- **Tamanho do Tile:** $16 	imes 16$ pixels.  

---

## 9. Pontos de Interesse

- **Farol do Alinhamento:** Fonte de Luz Plena e Ponto de Restauração/Save.  
- **Oficina do Gorn:** Localização do NPC Ferreiro Gorn e do nó de Forja.  
- **Mina da Garganta:** Concentração dos recursos de Minério de Ferro.  
- **Gruta do Setor Escuro:** Zona de iluminação reduzida (Penumbra).  

---

## 10. Rotas

Caminho rochoso principal conectando a zona segura do Farol à mina a Leste e à caverna a Sudoeste.  

---

## 11. Recursos

- 2x Nós de Minério de Ferro (`IronMineNode`).  
- 1x Flora Bioluminescente (`BioluminescentFloraNode`).  

---

## 12. NPCs

- 1x Ferreiro Gorn (`blacksmith_npc_node.gd`).  

---

## 13. Inimigos

- 2x Lobos Esfomeados (`hungry_wolf_node.gd`).  

---

## 14. Quests

QUEST-001 (A Providência do Ferro) concedida por Gorn.  

---

## 15. Iluminação

- **Área Segura (Farol):** Luz Plena ($0.75 - 1.0$).  
- **Área Externa:** Penumbra Azulada ($0.25$) mantida via `CanvasModulate`.  
- **Flora Bioluminescente:** Pulso de Luz Plena ($0.75$) em raio de 80px.  

---

## 16. Clima

Estável / Frio Moderado de Montanha.  

---

## 17. Navegação

Malha de navegação 2D (`NavigationRegion2D`) cobrindo todas as áreas transitáveis fora dos obstáculos de rocha e estruturas.  

---

## 18. Entradas

Estrada das Terras Alinhadas (ao Norte).  

---

## 19. Saídas

Passagem para o Setor Escuro (ao Sul).  

---

## 20. Interações

- Coleta de minério.  
- Forja de lingotes.  
- Diálogo/Loja com Gorn.  
- Ativação de fogueira/save.  
- Acionamento da lanterna portátil (Tecla 'F').  

---

## 21. Assets

Atualmente dependente dos assets catalogados na auditoria (AST-001 a AST-004).  

---

## 22. Cenas

`res://scenes/world/iron_gorge_outpost.tscn` (A ser construída).  

---

## 23. Resources

`res://data/regions/iron_gorge_outpost.tres`.  

---

## 24. Multiplayer

Host possui autoridade sobre o estado dos nós de minério, respawn do Lobo Esfomeado e sincronização dos clientes.  

---

## 25. Save/Load

Persistência do progresso da quest de Gorn, inventário do jogador e estado dos nós de minério via `SaveService`.  

---

## 26. Critérios de Aceitação

O local estará concluído quando o jogador puder circular por todo o perímetro sem colisões inválidas, interagir com a forja, minerar, conversar com Gorn e combater os lobos sob o efeito da iluminação bioluminescente e da lanterna.  

---

*Aguardando o envio dos arquivos autorizados (`main_theme.tres` e `Player.tscn`) e a sua aprovação explícita do LDD para prosseguir com os próximos passos da Apresentação Visual e World Building.*
