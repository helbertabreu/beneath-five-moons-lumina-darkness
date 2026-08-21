## item_stack.gd
## Objeto mutável de runtime que representa uma pilha ou slot de item no inventário.

class_name ItemStack
extends RefCounted

var item_definition: ItemDefinition = null
var quantity: int = 0
var instance_data: Dictionary = {}


func _init(p_definition: ItemDefinition = null, p_quantity: int = 1, p_instance_data: Dictionary = {}) -> void:
	item_definition = p_definition
	quantity = p_quantity
	instance_data = p_instance_data


## Retorna se o slot está completamente cheio
func is_full() -> bool:
	if not item_definition or not item_definition.is_stackable:
		return quantity >= 1
	return quantity >= item_definition.max_stack_size


## Adiciona quantidade respeitando o limite máximo da pilha
func add(amount: int) -> int:
	if not item_definition:
		return amount
		
	if not item_definition.is_stackable:
		if quantity == 0:
			quantity = 1
			return amount - 1
		return amount
		
	var max_size = item_definition.max_stack_size
	var space_left = max_size - quantity
	var added = mini(space_left, amount)
	quantity += added
	return amount - added


## Remove quantidade da pilha
func remove(amount: int) -> int:
	var removed = mini(quantity, amount)
	quantity -= removed
	return removed
