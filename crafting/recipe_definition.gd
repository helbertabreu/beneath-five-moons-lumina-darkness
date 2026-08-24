## Recurso Data-Driven que define uma receita de fabricação (Crafting).
## Isola os insumos, produtos, requisitos de profissão e estação.
class_name RecipeDefinition
extends Resource

## Identificador único da receita (ex: &"recipe.blacksmith.iron_ingot")
@export var id: StringName = &""

## Nome visível na interface do jogo
@export var display_name: String = ""

## Profissão necessária para fabricar esta receita (ex: &"profession.blacksmith")
@export var profession_id: StringName = &"profession.blacksmith"

## Nível/Tier mínimo exigido na profissão (1 a 5)
@export var required_profession_level: int = 1

## Tipo de estação de trabalho necessária (ex: &"station.forge", &"station.workbench")
@export var required_station_type: StringName = &"station.forge"

## Tier mínimo exigido na estação de trabalho (1 a 5)
@export var required_station_tier: int = 1

## Lista de insumos necessários.
## Formato: Array de Dictionaries -> [{"item_id": &"item.material.iron_ore", "quantity": 2}]
@export var inputs: Array[Dictionary] = []

## Lista de produtos gerados.
## Formato: Array de Dictionaries -> [{"item_definition": ItemDefinition, "quantity": 1}]
@export var outputs: Array[Dictionary] = []

## Custo de energia do jogador para executar esta receita
@export var energy_cost: float = 15.0

## Quantidade de XP concedida na profissão ao fabricar com sucesso
@export var granted_profession_xp: float = 25.0
