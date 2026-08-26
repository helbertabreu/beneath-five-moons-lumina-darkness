## hud.gd
## Controlador da HUD Contextual Minimalista (Presentation Model / View).
##
## Exibe elementos vitais sempre visíveis (HP, Estamina/Energia, Luz)
## e elementos contextuais (Fome, Fadiga) acionados por animações de Fade.

class_name HUDView
extends CanvasLayer

@export var theme_resource: Theme = preload("res://ui/theme/main_theme.tres")

# Nós de Interface - Sempre Visíveis
var _health_bar: ProgressBar = null
var _energy_bar: ProgressBar = null
var _light_indicator: Label = null

# Nós de Interface - Contextuais (Fade)
var _contextual_container: VBoxContainer = null
var _hunger_bar: ProgressBar = null
var _fatigue_bar: ProgressBar = null
var _fade_tween: Tween = null

# Subjanela de Inventário (Tipada como CanvasLayer para compatibilidade com inventory_ui.tscn)
var _inventory_ui_instance: CanvasLayer = null


func _ready() -> void:
	layer = 10
	_build_hud_layout()
	_connect_event_bus()
	_load_inventory_subwindow()


## Constrói a estrutura visual da HUD e aplica o Tema Chiaroscuro/Neon
func _build_hud_layout() -> void:
	var hud_control = Control.new()
	hud_control.name = "HUDControl"
	hud_control.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if theme_resource:
		hud_control.theme = theme_resource
	add_child(hud_control)

	# MarginContainer para afastar os elementos da borda da tela
	var margin = MarginContainer.new()
	margin.name = "HUDMargin"
	margin.set_anchors_preset(Control.PRESET_TOP_LEFT)
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud_control.add_child(margin)

	var main_vbox = VBoxContainer.new()
	main_vbox.name = "MainVBox"
	main_vbox.add_theme_constant_override("separation", 6)
	main_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(main_vbox)

	# -------------------------------------------------------------------------
	# 1. ELEMENTOS SEMPRE VISÍVEIS (Persistent VBox)
	# -------------------------------------------------------------------------
	var persistent_vbox = VBoxContainer.new()
	persistent_vbox.name = "PersistentVBox"
	persistent_vbox.add_theme_constant_override("separation", 4)
	persistent_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_vbox.add_child(persistent_vbox)

	# Barra de Vida (HP)
	var hp_vbox = VBoxContainer.new()
	var hp_label = Label.new()
	hp_label.text = "VIDA"
	hp_vbox.add_child(hp_label)

	_health_bar = ProgressBar.new()
	_health_bar.custom_minimum_size = Vector2(140, 10)
	_health_bar.max_value = 100.0
	_health_bar.value = 100.0
	_health_bar.show_percentage = false
	var hp_fill = StyleBoxFlat.new()
	hp_fill.bg_color = Color(1.0, 0.16, 0.33, 1.0) # Vermelho Carmim Neon
	_health_bar.add_theme_stylebox_override("fill", hp_fill)
	hp_vbox.add_child(_health_bar)
	persistent_vbox.add_child(hp_vbox)

	# Barra de Energia / Estamina
	var energy_vbox = VBoxContainer.new()
	var energy_label = Label.new()
	energy_label.text = "ENERGIA"
	energy_vbox.add_child(energy_label)

	_energy_bar = ProgressBar.new()
	_energy_bar.custom_minimum_size = Vector2(140, 8)
	_energy_bar.max_value = 100.0
	_energy_bar.value = 100.0
	_energy_bar.show_percentage = false
	var energy_fill = StyleBoxFlat.new()
	energy_fill.bg_color = Color(1.0, 0.7, 0.0, 1.0) # Amarelo Âmbar Neon
	_energy_bar.add_theme_stylebox_override("fill", energy_fill)
	energy_vbox.add_child(_energy_bar)
	persistent_vbox.add_child(energy_vbox)

	# Indicador de Nível de Luz
	_light_indicator = Label.new()
	_light_indicator.name = "LightIndicator"
	_light_indicator.text = "Luz: Penumbra (0.20)"
	_light_indicator.add_theme_color_override("font_color", Color(1.0, 0.9, 0.0, 1.0)) # Ouro Bioluminescente
	persistent_vbox.add_child(_light_indicator)

	# -------------------------------------------------------------------------
	# 2. ELEMENTOS CONTEXTUAIS (Contextual VBox com Fade)
	# -------------------------------------------------------------------------
	_contextual_container = VBoxContainer.new()
	_contextual_container.name = "ContextualVBox"
	_contextual_container.add_theme_constant_override("separation", 4)
	_contextual_container.modulate.a = 0.0 # Inicialmente invisível
	_contextual_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_vbox.add_child(_contextual_container)

	# Barra de Fome
	var hunger_vbox = VBoxContainer.new()
	var hunger_label = Label.new()
	hunger_label.text = "FOME"
	hunger_vbox.add_child(hunger_label)

	_hunger_bar = ProgressBar.new()
	_hunger_bar.custom_minimum_size = Vector2(120, 6)
	_hunger_bar.max_value = 100.0
	_hunger_bar.value = 100.0
	_hunger_bar.show_percentage = false
	var hunger_fill = StyleBoxFlat.new()
	hunger_fill.bg_color = Color(1.0, 0.42, 0.0, 1.0) # Laranja Terroso
	_hunger_bar.add_theme_stylebox_override("fill", hunger_fill)
	hunger_vbox.add_child(_hunger_bar)
	_contextual_container.add_child(hunger_vbox)

	# Barra de Fadiga
	var fatigue_vbox = VBoxContainer.new()
	var fatigue_label = Label.new()
	fatigue_label.text = "FADIGA"
	fatigue_vbox.add_child(fatigue_label)

	_fatigue_bar = ProgressBar.new()
	_fatigue_bar.custom_minimum_size = Vector2(120, 6)
	_fatigue_bar.max_value = 100.0
	_fatigue_bar.value = 0.0
	_fatigue_bar.show_percentage = false
	var fatigue_fill = StyleBoxFlat.new()
	fatigue_fill.bg_color = Color(0.61, 0.3, 0.86, 1.0) # Roxo Névoa
	_fatigue_bar.add_theme_stylebox_override("fill", fatigue_fill)
	fatigue_vbox.add_child(_fatigue_bar)
	_contextual_container.add_child(fatigue_vbox)


## Conecta os ouvintes de sinal do EventBus global
func _connect_event_bus() -> void:
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.event_emitted.connect(_on_event_emitted)


## Instancia e acopla com segurança a subjanela de Inventário
func _load_inventory_subwindow() -> void:
	if ResourceLoader.exists("res://ui/inventory/inventory_ui.tscn"):
		var inventory_scene = load("res://ui/inventory/inventory_ui.tscn") as PackedScene
		if inventory_scene:
			_inventory_ui_instance = inventory_scene.instantiate() as CanvasLayer
	
	# Fallback seguro caso a cena falhe
	if not _inventory_ui_instance:
		_inventory_ui_instance = InventoryUI.new() as CanvasLayer

	# Anexa com validação rigorosa de ponteiro nulo
	if is_instance_valid(_inventory_ui_instance):
		add_child(_inventory_ui_instance)
	else:
		print("[HUDView] AVISO: Não foi possível instanciar a subjanela InventoryUI.")


## Trata os eventos emitidos pelo domínio e atualiza a apresentação
func _on_event_emitted(event_name: StringName, payload: Dictionary) -> void:
	match event_name:
		&"HealthChanged":
			if payload.has("current") and _health_bar:
				_health_bar.value = payload["current"]
				if payload.has("max"):
					_health_bar.max_value = payload["max"]
		&"EnergyChanged":
			if payload.has("current") and _energy_bar:
				_energy_bar.value = payload["current"]
				if payload.has("max"):
					_energy_bar.max_value = payload["max"]
		&"LightLevelChanged":
			if payload.has("illumination") and _light_indicator:
				var val: float = payload["illumination"]
				var text_state = "Escuridão"
				if val >= 0.70:
					text_state = "Luz Plena"
				elif val >= 0.35:
					text_state = "Luz Moderada"
				elif val >= 0.15:
					text_state = "Penumbra"
				_light_indicator.text = "Luz: %s (%.2f)" % [text_state, val]
		&"HungerChanged":
			if payload.has("current") and _hunger_bar:
				_hunger_bar.value = payload["current"]
				_trigger_contextual_fade()
		&"FatigueChanged":
			if payload.has("current") and _fatigue_bar:
				_fatigue_bar.value = payload["current"]
				_trigger_contextual_fade()


## Aciona a animação de Fade-In, permanência e Fade-Out no painel contextual
func _trigger_contextual_fade() -> void:
	if not _contextual_container:
		return

	if _fade_tween and _fade_tween.is_running():
		_fade_tween.kill()

	_fade_tween = create_tween()
	# Fade-in em 0.3s
	_fade_tween.tween_property(_contextual_container, "modulate:a", 1.0, 0.3)
	# Permanece visível por 3.0s
	_fade_tween.tween_interval(3.0)
	# Fade-out em 0.8s
	_fade_tween.tween_property(_contextual_container, "modulate:a", 0.0, 0.8)
