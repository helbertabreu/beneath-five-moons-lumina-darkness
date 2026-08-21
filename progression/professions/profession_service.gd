## profession_service.gd
## Serviço global registrado no ServiceRegistry que gerencia o progresso das profissões.

class_name ProfessionService
extends Node

## Tabela de estados das profissões do jogador { profession_id (StringName): ProfessionState }
var _profession_states: Dictionary = {}


func _ready() -> void:
	if ServiceRegistry:
		ServiceRegistry.register_service(&"ProfessionService", self)
	print("[ProfessionService] Serviço de Profissões registrado com sucesso.")


## Concede XP a uma profissão e emite eventos de progresso no EventBus
func add_profession_xp(profession_id: StringName, amount: float) -> bool:
	var state = get_or_create_profession_state(profession_id)
	var xp_result = state.add_xp(amount)
	
	print("[ProfessionService] +%.1f XP concedido a %s. (Tier: %d, XP: %.1f/%.1f)" % [
		amount, profession_id, state.current_tier, state.current_xp, state.xp_per_tier
	])
	
	if xp_result.get("tier_up", false):
		print("[ProfessionService] PARABÉNS! Subida de Tier em %s: Tier %d -> Tier %d" % [
			profession_id, xp_result["old_tier"], xp_result["new_tier"]
		])
		
	_emit_event_safe(&"ProfessionXPChanged", {
		"profession_id": profession_id,
		"current_tier": state.current_tier,
		"current_xp": state.current_xp,
		"tier_up": xp_result.get("tier_up", false)
	})
	
	return true


## Obtém ou inicializa o estado de uma profissão
func get_or_create_profession_state(profession_id: StringName) -> ProfessionState:
	if not _profession_states.has(profession_id):
		_profession_states[profession_id] = ProfessionState.new(profession_id)
	return _profession_states[profession_id] as ProfessionState


## Retorna o Tier atual do jogador na profissão solicitada
func get_profession_tier(profession_id: StringName) -> int:
	if _profession_states.has(profession_id):
		return (_profession_states[profession_id] as ProfessionState).current_tier
	return 1


## Serializa todas as profissões para salvamento atômico
func serialize_professions() -> Dictionary:
	var serialized_data: Dictionary = {}
	for prof_id in _profession_states:
		var state = _profession_states[prof_id] as ProfessionState
		serialized_data[String(prof_id)] = state.serialize()
	return serialized_data


## Carrega todas as profissões des serializadas do save
func deserialize_professions(data: Dictionary) -> void:
	_profession_states.clear()
	for key in data:
		var prof_data = data[key] as Dictionary
		var prof_id = StringName(key)
		var state = ProfessionState.new(prof_id)
		if state.deserialize(prof_data):
			_profession_states[prof_id] = state
	print("[ProfessionService] Estado das profissões restaurado com sucesso.")


## Emissão defensiva de eventos via EventBus
func _emit_event_safe(event_name: StringName, payload: Dictionary) -> void:
	if not EventBus:
		return
	if EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", event_name, payload)
	elif EventBus.has_method("emit_event"):
		EventBus.call("emit_event", event_name, payload)
