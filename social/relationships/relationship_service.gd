## Serviço central de gerenciamento de relacionamentos e afinidade de NPCs.
## Registrado no ServiceRegistry sob o nome &"RelationshipService".

class_name RelationshipService
extends Node

## Dicionário de estados em runtime por ID de NPC [StringName, RelationshipState]
var _relationships: Dictionary = {}

## Dicionário de definições de NPCs [StringName, RelationshipDefinition]
var _definitions: Dictionary = {}


func _ready() -> void:
	if ServiceRegistry:
		ServiceRegistry.register_service(&"RelationshipService", self)


## Registra a definição estática de um NPC
func register_npc_definition(def: RelationshipDefinition) -> void:
	if not def or def.npc_id == &"":
		return
	_definitions[def.npc_id] = def
	if not _relationships.has(def.npc_id):
		_relationships[def.npc_id] = RelationshipState.new(def.npc_id, 0.0)


## Obter ou criar o estado de relacionamento de um NPC
func get_relationship_state(npc_id: StringName) -> RelationshipState:
	if not _relationships.has(npc_id):
		_relationships[npc_id] = RelationshipState.new(npc_id, 0.0)
	return _relationships[npc_id]


## Modifica a afinidade de um NPC e emite o evento global no EventBus
func modify_affinity(npc_id: StringName, amount: float, reason: String = "") -> float:
	var state = get_relationship_state(npc_id)
	var old_affinity = state.affinity
	state.add_affinity(amount)
	
	_emit_relationship_changed_event(npc_id, state.affinity, old_affinity, reason)
	return state.affinity


## Doa um item como presente para o NPC
func give_gift(npc_id: StringName, item_id: StringName) -> float:
	var state = get_relationship_state(npc_id)
	var affinity_delta = 2.0 # Padrão neutro
	
	if _definitions.has(npc_id):
		var def: RelationshipDefinition = _definitions[npc_id]
		affinity_delta = def.evaluate_gift(item_id)
		
	state.gifts_given_count += 1
	return modify_affinity(npc_id, affinity_delta, "gift_given:" + String(item_id))


## Calcula o multiplicador de desconto/bônus comercial oferecido pela afinidade pessoal do NPC
func get_shop_affinity_modifier(npc_id: StringName) -> float:
	var state = get_relationship_state(npc_id)
	match state.get_stance():
		RelationshipState.Stance.HATE:
			return 1.25 # +25% de custo (Hostil)
		RelationshipState.Stance.DISLIKE:
			return 1.10 # +10% de custo
		RelationshipState.Stance.NEUTRAL:
			return 1.00 # Sem alteração
		RelationshipState.Stance.LIKE:
			return 0.95 # 5% de desconto
		RelationshipState.Stance.FRIENDSHIP:
			return 0.90 # 10% de desconto
		RelationshipState.Stance.LOVE:
			return 0.85 # 15% de desconto
	return 1.00


func _emit_relationship_changed_event(npc_id: StringName, new_affinity: float, old_affinity: float, reason: String) -> void:
	if EventBus:
		var event_data = {
			"npc_id": npc_id,
			"new_affinity": new_affinity,
			"old_affinity": old_affinity,
			"reason": reason
		}
		if EventBus.has_signal("event_emitted"):
			EventBus.emit_signal("event_emitted", &"NPCRelationshipChanged", event_data)
		elif EventBus.has_method("emit_event"):
			EventBus.call("emit_event", &"NPCRelationshipChanged", event_data)


## Serializa todos os relacionamentos para Save
func serialize_all() -> Dictionary:
	var serialized_data = {}
	for id in _relationships.keys():
		var state: RelationshipState = _relationships[id]
		serialized_data[String(id)] = state.serialize()
	return serialized_data


## Carrega todos os relacionamentos do Save
func deserialize_all(data: Dictionary) -> void:
	_relationships.clear()
	for id_str in data.keys():
		var id_name = StringName(id_str)
		var state = RelationshipState.new(id_name)
		state.deserialize(data[id_str])
		_relationships[id_name] = state
