## interface comercial 2D responsável por conectar visualmente a compra e a venda de itens
## aos serviços centralizados PricingService, InventoryService e FactionService.
##
## A UI é reativa e desacoplada de lógica de negócios, consumindo apenas preços calculados
## e delegando as operações econômicas transacionais.

class_name ShopInterface
extends Control

signal shop_closed

@export var merchant_name: String = "Ferreiro Gorn"
@export var faction_id: StringName = &"faction.bronze_brotherhood"
@export var market_definition: MarketDefinition = null

var _pricing_service: PricingService = null
var _inventory_service: InventoryService = null
var _faction_service: FactionService = null

# Referências de Nodes de UI
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/Header/TitleLabel
@onready var gold_label: Label = $Panel/MarginContainer/VBoxContainer/Header/GoldLabel
@onready var items_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/ItemsContainer
@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/Header/CloseButton


func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)
	
	_initialize_services()
	refresh_shop_ui()


func _initialize_services() -> void:
	_pricing_service = PricingService.new()
	
	if ServiceRegistry:
		_inventory_service = ServiceRegistry.get_service(&"InventoryService") as InventoryService
		_faction_service = ServiceRegistry.get_service(&"FactionService") as FactionService


## Associa um mercado e nome de comerciante dinamicamente à interface
func setup_shop(p_merchant_name: String, p_faction_id: StringName, p_market: MarketDefinition) -> void:
	merchant_name = p_merchant_name
	faction_id = p_faction_id
	market_definition = p_market
	refresh_shop_ui()


## Atualiza os elementos visuais de preço, itens e saldo de moedas do jogador
func refresh_shop_ui() -> void:
	if title_label:
		title_label.text = "Loja — %s" % merchant_name
	
	var current_gold = 0
	if _inventory_service:
		current_gold = _inventory_service.get_total_quantity(&"item.currency.gold")
	
	if gold_label:
		gold_label.text = "Moedas: %d" % current_gold
		
	_populate_item_list()


func _populate_item_list() -> void:
	if not items_container:
		return
		
	# Limpa itens anteriores
	for child in items_container.get_children():
		child.queue_free()
		
	if not market_definition:
		return
		
	var rep_points: float = 0.0
	if _faction_service and faction_id != &"":
		rep_points = _faction_service.get_reputation(faction_id)
		
	# Lista os itens configurados no estoque atual do mercado
	for item_id in market_definition.current_stock.keys():
		var item_hbox = HBoxContainer.new()
		item_hbox.custom_minimum_size = Vector2(0, 32)
		
		# Nome do Item
		var name_label = Label.new()
		name_label.text = String(item_id)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		item_hbox.add_child(name_label)
		
		var base_price = 70 # Valor base padrão para calculo
		
		# Cálculo dos Preços de Compra e Venda
		var buy_price = _pricing_service.calculate_buy_price(base_price, market_definition, item_id, rep_points)
		var sell_price = _pricing_service.calculate_sell_price(base_price, market_definition, item_id, rep_points)
		
		# Cria definição sintética para transação
		var item_def = ItemDefinition.new()
		item_def.id = item_id
		item_def.name = String(item_id)
		item_def.base_price = base_price
		item_def.is_stackable = true
		
		# Botão de Compra
		var buy_btn = Button.new()
		buy_btn.text = "Comprar (%d Ouro)" % buy_price
		buy_btn.pressed.connect(func(): execute_buy(item_def, buy_price))
		item_hbox.add_child(buy_btn)
		
		# Botão de Venda
		var sell_btn = Button.new()
		sell_btn.text = "Vender (%d Ouro)" % sell_price
		sell_btn.pressed.connect(func(): execute_sell(item_def, sell_price))
		item_hbox.add_child(sell_btn)
		
		items_container.add_child(item_hbox)


## Realiza a compra transacional de um item pelo jogador
func execute_buy(item_def: ItemDefinition, buy_price: int) -> bool:
	if not _inventory_service or not item_def:
		return false
		
	var current_gold = _inventory_service.get_total_quantity(&"item.currency.gold")
	if current_gold < buy_price:
		print("[ShopInterface] Falha de Compra: Moedas insuficientes! Exigido: %d | Possui: %d" % [buy_price, current_gold])
		return false
		
	# Deduz as moedas e adiciona o item
	if _inventory_service.remove_item(&"item.currency.gold", buy_price):
		_inventory_service.add_item(item_def, 1)
		
		# Atualiza o estoque no mercado diretamente no dicionário
		if market_definition:
			var current_qty = market_definition.get_stock(item_def.id)
			market_definition.current_stock[item_def.id] = max(0, current_qty - 1)
			
		print("[ShopInterface] Compra realizada: %s por %d moedas." % [item_def.name, buy_price])
		refresh_shop_ui()
		return true
		
	return false


## Realiza a venda transacional de um item do jogador para a loja
func execute_sell(item_def: ItemDefinition, sell_price: int) -> bool:
	if not _inventory_service or not item_def:
		return false
		
	var player_item_count = _inventory_service.get_total_quantity(item_def.id)
	if player_item_count < 1:
		print("[ShopInterface] Falha de Venda: Jogador não possui o item %s!" % item_def.name)
		return false
		
	# Remove o item e reembolsa moedas
	if _inventory_service.remove_item(item_def.id, 1):
		# Cria definição de moeda de ouro
		var gold_def = ItemDefinition.new()
		gold_def.id = &"item.currency.gold"
		gold_def.name = "Moeda de Ouro"
		gold_def.is_stackable = true
		
		_inventory_service.add_item(gold_def, sell_price)
		
		# Adiciona estoque ao mercado diretamente no dicionário
		if market_definition:
			var current_qty = market_definition.get_stock(item_def.id)
			market_definition.current_stock[item_def.id] = current_qty + 1
			
		print("[ShopInterface] Venda realizada: %s por %d moedas." % [item_def.name, sell_price])
		refresh_shop_ui()
		return true
		
	return false


func _on_close_button_pressed() -> void:
	visible = false
	shop_closed.emit()
