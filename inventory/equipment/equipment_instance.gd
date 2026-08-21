## equipment_instance.gd
## Representa uma instância única de um equipamento com durabilidade e modificadores de runtime.

class_name EquipmentInstance
extends RefCounted

var instance_id: StringName = &""
var item_definition: ItemDefinition = null
var current_durability: float = 100.0
var max_durability: float = 100.0
var quality: StringName = &"Common"
var custom_modifiers: Dictionary = {}


func _init(p_definition: ItemDefinition = null, p_max_durability: float = 100.0) -> void:
	instance_id = StringName(str(ResourceUID.create_id()))
	item_definition = p_definition
	max_durability = p_max_durability
	current_durability = p_max_durability


## Consome a durabilidade do item e retorna true se o item quebrou
func consume_durability(amount: float) -> bool:
	current_durability = maxf(0.0, current_durability - amount)
	return current_durability <= 0.0


## Restaura a durabilidade do item
func repair(amount: float) -> void:
	current_durability = minf(max_durability, current_durability + amount)
