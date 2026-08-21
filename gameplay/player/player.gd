## player.gd
## Controlador principal da entidade do Jogador 2D.
## Le as ações semânticas do Input Map e delega para o MovementComponent2D e lanterna portátil.

class_name Player2D
extends CharacterBody2D

@onready var movement_component: MovementComponent2D = $MovementComponent2D

var _light_node: PointLight2D = null
var _is_light_on: bool = false


func _ready() -> void:
	_setup_portable_light()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"use_light"):
		toggle_light()


func _physics_process(delta: float) -> void:
	_handle_movement(delta)


func _handle_movement(delta: float) -> void:
	# Leitura dos eixos semânticos mapeados no Input Map
	var input_vector = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	var is_sprinting = Input.is_action_pressed(&"sprint")
	
	if movement_component:
		velocity = movement_component.calculate_velocity(input_vector, is_sprinting, delta, velocity)
		move_and_slide()


## Configura o nó de iluminação portátil dinâmico (PointLight2D)
func _setup_portable_light() -> void:
	_light_node = PointLight2D.new()
	_light_node.name = "PortableLantern"
	_light_node.energy = 1.2
	_light_node.texture_scale = 1.5
	_light_node.color = Color(1.0, 0.9, 0.65, 1.0) # Luz quente/amarelada
	
	# Criar textura de gradiente radial programaticamente para a luz
	var light_texture = GradientTexture2D.new()
	var gradient = Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 1))
	gradient.set_color(1, Color(0, 0, 0, 0))
	light_texture.gradient = gradient
	light_texture.fill = GradientTexture2D.FILL_RADIAL
	light_texture.fill_from = Vector2(0.5, 0.5)
	light_texture.fill_to = Vector2(0.5, 0.0)
	light_texture.width = 128
	light_texture.height = 128
	
	_light_node.texture = light_texture
	_light_node.enabled = false
	add_child(_light_node)


## Alterna o estado da lanterna (Ligar/Desligar) com a tecla F (use_light)
func toggle_light() -> void:
	_is_light_on = not _is_light_on
	if _light_node:
		_light_node.enabled = _is_light_on
		
	var light_service = ServiceRegistry.get_service(&"LightingService") as LightingService
	if light_service:
		var light_val = 0.90 if _is_light_on else 0.20
		light_service.update_player_light(light_val)
	else:
		print("[Player] Lanterna ", "LIGADA" if _is_light_on else "DESLIGADA")
