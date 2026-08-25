## inventory_ui.gd
## Interface gráfica estendida do Inventário e Equipamentos (MVVM/Presentation Model).
## Exibe a grade de slots do inventário e slots de equipamento, suporta Drag-and-Drop nativo,
## divisão de pilhas (Split via Shift+Clique) e reflete o estado do InventoryService via EventBus.

class_name InventoryUI
extends CanvasLayer

# --- REFERÊNCIAS E COMPONENTES DE INTERFACE ---
var main_control: Control
var main_panel: PanelContainer
var grid_container: GridContainer
var equipment_container: HBoxContainer
var tooltip_label: Label
var split_dialog: ConfirmationDialog
var split_spinbox: SpinBox

# --- ESTADO INTERNO ---
var _inventory_service: InventoryService = null
var _slot_ui_nodes: Array[Control] = []
var _pending_split_from_index: int = -1
var _pending_split_to_index: int = -1

# Mapeamento de slots visuais de equipamento (Apenas para apresentação)
var _equipment_slots: Dictionary = {
	&"head": null,
	&"chest": null,
	&"main_hand": null,
	&"off_hand": null
}


func _ready() -> void:
	_build_ui_structure()
	_create_split_dialog()
	_fetch_inventory_service()
	_subscribe_to_events()
	_refresh_inventory_grid()
	visible = false # Inicialmente fechado em jogo


func _unhandled_input(event: InputEvent) -> void:
	var is_inventory_pressed: bool = false
	
	if event.is_action_pressed(&"inventory"):
		is_inventory_pressed = true
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_I or event.physical_keycode == KEY_I:
			is_inventory_pressed = true
			
	if is_inventory_pressed:
		toggle_inventory()
		get_viewport().set_input_as_handled()


## Mostra ou oculta a janela de inventário
func toggle_inventory() -> void:
	visible = not visible
	if visible:
		_refresh_inventory_grid()
		if EventBus and EventBus.has_signal("inventory_opened"):
			EventBus.inventory_opened.emit()
	else:
		if EventBus and EventBus.has_signal("inventory_closed"):
			EventBus.inventory_closed.emit()


## Constrói programmaticamente a hierarquia visual do painel de inventário e equipamentos
func _build_ui_structure() -> void:
	layer = 15
	
	main_control = Control.new()
	main_control.name = "InventoryControl"
	main_control.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(main_control)
	
	# Painel Central de Inventário
	main_panel = PanelContainer.new()
	main_panel.name = "MainPanel"
	main_panel.custom_minimum_size = Vector2(340, 260)
	main_panel.set_anchors_preset(Control.PRESET_CENTER)
	main_control.add_child(main_panel)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.name = "MainVBox"
	main_panel.add_child(main_vbox)
	
	# Cabeçalho da Janela
	var header = Label.new()
	header.text = "INVENTÁRIO E EQUIPAMENTOS"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 14)
	main_vbox.add_child(header)
	
	# Seção de Equipamentos do Personagem
	var equip_title = Label.new()
	equip_title.text = "EQUIPAMENTO"
	equip_title.add_theme_font_size_override("font_size", 10)
	main_vbox.add_child(equip_title)
	
	equipment_container = HBoxContainer.new()
	equipment_container.name = "EquipmentContainer"
	equipment_container.alignment = BoxContainer.ALIGNMENT_CENTER
	main_vbox.add_child(equipment_container)
	
	_build_equipment_slots()
	
	var separator = HSeparator.new()
	main_vbox.add_child(separator)
	
	# Seção da Mochila / Grade
	var bag_title = Label.new()
	bag_title.text = "MOCHILA (Pressione 'I' para fechar)"
	bag_title.add_theme_font_size_override("font_size", 10)
	main_vbox.add_child(bag_title)
	
	grid_container = GridContainer.new()
	grid_container.name = "SlotGrid"
	grid_container.columns = 5
	grid_container.custom_minimum_size = Vector2(260, 140)
	main_vbox.add_child(grid_container)
	
	# Rodapé / Tooltip Informativo
	tooltip_label = Label.new()
	tooltip_label.name = "TooltipLabel"
	tooltip_label.text = "Passe o cursor sobre um item..."
	tooltip_label.add_theme_font_size_override("font_size", 9)
	tooltip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_vbox.add_child(tooltip_label)


## Cria os slots visuais de equipamentos (Cabeça, Peito, Mão Princ., Mão Sec.)
func _build_equipment_slots() -> void:
	var slot_keys = [&"head", &"chest", &"main_hand", &"off_hand"]
	var slot_names = ["Cabeça", "Peito", "Mão P.", "Mão S."]
	
	for i in range(slot_keys.size()):
		var key = slot_keys[i]
		var btn = Button.new()
		btn.name = "EquipSlot_" + String(key)
		btn.custom_minimum_size = Vector2(48, 48)
		btn.text = slot_names[i]
		btn.focus_mode = Control.FOCUS_NONE
		btn.add_theme_font_size_override("font_size", 9)
		
		equipment_container.add_child(btn)
		_equipment_slots[key] = btn


## Cria a janela modal para dividir pilhas (Split Stack)
func _create_split_dialog() -> void:
	split_dialog = ConfirmationDialog.new()
	split_dialog.title = "Dividir Pilha de Itens"
	split_dialog.dialog_text = "Selecione a quantidade a transferir:"
	
	split_spinbox = SpinBox.new()
	split_spinbox.min_value = 1
	split_spinbox.step = 1
	split_dialog.add_child(split_spinbox)
	
	split_dialog.confirmed.connect(_on_split_confirmed)
	add_child(split_dialog)


## Localiza e obtém referência ao InventoryService via ServiceRegistry
func _fetch_inventory_service() -> void:
	if ServiceRegistry and ServiceRegistry.has_service(&"InventoryService"):
		_inventory_service = ServiceRegistry.get_service(&"InventoryService") as InventoryService


## Conecta aos sinais globais do EventBus
func _subscribe_to_events() -> void:
	if EventBus:
		if EventBus.has_signal("event_emitted"):
			if not EventBus.event_emitted.is_connected(_on_event_emitted):
				EventBus.event_emitted.connect(_on_event_emitted)
		if EventBus.has_signal("inventory_toggle_requested"):
			if not EventBus.inventory_toggle_requested.is_connected(toggle_inventory):
				EventBus.inventory_toggle_requested.connect(toggle_inventory)


## Atualiza a grade visual de slots
func _refresh_inventory_grid() -> void:
	if not grid_container:
		return
		
	for child in grid_container.get_children():
		child.queue_free()
	_slot_ui_nodes.clear()
	
	if not _inventory_service:
		_fetch_inventory_service()
		if not _inventory_service:
			return
			
	var slots = _inventory_service.get_slots()
	for i in range(slots.size()):
		var slot_data = slots[i]
		var slot_node = _create_slot_node(i, slot_data)
		grid_container.add_child(slot_node)
		_slot_ui_nodes.append(slot_node)


## Cria um nó de slot visual customizado com suporte a Drag and Drop nativo
func _create_slot_node(slot_index: int, stack: ItemStack) -> Control:
	var slot_btn = InventorySlotButton.new(slot_index, stack, self)
	slot_btn.custom_minimum_size = Vector2(44, 44)
	slot_btn.focus_mode = Control.FOCUS_NONE
	
	if stack and stack.item_definition:
		var item_def = stack.item_definition
		slot_btn.text = "%s\n(%d)" % [item_def.name.left(5), stack.quantity]
		
		if item_def.icon:
			slot_btn.icon = item_def.icon
			slot_btn.expand_icon = true
	else:
		slot_btn.text = "Vazio"
		
	slot_btn.mouse_entered.connect(func(): _on_slot_hover(stack))
	slot_btn.gui_input.connect(func(event): _on_slot_gui_input(event, slot_index, stack))
	
	return slot_btn


## Handler para atualizar o tooltip ao passar o cursor
func _on_slot_hover(stack: ItemStack) -> void:
	if tooltip_label:
		if stack and stack.item_definition:
			var def = stack.item_definition
			tooltip_label.text = "%s [%s]\n%s | Preço: %d" % [def.name, def.category, def.description, def.base_price]
		else:
			tooltip_label.text = "Slot Vazio"


## Handler para cliques do mouse nos slots
func _on_slot_gui_input(event: InputEvent, slot_index: int, _stack: ItemStack) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_use_item_at_slot(slot_index)


## Solicita a remoção/uso de 1 unidade do item
func _use_item_at_slot(slot_index: int) -> void:
	if not _inventory_service:
		return
	var slots = _inventory_service.get_slots()
	if slot_index >= 0 and slot_index < slots.size():
		var stack = slots[slot_index]
		if stack and stack.item_definition:
			print("[InventoryUI] Solicitando uso do item: ", stack.item_definition.name)
			_inventory_service.remove_item(stack.item_definition.id, 1)


## Método invocado pelo Drag-and-Drop quando um item é solto em outro slot
func handle_slot_drop(from_index: int, to_index: int) -> void:
	if not _inventory_service:
		return
		
	if Input.is_key_pressed(KEY_SHIFT):
		var slots = _inventory_service.get_slots()
		if from_index >= 0 and from_index < slots.size():
			var source_stack = slots[from_index]
			if source_stack and source_stack.quantity > 1:
				_pending_split_from_index = from_index
				_pending_split_to_index = to_index
				split_spinbox.max_value = source_stack.quantity - 1
				split_spinbox.value = 1
				split_dialog.popup_centered()
				return
				
	_inventory_service.swap_slots(from_index, to_index)


## Confirmação da divisão de pilhas (Split Stack)
func _on_split_confirmed() -> void:
	if _inventory_service and _pending_split_from_index != -1 and _pending_split_to_index != -1:
		var amount = int(split_spinbox.value)
		_inventory_service.split_stack(_pending_split_from_index, _pending_split_to_index, amount)
		
	_pending_split_from_index = -1
	_pending_split_to_index = -1


## Reação a eventos do EventBus
func _on_event_emitted(event_name: StringName, _payload: Dictionary) -> void:
	match event_name:
		&"InventoryUpdated", &"ItemAdded", &"ItemRemoved", &"SlotsSwapped", &"StackSplit", &"StackMerged":
			if visible:
				_refresh_inventory_grid()


# ==============================================================================
# CLASSE INTERNA: Botão de Slot com Drag and Drop Nativo do Godot
# ==============================================================================
class InventorySlotButton extends Button:
	var slot_index: int
	var stack: ItemStack
	var ui_parent: InventoryUI

	func _init(p_index: int, p_stack: ItemStack, p_ui: InventoryUI) -> void:
		slot_index = p_index
		stack = p_stack
		ui_parent = p_ui

	func _get_drag_data(_at_position: Vector2) -> Variant:
		if not stack or not stack.item_definition:
			return null

		var drag_preview = Button.new()
		drag_preview.text = stack.item_definition.name.left(5)
		drag_preview.custom_minimum_size = Vector2(40, 40)
		set_drag_preview(drag_preview)

		return {
			"type": "inventory_slot",
			"from_index": slot_index
		}

	func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
		return data is Dictionary and data.get("type") == "inventory_slot"

	func _drop_data(_at_position: Vector2, data: Variant) -> void:
		if data is Dictionary and data.has("from_index"):
			var from_index = int(data["from_index"])
			ui_parent.handle_slot_drop(from_index, slot_index)
