## Nó interativo no mundo físico 2D que representa uma Estação de Trabalho.
class_name CraftingStationNode
extends Area2D

## Definição com os parâmetros da Estação (Type, Tier, Name)
@export var station_definition: CraftingStationDefinition

## Lista de receitas que esta estação disponibiliza para fabricação
@export var available_recipes: Array[RecipeDefinition] = []


func _ready() -> void:
	add_to_group("interactables")


## Método da interface IInteractable para interação no mundo 2D
func interact(actor: Node) -> void:
	print("[CraftingStationNode] Interagindo com estação: ", 
		station_definition.display_name if station_definition else name)


## Retorna a definição desta estação
func get_station_definition() -> CraftingStationDefinition:
	return station_definition
