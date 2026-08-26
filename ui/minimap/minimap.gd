## Script da Interface de Minimapa (DEC-TIS-004 / Gate 21)
## Exibe a representação top-down do mundo próximo com radar e iluminação reativa.

class_name Minimap
extends CanvasLayer

@export var target_player: Node2D = null
@export var zoom_level: float = 2.0

@onready var minimap_container: SubViewportContainer = $MarginContainer/PanelContainer/SubViewportContainer
@onready var sub_viewport: SubViewport = $MarginContainer/PanelContainer/SubViewportContainer/SubViewport
@onready var minimap_camera: Camera2D = $MarginContainer/PanelContainer/SubViewportContainer/SubViewport/MinimapCamera2D
@onready var icons_layer: Control = $MarginContainer/PanelContainer/SubViewportContainer/SubViewport/IconsLayer

var _marker_nodes: Dictionary = {} # EntityId / Node -> ColorRect


func _ready() -> void:
	layer = 12
	_setup_camera()
	_connect_event_bus()
	print("[Minimap] Minimapa inicializado e aguardando vinculação de alvos.")


func _physics_process(_delta: float) -> void:
	if is_instance_valid(target_player):
		minimap_camera.global_position = target_player.global_position
		_update_markers_visibility()


## Configura os parâmetros básicos da câmera ortográfica do minimapa
func _setup_camera() -> void:
	if minimap_camera:
		minimap_camera.zoom = Vector2(zoom_level, zoom_level)


## Conecta os sinais de barramento para escutar criação e destruição de marcadores
func _connect_event_bus() -> void:
	if EventBus:
		if EventBus.has_signal("event_emitted"):
			EventBus.connect("event_emitted", _on_event_emitted)


## Processa eventos recebidos do EventBus
func _on_event_emitted(event_name: StringName, data: Dictionary) -> void:
	match event_name:
		&"RegisterMinimapMarker":
			if data.has("node") and data.has("color"):
				register_marker(data["node"], data["color"], data.get("is_enemy", false))
		&"UnregisterMinimapMarker":
			if data.has("node"):
				unregister_marker(data["node"])


## Registra manualmente ou via evento um marcador no minimapa
func register_marker(target_node: Node2D, marker_color: Color, is_enemy: bool = false) -> void:
	if not is_instance_valid(target_node) or _marker_nodes.has(target_node):
		return

	var marker = ColorRect.new()
	marker.custom_minimum_size = Vector2(4, 4)
	marker.position = Vector2(-2, -2)
	marker.color = marker_color
	marker.set_meta("is_enemy", is_enemy)
	marker.set_meta("target_node", target_node)

	icons_layer.add_child(marker)
	_marker_nodes[target_node] = marker


## Remove um marcador do minimapa
func unregister_marker(target_node: Node2D) -> void:
	if _marker_nodes.has(target_node):
		var marker = _marker_nodes[target_node]
		if is_instance_valid(marker):
			marker.queue_free()
		_marker_nodes.erase(target_node)


## Atualiza a posição e visibilidade dos marcadores conforme iluminação e alcance
func _update_markers_visibility() -> void:
	var lighting_service = ServiceRegistry.get_service(&"LightingService") as LightingService
	var current_light = 0.20 # Penumbra padrão

	if lighting_service and lighting_service.has_method("get_current_light_level"):
		current_light = lighting_service.get_current_light_level()

	for target_node in _marker_nodes.keys():
		var marker: ColorRect = _marker_nodes[target_node]
		if not is_instance_valid(target_node) or not is_instance_valid(marker):
			continue

		# Atualiza posição relativa dentro do Viewport do minimapa
		marker.global_position = target_node.global_position

		# Regra do Setor Escuro: Inimigos na escuridão/penumbra ficam ocultos se a luz for < 0.35
		var is_enemy: bool = marker.get_meta("is_enemy", false)
		if is_enemy:
			marker.visible = (current_light >= 0.35)
		else:
			marker.visible = true
