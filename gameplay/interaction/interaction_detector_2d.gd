## interaction_detector_2d.gd
## Componente baseado em Area2D responsável por detectar objetos interagíveis próximos ao jogador
## e disparar o comando de interação ao receber a ação semântica 'interact'.

class_name InteractionDetector2D
extends Area2D

# Lista de objetos interagíveis atualmente dentro do alcance do jogador
var _nearby_interactables: Array[Node2D] = []

# Referência ao nó pai (Player)
@onready var _owner_player: Node2D = get_parent() as Node2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		try_interact()


## Procura o objeto interativo mais próximo e dispara a interação
func try_interact() -> bool:
	var target = get_closest_interactable()
	if target:
		if target.has_method("can_interact") and not target.can_interact(_owner_player):
			print("[InteractionDetector2D] Alvo incapaz de interagir no momento.")
			return false
			
		if target.has_method("interact"):
			print("[InteractionDetector2D] Executando interação com: ", target.name)
			target.interact(_owner_player)
			return true
	return false


## Retorna o objeto interagível mais próximo da posição do jogador
func get_closest_interactable() -> Node2D:
	_clean_invalid_targets()
	if _nearby_interactables.is_empty():
		return null
		
	var closest_node: Node2D = null
	var shortest_distance: float = INF
	var player_pos = _owner_player.global_position if _owner_player else global_position
	
	for node in _nearby_interactables:
		if is_instance_valid(node):
			var dist = player_pos.distance_squared_to(node.global_position)
			if dist < shortest_distance:
				shortest_distance = dist
				closest_node = node
				
	return closest_node


func _on_body_entered(body: Node2D) -> void:
	_register_candidate(body)


func _on_body_exited(body: Node2D) -> void:
	_unregister_candidate(body)


func _on_area_entered(area: Area2D) -> void:
	_register_candidate(area)


func _on_area_exited(area: Area2D) -> void:
	_unregister_candidate(area)


func _register_candidate(node: Node2D) -> void:
	if node == _owner_player:
		return
		
	if node.has_method("interact") or node.get_script() is IInteractable:
		if not _nearby_interactables.has(node):
			_nearby_interactables.append(node)
			print("[InteractionDetector2D] Objeto interagível detectado: ", node.name)


func _unregister_candidate(node: Node2D) -> void:
	if _nearby_interactables.has(node):
		_nearby_interactables.erase(node)
		print("[InteractionDetector2D] Objeto interagível saiu do alcance: ", node.name)


func _clean_invalid_targets() -> void:
	_nearby_interactables = _nearby_interactables.filter(func(node): return is_instance_valid(node))
