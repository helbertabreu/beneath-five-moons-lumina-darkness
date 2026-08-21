## player.gd
## Controlador principal da entidade do Jogador 2D.
## Le as ações semânticas do Input Map e delega para o MovementComponent2D.

class_name Player2D
extends CharacterBody2D

@onready var movement_component: MovementComponent2D = $MovementComponent2D


func _physics_process(delta: float) -> void:
	_handle_movement(delta)


func _handle_movement(delta: float) -> void:
	# Leitura dos eixos semânticos mapeados no Input Map
	var input_vector = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	var is_sprinting = Input.is_action_pressed(&"sprint")
	
	if movement_component:
		velocity = movement_component.calculate_velocity(input_vector, is_sprinting, delta, velocity)
		move_and_slide()
