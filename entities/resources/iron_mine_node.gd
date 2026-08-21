## iron_mine_node.gd
## Nó de recurso interativo que representa uma jazida de Minério de Ferro.
##
## Consome energia do SurvivalComponent do jogador e deposita itens no InventoryService.

extends Area2D

# Quantidade de minerações possíveis antes do esgotamento da jazida
@export var remaining_charges: int = 3
@export var energy_cost: float = 10.0

var _visual_rect: ColorRect = null
var _item_definition: ItemDefinition = null


func _ready() -> void:
	monitorable = true
	monitoring = true
	
	# Colisão física do nó de minério (Raio de 22px)
	var col_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 22.0
	col_shape.shape = circle
	add_child(col_shape)
	
	# Visual provisório da jazida (Retângulo Cinza/Grafite)
	_visual_rect = ColorRect.new()
	_visual_rect.custom_minimum_size = Vector2(24, 24)
	_visual_rect.position = Vector2(-12, -12)
	_visual_rect.color = Color(0.4, 0.4, 0.45, 1.0) # Cinza minério
	add_child(_visual_rect)
	
	# Configura a definição do item extraído
	_item_definition = ItemDefinition.new()
	_item_definition.id = &"item.material.iron_ore"
	_item_definition.name = "Minério de Ferro"
	_item_definition.is_stackable = true
	_item_definition.max_stack_size = 99
	
	print("[Mina de Ferro] Jazida inicializada com %d cargas." % remaining_charges)


## Mensagem de contexto para a UI
func get_interaction_text() -> String:
	if remaining_charges > 0:
		return "Minerar Ferro (-10 Energia)"
	return "Jazida Esgotada"


## Retorna se a jazida ainda pode ser minerada
func can_interact(_interactor: Node2D) -> bool:
	return remaining_charges > 0


## Executa a ação de mineração
func interact(interactor: Node2D) -> void:
	if remaining_charges <= 0:
		print("[Mina de Ferro] A jazida está completamente esgotada!")
		return
		
	# 1. Tenta obter o SurvivalComponent do jogador
	var survival_comp: SurvivalComponent = interactor.get_node_or_null("SurvivalComponent") as SurvivalComponent
	if not survival_comp:
		# Fallback: procura nos filhos do interactor
		for child in interactor.get_children():
			if child is SurvivalComponent:
				survival_comp = child
				break
				
	# 2. Valida se o jogador tem energia suficiente
	if survival_comp:
		if survival_comp.energy < energy_cost:
			print("[Mina de Ferro] AVISO: Energia insuficiente para minerar! (Atual: %.1f, Necessária: %.1f)" % [survival_comp.energy, energy_cost])
			return
		
		# Consome a energia do jogador
		survival_comp.energy = maxf(0.0, survival_comp.energy - energy_cost)
		print("[Mina de Ferro] Energia consumida! Energia restante do jogador: %.1f / %.1f" % [survival_comp.energy, survival_comp.max_energy])
		
		if EventBus and EventBus.has_signal("event_emitted"):
			EventBus.emit_signal("event_emitted", &"EnergyChanged", {"current": survival_comp.energy, "max": survival_comp.max_energy})
	
	# 3. Processa a extração do recurso
	remaining_charges -= 1
	var yield_amount = randi_range(1, 2)
	
	# 4. Adiciona ao InventoryService global
	var inv_service = ServiceRegistry.get_service(&"InventoryService") as InventoryService
	if inv_service:
		inv_service.add_item(_item_definition, yield_amount)
	else:
		print("[Mina de Ferro] Erro: InventoryService não encontrado no ServiceRegistry!")
		
	print("[Mina de Ferro] Coletado %d x Minério de Ferro. Cargas restantes da jazida: %d" % [yield_amount, remaining_charges])
	
	# 5. Atualiza o visual e esgota a jazida se necessário
	if remaining_charges <= 0:
		_visual_rect.color = Color(0.2, 0.2, 0.2, 0.6) # Cinza escuro/desativado
		print("[Mina de Ferro] A jazida de ferro foi completamente esgotada!")
