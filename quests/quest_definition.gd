## quest_definition.gd
## Resource de dados que define requisitos, objetivos e recompensas de uma missão.

class_name QuestDefinition
extends Resource

enum QuestType { MAIN, ORIGIN, PROFESSION, FACTION, LOCAL }

## ID único da quest (ex: &"quest.local.blacksmith_iron")
@export var id: StringName = &""

## Título amigável da missão
@export var title: String = ""

## Descrição detalhada do objetivo
@export var description: String = ""

## Categoria da missão
@export var type: QuestType = QuestType.LOCAL

## Item necessário para entrega { "item_id": quantidade }
@export var required_items: Dictionary = {}

## Recompensa em moedas
@export var reward_currency: int = 100

## Recompensa em reputação local
@export var reward_reputation: float = 50.0
