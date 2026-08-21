## Script de teste unitário para validação da Engine de Preços e Economia Dinâmica (TASK-202).
##
## Executa testes isolados da fórmula de preço, limites de segurança (clamps) e
## multiplicadores de reputação do BALANCE.md.

extends Node

var _pricing_service: PricingService
var _test_market: MarketDefinition


func _ready() -> void:
	print("[PricingTest] Iniciando Testes Unitários do PricingService...")
	
	_setup_test_environment()
	_test_reputation_discounts()
	_test_supply_and_demand_formula()
	_test_safety_clamps()
	_test_buy_and_sell_prices()
	
	print("[PricingTest] [TEST PASSED] Todos os testes do PricingService passaram com 100% de sucesso!")


func _setup_test_environment() -> void:
	_pricing_service = PricingService.new()
	ServiceRegistry.register_service(&"PricingService", _pricing_service)
	
	_test_market = MarketDefinition.new()
	_test_market.market_id = &"market.test_village"
	_test_market.min_stock_requirements = { &"item.material.iron_ingot": 10 }
	_test_market.current_stock = { &"item.material.iron_ingot": 10 }
	_test_market.current_demand = { &"item.material.iron_ingot": 10 }
	_test_market.tax_rate = 0.0


func _test_reputation_discounts() -> void:
	print("[PricingTest] Testando descontos de reputação...")
	
	assert(_pricing_service.get_reputation_multiplier(0.0) == 1.00, "Reputação 0 deve ter 0% de desconto")
	assert(_pricing_service.get_reputation_multiplier(1500.0) == 0.95, "Reputação 1500 deve ter 5% de desconto (0.95)")
	assert(_pricing_service.get_reputation_multiplier(4000.0) == 0.90, "Reputação 4000 deve ter 10% de desconto (0.90)")
	assert(_pricing_service.get_reputation_multiplier(7000.0) == 0.85, "Reputação 7000 deve ter 15% de desconto (0.85)")
	assert(_pricing_service.get_reputation_multiplier(9500.0) == 0.80, "Reputação 9500 deve ter 20% de desconto (0.80)")
	
	print("[PricingTest] [OK] Descontos de reputação validados.")


func _test_supply_and_demand_formula() -> void:
	print("[PricingTest] Testando fórmula de oferta e demanda...")
	
	# Estoque = Demanda (10) -> Fator (0) -> Multiplicador = 1.0
	var mult_balanced: float = _pricing_service.calculate_supply_demand_multiplier(_test_market, &"item.material.iron_ingot")
	assert(is_equal_approx(mult_balanced, 1.0), "Estoque equilibrado deve resultar em multiplicador 1.0")
	
	# Alta escassez: Estoque = 0, Demanda = 20, MinStock = 10 -> Factor = (20-0)/10 = 2.0 -> Mult = 3.0
	_test_market.current_stock[&"item.material.iron_ingot"] = 0
	_test_market.current_demand[&"item.material.iron_ingot"] = 20
	var mult_scarce: float = _pricing_service.calculate_supply_demand_multiplier(_test_market, &"item.material.iron_ingot")
	assert(is_equal_approx(mult_scarce, 3.0), "Alta escassez deve triplicar o preço base (multiplicador 3.0)")
	
	print("[PricingTest] [OK] Fórmula de oferta e demanda validada.")


func _test_safety_clamps() -> void:
	print("[PricingTest] Testando limites de segurança (Clamps 0.25x - 3.00x)...")
	
	# Excesso massivo de estoque: Estoque = 100, Demanda = 0, MinStock = 10 -> Factor = -10.0 -> Mult teórico = -9.0
	_test_market.current_stock[&"item.material.iron_ingot"] = 100
	_test_market.current_demand[&"item.material.iron_ingot"] = 0
	var mult_excess: float = _pricing_service.calculate_supply_demand_multiplier(_test_market, &"item.material.iron_ingot")
	
	assert(mult_excess >= PricingService.MIN_PRICE_MULTIPLIER, "Multiplicador não pode ser menor que 0.25")
	assert(is_equal_approx(mult_excess, 0.25), "Excesso massivo deve ser travado no piso de 0.25x")
	
	print("[PricingTest] [OK] Limites de segurança validados.")


func _test_buy_and_sell_prices() -> void:
	print("[PricingTest] Testando preços de compra e venda...")
	
	# Reset do mercado para estado neutro (1.0x) e Preço Base do Lingote de Ferro = 70 moedas
	_test_market.current_stock[&"item.material.iron_ingot"] = 10
	_test_market.current_demand[&"item.material.iron_ingot"] = 10
	
	var base_price: int = 70
	var buy_price_neutral: int = _pricing_service.calculate_buy_price(base_price, _test_market, &"item.material.iron_ingot", 0.0)
	assert(buy_price_neutral == 70, "Preço de compra neutro deve ser 70 moedas")
	
	# Com reputação máxima (9000 rep = 20% desconto -> 70 * 0.8 = 56)
	var buy_price_reputable: int = _pricing_service.calculate_buy_price(base_price, _test_market, &"item.material.iron_ingot", 9000.0)
	assert(buy_price_reputable == 56, "Preço de compra com reputação máxima deve ser 56 moedas")
	
	# Preço de Venda do jogador é 60% do valor de compra
	var sell_price: int = _pricing_service.calculate_sell_price(base_price, _test_market, &"item.material.iron_ingot", 0.0)
	assert(sell_price == 42, "Preço de venda deve ser 60%% de 70 = 42 moedas")
	
	print("[PricingTest] [OK] Preços de compra e venda validados.")
