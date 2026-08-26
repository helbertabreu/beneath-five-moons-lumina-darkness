## player.gd
## Controlador principal e de apresentação visual do Jogador 2D.
##
## Mantém desacoplamento da lógica física com suporte a animações,
## orientação de sprite, sombra no terreno, lanterna portátil e combate.

class_name Player2D
extends CharacterBody2D

signal visual_state_changed(state_name: StringName, direction: Vector2)

@onready var movement_component: MovementComponent2D = $MovementComponent2D

var _light_node: PointLight2D = null
var _is_light_on: bool = false
var _attack_area: Area2D = null

# Nós e variáveis de Apresentação Visual
var _sprite_node: Sprite2D = null
var _animation_player: AnimationPlayer = null
var _lantern_anchor: Marker2D = null
var _shadow_sprite: Sprite2D = null
var _last_facing_direction: Vector2 = Vector2.DOWN
var _is_attacking: bool = false

# Cache de Texturas para Spritesheets Direcionais
var _tex_walk: Texture2D = null
var _tex_idle: Texture2D = null
var _tex_slash: Texture2D = null


func _ready() -> void:
	_load_animation_textures()
	_setup_visual_nodes()
	_setup_portable_light()
	_setup_attack_area()
	_update_presentation()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"use_light"):
		toggle_light()
	elif event.is_action_pressed(&"attack") and not _is_attacking:
		perform_attack()


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_update_presentation()


func _handle_movement(delta: float) -> void:
	var input_vector = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	var is_sprinting = Input.is_action_pressed(&"sprint")
	
	if movement_component:
		velocity = movement_component.calculate_velocity(input_vector, is_sprinting, delta, velocity)
		move_and_slide()
		
		if input_vector != Vector2.ZERO:
			_last_facing_direction = input_vector.normalized()


## Carrega e valida no cache os recursos de textura dos spritesheets direcionais
func _load_animation_textures() -> void:
	if ResourceLoader.exists("res://assets/textures/SpriteSheetPlayer.png"):
		_tex_walk = load("res://assets/textures/SpriteSheetPlayer.png") as Texture2D
		
	if ResourceLoader.exists("res://assets/textures/SpriteSheetPlayer_Idle.png"):
		_tex_idle = load("res://assets/textures/SpriteSheetPlayer_Idle.png") as Texture2D
	else:
		_tex_idle = _tex_walk
		
	if ResourceLoader.exists("res://assets/textures/SpriteSheetPlayer_Slash.png"):
		_tex_slash = load("res://assets/textures/SpriteSheetPlayer_Slash.png") as Texture2D
	else:
		_tex_slash = _tex_walk


## Configura e inicializa programaticamente a infraestrutura visual do Player
func _setup_visual_nodes() -> void:
	var placeholder = get_node_or_null("PlaceholderVisual")
	if placeholder:
		placeholder.visible = false
	
	_sprite_node = get_node_or_null("Sprite2D") as Sprite2D
	if not _sprite_node:
		_sprite_node = get_node_or_null("PlayerSprite") as Sprite2D
		
	if not _sprite_node:
		_sprite_node = Sprite2D.new()
		_sprite_node.name = "Sprite2D"
		_sprite_node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		_sprite_node.texture = _tex_idle if _tex_idle else load("res://assets/textures/SpriteSheetPlayer_Idle.png")
		_sprite_node.hframes = 4
		_sprite_node.vframes = 4
		add_child(_sprite_node)
		move_child(_sprite_node, 0)
	
	_shadow_sprite = get_node_or_null("ShadowSprite2D") as Sprite2D
	if not _shadow_sprite:
		_shadow_sprite = get_node_or_null("ShadowSprite") as Sprite2D
		
	if not _shadow_sprite:
		_shadow_sprite = Sprite2D.new()
		_shadow_sprite.name = "ShadowSprite2D"
		_shadow_sprite.position = Vector2(0, 11)
		_shadow_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		var gradient_tex = GradientTexture2D.new()
		var grad = Gradient.new()
		grad.set_color(0, Color(0, 0, 0, 0.45))
		grad.set_color(1, Color(0, 0, 0, 0))
		gradient_tex.gradient = grad
		gradient_tex.fill = GradientTexture2D.FILL_RADIAL
		gradient_tex.fill_from = Vector2(0.5, 0.5)
		gradient_tex.fill_to = Vector2(1, 0.5)
		gradient_tex.width = 18
		gradient_tex.height = 10
		_shadow_sprite.texture = gradient_tex
		add_child(_shadow_sprite)
		move_child(_shadow_sprite, 0)
		
	_animation_player = get_node_or_null("AnimationPlayer") as AnimationPlayer
	if not _animation_player:
		_animation_player = AnimationPlayer.new()
		_animation_player.name = "AnimationPlayer"
		add_child(_animation_player)
		
	_lantern_anchor = get_node_or_null("LanternAnchor") as Marker2D
	if not _lantern_anchor:
		_lantern_anchor = Marker2D.new()
		_lantern_anchor.name = "LanternAnchor"
		add_child(_lantern_anchor)


## Configura o nó de iluminação portátil dinâmico (PointLight2D)
func _setup_portable_light() -> void:
	_light_node = get_node_or_null("LanternPointLight2D") as PointLight2D
	if not _light_node:
		_light_node = get_node_or_null("PortableLantern") as PointLight2D
		
	if not _light_node:
		_light_node = PointLight2D.new()
		_light_node.name = "LanternPointLight2D"
		_light_node.energy = 1.1
		_light_node.texture_scale = 1.2
		_light_node.color = Color(1.0, 0.85, 0.6, 1.0)
		
		var light_texture = GradientTexture2D.new()
		var gradient = Gradient.new()
		gradient.set_color(0, Color(1, 0.9, 0.65, 1))
		gradient.set_offset(1, 0.45)
		gradient.set_color(1, Color(0.8, 0.5, 0.2, 0.4))
		light_texture.gradient = gradient
		light_texture.fill = GradientTexture2D.FILL_RADIAL
		light_texture.fill_from = Vector2(0.5, 0.5)
		light_texture.fill_to = Vector2(1, 0.5)
		light_texture.width = 256
		light_texture.height = 256
		
		_light_node.texture = light_texture
		_light_node.enabled = false
		
		if _lantern_anchor:
			_lantern_anchor.add_child(_light_node)
		else:
			add_child(_light_node)


## Configura a área física de ataque Melee ao redor do jogador
func _setup_attack_area() -> void:
	_attack_area = get_node_or_null("MeleeAttackArea") as Area2D
	if not _attack_area:
		_attack_area = Area2D.new()
		_attack_area.name = "MeleeAttackArea"
		_attack_area.monitorable = false
		_attack_area.monitoring = true
		
		var col_shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		circle.radius = 45.0
		col_shape.shape = circle
		_attack_area.add_child(col_shape)
		add_child(_attack_area)


## Atualiza os estados visuais, rotação da lanterna e toca animação direcional
func _update_presentation() -> void:
	if _lantern_anchor and _last_facing_direction != Vector2.ZERO:
		_lantern_anchor.position = _last_facing_direction * 12.0
		
	if _animation_player and not _is_attacking:
		var dir_suffix = _get_direction_suffix(_last_facing_direction)
		var is_moving = velocity.length() > 5.0
		var anim_name = "walk_" + dir_suffix if is_moving else "idle_" + dir_suffix
		
		if _animation_player.has_animation(anim_name) and _animation_player.current_animation != anim_name:
			_animation_player.play(anim_name)
			
	visual_state_changed.emit(&"walk" if velocity.length() > 5.0 else &"idle", _last_facing_direction)


## Retorna o sufixo direcional correspondente ao vetor de orientação do personagem
func _get_direction_suffix(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y):
		return "right" if dir.x > 0 else "left"
	else:
		return "down" if dir.y > 0 else "up"


## Alterna o estado da lanterna (Ligar/Desligar) com a tecla F (use_light)
func toggle_light() -> void:
	_is_light_on = not _is_light_on
	if _light_node:
		_light_node.enabled = _is_light_on
		
	if ServiceRegistry and ServiceRegistry.has_service(&"LightingService"):
		var light_service = ServiceRegistry.get_service(&"LightingService") as LightingService
		if light_service:
			var light_val = 0.90 if _is_light_on else 0.20
			light_service.update_player_light(light_val)
	else:
		print("[Player] Lanterna ", "LIGADA" if _is_light_on else "DESLIGADA", " (Serviço de Iluminação Indisponível)")


## Executa o golpe Melee com a tecla Espaço (attack)
func perform_attack() -> void:
	print("[Player] Executando Ataque Melee!")
	if not _attack_area or _is_attacking:
		return
		
	_is_attacking = true
	var dir_suffix = _get_direction_suffix(_last_facing_direction)
	var anim_name = "attack_" + dir_suffix
	
	if _animation_player and _animation_player.has_animation(anim_name):
		_animation_player.play(anim_name)
		
	var overlapping_areas = _attack_area.get_overlapping_areas()
	var damage_ctx = DamageContext.new(15.0, self, false)
	var hit_count = 0
	
	for area in overlapping_areas:
		if area.has_method("receive_damage"):
			area.call("receive_damage", damage_ctx)
			hit_count += 1
			
	if hit_count == 0:
		print("[Player] Ataque no ar (Nenhum inimigo atingido).")
		
	get_tree().create_timer(0.3).timeout.connect(func():
		_is_attacking = false
		_update_presentation()
	)
