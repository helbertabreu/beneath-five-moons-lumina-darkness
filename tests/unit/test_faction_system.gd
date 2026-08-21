## Script de teste unitário para validação do FactionService e Reputação Multidimensional (TASK-203).

extends Node

var _faction_service: FactionService


func _ready() -> void:
	print("[FactionTest] Iniciando Testes Unitários do FactionService...")
	
	_setup_test_environment()
	_test_reputation_bounds_and_stances()
	_test_cross_faction_rivalry()
	_test_save_load_state()
	
	print("[FactionTest] [TEST PASSED] Todos os testes do FactionService passaram com 100% de sucesso!")


func _setup_test_environment() -> void:
	_faction_service = FactionService.new()
	ServiceRegistry.register_service(&"FactionService", _faction_service)
	
	# Cria Facção 1: Guardiões do Alinhamento
	var guardiões := FactionDefinition.new()
	guardiões.faction_id = &"faction.alignment_guardians"
	guardiões.display_name = "Os Guardiões do Alinhamento"
	guardiões.default_reputation = 0.0
	guardiões.rival_factions = { &"faction.umbra_syndicate": 0.5 } # Ganhar rep com Guardiões reduz 50% no Sindicato
	_faction_service.register_faction_definition(guardiões)
	
	# Cria Facção 2: Sindicato de Umbra
	var sindicato := FactionDefinition.new()
	sindicato.faction_id = &"faction.umbra_syndicate"
	sindicato.display_name = "O Sindicato de Umbra"
	sindicato.default_reputation = 2000.0
	sindicato.rival_factions = { &"faction.alignment_guardians": 1.0 }
	_faction_service.register_faction_definition(sindicato)


func _test_reputation_bounds_and_stances() -> void:
	print("[FactionTest] Testando limites de reputação e níveis de Stance...")
	
	var faction_id: StringName = &"faction.alignment_guardians"
	
	assert(_faction_service.get_reputation(faction_id) == 0.0, "Reputação inicial deve ser 0.0")
	assert(_faction_service.get_stance(faction_id) == FactionDefinition.Stance.HATED, "0 rep deve ser HATED")
	
	_faction_service.modify_reputation(faction_id, 1500.0, false)
	assert(_faction_service.get_reputation(faction_id) == 1500.0, "Reputação deve ser 1500.0")
	assert(_faction_service.get_stance(faction_id) == FactionDefinition.Stance.NEUTRAL, "1500 rep deve ser NEUTRAL")
	
	_faction_service.modify_reputation(faction_id, 8000.0, false) # Total 9500
	assert(_faction_service.get_reputation(faction_id) == 9500.0, "Reputação deve ser 9500.0")
	assert(_faction_service.get_stance(faction_id) == FactionDefinition.Stance.ALLIED, "9500 rep deve ser ALLIED")
	
	# Teste de Clamp Máximo
	_faction_service.modify_reputation(faction_id, 5000.0, false)
	assert(_faction_service.get_reputation(faction_id) == 10000.0, "Reputação não pode exceder 10000.0")
	
	print("[FactionTest] [OK] Limites e posturas validados.")


func _test_cross_faction_rivalry() -> void:
	print("[FactionTest] Testando cálculo de rivalidades cruzadas...")
	
	# Reset do Sindicato de Umbra para 2000.0 rep
	var sindicato_id: StringName = &"faction.umbra_syndicate"
	var guardiões_id: StringName = &"faction.alignment_guardians"
	
	_faction_service.modify_reputation(guardiões_id, -10000.0, false) # Trava Guardiões em 0.0
	assert(_faction_service.get_reputation(guardiões_id) == 0.0, "Guardiões resetado para 0.0")
	
	# Ganhar +1000 rep com Guardiões deve penalizar Sindicato em -(1000 * 0.5) = -500.0
	var rep_sindicato_antes: float = _faction_service.get_reputation(sindicato_id)
	_faction_service.modify_reputation(guardiões_id, 1000.0, true)
	
	var rep_sindicato_depois: float = _faction_service.get_reputation(sindicato_id)
	assert(rep_sindicato_depois == (rep_sindicato_antes - 500.0), "Ganho de rep com Guardiões deve reduzir 500 rep do Sindicato")
	
	print("[FactionTest] [OK] Rivalidades cruzadas validadas.")


func _test_save_load_state() -> void:
	print("[FactionTest] Testando salvamento e carregamento de estado...")
	
	var original_state: Dictionary = _faction_service.get_save_state()
	
	var mock_save: Dictionary = {
		"faction.alignment_guardians": 7500.0,
		"faction.umbra_syndicate": 1200.0
	}
	
	_faction_service.load_save_state(mock_save)
	
	assert(_faction_service.get_reputation(&"faction.alignment_guardians") == 7500.0, "Reputação carregada dos Guardiões deve ser 7500.0")
	assert(_faction_service.get_reputation(&"faction.umbra_syndicate") == 1200.0, "Reputação carregada do Sindicato deve ser 1200.0")
	assert(_faction_service.get_stance(&"faction.alignment_guardians") == FactionDefinition.Stance.RESPECTED, "7500.0 rep deve ser RESPECTED")
	
	print("[FactionTest] [OK] Persistência validada.")
