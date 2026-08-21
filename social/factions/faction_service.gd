## Serviço de Gerenciamento de Reputação Multidimensional e Facções.
##
## Mantém o estado runtime de reputação do jogador com facções, vilarejos e religiões,
## processando reações cruzadas (rivalidades), limites (0-10.000) e eventos.

class_name FactionService
extends RefCounted

## Limites estritos de pontuação do BALANCE.md
const MIN_REPUTATION: float = 0.0
const MAX_REPUTATION: float = 10000.0

## Dicionário de definições registradas (StringName -> FactionDefinition)
var _definitions: Dictionary = {}

## Dicionário de estado de reputação do jogador (StringName -> float)
var _player_reputation: Dictionary = {}


## Registra uma definição de facção no serviço.
func register_faction_definition(definition: FactionDefinition) -> void:
	if definition == null or definition.faction_id == &"":
		push_error("FactionService: Tentativa de registrar FactionDefinition inválida.")
		return
	
	_definitions[definition.faction_id] = definition
	if not _player_reputation.has(definition.faction_id):
		_player_reputation[definition.faction_id] = definition.default_reputation


## Modifica os pontos de reputação com uma facção e processa efeitos em facções rivais.
func modify_reputation(faction_id: StringName, amount: float, apply_rivalries: bool = true) -> void:
	if not _definitions.has(faction_id):
		push_warning("FactionService: Facção '%s' não registrada. Ação ignorada." % faction_id)
		return
	
	var current_rep: float = get_reputation(faction_id)
	var old_stance: FactionDefinition.Stance = FactionDefinition.get_stance_from_reputation(current_rep)
	
	var new_rep: float = clampf(current_rep + amount, MIN_REPUTATION, MAX_REPUTATION)
	_player_reputation[faction_id] = new_rep
	
	var new_stance: FactionDefinition.Stance = FactionDefinition.get_stance_from_reputation(new_rep)
	
	# Emite evento de mudança de reputação via EventBus (se disponível)
	if EventBus and EventBus.has_signal("reputation_changed"):
		EventBus.emit_signal("reputation_changed", faction_id, new_rep, amount)
	
	# Emite evento caso a postura (Stance) tenha mudado de nível
	if old_stance != new_stance:
		if EventBus and EventBus.has_signal("faction_stance_changed"):
			EventBus.emit_signal("faction_stance_changed", faction_id, old_stance, new_stance)
		print("[FactionService] Postura com '%s' alterada: %s -> %s" % [faction_id, old_stance, new_stance])
	
	# Processa rivalidades cruzadas se o ganho for positivo
	if apply_rivalries and amount > 0.0:
		var def: FactionDefinition = _definitions[faction_id]
		for rival_id in def.rival_factions.keys():
			var multiplier: float = def.rival_factions[rival_id]
			var penalty: float = -(amount * multiplier)
			modify_reputation(rival_id, penalty, false)


## Retorna os pontos de reputação atuais para uma facção específica.
func get_reputation(faction_id: StringName) -> float:
	return _player_reputation.get(faction_id, 0.0)


## Retorna o nível de postura (Stance) atual com uma facção.
func get_stance(faction_id: StringName) -> FactionDefinition.Stance:
	var rep: float = get_reputation(faction_id)
	return FactionDefinition.get_stance_from_reputation(rep)


## Retorna um dicionário exportável contendo todo o estado de reputação para Save/Load.
func get_save_state() -> Dictionary:
	return _player_reputation.duplicate()


## Restaura o estado de reputação a partir de dados de Save.
func load_save_state(state_data: Dictionary) -> void:
	for faction_id in state_data.keys():
		_player_reputation[StringName(faction_id)] = clampf(float(state_data[faction_id]), MIN_REPUTATION, MAX_REPUTATION)
