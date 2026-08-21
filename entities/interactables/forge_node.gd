## forge_node.gd
## Estação de crafting interativa que representa uma Forja de Ferreiro.
##
## Consome matérias-primas e energia para produzir lingotes e conceder XP de profissão.

extends Area2D

var _visual_rect: ColorRect = null
var _recipe: RecipeDefinition = null


func _ready() -> void:
	monitorable = true
	monitoring = true
	
	# Colisão física da área da forja (Raio de 25px)
	var col_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 25.0
	col_shape.shape = circle
	add_child(col_shape)
	
	# Visual provisório da forja (Retângulo Laranja/Brasa)
	_visual_rect = ColorRect.new()
	_visual_rect.custom_minimum_size = Vector2(26, 26)
	_visual_rect.position = Vector2(-13, -13)
	_visual_rect.color = Color(0.9, 0.35, 0.1, 1.0) # Laranja brasa
	add_child(_visual_rect)
	
	_setup_default_recipe()
	print("[Forja de Ferreiro] Estação pronta para fundição.")


## Configura a receita padrão de Lingote de Ferro (2x Minério de Ferro -> 1x Lingote de Ferro)
func _setup_default_recipe() -> void:
	var iron_ingot = ItemDefinition.new()
	iron_ingot.id = &"item.material.iron_ingot"
	iron_ingot.name = "Lingote de Ferro"
	iron_ingot.category = &"Material Refinado"
	iron_ingot.is_stackable = true
	iron_ingot.max_stack_size = 99
	iron_ingot.base_price = 70
	
	_recipe = RecipeDefinition.new()
	_recipe.id = &"recipe.blacksmith.iron_ingot"
	_recipe.name = "Fundir Lingote de Ferro"
	_recipe.required_profession = &"Blacksmith"
	_recipe.energy_cost = 15.0
	_recipe.xp_reward = 25.0
	_recipe.required_ingredients = {
		&"item.material.iron_ore": 2
	}
	_recipe.result_item = iron_ingot
	_recipe.result_quantity = 1


## Mensagem de contexto para a UI
func get_interaction_text() -> String:
	return "Forjar Lingote de Ferro (2x Minério | -15 Energia)"


## Retorna se a forja pode receber interação
func can_interact(_interactor: Node2D) -> bool:
	return true


## Executa o processo transacional de fundição
func interact(interactor: Node2D) -> void:
	var inv_service = ServiceRegistry.get_service(&"InventoryService") as InventoryService
	if not inv_service:
		print("[Forja] Erro: InventoryService não registrado!")
		return
		
	# 1. Valida se o jogador possui os ingredientes no inventário
	for ingredient_id in _recipe.required_ingredients:
		var required_qty = _recipe.required_ingredients[ingredient_id]
		var current_qty = inv_service.get_total_quantity(ingredient_id)
		
		if current_qty < required_qty:
			print("[Forja] Ingredientes insuficientes! Requer %d x %s (Você possui: %d)." % [required_qty, ingredient_id, current_qty])
			return
			
	# 2. Valida se o jogador possui energia no SurvivalComponent
	var survival_comp: SurvivalComponent = interactor.get_node_or_null("SurvivalComponent") as SurvivalComponent
	if not survival_comp:
		for child in interactor.get_children():
			if child is SurvivalComponent:
				survival_comp = child
				break
				
	if survival_comp and survival_comp.energy < _recipe.energy_cost:
		print("[Forja] AVISO: Energia insuficiente para forjar! (Atual: %.1f, Necessária: %.1f)" % [survival_comp.energy, _recipe.energy_cost])
		return
		
	# 3. Execução Transacional: Consome Ingredientes e Energia
	for ingredient_id in _recipe.required_ingredients:
		var required_qty = _recipe.required_ingredients[ingredient_id]
		inv_service.remove_item(ingredient_id, required_qty)
		
	if survival_comp:
		survival_comp.energy = maxf(0.0, survival_comp.energy - _recipe.energy_cost)
		print("[Forja] Energia consumida! Energia restante do jogador: %.1f / %.1f" % [survival_comp.energy, survival_comp.max_energy])
		
		# Disparo do evento de energia de forma segura
		_emit_event_safe(&"EnergyChanged", {"current": survival_comp.energy, "max": survival_comp.max_energy})
			
	# 4. Entrega o Produto Final
	inv_service.add_item(_recipe.result_item, _recipe.result_quantity)
	print("[Forja] SUCESSO! 1x Lingote de Ferro forjado e adicionado ao inventário.")
	
	# 5. Notifica XP na Profissão e registra no Output
	print("[Forja] +%.1f XP concedido na profissão: %s" % [_recipe.xp_reward, _recipe.required_profession])
	
	# Emite eventos no Barramento
	_emit_event_safe(&"ItemCrafted", {
		"recipe_id": _recipe.id,
		"result_item": _recipe.result_item.id,
		"quantity": _recipe.result_quantity
	})
	_emit_event_safe(&"ProfessionXPChanged", {
		"profession": _recipe.required_profession,
		"xp_gained": _recipe.xp_reward
	})


## Método auxiliar para disparar eventos com segurança no EventBus
func _emit_event_safe(event_name: StringName, data: Dictionary) -> void:
	if not EventBus:
		return
		
	if EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", event_name, data)
	elif EventBus.has_method("emit_event"):
		EventBus.call("emit_event", event_name, data)
