## Gerenciador Central de World Streaming e Simulação Offline.
##
## Controla o descarregamento de regiões ativas, salva estados de território em memória,
## executa simulação abstrata temporal offline para regiões descarregadas e interage com SaveService.

class_name WorldRegionManager
extends RefCounted

## ID da região atualmente carregada e ativa na simulação visual
var active_region_id: StringName = &""

## Dicionário de definições de regiões registradas (StringName -> RegionDefinition)
var _region_definitions: Dictionary = {}

## Dicionário de estados persistidos por região (StringName -> Dictionary)
var _region_states: Dictionary = {}

## Dicionário de marcas de tempo do último descarregamento (StringName -> float/int em minutos)
var _last_unload_timestamps: Dictionary = {}


## Registra uma definição de região no gerenciador.
func register_region_definition(definition: RegionDefinition) -> void:
	if definition == null or definition.region_id == &"":
		push_error("WorldRegionManager: Tentativa de registrar RegionDefinition inválida.")
		return
	_region_definitions[definition.region_id] = definition


## Executa o descarregamento da região atual e processa o registro de simulação offline.
func unload_current_region(current_game_minute: int) -> bool:
	if active_region_id == &"":
		return false
		
	var unloaded_id: StringName = active_region_id
	_last_unload_timestamps[unloaded_id] = current_game_minute
	
	# Captura estado da região se não existir
	if not _region_states.has(unloaded_id):
		_region_states[unloaded_id] = { "resource_depletion_level": 0.0 }
		
	print("[WorldRegionManager] Região '%s' descarregada no minuto %d." % [unloaded_id, current_game_minute])
	active_region_id = &""
	
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"RegionUnloaded", { "region_id": unloaded_id })
		
	return true


## Carrega uma nova região e aplica a simulação abstrata offline acumulada durante o tempo fora.
func load_region(region_id: StringName, current_game_minute: int) -> bool:
	if not _region_definitions.has(region_id):
		push_error("WorldRegionManager: Região '%s' não possui definição registrada." % region_id)
		return false
		
	if active_region_id != &"":
		unload_current_region(current_game_minute)
		
	active_region_id = region_id
	
	# Executa simulação offline caso a região já tenha sido visitada anteriormente
	if _last_unload_timestamps.has(region_id):
		var minutes_offline: int = current_game_minute - int(_last_unload_timestamps[region_id])
		if minutes_offline > 0:
			_simulate_offline_progress(region_id, minutes_offline)
			
	print("[WorldRegionManager] Região '%s' carregada e ativa." % region_id)
	
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"RegionLoaded", { "region_id": region_id })
		
	return true


## Simula abstratamente o avanço de recursos e estado da região descarregada.
func _simulate_offline_progress(region_id: StringName, minutes_passed: int) -> void:
	var def: RegionDefinition = _region_definitions[region_id]
	var state: Dictionary = _region_states.get(region_id, { "resource_depletion_level": 0.0 })
	
	var current_depletion: float = float(state.get("resource_depletion_level", 0.0))
	var recovery_amount: float = (float(minutes_passed) * 0.01) * def.offline_regeneration_rate
	var new_depletion: float = maxf(0.0, current_depletion - recovery_amount)
	
	state["resource_depletion_level"] = new_depletion
	_region_states[region_id] = state
	
	print("[WorldRegionManager] Simulação Offline em '%s': %d minutos decorridos. Recuperação de recursos: %.2f" % [
		region_id, minutes_passed, recovery_amount
	])


## Retorna os dados serializáveis de todas as regiões para Save/Load.
func get_save_state() -> Dictionary:
	return {
		"active_region_id": String(active_region_id),
		"region_states": _region_states.duplicate(true),
		"last_unload_timestamps": _last_unload_timestamps.duplicate()
	}


## Restaura o estado de streaming a partir do payload de Save.
func load_save_state(data: Dictionary) -> void:
	active_region_id = StringName(data.get("active_region_id", ""))
	_region_states = data.get("region_states", {}).duplicate(true)
	_last_unload_timestamps = data.get("last_unload_timestamps", {}).duplicate()
