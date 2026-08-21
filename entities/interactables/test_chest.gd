## test_chest.gd
## Objeto interativo de teste (Baú) para validar o InteractionDetector2D e a interface IInteractable.

extends Area2D

var is_open: bool = false
var _visual_rect: ColorRect = null


func _ready() -> void:
	# Cria a colisão da área de interação do baú (Círculo de raio 16px)
	var col_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 16.0
	col_shape.shape = circle
	add_child(col_shape)
	
	# Visual provisório do baú (Verde para fechado)
	_visual_rect = ColorRect.new()
	_visual_rect.custom_minimum_size = Vector2(20, 20)
	_visual_rect.position = Vector2(-10, -10)
	_visual_rect.color = Color(0.2, 0.8, 0.2, 1.0) # Verde
	add_child(_visual_rect)


## Retorna a mensagem contextual para a UI
func get_interaction_text() -> String:
	return "Fechar Baú" if is_open else "Abrir Baú"


## Retorna se o objeto pode receber interação no momento
func can_interact(_interactor: Node2D) -> bool:
	return true


## Executa a lógica de interação
func interact(_interactor: Node2D) -> void:
	is_open = not is_open
	
	if is_open:
		_visual_rect.color = Color(0.9, 0.7, 0.1, 1.0) # Amarelo/Dourado (Aberto)
		print("[Baú de Teste] Você ABERIU o baú! Item encontrado: [Minério de Ferro].")
	else:
		_visual_rect.color = Color(0.2, 0.8, 0.2, 1.0) # Verde (Fechado)
		print("[Baú de Teste] Você FECHOU o baú.")
		
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"ChestInteracted", {"is_open": is_open})
