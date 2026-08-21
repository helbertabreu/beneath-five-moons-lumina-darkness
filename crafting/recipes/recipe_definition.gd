## recipe_definition.gd
## Resource estático que define os requisitos e resultados de uma receita de crafting/fundição.

class_name RecipeDefinition
extends Resource

## ID único da receita (ex: "recipe.blacksmith.iron_ingot")
@export var id: StringName = &""

## Nome visível da receita na UI
@export var name: String = ""

## Profissão necessária para criar esta receita (ex: &"Blacksmith")
@export var required_profession: StringName = &"Blacksmith"

## Nível mínimo exigido na profissão
@export var required_profession_level: int = 1

## Custo de energia do jogador para executar a produção
@export var energy_cost: float = 15.0

## XP concedido na profissão ao concluir
@export var xp_reward: float = 25.0

## Dicionário de Ingredientes { "item_id": quantidade }
@export var required_ingredients: Dictionary = {}

## Item gerado como resultado
@export var result_item: ItemDefinition = null

## Quantidade de itens gerados
@export var result_quantity: int = 1
