# Assets_Catalog.md

**CATÁLOGO OFICIAL DE ASSETS DO PROJETO**  

**Direção Visual Oficial:** Pixel Art Neons / Chiaroscuro — Retro-Stylized.  
**Parâmetros de Renderização:** Resolução-base $640 \times 360$, Tile Size $16 \times 16$ px, Player/NPC/Enemy $32 \times 32$ px, Texture Filter Nearest (sem borrão de interpolação e sem Mipmaps).  

---

## 1. ASSETS DE PERSONAGENS, ENTIDADES E MONSTROS (`res://assets/textures/entities/`)

| ID | Nome | Tipo | Resolução | Finalidade / Uso | Dependência | Prioridade | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| AST-002 | `SpriteSheetPlayer.png` | SpriteSheet (Grid $4 \times 4$) | $128 \times 128$ px (Quadros de $32 \times 32$ px) | Animações de movimentação direcionais do Player (walk, sprint, idle) | `Player.tscn` / `player.gd` | Mandatory | INTEGRATED / READY |
| AST-003 | `SpriteSheetBlacksmith.png` | SpriteSheet (Grid $4 \times 2$) | $128 \times 64$ px (Quadros de $32 \times 32$ px) | Apresentação e animações do NPC Guardião / Mercador Ferreiro | `NPCFerreiro2D` / `DialogService` | Mandatory | MISSING ASSET |
| AST-004 | `SpriteSheetHungryWolf.png` | SpriteSheet (Grid $4 \times 3$) | $128 \times 96$ px (Quadros de $32 \times 32$ px) | Animações de patrulha, ataque e reação à luz do inimigo Lobo Esfomeado | `hungry_wolf_node.gd` / `CombatSystem` | Mandatory | MISSING ASSET |

---

## 2. ASSETS DE CENÁRIO, MUNDO E ESTRUTURAS (`res://assets/textures/environment/`)

| ID | Nome | Tipo | Resolução | Finalidade / Uso | Dependência | Prioridade | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| AST-001 | `TileSetIronGorge.png` | TileSet (Grid $16 \times 16$) | $256 \times 256$ px | Terreno, elevações, rochas, caminhos e paredes do Posto Avançado da Garganta de Ferro | `TileMapLayer` / `GargantaDeFerro.tscn` | Mandatory | MISSING ASSET |
| AST-006 | `SpriteAlignmentBeacon.png` | Texture2D / Sprite | $32 \times 64$ px | Estrutura visual do Farol do Alinhamento (Ponto de Save, Respawn e zona segura) | `AlignmentBeaconNode` / `SaveService` | Mandatory | MISSING ASSET |
| AST-007 | `SpriteForgeStation.png` | Texture2D / Sprite | $48 \times 48$ px | Estação de trabalho visual da Forja de Ferro | `forge_node.gd` / `CraftingService` | Mandatory | MISSING ASSET |
| AST-008 | `SpriteIronOreNode.png` | SpriteSheet (2 Quadros) | $32 \times 16$ px (Quadros de $16 \times 16$ px) | Nó interativo de minério de ferro (Estado Ativo / Estado Exaurido) | `resource_iron_node.gd` / `GatheringSystem` | Mandatory | MISSING ASSET |
| AST-009 | `TextureBioluminescentFlora.png` | GradientTexture2D / Sprite | $32 \times 32$ px | Representação da flora bioluminescente que gera ilhas de luz no Setor Escuro | `bioluminescent_flora_node.gd` | Mandatory | INTEGRATED / READY |

---

## 3. ASSETS DE INTERFASE E ÍCONES DA HUD (`res://assets/textures/ui/`)

| ID | Nome | Tipo | Resolução | Finalidade / Uso | Dependência | Prioridade | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| AST-005 | `ItemIconsSheet.png` | AtlasTexture / Grid | $160 \times 160$ px (Ícones de $16 \times 16$ px ou $32 \times 32$ px) | Ícones visuais de Minério de Ferro, Lingote de Ferro, Carvão e Poção de Energia | `InventoryService` / GridContainer UI | Mandatory | MISSING ASSET |
| AST-010 | `UIThemeRetroNineSlice.png` | StyleBoxTexture / 9-Slice | $48 \times 48$ px | Bordas de janelas, containers de inventário, barras de diálogo e painéis retro-stylized | Theme Global / `UIManager.tscn` | Mandatory | MISSING ASSET |
| AST-011 | `HUDStatBars.png` | TextureProgressBar | $128 \times 32$ px | Molduras e preenchimentos das barras visuais de Vida (HP), Estamina, Energia e Lanterna | HUD / `HUDView` | Mandatory | MISSING ASSET |
