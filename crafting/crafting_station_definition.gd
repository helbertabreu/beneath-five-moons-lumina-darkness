## Recurso Data-Driven que define os parâmetros e capacidades de uma Estação de Trabalho.
class_name CraftingStationDefinition
extends Resource

## Identificador do tipo da estação (ex: &"station.forge", &"station.workbench")
@export var station_type_id: StringName = &"station.forge"

## Nome visível da estação de trabalho
@export var display_name: String = "Forja de Ferro"

## Tier da estação de trabalho (1 a 5)
@export var tier: int = 1

## Multiplicador de velocidade de fabricação (recurso futuro)
@export var craft_speed_multiplier: float = 1.0
