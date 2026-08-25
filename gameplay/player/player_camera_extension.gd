## player_camera_extension.gd
## Extensão de controle visual e comportamento da Camera2D do Jogador.
##
## Gerencia suavização Top-Down, desvio dinâmico por direção (look-ahead),
## sistema de trauma/screen shake para feedback de combate e calibração de zoom
## na resolução-base 640x360 sem alterar os dados do PlayerDomain.

class_name PlayerCameraExtension
extends Camera2D

## Propriedades de Enquadramento e Zoom
@export var base_zoom: Vector2 = Vector2(1.0, 1.0)
@export var exploration_zoom: Vector2 = Vector2(1.0, 1.0)
@export var combat_zoom: Vector2 = Vector2(1.15, 1.15)
@export var dialogue_zoom: Vector2 = Vector2(1.25, 1.25)
@export var zoom_speed: float = 4.0

## Propriedades de Desvio (Look-Ahead)
@export var look_ahead_distance: float = 24.0
@export var look_ahead_speed: float = 3.0

## Propriedades de Trauma e Shake (Vibração da Câmera)
@export var max_shake_offset: Vector2 = Vector2(12.0, 8.0)
@export var max_shake_roll: float = 0.05
@export var trauma_decay_rate: float = 1.8

var _trauma: float = 0.0
var _target_zoom: Vector2 = Vector2(1.0, 1.0)
var _target_look_ahead: Vector2 = Vector2.ZERO
var _current_look_ahead: Vector2 = Vector2.ZERO
var _player_ref: Player2D = null


func _ready() -> void:
	zoom = base_zoom
	_target_zoom = base_zoom
	position_smoothing_enabled = true
	position_smoothing_speed = 6.0
	
	# Busca referência do Player2D pai
	_player_ref = get_parent() as Player2D
	if _player_ref:
		if _player_ref.has_signal("visual_state_changed"):
			_player_ref.visual_state_changed.connect(_on_player_visual_state_changed)
			
	# Escuta eventos de combate e dano no EventBus para acionar vibração
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.event_emitted.connect(_on_event_emitted)


func _process(delta: float) -> void:
	_update_zoom(delta)
	_update_look_ahead(delta)
	_process_shake(delta)


## Adiciona trauma para gerar vibração na tela (valor entre 0.0 e 1.0)
func add_trauma(amount: float) -> void:
	_trauma = clampf(_trauma + amount, 0.0, 1.0)


## Ajusta os limites da câmera de acordo com as bordas da região carregada
func set_region_limits(left: int, top: int, right: int, bottom: int) -> void:
	limit_left = left
	limit_top = top
	limit_right = right
	limit_bottom = bottom


## Altera o zoom-alvo da câmera para um estado de gameplay
func set_camera_mode_zoom(mode_name: StringName) -> void:
	match mode_name:
		&"combat":
			_target_zoom = combat_zoom
		&"dialogue":
			_target_zoom = dialogue_zoom
		_:
			_target_zoom = exploration_zoom


func _update_zoom(delta: float) -> void:
	if zoom != _target_zoom:
		zoom = zoom.lerp(_target_zoom, zoom_speed * delta)


func _update_look_ahead(delta: float) -> void:
	_current_look_ahead = _current_look_ahead.lerp(_target_look_ahead, look_ahead_speed * delta)
	position = _current_look_ahead


func _process_shake(delta: float) -> void:
	if _trauma > 0.0:
		_trauma = maxf(_trauma - trauma_decay_rate * delta, 0.0)
		var shake_amount: float = _trauma * _trauma # Curva quadrática de decaimento
		
		offset = Vector2(
			randf_range(-1.0, 1.0) * max_shake_offset.x * shake_amount,
			randf_range(-1.0, 1.0) * max_shake_offset.y * shake_amount
		)
		rotation = randf_range(-1.0, 1.0) * max_shake_roll * shake_amount
	else:
		offset = Vector2.ZERO
		rotation = 0.0


func _on_player_visual_state_changed(_state_name: StringName, direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		_target_look_ahead = direction.normalized() * look_ahead_distance


func _on_event_emitted(event_name: StringName, payload: Dictionary) -> void:
	match event_name:
		&"PlayerTookDamage":
			add_trauma(0.5)
		&"PlayerAttacked":
			add_trauma(0.2)
		&"ExplosionOccurred":
			add_trauma(0.8)
