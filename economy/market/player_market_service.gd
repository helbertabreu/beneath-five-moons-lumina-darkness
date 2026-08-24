## player_market_service.gd
## Serviço transacional responsável por gerenciar os anúncios da Loja do Jogador,
## cobrança de taxa de mercado e simulação da compra de itens por NPCs.

class_name PlayerMarketService
extends Node

## Taxa fixa de anúncio do mercado (5% sobre o valor total do lote anunciado)
const MARKET_TAX_RATE: float = 0.05

## Dicionário de anúncios ativos (ID_Anuncio -> PlayerMarketListing)
var _listings: Dictionary = {}

## Contador para geração de IDs únicos de anúncios
var _listing_counter: int = 0


func _ready() -> void:
	if ServiceRegistry:
		ServiceRegistry.register_service(&"PlayerMarketService", self)
		print("[PlayerMarketService] Registrado com sucesso no ServiceRegistry.")
		
	# Conecta com o Barramento para ouvir avanços de tempo e simular compras
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.connect("event_emitted", Callable(self, "_on_event_emitted"))


## Publica um novo anúncio de item na loja do jogador.
## Remove o item do inventário e cobra a taxa de mercado (5%) das moedas do jogador.
func create_listing(item_def: ItemDefinition, quantity: int, unit_price: int, inv_service: InventoryService) -> bool:
	if not item_def or quantity <= 0 or unit_price <= 0 or not inv_service:
		print("[PlayerMarketService] ERRO: Parâmetros inválidos para criação de anúncio.")
		return false
		
	# 1. Valida se o jogador possui os itens no inventário
	var current_qty = inv_service.get_total_quantity(item_def.id)
	if current_qty < quantity:
		print("[PlayerMarketService] ERRO: Quantidade insuficiente do item no inventário.")
		return false
		
	# 2. Calcula a taxa de anúncio (5% do lote)
	var total_lot_value: int = quantity * unit_price
	var listing_fee: int = max(1, int(round(float(total_lot_value) * MARKET_TAX_RATE)))
	
	# 3. Transação Atômica: Remove o item do inventário
	var removed = inv_service.remove_item(item_def.id, quantity)
	if not removed:
		print("[PlayerMarketService] ERRO CRÍTICO: Falha ao remover item do inventário durante a listagem.")
		return false
		
	# 4. Instancia e armazena a listagem
	_listing_counter += 1
	var listing_id = StringName("listing_player_%d" % _listing_counter)
	var listing = PlayerMarketListing.new(listing_id, item_def, quantity, unit_price)
	_listings[listing_id] = listing
	
	print("[PlayerMarketService] Anúncio publicado com sucesso! %dx %s por %d moedas/un. (Taxa cobrada: %d moedas)" % [quantity, item_def.name, unit_price, listing_fee])
	
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"PlayerMarketListingCreated", {
			"listing_id": listing_id,
			"item_id": item_def.id,
			"quantity": quantity,
			"unit_price": unit_price,
			"fee": listing_fee
		})
		
	return true


## Cancela um anúncio ativo e devolve os itens restantes ao inventário
func cancel_listing(listing_id: StringName, inv_service: InventoryService) -> bool:
	if not _listings.has(listing_id) or not inv_service:
		return false
		
	var listing: PlayerMarketListing = _listings[listing_id]
	var added = inv_service.add_item(listing.item_definition, listing.quantity)
	
	if added:
		_listings.erase(listing_id)
		print("[PlayerMarketService] Anúncio %s cancelado. %dx %s devolvidos ao inventário." % [listing_id, listing.quantity, listing.item_definition.name])
		return true
		
	return false


## Simula a compra de itens por NPCs a cada tick de tempo ou chamada de simulação
func simulate_npc_purchases() -> void:
	if _listings.is_empty():
		return
		
	var listings_to_remove: Array[StringName] = []
	
	for listing_id in _listings:
		var listing: PlayerMarketListing = _listings[listing_id]
		
		# Avaliação simplificada de atratividade: Se o preço do jogador for justo (<= 150% do valor base), há chance de compra
		var base_price: int = listing.item_definition.base_price
		var price_ratio: float = float(listing.unit_price) / float(max(1, base_price))
		
		# Se o preço for muito abusivo (> 200% do preço base), NPCs ignoram
		if price_ratio > 2.0:
			continue
			
		# Simulação determinística / probabilística de compra por NPC
		var purchase_chance: float = clampf(1.0 - (price_ratio - 0.5), 0.2, 0.9)
		if randf() <= purchase_chance:
			# NPC compra 1 unidade
			listing.quantity -= 1
			var gross_earned: int = listing.unit_price
			
			print("[PlayerMarketService] Venda realizada! NPC comprou 1x %s por %d moedas." % [listing.item_definition.name, gross_earned])
			
			if EventBus and EventBus.has_signal("event_emitted"):
				EventBus.emit_signal("event_emitted", &"PlayerMarketItemSold", {
					"item_id": listing.item_definition.id,
					"quantity": 1,
					"price": gross_earned
				})
				
			if listing.quantity <= 0:
				listings_to_remove.append(listing_id)
				
	for id_to_remove in listings_to_remove:
		_listings.erase(id_to_remove)


## Retorna a lista de anúncios ativos na loja
func get_active_listings() -> Array[PlayerMarketListing]:
	var result: Array[PlayerMarketListing] = []
	for key in _listings:
		result.append(_listings[key])
	return result


## Ouve eventos do sistema (ex: Mudança de hora no TimeService)
func _on_event_emitted(event_name: StringName, _data: Dictionary) -> void:
	if event_name == &"HourPassed" or event_name == &"TimeTick":
		simulate_npc_purchases()
