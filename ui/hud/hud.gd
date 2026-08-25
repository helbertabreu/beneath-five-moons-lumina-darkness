class_name HUDView
extends CanvasLayer

## HUD Contextual Minimalista do projeto Beneath Five Moons / Lumina Darkness.
## Constroi a interface via codigo no _ready, instancia a subjanela do inventario visual
## e reage desacopladamente aos eventos do EventBus.

# --- CONTAINERES DE UI ---
var main_control: Control
var margin_container: MarginContainer
var persistent_vbox: VBoxContainer
var contextual_vbox: VBoxContainer

# --- BARRAS SEMPRE VISÍVEIS ---
var health_bar: ProgressBar
var energy_bar: ProgressBar
var light_indicator: Label

# --- BARRAS CONTEXTUAIS (FADE) ---
var hunger_bar: ProgressBar
var fatigue_bar: ProgressBar

# --- INSTÂNCIA DE JANELAS ---
var inventory_ui_instance: InventoryUI = null

# --- CONTROLE DE ANIMAÇÃO ---
var _contextual_tween: Tween = null


func _ready() -> void:
	_build_ui_hierarchy()
	_instantiate_inventory_ui()
	_subscribe_to_events()
	_reset_ui_state()


## Instancia programmaticamente o Inventário Visual se não estiver na árvore
func _instantiate_inventory_ui() -> void:
	var inv_scene = load("res://ui/inventory/inventory_ui.tscn") as PackedScene
	if inv_scene:
		inventory_ui_instance = inv_scene.instantiate() as InventoryUI
		if inventory_ui_instance:
			add_child(inventory_ui_instance)


## Constrói programmaticamente a hierarquia de nós do HUD
func _build_ui_hierarchy() -> void:
	layer = 10
	
	# Control Raiz (Full Rect)
	main_control = Control.new()
	main_control.name = "HUDControl"
	main_control.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(main_control)
	
	# MarginContainer para Margens de Tela
	margin_container = MarginContainer.new()
	margin_container.name = "MarginContainer"
	margin_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin_container.add_theme_constant_override("margin_left", 16)
	margin_container.add_theme_constant_override("margin_top", 16)
	margin_container.add_theme_constant_override("margin_right", 16)
	margin_container.add_theme_constant_override("margin_bottom", 16)
	main_control.add_child(margin_container)
	
	# Layout Topo Esquerdo (Elementos Sempre Visíveis)
	persistent_vbox = VBoxContainer.new()
	persistent_vbox.name = "PersistentVBox"
	persistent_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	persistent_vbox.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	persistent_vbox.custom_minimum_size = Vector2(180, 0)
	margin_container.add_child(persistent_vbox)
	
	# 1. Barra de Vida (HP)
	var hp_label = Label.new()
	hp_label.text = "VIDA"
	hp_label.add_theme_font_size_override("font_size", 10)
	persistent_vbox.add_child(hp_label)
	
	health_bar = ProgressBar.new()
	health_bar.name = "HealthBar"
	health_bar.custom_minimum_size = Vector2(160, 12)
	health_bar.max_value = 100.0
	health_bar.value = 100.0
	health_bar.show_percentage = false
	persistent_vbox.add_child(health_bar)
	
	# 2. Barra de Estamina / Energia
	var energy_label = Label.new()
	energy_label.text = "ENERGIA"
	energy_label.add_theme_font_size_override("font_size", 10)
	persistent_vbox.add_child(energy_label)
	
	energy_bar = ProgressBar.new()
	energy_bar.name = "EnergyBar"
	energy_bar.custom_minimum_size = Vector2(160, 10)
	energy_bar.max_value = 100.0
	energy_bar.value = 100.0
	energy_bar.show_percentage = false
	persistent_vbox.add_child(energy_bar)
	
	# 3. Indicador de Nível de Luz
	light_indicator = Label.new()
	light_indicator.name = "LightIndicator"
	light_indicator.text = "Luz: Penumbra"
	light_indicator.add_theme_font_size_override("font_size", 11)
	persistent_vbox.add_child(light_indicator)
	
	# Layout Contextual (Fome, Temperatura, Fadiga - Inicialmente Oculto)
	contextual_vbox = VBoxContainer.new()
	contextual_vbox.name = "ContextualVBox"
	contextual_vbox.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	contextual_vbox.size_flags_vertical = Control.SIZE_SHRINK_END
	contextual_vbox.custom_minimum_size = Vector2(140, 0)
	margin_container.add_child(contextual_vbox)
	
	# 4. Barra de Fome
	var hunger_label = Label.new()
	hunger_label.text = "FOME"
	hunger_label.add_theme_font_size_override("font_size", 9)
	contextual_vbox.add_child(hunger_label)
	
	hunger_bar = ProgressBar.new()
	hunger_bar.name = "HungerBar"
	hunger_bar.custom_minimum_size = Vector2(140, 8)
	hunger_bar.max_value = 100.0
	hunger_bar.value = 100.0
	hunger_bar.show_percentage = false
	contextual_vbox.add_child(hunger_bar)
	
	# 5. Barra de Fadiga
	var fatigue_label = Label.new()
	fatigue_label.text = "FADIGA"
	fatigue_label.add_theme_font_size_override("font_size", 9)
	contextual_vbox.add_child(fatigue_label)
	
	fatigue_bar = ProgressBar.new()
	fatigue_bar.name = "FatigueBar"
	fatigue_bar.custom_minimum_size = Vector2(140, 8)
	fatigue_bar.max_value = 100.0
	fatigue_bar.value = 0.0
	fatigue_bar.show_percentage = false
	contextual_vbox.add_child(fatigue_bar)


## Inscreve a View nos eventos globais emitidos pelo EventBus
func _subscribe_to_events() -> void:
	if EventBus and EventBus.has_signal("event_emitted"):
		if not EventBus.event_emitted.is_connected(_on_event_emitted):
			EventBus.event_emitted.connect(_on_event_emitted)


## Define o estado inicial transparente do container contextual
func _reset_ui_state() -> void:
	if contextual_vbox:
		contextual_vbox.modulate.a = 0.0


## Handler central para eventos do barramento
func _on_event_emitted(event_name: StringName, payload: Dictionary) -> void:
	match event_name:
		&"HealthChanged":
			_update_bar(health_bar, payload.get("current", 0.0), payload.get("max", 100.0))
		&"EnergyChanged":
			_update_bar(energy_bar, payload.get("current", 0.0), payload.get("max", 100.0))
		&"HungerChanged":
			_update_bar(hunger_bar, payload.get("current", 0.0), payload.get("max", 100.0))
			_trigger_contextual_fade()
		&"FatigueChanged":
			_update_bar(fatigue_bar, payload.get("current", 0.0), payload.get("max", 100.0))
			_trigger_contextual_fade()
		&"LightLevelChanged":
			if light_indicator:
				var level_str: String = payload.get("level", "Penumbra")
				light_indicator.text = "Luz: " + level_str


## Atualiza os valores da barra visual informada
func _update_bar(bar: ProgressBar, current: float, max_val: float) -> void:
	if bar:
		bar.max_value = max_val
		bar.value = clampf(current, 0.0, max_val)


## Anima o aparecimento e desaparecimento (Fade) do painel contextual
func _trigger_contextual_fade() -> void:
	if not contextual_vbox:
		return
		
	if _contextual_tween and _contextual_tween.is_running():
		_contextual_tween.kill()
		
	_contextual_tween = create_tween()
	_contextual_tween.tween_property(contextual_vbox, "modulate:a", 1.0, 0.3)
	_contextual_tween.tween_interval(3.0)
	_contextual_tween.tween_property(contextual_vbox, "modulate:a", 0.0, 0.8)
