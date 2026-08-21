# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto.
> O objetivo é evitar que decisões previamente aprovadas sejam alteradas ou esquecidas sem justificativa.

---

# STATUS POSSÍVEIS

- PROPOSTA
- ATIVA
- SUPERADA
- CANCELADA

---

# DECISÕES ATIVAS

## ADR-001 — ServiceRegistry & Injeção de Dependências Desacoplada

**Data:** 2026-08-18

**Status:** ATIVA

### Contexto

Sistemas do jogo precisam se comunicar de forma desacoplada sem que tudo se torne um singleton/Autoload rígido.

### Decisão

Utilizar o `ServiceRegistry` como nó central de registro e obtenção de serviços do sistema no Boot (`TimeService`, `SaveService`, `InventoryService`).

---

## ADR-008 — Migração para 2D Top-Down no Godot 4.7.1

**Data:** 2026-08-18

**Status:** ATIVA

### Contexto

GDD original citava 3ª Pessoa 3D, exigindo um volume massivo de assets e complexidade física incompatível com o desenvolvimento solo do MVP.

### Decisão

Migrar a perspectiva e toda a simulação física/renderização para **2D Top-Down**, mantendo todas as mecânicas sistêmicas intactas (`CharacterBody2D`, `PointLight2D`, `Area2D`).

---

## ADR-009 — Contrato Genérico para Interações 2D (`IInteractable`)

**Data:** 2026-08-20

**Status:** ATIVA

### Contexto

A Sprint 3 exigia que o jogador interagisse com múltiplos elementos do mapa (baús, nós de minério, NPCs) sem que o Player precisasse conhecer a classe concreta de cada objeto.

### Decisão

Adotar o padrão de detecção dinâmica via `InteractionDetector2D` baseado em `Area2D`, que valida a existência dos métodos de contrato (`can_interact` e `interact`) nos nós detectados.

---

## ADR-010 — Arquitetura de Inventário Transactional Resource-Driven

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A Sprint 4 exigia a gestão de itens empilháveis e instâncias de equipamentos com durabilidade, sem acoplar regras de itens a nós visuais de UI.

### Decisão

Separar rigorosamente a definição estática (`ItemDefinition` como `Resource`), o estado runtime de pilhas (`ItemStack` como `RefCounted`), as instâncias com durabilidade (`EquipmentInstance`) e o gerenciador transactional (`InventoryService`).

---

## ADR-011 — Coleta Transactional de Recursos com Custo Vital

**Data:** 2026-08-21

**Status:** ATIVA

### Contexto

A TASK-107 exigia que a extração de minério no mapa consumisse recursos do jogador e depositasse itens de forma atômica no inventário.

### Decisão

Implementar os nós de recurso (`iron_mine_node.gd`) validando a energia do `SurvivalComponent` antes do consumo e delegando a entrega de itens diretamente ao `InventoryService` registrado no `ServiceRegistry`.
