## Entidade interativa de NPC (Gorn, o Ferreiro) que fornece e valida a Quest 01
## e gerencia o relacionamento com o jogador via RelationshipService.

extends Area2D

var _visual_rect: ColorRect = null
var _quest_def: QuestDefinition = null
var _npc_id: StringName = &"npc.blacksmith.gorn"


func _ready() -> void:
	monitorable = true
	monitoring = true
	
	# Colisão física do NPC (Raio de 25px)
	var col_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 25.0
	col_shape.shape = circle
	add_child(col_shape)
	
	# Visual provisório do NPC (Retângulo Azul/Ferreiro)
	_visual_rect = ColorRect.new()
	_visual_rect.custom_minimum_size = Vector2(24, 24)
	_visual_rect.position = Vector2(-12, -12)
	_visual_rect.color = Color(0.2, 0.4, 0.8, 1.0) # Azul
	add_child(_visual_rect)
	
	_setup_quest_data()
	_setup_relationship_data()
	print("[NPC Ferreiro Gorn] Pronto para interação.")


## Configura a Quest 01 (A Providência do Ferro)
func _setup_quest_data() -> void:
	_quest_def = QuestDefinition.new()
	_quest_def.id = &"quest.local.blacksmith_iron"
	_quest_def.title = "A Providência do Ferro"
	_quest_def.description = "Traga 1x Lingote de Ferro para o Ferreiro Gorn."
	_quest_def.required_items = {
		&"item.material.iron_ingot": 1
	}
	_quest_def.reward_currency = 100
	_quest_def.reward_reputation = 50.0


## Configura a definição de relacionamento do NPC com o RelationshipService
func _setup_relationship_data() -> void:
	var rel_service = ServiceRegistry.get_service(&"RelationshipService") as RelationshipService
	if rel_service:
		var rel_def = RelationshipDefinition.new()
		rel_def.npc_id = _npc_id
		rel_def.display_name = "Gorn, o Ferreiro"
		rel_def.loved_item_ids = [&"item.material.iron_ingot"]
		rel_def.liked_item_ids = [&"item.material.iron_ore"]
		rel_def.hated_item_ids = [&"item.junk.trash"]
		rel_service.register_npc_definition(rel_def)


## Retorna a mensagem de contexto para o detector
func get_interaction_text() -> String:
	return "Falar com Gorn, o Ferreiro"


func can_interact(_interactor: Node2D) -> bool:
	return true


## Trata o fluxo transacional do diálogo, afinidade e validação da Quest
func interact(_interactor: Node2D) -> void:
	var quest_service = ServiceRegistry.get_service(&"QuestService") as QuestService
	var inv_service = ServiceRegistry.get_service(&"InventoryService") as InventoryService
	var rel_service = ServiceRegistry.get_service(&"RelationshipService") as RelationshipService
	
	if not quest_service or not inv_service:
		print("[Gorn] Erro: Serviços não registrados!")
		return
		
	var state = quest_service.get_quest_state(_quest_def.id)
	
	match state:
		QuestService.QuestState.LOCKED:
			# Aceitar a Quest 01
			print("[Gorn] 'Saudações, viajante! As reservas de ferro do vilarejo acabaram. Traga-me 1x Lingote de Ferro!'")
			quest_service.accept_quest(_quest_def.id)
			print("[Quest 01] Nova Missão Aceita: ", _quest_def.title)
			
		QuestService.QuestState.ACCEPTED:
			# Checar se o jogador tem o Lingote de Ferro
			var required_item_id = &"item.material.iron_ingot"
			var current_qty = inv_service.get_total_quantity(required_item_id)
			
			if current_qty >= 1:
				# Entregar Lingote e Concluir Quest
				inv_service.remove_item(required_item_id, 1)
				quest_service.complete_quest(_quest_def.id)
				
				# Aumenta a afinidade com o NPC ao entregar a quest
				if rel_service:
					rel_service.modify_affinity(_npc_id, 15.0, "quest_completed:" + String(_quest_def.id))
				
				print("[Gorn] 'Excelente trabalho! Este lingote servirá perfeitamente. Aqui está sua recompensa!'")
				print("[Recompensa] +%d Moedas e +%.1f de Reputação Local com o Vilarejo!" % [_quest_def.reward_currency, _quest_def.reward_reputation])
				
				# Disparo de eventos
				_emit_event_safe(&"ReputationChanged", {
					"settlement": &"territory.village.start",
					"amount": _quest_def.reward_reputation
				})
			else:
				print("[Gorn] 'Ainda estou aguardando o Lingote de Ferro! Minere 2x Minérios de Ferro e forje-os na Forja ao lado.'")
				
		QuestService.QuestState.COMPLETED:
			print("[Gorn] 'Obrigado novamente pela ajuda com o ferro, amigo!'")


## Emissão segura de eventos
func _emit_event_safe(event_name: StringName, data: Dictionary) -> void:
	if not EventBus:
		return
	if EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", event_name, data)
	elif EventBus.has_method("emit_event"):
		EventBus.call("emit_event", event_name, data)
