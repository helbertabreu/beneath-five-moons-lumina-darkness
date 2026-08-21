## Suíte de Teste Unitário e Integrado para Validação do Sistema de Comércio (TASK-301)
##
## Valida o cálculo dinâmico de preços (compra/venda), margens do BALANCE.md,
## descontos por reputação de facção e atomicidade de transações de inventário.

class_name TestShopSystem
extends RefCounted

func run_shop_tests() -> bool:
	print("\n--- INICIANDO SUÍTE DE TESTES: SISTEMA DE COMÉRCIO (TASK-301) ---")
	
	var pricing_ok = test_pricing_calculation()
	var reputation_discount_ok = test_reputation_discount()
	var buy_transaction_ok = test_buy_transaction()
	var sell_transaction_ok = test_sell_transaction()
	var insufficient_funds_ok = test_insufficient_funds()
	
	if pricing_ok and reputation_discount_ok and buy_transaction_ok and sell_transaction_ok and insufficient_funds_ok:
		print("[TEST PASSED] Sistema de Comércio e Precificação Inteiramente Validado!")
		return true
	else:
		push_error("[TEST FAILED] Falha na validação do Sistema de Comércio!")
		return false


func _create_mock_market() -> MarketDefinition:
	var market = MarketDefinition.new()
	market.market_id = &"territory.village.start"
	market.tax_rate = 0.05
	
	var item_id = &"item.material.iron_ingot"
	
	# Popula os dicionários internos do MarketDefinition respeitando o contrato real do Resource
	market.current_stock[item_id] = 10
	market.current_demand[item_id] = 10
	market.min_stock_requirements[item_id] = 5
	
	return market


func test_pricing_calculation() -> bool:
	var pricing_service = PricingService.new()
	var market = _create_mock_market()
	
	# Oferta e demanda equilibradas (Demanda=10, Estoque=10 -> Mult=1.0)
	# Preço Base = 70, Taxa = 5% -> 70 * 1.05 = 73.5 -> 74
	var buy_price = pricing_service.calculate_buy_price(70, market, &"item.material.iron_ingot", 0.0)
	if buy_price != 74:
		push_error("TestShopSystem: Preço de compra incorreto. Esperado: 74, Obtido: %d" % buy_price)
		return false
		
	# Preço de Venda = 74 * 0.60 = 44.4 -> 44
	var sell_price = pricing_service.calculate_sell_price(70, market, &"item.material.iron_ingot", 0.0)
	if sell_price != 44:
		push_error("TestShopSystem: Preço de venda incorreto. Esperado: 44, Obtido: %d" % sell_price)
		return false
		
	print("[TestShopSystem] -> Cálculo de Preços Base e Margem de Venda: OK")
	return true


func test_reputation_discount() -> bool:
	var pricing_service = PricingService.new()
	var market = _create_mock_market()
	
	# Reputação Respeitado (3000 pontos) -> Multiplicador 0.90 (10% de desconto)
	# Base 70 * 0.90 = 63 * 1.05 (taxa) = 66.15 -> 66
	var buy_price_respected = pricing_service.calculate_buy_price(70, market, &"item.material.iron_ingot", 3000.0)
	if buy_price_respected != 66:
		push_error("TestShopSystem: Desconto de reputação incorreto. Esperado: 66, Obtido: %d" % buy_price_respected)
		return false
		
	print("[TestShopSystem] -> Descontos por Reputação de Facção: OK")
	return true


func test_buy_transaction() -> bool:
	var inv_service = InventoryService.new()
	inv_service.max_slots = 10
	inv_service._initialize_inventory()
	
	var gold_def = ItemDefinition.new()
	gold_def.id = &"item.currency.gold"
	gold_def.name = "Moeda de Ouro"
	gold_def.is_stackable = true
	inv_service.add_item(gold_def, 200) # Adiciona 200 de ouro
	
	var shop = ShopInterface.new()
	shop._inventory_service = inv_service
	shop._pricing_service = PricingService.new()
	shop.market_definition = _create_mock_market()
	
	var iron_ingot = ItemDefinition.new()
	iron_ingot.id = &"item.material.iron_ingot"
	iron_ingot.name = "Lingote de Ferro"
	iron_ingot.base_price = 70
	iron_ingot.is_stackable = true
	
	var success = shop.execute_buy(iron_ingot, 74)
	
	if not success:
		push_error("TestShopSystem: Transação de compra falhou inesperadamente.")
		return false
		
	var remaining_gold = inv_service.get_total_quantity(&"item.currency.gold")
	var item_qty = inv_service.get_total_quantity(&"item.material.iron_ingot")
	
	if remaining_gold != 126 or item_qty != 1:
		push_error("TestShopSystem: Estado de inventário inválido após compra. Ouro: %d (esp: 126), Item: %d (esp: 1)" % [remaining_gold, item_qty])
		return false
		
	print("[TestShopSystem] -> Transação Atômica de Compra: OK")
	return true


func test_sell_transaction() -> bool:
	var inv_service = InventoryService.new()
	inv_service.max_slots = 10
	inv_service._initialize_inventory()
	
	var iron_ingot = ItemDefinition.new()
	iron_ingot.id = &"item.material.iron_ingot"
	iron_ingot.name = "Lingote de Ferro"
	iron_ingot.base_price = 70
	iron_ingot.is_stackable = true
	inv_service.add_item(iron_ingot, 1) # Adiciona 1 lingote
	
	var shop = ShopInterface.new()
	shop._inventory_service = inv_service
	shop._pricing_service = PricingService.new()
	shop.market_definition = _create_mock_market()
	
	var success = shop.execute_sell(iron_ingot, 44)
	if not success:
		push_error("TestShopSystem: Transação de venda falhou inesperadamente.")
		return false
		
	var gold_qty = inv_service.get_total_quantity(&"item.currency.gold")
	var item_qty = inv_service.get_total_quantity(&"item.material.iron_ingot")
	
	if gold_qty != 44 or item_qty != 0:
		push_error("TestShopSystem: Estado de inventário inválido após venda. Ouro: %d (esp: 44), Item: %d (esp: 0)" % [gold_qty, item_qty])
		return false
		
	print("[TestShopSystem] -> Transação Atômica de Venda: OK")
	return true


func test_insufficient_funds() -> bool:
	var inv_service = InventoryService.new()
	inv_service.max_slots = 10
	inv_service._initialize_inventory()
	
	var gold_def = ItemDefinition.new()
	gold_def.id = &"item.currency.gold"
	gold_def.name = "Moeda de Ouro"
	gold_def.is_stackable = true
	inv_service.add_item(gold_def, 10) # Apenas 10 de ouro
	
	var shop = ShopInterface.new()
	shop._inventory_service = inv_service
	shop._pricing_service = PricingService.new()
	
	var iron_ingot = ItemDefinition.new()
	iron_ingot.id = &"item.material.iron_ingot"
	iron_ingot.name = "Lingote de Ferro"
	
	var success = shop.execute_buy(iron_ingot, 74)
	if success:
		push_error("TestShopSystem: Compra realizada sem fundos suficientes!")
		return false
		
	print("[TestShopSystem] -> Bloqueio de Compra por Saldo Insuficiente: OK")
	return true
