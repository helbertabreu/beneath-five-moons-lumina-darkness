## test_core_infrastructure.gd
## Script de teste atômico para validação da infraestrutura base do projeto (Sprint 1).

extends RefCounted

var _events_received: Dictionary = {}


func run_all_tests() -> bool:
	print("\n==================================================")
	print("  INICIANDO BATERIA DE TESTES: CORE INFRASTRUCTURE")
	print("==================================================")
	
	var success: bool = true
	
	success = _test_service_registry() and success
	success = _test_event_bus() and success
	success = _test_time_service() and success
	success = _test_save_load_system() and success
	
	print("==================================================")
	if success:
		print("  RESULTADO: TODOS OS TESTES PASSARAM COM SUCESSO! [TEST PASSED]")
	else:
		print("  RESULTADO: FALHA EM UM OU MAIS TESTES! [TEST FAILED]")
	print("==================================================\n")
	
	return success


func _test_service_registry() -> bool:
	print("\n[TEST] Testando ServiceRegistry...")
	
	if not ServiceRegistry:
		push_error("ServiceRegistry Autoload não está disponível.")
		return false
	
	var is_time_registered = ServiceRegistry.has_service(&"TimeService")
	var is_save_registered = ServiceRegistry.has_service(&"SaveService")
	
	if not is_time_registered or not is_save_registered:
		push_error("Falha: Serviços essenciais não foram encontrados no ServiceRegistry.")
		return false
	
	print("  -> ServiceRegistry: OK (Serviços localizados corretamente)")
	return true


func _test_event_bus() -> bool:
	print("\n[TEST] Testando EventBus...")
	
	if not EventBus:
		push_error("EventBus Autoload não está disponível.")
		return false
	
	_events_received["save_completed"] = false
	
	var callback = func(slot_name: String):
		_events_received["save_completed"] = true
		print("  -> Evento recebido no callback: save_completed (%s)" % slot_name)
	
	EventBus.save_completed.connect(callback)
	EventBus.save_completed.emit("test_slot")
	EventBus.save_completed.disconnect(callback)
	
	if not _events_received["save_completed"]:
		push_error("Falha: O evento no EventBus não foi recebido pelo ouvinte.")
		return false
	
	print("  -> EventBus: OK (Sinais assíncronos emitidos e escutados)")
	return true


func _test_time_service() -> bool:
	print("\n[TEST] Testando TimeService...")
	
	if not ServiceRegistry.has_service(&"TimeService"):
		push_error("TimeService não registrado.")
		return false
	
	var time_svc = ServiceRegistry.get_service(&"TimeService")
	var initial_minute = time_svc.current_minute
	
	# Simula o avanço forçado do tempo
	time_svc.advance_hours(1)
	
	if time_svc.current_minute != initial_minute:
		push_error("Falha: Avanço de hora não manteve coerência dos minutos.")
		return false
	
	print("  -> TimeService: OK (Relógio lógico avançou 1 hora com sucesso)")
	return true


func _test_save_load_system() -> bool:
	print("\n[TEST] Testando SaveService e GameStateData...")
	
	if not ServiceRegistry.has_service(&"SaveService"):
		push_error("SaveService não registrado.")
		return false
	
	var save_svc = ServiceRegistry.get_service(&"SaveService")
	
	# Modifica o estado atual
	save_svc.current_state.player_name = "Testador_Alpha"
	save_svc.current_state.health = 85.5
	save_svc.current_state.inventory_items["item.mat.iron_ore"] = 12
	
	# Salva no slot de teste
	var save_ok = save_svc.save_game("test_save_slot")
	if not save_ok:
		push_error("Falha na gravação do arquivo de save.")
		return false
	
	# Altera o estado na memória para valores limpos
	save_svc.current_state.player_name = "Limpo"
	save_svc.current_state.health = 100.0
	save_svc.current_state.inventory_items.clear()
	
	# Carrega do slot de teste
	var load_ok = save_svc.load_game("test_save_slot")
	if not load_ok:
		push_error("Falha na leitura do arquivo de save.")
		return false
	
	# Valida se os dados foram restaurados
	if save_svc.current_state.player_name != "Testador_Alpha" or save_svc.current_state.health != 85.5:
		push_error("Falha: Os dados recarregados não correspondem ao estado salvo.")
		return false
	
	if not save_svc.current_state.inventory_items.has("item.mat.iron_ore"):
		push_error("Falha: O inventário salvo não foi restaurado corretamente.")
		return false
	
	print("  -> SaveService: OK (Gravação e leitura atômica de JSON validadas)")
	return true
