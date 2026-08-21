## inventory_service.gd
## Serviço transactional responsável por gerenciar adição, remoção e consulta de itens
## de um inventário desacoplado de UI.

class_name InventoryService
extends Node

## Capacidade padrão de slots do inventário
@export var max_slots: int = 20

## Lista de slots do inventário
var _slots: Array[ItemStack] = []


func _ready() -> void:
	_initialize_inventory()
	
	# Registra este serviço no ServiceRegistry global
	if ServiceRegistry:
		ServiceRegistry.register_service(&"InventoryService", self)
		print("[InventoryService] Registrado com sucesso no ServiceRegistry.")


func _initialize_inventory() -> void:
	_slots.clear()
	for i in range(max_slots):
		_slots.append(ItemStack.new(null, 0))


## Tenta adicionar um item ao inventário de forma transacional
func add_item(definition: ItemDefinition, amount: int = 1) -> bool:
	if not definition or amount <= 0:
		return false
		
	var remaining_to_add = amount
	
	# 1. Tenta preencher pilhas existentes do mesmo item (se for empilhável)
	if definition.is_stackable:
		for slot in _slots:
			if slot.item_definition and slot.item_definition.id == definition.id:
				remaining_to_add = slot.add(remaining_to_add)
				if remaining_to_add <= 0:
					break
	
	# 2. Se ainda restam itens, utiliza slots vazios
	if remaining_to_add > 0:
		for slot in _slots:
			if slot.item_definition == null:
				slot.item_definition = definition
				remaining_to_add = slot.add(remaining_to_add)
				if remaining_to_add <= 0:
					break
					
	var added_quantity = amount - remaining_to_add
	
	if added_quantity > 0:
		print("[InventoryService] Adicionado %d x %s ao inventário." % [added_quantity, definition.name])
		if EventBus and EventBus.has_signal("event_emitted"):
			EventBus.emit_signal("event_emitted", &"ItemAdded", {
				"item_id": definition.id,
				"amount": added_quantity
			})
			
	return remaining_to_add == 0


## Remove uma quantidade específica de um item pelo ID
func remove_item(item_id: StringName, amount: int = 1) -> bool:
	if get_total_quantity(item_id) < amount:
		print("[InventoryService] AVISO: Quantidade insuficiente de ", item_id, " para remoção.")
		return false
		
	var remaining_to_remove = amount
	
	for slot in _slots:
		if slot.item_definition and slot.item_definition.id == item_id:
			var removed = slot.remove(remaining_to_remove)
			remaining_to_remove -= removed
			
			if slot.quantity <= 0:
				slot.item_definition = null
				
			if remaining_to_remove <= 0:
				break
				
	print("[InventoryService] Removido %d x %s do inventário." % [amount, item_id])
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"ItemRemoved", {
			"item_id": item_id,
			"amount": amount
		})
		
	return true


## Retorna a quantidade total acumulada de um item no inventário
func get_total_quantity(item_id: StringName) -> int:
	var total = 0
	for slot in _slots:
		if slot.item_definition and slot.item_definition.id == item_id:
			total += slot.quantity
	return total


## Retorna a lista de slots para inspeção/UI
func get_slots() -> Array[ItemStack]:
	return _slots
