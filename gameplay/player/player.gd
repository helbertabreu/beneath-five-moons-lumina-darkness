## player.gd
## Controlador principal do Jogador 2D com suporte a lanterna e ataque Melee.

class_name Player2D
extends CharacterBody2D

@onready var movement_component: MovementComponent2D = $MovementComponent2D

var _light_node: PointLight2D = null
var _is_light_on: bool = false
var _attack_area: Area2D = null


func _ready() -> void:
	_setup_portable_light()
	_setup_attack_area()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"use_light"):
		toggle_light()
	elif event.is_action_pressed(&"attack"):
		perform_attack()


func _physics_process(delta: float) -> void:
	_handle_movement(delta)


func _handle_movement(delta: float) -> void:
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
	_light_node.color = Color(1.0, 0.9, 0.65, 1.0)
	
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


## Configura a área física de ataque Melee ao redor do jogador
func _setup_attack_area() -> void:
	_attack_area = Area2D.new()
	_attack_area.name = "MeleeAttackArea"
	_attack_area.monitorable = false
	_attack_area.monitoring = true
	
	var col_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 45.0 # Alcance de ataque de 45px
	col_shape.shape = circle
	_attack_area.add_child(col_shape)
	add_child(_attack_area)


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


## Executa o golpe Melee com a barra de Espaço (attack)
func perform_attack() -> void:
	print("[Player] Executando Ataque Melee!")
	if not _attack_area:
		return
		
	var overlapping_areas = _attack_area.get_overlapping_areas()
	var damage_ctx = DamageContext.new(15.0, self, false)
	var hit_count = 0
	
	for area in overlapping_areas:
		if area.has_method("receive_damage"):
			area.call("receive_damage", damage_ctx)
			hit_count += 1
			
	if hit_count == 0:
		print("[Player] Ataque no ar (Nenhum inimigo atingido).")
