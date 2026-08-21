# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto Beneath Five Moons / Lumina Darkness.
> O objetivo é evitar que decisões previamente aprovadas sejam alteradas ou esquecidas sem justificativa.

---

# COMO REGISTRAR UMA DECISÃO

Para cada decisão importante, utilize o modelo ADR.

---

# STATUS POSSÍVEIS

- PROPOSTA
- ATIVA
- SUPERADA
- CANCELADA

---

# DECISÕES ATIVAS

## ADR-001 — Desacoplamento de Persistência via EntityId

**Data:** 2026-08-20  
**Status:** ATIVA  

### Contexto
O projeto exige suporte a Save/Load seguro e arquitetura preparada para futuro Multiplayer.

### Decisão
Utilizar identificadores estáveis (`EntityId` em `StringName`) em vez de referências por `NodePath` para identificar entidades persitentes e dados salvos.

### Motivo
Garantir a integridade dos dados salvos independente da hierarquia visual da cena e prevenir quebras de Save ao mover nós no editor.

---

## ADR-002 — Arquitetura de Scenes e Components

**Data:** 2026-08-20  
**Status:** ATIVA  

### Contexto
O projeto precisa manter sistemas modulares e reutilizáveis.

### Decisão
Priorizar composição por Nodes/Components, Scenes reutilizáveis, Resources e Signals antes de criar hierarquias profundas de herança.

### Motivo
Reduzir acoplamento e facilitar manutenção, testes e evolução do projeto.

---

## ADR-003 — Uso de Autoloads

**Data:** 2026-08-20  
**Status:** ATIVA  

### Decisão
Autoloads serão utilizados apenas para serviços genuinamente globais e desacoplados (`ServiceRegistry`, `EventBus`, `TimeService`, `SaveService`).

### Motivo
Evitar dependências diretas de singletons rígidos e facilitar testes isolados.

---

## ADR-004 — Dados Data-Driven via Resources

**Data:** 2026-08-20  
**Status:** ATIVA  

### Decisão
Dados configuráveis de gameplay (itens, receitas, monstros, atributos de sobrevivência) deverão ser separados da lógica utilizando `Resource`.

### Motivo
Facilitar o balanceamento no `BALANCE.md` sem exigir alteração nos scripts do jogo.

---

## ADR-005 — Compatibilidade Godot 4.7.1 e GDScript 2.0

**Data:** 2026-08-20  
**Status:** ATIVA  

### Decisão
O projeto será desenvolvido rigorosamente utilizando GDScript 2.0 e APIs nativas do Godot 4.7.1.

---

## ADR-008 — Transição do MVP para Perspectiva 2D e Exclusão da Sede

**Data:** 2026-08-20  
**Status:** ATIVA  

### Contexto
Auditoria de pré-produção indicou alto risco de escopo para um desenvolvedor iniciante em um jogo 3D de mundo aberto.

### Decisão
1. Converter a perspectiva do MVP para Top-Down 2D (`CharacterBody2D`, `PointLight2D`, `TileMapLayer`).
2. Remover o parâmetro de Sede no MVP, focando a sobrevivência em 6 necessidades fundamentais (Vida, Fome, Fadiga, Energia, Temperatura e Conforto).

### Motivo
Garantir a entrega da Vertical Slice e do MVP de forma viável, sustentável e testável.
