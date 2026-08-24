## Serviço transacional desacoplado responsável por validar e executar receitas de crafting.
## Registrado globalmente no ServiceRegistry.
class_name CraftingService
extends Node


func _ready() -> void:
	if ServiceRegistry:
		ServiceRegistry.register_service(&"CraftingService", self)
		print("[CraftingService] Serviço registrado com sucesso no ServiceRegistry.")


## Tenta fabricar uma receita para um determinado ator/jogador em uma estação de trabalho.
## Executa validação atômica rigorosa e transação completa.
func craft_recipe(recipe: RecipeDefinition, station_def: CraftingStationDefinition, player_node: Node = null) -> Dictionary:
	if not recipe or not station_def:
		return {"success": false, "reason": "Receita ou Estação de Trabalho inválida."}
		
	# 1. Validar Tipo e Tier da Estação
	if station_def.station_type_id != recipe.required_station_type:
		return {"success": false, "reason": "Estação incorreta. Requer: %s" % recipe.required_station_type}
		
	if station_def.tier < recipe.required_station_tier:
		return {"success": false, "reason": "Tier da estação insuficiente. Requer Tier %d" % recipe.required_station_tier}

	# 2. Obter Serviços Necessários via ServiceRegistry
	var inventory_service: InventoryService = ServiceRegistry.get_service(&"InventoryService") as InventoryService
	var profession_service: ProfessionService = ServiceRegistry.get_service(&"ProfessionService") as ProfessionService
	
	if not inventory_service or not profession_service:
		return {"success": false, "reason": "Serviços essenciais (Inventory/Profession) não encontrados."}

	# 3. Validar Nível da Profissão
	var current_tier = profession_service.get_profession_tier(recipe.profession_id)
	if current_tier < recipe.required_profession_level:
		return {"success": false, "reason": "Nível de profissão insuficiente em %s. Requer Nível %d" % [
			recipe.profession_id, recipe.required_profession_level
		]}

	# 4. Validar Custo de Energia (se o nó do player e o SurvivalComponent estiverem presentes)
	var survival_comp = null
	if player_node:
		survival_comp = player_node.get_node_or_null("SurvivalComponent")
		if survival_comp and survival_comp.has_method("get_energy"):
			if survival_comp.get_energy() < recipe.energy_cost:
				return {"success": false, "reason": "Energia insuficiente. Requer %.1f" % recipe.energy_cost}

	# 5. Validar Insumos do Inventário
	for input in recipe.inputs:
		var item_id: StringName = input.get("item_id", &"")
		var required_qty: int = input.get("quantity", 1)
		if inventory_service.get_total_quantity(item_id) < required_qty:
			return {"success": false, "reason": "Insumos insuficientes para o item %s." % item_id}

	# --- FIM DA VALIDAÇÃO / INÍCIO DA TRANSAÇÃO ATÔMICA ---

	# A) Deduzir Insumos
	for input in recipe.inputs:
		var item_id: StringName = input.get("item_id", &"")
		var required_qty: int = input.get("quantity", 1)
		inventory_service.remove_item(item_id, required_qty)

	# B) Deduzir Energia
	if survival_comp and survival_comp.has_method("consume_energy"):
		survival_comp.consume_energy(recipe.energy_cost)

	# C) Adicionar Produtos do Output ao Inventário
	for output in recipe.outputs:
		var item_def: ItemDefinition = output.get("item_definition", null)
		var output_qty: int = output.get("quantity", 1)
		if item_def:
			inventory_service.add_item(item_def, output_qty)

	# D) Conceder XP de Profissão
	if recipe.granted_profession_xp > 0.0:
		profession_service.add_profession_xp(recipe.profession_id, recipe.granted_profession_xp)

	# E) Emitir Eventos
	if EventBus and EventBus.has_method("emit_custom_event"):
		EventBus.emit_custom_event(&"ItemCrafted", {
			"recipe_id": recipe.id,
			"profession_id": recipe.profession_id,
			"station_type": station_def.station_type_id
		})

	print("[CraftingService] RECEITA FABRICADA COM SUCESSO: %s" % recipe.display_name)
	return {"success": true, "recipe_id": recipe.id}
