## player_camera_extension.gd
## Extensão de apresentação visual e controle da Câmera 2D para o Player2D.
##
## Gerencia acompanhamento suave, limites de mapa, resolução pixel art (640x360)
## e impulsos de trepidação de tela (Camera Shake) orientados por eventos do EventBus.

class_name PlayerCameraExtension
extends Camera2D

## Taxa de decaimento por segundo da trepidação de câmera
@export var shake_decay: float = 5.0

## Deslocamento máximo em pixels para o efeito de shake (Pixel Art Scale)
@export var max_shake_offset: Vector2 = Vector2(6.0, 6.0)

var _shake_strength: float = 0.0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	_setup_camera_parameters()
	_connect_event_listeners()


func _process(delta: float) -> void:
	_process_camera_shake(delta)


## Configura os parâmetros visuais padrão de câmera de acordo com a ADR-022
func _setup_camera_parameters() -> void:
	position_smoothing_enabled = true
	position_smoothing_speed = 5.0
	
	# Garante a escala 1:1 para resolução base de 640x360 em pixel art
	zoom = Vector2(1.0, 1.0)


## Processa a atenuação do Camera Shake com ruído aleatório
func _process_camera_shake(delta: float) -> void:
	if _shake_strength > 0.0:
		_shake_strength = lerpf(_shake_strength, 0.0, shake_decay * delta)
		offset = Vector2(
			_rng.randf_range(-max_shake_offset.x, max_shake_offset.x) * _shake_strength,
			_rng.randf_range(-max_shake_offset.y, max_shake_offset.y) * _shake_strength
		)
		if _shake_strength < 0.01:
			_shake_strength = 0.0
			offset = Vector2.ZERO
	else:
		offset = Vector2.ZERO


## Aciona o efeito de trepidação de câmera com intensidade (0.0 a 1.0)
func apply_shake(intensity: float = 0.5) -> void:
	_shake_strength = clampf(intensity, 0.0, 1.0)


## Configura os limites físicos da câmera no mapa (Rect2 em pixels)
func set_camera_limits(bounds: Rect2) -> void:
	limit_left = int(bounds.position.x)
	limit_top = int(bounds.position.y)
	limit_right = int(bounds.position.x + bounds.size.x)
	limit_bottom = int(bounds.position.y + bounds.size.y)


## Conecta aos eventos desacoplados do EventBus
func _connect_event_listeners() -> void:
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.event_emitted.connect(_on_global_event)


func _on_global_event(event_name: StringName, payload: Dictionary) -> void:
	match event_name:
		&"PlayerHit":
			apply_shake(0.6)
		&"MeleeAttackExecuted":
			apply_shake(0.25)
		&"ExplosionOccurred":
			apply_shake(0.8)
