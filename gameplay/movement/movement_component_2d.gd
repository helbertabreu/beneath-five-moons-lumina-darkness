## movement_component_2d.gd
## Componente modular responsável por gerenciar a física e aceleração de movimento 2D.

class_name MovementComponent2D
extends Node

@export_category("Configurações de Movimento")
@export var walk_speed: float = 120.0
@export var sprint_speed: float = 200.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0

var current_velocity: Vector2 = Vector2.ZERO


## Processa o vetor de movimento desejado e aplica aceleração/atrito.
## Retorna a nova velocidade calculada.
func calculate_velocity(input_vector: Vector2, is_sprinting: bool, delta: float, velocity_reference: Vector2) -> Vector2:
	var target_speed = sprint_speed if is_sprinting else walk_speed
	var target_velocity = input_vector.normalized() * target_speed
	
	if input_vector != Vector2.ZERO:
		# Aplica aceleração em direção ao vetor alvo
		return velocity_reference.move_toward(target_velocity, acceleration * delta)
	else:
		# Aplica desaceleração/atrito até parar
		return velocity_reference.move_toward(Vector2.ZERO, friction * delta)
