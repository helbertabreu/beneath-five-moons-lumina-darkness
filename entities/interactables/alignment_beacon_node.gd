## alignment_beacon_node.gd
## Nó interativo do Farol do Alinhamento (Gate 25.2 / TASK-409B).
## Permite ao jogador salvar o jogo ao interagir (pressionar 'E' ou aproximar-se) e serve como ponto de save/respawn.

class_name AlignmentBeaconNode
extends Area2D

@export var save_slot_name: String = "save_slot_1"
@export var interaction_radius: float = 48.0

var _is_player_in_range: bool = false


func _ready() -> void:
	collision_layer = 4 # Camada de interativos
	collision_mask = 1  # Camada do Player
	
	# Garante a existência do CollisionShape2D se não configurado na cena
	if not has_node("CollisionShape2D"):
		var col = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = interaction_radius
		col.shape = shape
		add_child(col)
		
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	print("[AlignmentBeacon] Farol do Alinhamento inicializado na posição: ", global_position)


func _unhandled_input(event: InputEvent) -> void:
	if _is_player_in_range and event.is_action_pressed("interact"):
		trigger_save()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		_is_player_in_range = true
		print("[AlignmentBeacon] Jogador entrou no raio de interação do Farol.")
		if EventBus and EventBus.has_signal("event_emitted"):
			EventBus.emit_signal("event_emitted", &"ShowInteractionPrompt", {"text": "Pressione 'E' para Salvar no Farol"})


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") or body.name == "Player":
		_is_player_in_range = false
		print("[AlignmentBeacon] Jogador saiu do raio de interação do Farol.")
		if EventBus and EventBus.has_signal("event_emitted"):
			EventBus.emit_signal("event_emitted", &"HideInteractionPrompt", {})


func interact(_actor: Node2D) -> void:
	trigger_save()


func trigger_save() -> void:
	print("[AlignmentBeacon] Acionando salvamento atômico no Farol...")
	var save_service = ServiceRegistry.get_service(&"SaveService")
	if save_service and save_service.has_method("save_game"):
		var success = save_service.save_game(save_slot_name)
		if success:
			print("[AlignmentBeacon] Jogo salvo com sucesso pelo Farol!")
			if EventBus and EventBus.has_signal("event_emitted"):
				EventBus.emit_signal("event_emitted", &"ShowNotification", {"message": "Jogo Salvo com Sucesso no Farol!"})
		else:
			push_error("[AlignmentBeacon] Falha ao salvar o jogo no slot: %s" % save_slot_name)
	else:
		push_error("[AlignmentBeacon] SaveService não registrado no ServiceRegistry!")
