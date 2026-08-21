## quest_service.gd
## Serviço global responsável pelo rastreamento do estado das missões (LOCKED, ACCEPTED, COMPLETED).

class_name QuestService
extends Node

enum QuestState { LOCKED, ACCEPTED, COMPLETED, FAILED }

## Dicionário de estado das quests { quest_id (StringName): QuestState }
var _quest_states: Dictionary = {}


func _ready() -> void:
	if ServiceRegistry:
		ServiceRegistry.register_service(&"QuestService", self)
	print("[QuestService] Serviço de Quests registrado com sucesso.")


## Retorna o estado atual de uma missão
func get_quest_state(quest_id: StringName) -> QuestState:
	return _quest_states.get(quest_id, QuestState.LOCKED)


## Aceita uma nova missão
func accept_quest(quest_id: StringName) -> void:
	_quest_states[quest_id] = QuestState.ACCEPTED
	print("[QuestService] Missão aceita: ", quest_id)
	
	_emit_event_safe(&"QuestStarted", {"quest_id": quest_id})


## Conclui uma missão com sucesso
func complete_quest(quest_id: StringName) -> void:
	_quest_states[quest_id] = QuestState.COMPLETED
	print("[QuestService] SUCESSO! Missão concluída: ", quest_id)
	
	_emit_event_safe(&"QuestCompleted", {"quest_id": quest_id})


## Disparo seguro de eventos no EventBus
func _emit_event_safe(event_name: StringName, data: Dictionary) -> void:
	if not EventBus:
		return
	if EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", event_name, data)
	elif EventBus.has_method("emit_event"):
		EventBus.call("emit_event", event_name, data)
