## Script do Posto Avançado da Garganta de Ferro (Gate 23 e 24)
## Orquestra o layout visual, colissões, spawning de entidades e iluminação da região.

extends Node2D

@onready var tilemap_layer: TileMapLayer = $TileMapLayer
@onready var entities_container: Node2D = $Entities
@onready var lights_container: Node2D = $Lights
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

const FORGE_NODE_SCRIPT = preload("res://entities/interactables/forge_node.gd")
const IRON_MINE_NODE_SCRIPT = preload("res://entities/resources/iron_mine_node.gd")
const BIOLUMINESCENT_FLORA_SCRIPT = preload("res://entities/environment/bioluminescent_flora_node.gd")

var _player_instance: Node2D = null


func _ready() -> void:
	_setup_environment_lighting()
	_spawn_structures_and_resources()
	print("[Garganta de Ferro] Região carregada com sucesso.")


## Configura a iluminação ambiente (Penumbra Azulada do Setor Escuro)
func _setup_environment_lighting() -> void:
	if canvas_modulate:
		canvas_modulate.color = Color(0.15, 0.18, 0.28, 1.0) # Penumbra padrão (0.20)


## Instancia as entidades interativas nos pontos definidos no LDD
func _spawn_structures_and_resources() -> void:
	# 1. Forja do Ferreiro (Norte / Centro - Próximo ao Farol)
	var forge = Area2D.new()
	forge.name = "ForgeNode"
	forge.position = Vector2(320, 160)
	forge.set_script(FORGE_NODE_SCRIPT)
	entities_container.add_child(forge)
	_emit_minimap_marker(forge, Color(1.0, 0.5, 0.0), false) # Marcador Laranja

	# 2. Nós de Minério de Ferro (Leste - Área de Mineração)
	var mine_1 = Area2D.new()
	mine_1.name = "IronMine_01"
	mine_1.position = Vector2(520, 180)
	mine_1.set_script(IRON_MINE_NODE_SCRIPT)
	entities_container.add_child(mine_1)
	_emit_minimap_marker(mine_1, Color(0.7, 0.7, 0.7), false) # Marcador Cinza

	var mine_2 = Area2D.new()
	mine_2.name = "IronMine_02"
	mine_2.position = Vector2(550, 220)
	mine_2.set_script(IRON_MINE_NODE_SCRIPT)
	entities_container.add_child(mine_2)
	_emit_minimap_marker(mine_2, Color(0.7, 0.7, 0.7), false)

	# 3. Flora Bioluminescente (Sudoeste - Entrada da Caverna)
	var flora = Area2D.new()
	flora.name = "BioluminescentFlora"
	flora.position = Vector2(120, 360)
	flora.set_script(BIOLUMINESCENT_FLORA_SCRIPT)
	entities_container.add_child(flora)
	_emit_minimap_marker(flora, Color(0.0, 0.9, 1.0), false) # Marcador Ciano

	# 4. Farol do Alinhamento (Ponto de Save / Luz Plena)
	_spawn_alignment_beacon(Vector2(320, 100))


## Cria o Farol do Alinhamento que emite luz e serve como Save Point
func _spawn_alignment_beacon(pos: Vector2) -> void:
	var beacon = Area2D.new()
	beacon.name = "AlignmentBeacon"
	beacon.position = pos

	var beacon_light = PointLight2D.new()
	beacon_light.color = Color(1.0, 0.9, 0.6, 1.0)
	beacon_light.energy = 1.4
	beacon_light.texture_scale = 3.0
	beacon.add_child(beacon_light)

	lights_container.add_child(beacon)
	_emit_minimap_marker(beacon, Color(1.0, 0.84, 0.0), false) # Marcador Dourado


## Dispara evento de registro de marcador no minimapa
func _emit_minimap_marker(node: Node2D, color: Color, is_enemy: bool) -> void:
	if EventBus:
		var data = {
			"node": node,
			"color": color,
			"is_enemy": is_enemy
		}
		if EventBus.has_signal("event_emitted"):
			EventBus.emit_signal("event_emitted", &"RegisterMinimapMarker", data)
