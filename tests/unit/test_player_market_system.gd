## test_player_market_system.gd
## Suíte de testes unitários para validação das regras de negócio do PlayerMarketService (TASK-304).

class_name TestPlayerMarketSystem
extends RefCounted


func run_market_tests() -> bool:
	print("\n=== INICIANDO TESTE DO SISTEMA DE MERCADO E LOJA DO JOGADOR (TASK-304) ===")
	
	# 1. Configura os serviços de suporte
	var inv_service = InventoryService.new()
	inv_service._initialize_inventory()
	
	var market_service = PlayerMarketService.new()
	
	# 2. Cria Item de Teste (Lingote de Ferro)
	var iron_ingot = ItemDefinition.new()
	iron_ingot.id = &"item.material.iron_ingot"
	iron_ingot.name = "Lingote de Ferro"
	iron_ingot.base_price = 70
	iron_ingot.is_stackable = true
	iron_ingot.max_stack_size = 99
	
	# Adiciona 5 Lingotes ao inventário do jogador
	inv_service.add_item(iron_ingot, 5)
	
	# 3. Teste A: Tentar publicar mais itens do que o possuído (Deve Falhar)
	var fail_listing = market_service.create_listing(iron_ingot, 10, 70, inv_service)
	if fail_listing:
		push_error("[TEST FAIL] Anúncio criado com quantidade superior ao inventário!")
		return false
	print("[TEST PASSED] Validação de quantidade insuficiente no inventário funcionou.")
	
	# 4. Teste B: Publicar 3x Lingotes de Ferro por 80 moedas cada (Deve Suceder)
	var success_listing = market_service.create_listing(iron_ingot, 3, 80, inv_service)
	if not success_listing:
		push_error("[TEST FAIL] Falha ao criar anúncio válido no mercado.")
		return false
		
	if inv_service.get_total_quantity(iron_ingot.id) != 2:
		push_error("[TEST FAIL] O inventário não deduziu os 3 itens publicados corretamente!")
		return false
	print("[TEST PASSED] Anúncio publicado e 3 itens deduzidos do inventário com sucesso.")
	
	# 5. Teste C: Verificar se o anúncio está ativo
	var listings = market_service.get_active_listings()
	if listings.size() != 1 or listings[0].quantity != 3:
		push_error("[TEST FAIL] Lista de anúncios ativos inconsistente!")
		return false
	print("[TEST PASSED] Anúncio ativo registrado corretamente no PlayerMarketService.")
	
	# 6. Teste D: Simular compra por NPCs
	market_service.simulate_npc_purchases()
	print("[TEST PASSED] Ciclo de simulação de compras de NPCs executado com sucesso.")
	
	print("=== TODOS OS TESTES DA LOJA DO JOGADOR (TASK-304) PASSARAM COM SUCESSO! ===\n")
	return true
