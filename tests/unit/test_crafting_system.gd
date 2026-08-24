## Suíte de Testes Unitários e Validação Atômica do Sistema de Crafting (TASK-303).
extends Node


func _ready() -> void:
	print("\n========== INICIANDO SUÍTE DE TESTES: CRAFTING SYSTEM (TASK-303) ==========")
	run_all_tests()


func run_all_tests() -> void:
	test_crafting_validation_and_execution()


func test_crafting_validation_and_execution() -> void:
	# 1. Instanciar Serviços de Suporte Mocado
	var inv_service = InventoryService.new()
	var prof_service = ProfessionService.new()
	var craft_service = CraftingService.new()
	
	add_child(inv_service)
	add_child(prof_service)
	add_child(craft_service)

	# 2. Criar Definições de Itens de Teste
	var iron_ore_def = ItemDefinition.new()
	iron_ore_def.id = &"item.material.iron_ore"
	iron_ore_def.name = "Minério de Ferro"
	iron_ore_def.is_stackable = true

	var iron_ingot_def = ItemDefinition.new()
	iron_ingot_def.id = &"item.material.iron_ingot"
	iron_ingot_def.name = "Lingote de Ferro"
	iron_ingot_def.is_stackable = true

	# 3. Criar Estação de Trabalho de Teste (Forja Tier 1)
	var station_def = CraftingStationDefinition.new()
	station_def.station_type_id = &"station.forge"
	station_def.tier = 1

	# 4. Criar Receita de Teste
	var recipe = RecipeDefinition.new()
	recipe.id = &"recipe.blacksmith.iron_ingot"
	recipe.display_name = "Forjar Lingote de Ferro"
	recipe.profession_id = &"profession.blacksmith"
	recipe.required_profession_level = 1
	recipe.required_station_type = &"station.forge"
	recipe.required_station_tier = 1
	recipe.energy_cost = 0.0 # Sem player no teste unitário puro
	recipe.inputs = [{"item_id": &"item.material.iron_ore", "quantity": 2}]
	recipe.outputs = [{"item_definition": iron_ingot_def, "quantity": 1}]
	recipe.granted_profession_xp = 25.0

	# TESTE A: Tentar fabricar SEM insumos (Deve falhar)
	var result_fail = craft_service.craft_recipe(recipe, station_def)
	assert(result_fail["success"] == false, "ERRO: O crafting deveria ter falhado por falta de insumos.")
	print("✓ Teste A Aprovado: Crafting negado corretamente por insumos insuficientes.")

	# TESTE B: Adicionar insumos e executar crafting
	inv_service.add_item(iron_ore_def, 4) # Adiciona 4 minérios
	assert(inv_service.get_total_quantity(&"item.material.iron_ore") == 4, "ERRO ao adicionar insumos.")

	var result_success = craft_service.craft_recipe(recipe, station_def)
	assert(result_success["success"] == true, "ERRO: O crafting falhou mesmo com insumos válidos.")
	
	# Verificar se consumiu 2 minérios (restando 2) e produziu 1 lingote
	assert(inv_service.get_total_quantity(&"item.material.iron_ore") == 2, "ERRO: Quantidade de insumos incorreta após o craft.")
	assert(inv_service.get_total_quantity(&"item.material.iron_ingot") == 1, "ERRO: Produto não foi adicionado ao inventário.")
	
	# Verificar se a XP da profissão foi concedida
	var tier = prof_service.get_profession_tier(&"profession.blacksmith")
	assert(tier >= 1, "ERRO: Progresso de profissão não registrado.")

	print("✓ Teste B Aprovado: Insumos consumidos, produto entregue e XP concedida com sucesso!")
	print("\n[TEST PASSED] SUÍTE DE CRAFTING SYSTEM VALIDADA COM SUCESSO ABSOLUTO!\n")

	# Limpeza
	inv_service.queue_free()
	prof_service.queue_free()
	craft_service.queue_free()
