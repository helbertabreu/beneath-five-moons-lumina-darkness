## Define a configuração estática e inicial de oferta/demanda de um mercado ou vilarejo.
##
## Armazena estoques locais, demanda por item e parâmetros econômicos
## utilizados pelo PricingService para calcular preços flutuantes.
class_name MarketDefinition
extends Resource

## Identificador único do mercado (ex: &"market.port_astraea", &"market.initial_village")
@export var market_id: StringName = &"market.default"

## Nome visível do mercado
@export var display_name: String = "Mercado Local"

## Dicionário de Estoque Mínimo necessário por Item ID (StringName -> int)
## Exemplo: { &"item.material.iron_ingot": 10 }
@export var min_stock_requirements: Dictionary = {}

## Dicionário de Estoque Atual por Item ID (StringName -> int)
@export var current_stock: Dictionary = {}

## Dicionário de Demanda Atual por Item ID (StringName -> int)
@export var current_demand: Dictionary = {}

## Taxa de imposto comercial praticada pelo mercado (0.0 a 0.25 = 0% a 25%)
@export_range(0.0, 0.25) var tax_rate: float = 0.0


## Retorna o estoque atual para um item específico. Retorna min_stock se não definido.
func get_stock(item_id: StringName) -> int:
	return current_stock.get(item_id, get_min_stock(item_id))


## Retorna a demanda atual para um item específico. Retorna min_stock se não definido.
func get_demand(item_id: StringName) -> int:
	return current_demand.get(item_id, get_min_stock(item_id))


## Retorna o estoque mínimo exigido para um item específico. Retorna 1 se não definido para evitar divisão por zero.
func get_min_stock(item_id: StringName) -> int:
	var min_s: int = min_stock_requirements.get(item_id, 10)
	return max(1, min_s)
