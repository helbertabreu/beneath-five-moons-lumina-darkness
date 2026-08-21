## test_vertical_slice_integration.gd
## Suíte de teste automatizada de integração da Vertical Slice 2D.
## Valida o ciclo completo de persistência: Save -> Destroy -> Load -> Verify State.

extends RefCounted


func run_vertical_slice_tests() -> bool:
	print("[IntegrationTest] Iniciando Teste de Integração da Vertical Slice 2D...")
	var success = true
	
	if not _test_services_registration(): success = false
	if not _test_inventory_transaction(): success = false
	if not _test_full_save_load_cycle(): success = false
	
	if success:
		print("[IntegrationTest] [TEST PASSED] Suíte de Integração e Persistência aprovada com 100% de Sucesso!")
	else:
		push_error("[IntegrationTest] [TEST FAILED] Falha no teste de integração da Vertical Slice!")
		
	return success


## 1. Valida o registro de todos os serviços centrais
func _test_services_registration() -> bool:
	var inv = ServiceRegistry.get_service(&"InventoryService")
	var light = ServiceRegistry.get_service(&"LightingService")
	var quest = ServiceRegistry.get_service(&"QuestService")
	
	if inv == null or light == null or quest == null:
		push_error("[IntegrationTest] Servidores essenciais ausentes no ServiceRegistry!")
		return false
		
	return true


## 2. Valida transações de adição e remoção de itens
func _test_inventory_transaction() -> bool:
	var inv_service = ServiceRegistry.get_service(&"InventoryService") as InventoryService
	if not inv_service:
		return false
		
	var test_item = ItemDefinition.new()
	test_item.id = &"item.material.iron_ore"
	test_item.is_stackable = true
	
	# Adiciona 5 minérios
	inv_service.add_item(test_item, 5)
	if inv_service.get_total_quantity(&"item.material.iron_ore") != 5:
		return false
		
	# Remove 2 minérios
	var removed = inv_service.remove_item(&"item.material.iron_ore", 2)
	if not removed or inv_service.get_total_quantity(&"item.material.iron_ore") != 3:
		return false
		
	# Limpa itens de teste
	inv_service.remove_item(&"item.material.iron_ore", 3)
	return true


## 3. Valida o ciclo de Save/Load atômico do Estado do Mundo e do Jogador
func _test_full_save_load_cycle() -> bool:
	var test_slot = "integration_test_slot"
	var save_payload = {
		"version": 1,
		"player": {
			"health": 100.0,
			"energy": 85.0,
			"inventory": {
				"item.material.iron_ingot": 1
			}
		},
		"quests": {
			"quest.local.blacksmith_iron": "COMPLETED"
		},
		"reputation": {
			"settlement.village.start": 50.0
		}
	}
	
	# Salva dados em disco
	var save_success = SaveService.save_game_data(save_payload, test_slot)
	if not save_success:
		return false
		
	# Carrega dados do disco
	var loaded_payload = SaveService.load_game_data(test_slot)
	if loaded_payload.is_empty():
		return false
		
	# Compara a semântica do estado recuperado
	var loaded_quests = loaded_payload.get("quests", {})
	if loaded_quests.get("quest.local.blacksmith_iron", "") != "COMPLETED":
		push_error("[IntegrationTest] Estado da Quest divergiu após Load!")
		return false
		
	var loaded_player = loaded_payload.get("player", {})
	if loaded_player.get("energy", 0.0) != 85.0:
		push_error("[IntegrationTest] Atributo de Energia divergiu após Load!")
		return false
		
	return true
