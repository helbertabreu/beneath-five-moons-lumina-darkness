## Script de teste unitário para validação do WorldRegionManager e Simulação Offline (TASK-204).

extends Node

var _region_manager: WorldRegionManager


func _ready() -> void:
	print("[StreamingTest] Iniciando Testes Unitários do WorldRegionManager...")
	
	_setup_test_environment()
	_test_region_load_and_unload()
	_test_offline_simulation()
	_test_save_and_load_state()
	
	print("[StreamingTest] [TEST PASSED] Todos os testes do WorldRegionManager passaram com 100% de sucesso!")


func _setup_test_environment() -> void:
	_region_manager = WorldRegionManager.new()
	ServiceRegistry.register_service(&"WorldRegionManager", _region_manager)
	
	# Cria Região 1: Porto de Astraea
	var astraea := RegionDefinition.new()
	astraea.region_id = &"region.port_astraea"
	astraea.display_name = "Porto de Astraea"
	astraea.danger_level = 0
	astraea.offline_regeneration_rate = 1.0
	_region_manager.register_region_definition(astraea)
	
	# Cria Região 2: Setor Escuro
	var dark_sector := RegionDefinition.new()
	dark_sector.region_id = &"region.dark_sector"
	dark_sector.display_name = "Setor Escuro"
	dark_sector.danger_level = 3
	dark_sector.offline_regeneration_rate = 0.5
	_region_manager.register_region_definition(dark_sector)


func _test_region_load_and_unload() -> void:
	print("[StreamingTest] Testando carregamento e descarregamento de regiões...")
	
	assert(_region_manager.active_region_id == &"", "Inicialmente nenhuma região deve estar ativa")
	
	var load_success: bool = _region_manager.load_region(&"region.port_astraea", 10)
	assert(load_success, "Deve carregar Porto de Astraea com sucesso")
	assert(_region_manager.active_region_id == &"region.port_astraea", "Região ativa deve ser Porto de Astraea")
	
	# Transição para o Setor Escuro no minuto 50
	var transition_success: bool = _region_manager.load_region(&"region.dark_sector", 50)
	assert(transition_success, "Deve transitar para o Setor Escuro com sucesso")
	assert(_region_manager.active_region_id == &"region.dark_sector", "Região ativa deve ser Setor Escuro")
	
	print("[StreamingTest] [OK] Carregamento e descarregamento validados.")


func _test_offline_simulation() -> void:
	print("[StreamingTest] Testando simulação offline de região descarregada...")
	
	# Simula degradação inicial no Porto de Astraea descarregado no minuto 50
	var state = { "resource_depletion_level": 5.0 }
	_region_manager._region_states[&"region.port_astraea"] = state
	
	# Retorna ao Porto de Astraea no minuto 150 (100 minutos depois)
	_region_manager.load_region(&"region.port_astraea", 150)
	
	var updated_state: Dictionary = _region_manager._region_states[&"region.port_astraea"]
	var depletion: float = float(updated_state.get("resource_depletion_level", 0.0))
	
	# Recuperação esperada = 100 min * 0.01 * 1.0 = 1.0. Nível final deve ser 5.0 - 1.0 = 4.0
	assert(is_equal_approx(depletion, 4.0), "Nível de depleção após simulação offline deve ser 4.0")
	
	print("[StreamingTest] [OK] Simulação offline validada com sucesso.")


func _test_save_and_load_state() -> void:
	print("[StreamingTest] Testando persistência e serialização de estado do mundo...")
	
	var save_data: Dictionary = _region_manager.get_save_state()
	
	var mock_manager := WorldRegionManager.new()
	mock_manager.register_region_definition(_region_manager._region_definitions[&"region.port_astraea"])
	mock_manager.load_save_state(save_data)
	
	assert(mock_manager.active_region_id == &"region.port_astraea", "Região ativa carregada deve ser Porto de Astraea")
	assert(mock_manager._region_states.has(&"region.port_astraea"), "Estado da região deve ter sido restaurado")
	
	print("[StreamingTest] [OK] Persistência do estado do mundo validada.")
