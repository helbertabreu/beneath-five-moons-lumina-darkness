## Serviço centralizado de precificação e cálculo econômico dinâmico.
##
## Calcula preços de compra e venda considerando Preço Base, Reputação Local,
## Oferta/Demanda e Impostos, garantindo os limites de segurança (Clamps) do BALANCE.md.

class_name PricingService
extends RefCounted

## Limites globais de multiplicador de preço definidos na Tabela 6 do BALANCE.md
const MIN_PRICE_MULTIPLIER: float = 0.25
const MAX_PRICE_MULTIPLIER: float = 3.00

## Multiplicador para o preço de venda do jogador (jogadores vendem por 60% do valor de compra base)
const PLAYER_SELL_MARGIN: float = 0.60


## Calcula o preço final de COMPRA do jogador em um mercado.
##
## Formula: BasePrice * RepMultiplier * (1 + (Demand - Stock) / MinStock) * (1 + TaxRate)
func calculate_buy_price(base_price: int, market: MarketDefinition, item_id: StringName, reputation_points: float = 0.0) -> int:
	if base_price <= 0:
		return 0
	
	var rep_mult: float = get_reputation_multiplier(reputation_points)
	var supply_demand_mult: float = calculate_supply_demand_multiplier(market, item_id)
	
	# Aplica a fórmula do GDD / BALANCE.md
	var total_multiplier: float = rep_mult * supply_demand_mult
	
	# Aplica o limite de segurança (Clamp) do BALANCE.md
	total_multiplier = clampf(total_multiplier, MIN_PRICE_MULTIPLIER, MAX_PRICE_MULTIPLIER)
	
	var price_before_tax: float = float(base_price) * total_multiplier
	var tax_amount: float = price_before_tax * market.tax_rate
	
	var final_price: int = max(1, int(round(price_before_tax + tax_amount)))
	return final_price


## Calcula o preço final de VENDA do jogador em um mercado.
func calculate_sell_price(base_price: int, market: MarketDefinition, item_id: StringName, reputation_points: float = 0.0) -> int:
	var buy_price: int = calculate_buy_price(base_price, market, item_id, reputation_points)
	var sell_price: int = max(1, int(round(float(buy_price) * PLAYER_SELL_MARGIN)))
	return sell_price


## Calcula o multiplicador de Oferta/Demanda: (1 + (Demanda - Estoque) / Estoque Mínimo)
func calculate_supply_demand_multiplier(market: MarketDefinition, item_id: StringName) -> float:
	if market == null:
		return 1.0
		
	var stock: int = market.get_stock(item_id)
	var demand: int = market.get_demand(item_id)
	var min_stock: int = market.get_min_stock(item_id)
	
	var factor: float = float(demand - stock) / float(min_stock)
	var multiplier: float = 1.0 + factor
	
	return clampf(multiplier, MIN_PRICE_MULTIPLIER, MAX_PRICE_MULTIPLIER)


## Retorna o multiplicador de preço baseado na tabela de Reputação (0 a 10.000 pontos)
## 0-999: 1.00 (0% desc) | 1000-2999: 0.95 (5% desc) | 3000-5999: 0.90 (10% desc)
## 6000-8999: 0.85 (15% desc) | 9000-10000: 0.80 (20% desc)
func get_reputation_multiplier(reputation_points: float) -> float:
	var rep: float = clampf(reputation_points, 0.0, 10000.0)
	
	if rep >= 9000.0:
		return 0.80
	elif rep >= 6000.0:
		return 0.85
	elif rep >= 3000.0:
		return 0.90
	elif rep >= 1000.0:
		return 0.95
	else:
		return 1.00
