## player_market_listing.gd
## Objeto de dados que representa um único anúncio de item na Loja do Jogador.

class_name PlayerMarketListing
extends RefCounted

## ID único da listagem
var listing_id: StringName = &""

## Definição do item anunciado
var item_definition: ItemDefinition = null

## Quantidade colocada à venda
var quantity: int = 1

## Preço unitário estipulado pelo jogador (em moedas)
var unit_price: int = 0

## ID do vendedor (por padrão a entidade do jogador)
var seller_id: StringName = &"ent.player.001"

## Timestamp de criação da listagem (Unix Time)
var created_at: int = 0


func _init(p_id: StringName = &"", p_item: ItemDefinition = null, p_quantity: int = 1, p_price: int = 0) -> void:
	listing_id = p_id
	item_definition = p_item
	quantity = p_quantity
	unit_price = p_price
	created_at = Time.get_unix_time_from_system()


## Calcula o valor total bruto da venda do lote
func get_total_price() -> int:
	return quantity * unit_price
