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
```

---

# STATUS POSSÍVEIS

- PROPOSTA
- ATIVA
- SUPERADA
- CANCELADA

---

# DECISÕES ATIVAS

## ADR-001 — Desacoplamento da Persistência via EntityId

**Data:** 2026-08-20  
**Status:** ATIVA

### Contexto
O Save/Load não pode depender do caminho dos Nós (`NodePath`) na árvore do Godot, sob risco de corromper dados caso a estrutura da cena mude.

### Decisão
Toda entidade persistente possuirá um `EntityId` estável do tipo `StringName` (ex: `ent.player.001`).

### Consequências
Saves imunes à reestruturação de cenas e arquitetura preparada para multiplayer futuro.

---

## ADR-002 — Composição de Nós e Componentes em GDScript

**Data:** 2026-08-20  
**Status:** ATIVA

### Contexto
O projeto precisa manter alto desacoplamento e evitar heranças profundas.

### Decisão
Utilizar o padrão Composição. Nós do Godot representam presença visual/física, enquanto componentes em scripts controlam regras lógicas.

---

## ADR-003 — Limites de Autoloads e uso do ServiceRegistry

**Data:** 2026-08-20  
**Status:** ATIVA

### Contexto
Autoloads em excesso criam acoplamento invisível e "God Objects".

### Decisão
Apenas serviços puramente globais (ex: `EventBus`, `TimeService`, `SaveService`) serão Autoloads. A localização de serviços será mediada pelo `ServiceRegistry`.

---

## ADR-004 — Separação Definition × Instance × State

**Data:** 2026-08-20  
**Status:** ATIVA

### Decisão
- `Definition` (Godot Resource .tres): Dados estáticos e imutáveis de conteúdo.
- `Runtime State` (RefCounted/Objects): Estado mutável serializável.
- `Node/Component` (Node2D/Control): Apresentação visual e física.

---

## ADR-005 — Compatibilidade Estrita com Godot 4.7.1 e GDScript 2.0

**Data:** 2026-08-20  
**Status:** ATIVA

### Decisão
Todo o código deve ser GDScript 2.0 estritamente tipado, sem chamadas obsoletas da Godot 3.x.

---

## ADR-008 — Remapeamento de Escopo MVP: Perspectiva 2D e Exclusão da Sede

**Data:** 2026-08-20  
**Status:** ATIVA

### Contexto
Avaliação da complexidade de escopo durante a Revisão do Gate 0.

### Decisão
1. O jogo será desenvolvido **exclusivamente em 2D** (perspectiva Top-Down 2D usando `CharacterBody2D`, `PointLight2D` e `TileMapLayer`).
2. A necessidade de **Sede** está oficialmente removida do MVP, mantendo a sobrevivência focada em Vida, Fome, Fadiga, Energia, Temperatura e Conforto.

### Motivo
Reduzir o risco de produção para um desenvolvedor iniciante, acelerar a entrega do protótipo jogável e garantir 60 FPS estáveis sem gargalos de arte 3D.

### Consequências Positivas
- Simplificação na criação de cenas e físicas 2D.
- Uso de iluminação por `CanvasModulate` e `PointLight2D` com excelente performance.
- Foco absoluto na diversão dos sistemas sistêmicos.

### Sistemas Afetados
- Player (`CharacterBody2D`), Câmera (`Camera2D`), Iluminação (`PointLight2D`), Sobrevivência (`SurvivalComponent`).

---

# REGRAS DO DOCUMENTO

1. Nunca apagar decisões importantes.
2. Nunca alterar uma decisão ATIVA silenciosamente.
3. Se uma nova decisão contradizer uma decisão anterior, registrar uma nova ADR.
4. Explicar o motivo da mudança.
5. Preservar o histórico.
6. Referenciar arquivos e sistemas afetados quando relevante.
7. O documento deve representar decisões realmente aprovadas, não apenas sugestões.
8. Decisões provisórias devem ser claramente marcadas como PROPOSTA.
