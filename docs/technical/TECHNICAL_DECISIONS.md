# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto.
>
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

# STATUS POSSÍVEIS

- PROPOSTA
- ATIVA
- SUPERADA
- CANCELADA

# DECISÕES ATIVAS

## ADR-001 — Adoção da Perspectiva 2D Top-Down para a Vertical Slice MVP

**Data:** 2026-08-18

**Status:** ATIVA

### Contexto

O projeto precisava de uma validação funcional rápida dos sistemas sistêmicos (sobrevivência, coleta, forja, combate, quests e iluminação).

### Decisão

Desenvolver a Vertical Slice em perspectiva 2D Top-Down mantendo a camada de domínio desacoplada.

### Motivo

Reduzir a complexidade de assets 3D na fase de validação mantendo a arquitetura pronta para migração futura.

### Consequências positivas

- Agilidade de prototipagem e facilidade na criação de testes automatizados.

### Trade-offs

- A apresentação visual inicial difere da visão de longo prazo em 3ª pessoa.

### Sistemas afetados

- Player, Inimigos, Câmera e Iluminação.

---

## ADR-002 — Arquitetura de Scenes e Components

**Status:** ATIVA

### Contexto

O projeto precisa manter sistemas modulares e reutilizáveis.

### Decisão

Priorizar composição por Nodes/Components, Scenes reutilizáveis, Resources e Signals antes de criar hierarquias profundas de herança.

### Motivo

Reduzir acoplamento e facilitar manutenção, testes e evolução do projeto.

### Consequências

O projeto deve evitar scripts monolíticos e heranças profundas quando composição resolver o problema.

---

## ADR-003 — Uso de Autoloads

**Status:** ATIVA

### Decisão

Autoloads serão utilizados apenas para sistemas realmente globais e persistentes entre Scenes.

### Exemplos

- EventBus
- TimeService
- GameState
- SaveService
- SceneManager
- ServiceRegistry

### Regra

Não transformar componentes de gameplay comuns em Autoloads.

---

## ADR-004 — Dados Data-Driven

**Status:** ATIVA

### Decisão

Quando apropriado, dados configuráveis de gameplay deverão ser separados da lógica utilizando Resources.

### Exemplos

- Items
- Weapons
- Enemies
- Characters
- Skills
- Quests
- Loot Tables

### Motivo

Facilitar balanceamento, manutenção e expansão.

---

## ADR-005 — Compatibilidade Godot 4

**Status:** ATIVA

### Decisão

O projeto será desenvolvido utilizando APIs, sintaxe e práticas compatíveis com Godot 4.x (especificamente Godot 4.7.1).

### Regra

Não introduzir código ou APIs específicas de Godot 3.x.

---

## ADR-012 — Padrão MVVM/Presentation Model para a Interface de Comércio (TASK-301)

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A interface de comércio (`ShopInterface.tscn` / `shop_interface.gd`) precisava exibir preços dinâmicos baseados no estado do mercado e reputação com a facção do comerciante, sem duplicar regras econômicas dentro da camada visual de UI.

### Decisão

Implementar a `ShopInterface` seguindo o padrão Presentation Model/MVVM. A UI apenas lê os preços calculados via `PricingService.calculate_buy_price()` e `calculate_sell_price()` e executa transações chamando a API do `InventoryService`.

### Motivo

Garante que as regras de precificação, margem de venda (60%), descontos de facção e taxas permaneçam isoladas e testáveis na camada de domínio, mantendo a UI totalmente desacoplada e reutilizável.

### Consequências Positivas

- A interface de UI pode ser reaproveitada por qualquer comerciante ou vilarejo.
- Testes unitários do sistema de comércio rodam sem necessidade de carregar a árvore de visualização física do Godot.

---

# DECISÕES DE GAMEPLAY

## ADR-008 — Remoção do Parâmetro de Sede do MVP

**Data:** 2026-08-18

**Status:** ATIVA

### Contexto

O GDD previa o parâmetro Sede no SurvivalComponent junto com Fome, Fadiga, Energia, Temperatura e Conforto.

### Decisão

Adiar a mecânica de Sede para fases pós-MVP.

### Motivo

Evitar atrito excessivo de micromanagement na fase de testes iniciais.

### Impacto no gameplay

O SurvivalComponent foca em 5 necessidades fundamentais durante o MVP.

---

# DECISÕES DE PERFORMANCE

## ADR-010 — Frequências Diferenciadas de Simulação (Ticks)

**Data:** 2026-08-20

**Status:** ATIVA

### Problema

Processar economia, regeneração de recursos e simulação de NPCs a cada frame gerava desperdício de CPU.

### Decisão

Isolar simulações de baixo ciclo em ticks do `TimeService` (ex: a cada minuto do jogo) em vez de usar `_process(delta)`.

### Motivo

Manter a performance em 60 FPS estáveis sem gargalos de CPU.

### Trade-offs

Ações de mundo são processadas em intervalos discretos.

---

# DECISÕES SUPERADAS

*(Nenhuma decisão superada no momento)*

# REGRAS DO DOCUMENTO

1. Nunca apagar decisões importantes.
2. Nunca alterar uma decisão ATIVA silenciosamente.
3. Se uma nova decisão contradizer uma decisão anterior, registrar uma nova ADR.
4. Explicar o motivo da mudança.
5. Preservar o histórico.
6. Referenciar arquivos e sistemas afetados quando relevante.
7. O documento deve representar decisões realmente aprovadas, não apenas sugestões.
8. Decisões provisórias devem ser claramente marcadas como PROPOSTA.
