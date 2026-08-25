## inventory_service.gd
## Serviço transacional responsável por gerenciar adição, remoção, troca e consulta de itens
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
		_notify_inventory_changed(&"ItemAdded", definition.id, added_quantity)
			
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
	_notify_inventory_changed(&"ItemRemoved", item_id, amount)
		
	return true


## Troca a posição de dois slots (Operação de Drag-and-Drop da UI)
func swap_slots(from_index: int, to_index: int) -> bool:
	if not _is_valid_slot_index(from_index) or not _is_valid_slot_index(to_index):
		return false
		
	if from_index == to_index:
		return true
		
	var temp_slot = _slots[from_index]
	_slots[from_index] = _slots[to_index]
	_slots[to_index] = temp_slot
	
	_notify_inventory_changed(&"SlotsSwapped", &"", 0)
	return true


## Divide uma pilha de itens transferindo uma quantidade específica para outro slot
func split_stack(from_index: int, to_index: int, amount: int) -> bool:
	if not _is_valid_slot_index(from_index) or not _is_valid_slot_index(to_index):
		return false
		
	var source_slot = _slots[from_index]
	var target_slot = _slots[to_index]
	
	if not source_slot.item_definition or amount <= 0 or source_slot.quantity < amount:
		return false
		
	# Caso o slot destino esteja vazio
	if not target_slot.item_definition:
		target_slot.item_definition = source_slot.item_definition
		source_slot.quantity -= amount
		target_slot.quantity = amount
		if source_slot.quantity <= 0:
			source_slot.item_definition = null
		_notify_inventory_changed(&"StackSplit", source_slot.item_definition.id, amount)
		return true
		
	# Caso o slot destino possua o mesmo item empilhável
	if target_slot.item_definition.id == source_slot.item_definition.id and target_slot.item_definition.is_stackable:
		var space_in_target = target_slot.item_definition.max_stack_size - target_slot.quantity
		var transfer_amount = mini(amount, space_in_target)
		if transfer_amount > 0:
			source_slot.quantity -= transfer_amount
			target_slot.quantity += transfer_amount
			if source_slot.quantity <= 0:
				source_slot.item_definition = null
			_notify_inventory_changed(&"StackMerged", source_slot.item_definition.id, transfer_amount)
			return true
			
	return false


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


func _is_valid_slot_index(index: int) -> bool:
	return index >= 0 and index < _slots.size()


func _notify_inventory_changed(event_name: StringName, item_id: StringName, amount: int) -> void:
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", event_name, {
			"item_id": item_id,
			"amount": amount
		})
		EventBus.emit_signal("event_emitted", &"InventoryUpdated", {})
