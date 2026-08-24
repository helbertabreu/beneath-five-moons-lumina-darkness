## boot.gd
## Script anexado à cena principal de Boot (Boot.tscn).
## Instancia serviços, executa validações de infraestrutura, integração, profissões, economia, relacionamentos, loja do jogador e ilhas bioluminescentes.

extends Node2D

const TestRunner = preload("res://tests/test_core_infrastructure.gd")
const IntegrationTestRunner = preload("res://tests/test_vertical_slice_integration.gd")
const ProfessionTestRunner = preload("res://tests/test_profession_system.gd")
const ShopTestRunner = preload("res://tests/unit/test_shop_system.gd")
const RelationshipTestRunner = preload("res://tests/unit/test_relationship_system.gd")
const PlayerMarketTestRunner = preload("res://tests/unit/test_player_market_system.gd")

const PlayerScene = preload("res://scenes/player/Player.tscn")
const TestChestScript = preload("res://entities/interactables/test_chest.gd")
const IronMineScript = preload("res://entities/resources/iron_mine_node.gd")
const ForgeNodeScript = preload("res://entities/interactables/forge_node.gd")
const InventoryServiceScript = preload("res://inventory/inventory_service.gd")
const LightingServiceScript = preload("res://world/lighting/lighting_service.gd")
const HungryWolfScript = preload("res://entities/enemies/hungry_wolf_node.gd")
const QuestServiceScript = preload("res://quests/runtime/quest_service.gd")
const BlacksmithNPCScript = preload("res://entities/npc/blacksmith_npc_node.gd")
const ProfessionServiceScript = preload("res://progression/professions/profession_service.gd")
const RelationshipServiceScript = preload("res://social/relationships/relationship_service.gd")
const PlayerMarketServiceScript = preload("res://economy/market/player_market_service.gd")
const BioluminescentFloraScript = preload("res://entities/environment/bioluminescent_flora_node.gd")

var _player_instance: CharacterBody2D = null
var _inventory_service: Node = null
var _lighting_service: Node = null
var _quest_service: Node = null
var _profession_service: Node = null
var _faction_service: FactionService = null
var _relationship_service: Node = null
var _player_market_service: Node = null


func _ready() -> void:
	print("[Boot] Iniciando Beneath Five Moons / Lumina Darkness...")
	print("[Boot] Engine: Godot 4.7.1 | Perspectiva: Top-Down 2D")
	
	await get_tree().process_frame
	
	_setup_services()
	
	var tests_passed = _run_bootstrap_and_relationship_tests()
	
	if tests_passed:
		_setup_environment_lighting()
		_spawn_test_environment()


func _run_bootstrap_and_relationship_tests() -> bool:
	# 1. Executa Teste da Infraestrutura Base
	var infra_runner = TestRunner.new()
	var infra_ok = infra_runner.run_all_tests()
	
	# 2. Executa Teste de Integração da Vertical Slice 2D
	var integration_runner = IntegrationTestRunner.new()
	var integration_ok = integration_runner.run_vertical_slice_tests()
	
	# 3. Executa Teste da Engine de Profissões (Sprint 8 / TASK-201)
	var profession_runner = ProfessionTestRunner.new()
	var profession_ok = profession_runner.run_profession_tests()
	
	# 4. Executa Teste do Sistema Comercial e Precificação (Sprint 12 / TASK-301)
	var shop_runner = ShopTestRunner.new()
	var shop_ok = shop_runner.run_shop_tests()
	
	# 5. Executa Teste do Sistema de Relacionamentos e Afinidade (Sprint 13 / TASK-302)
	var rel_runner = RelationshipTestRunner.new()
	var rel_ok = rel_runner.run_relationship_tests()
	
	# 6. Executa Teste da Loja do Jogador e Mercado Local (Sprint 15 / TASK-304)
	var market_runner = PlayerMarketTestRunner.new()
	var market_ok = market_runner.run_market_tests()
	
	# 7. Executa Teste de Iluminação Bioluminescente 2D (Sprint 16 / POLISH-001)
	var bio_runner = TestBioluminescentLighting.new()
	var bio_ok = bio_runner.run_bioluminescent_tests()
	
	if infra_ok and integration_ok and profession_ok and shop_ok and rel_ok and market_ok and bio_ok:
		print("[Boot] INTEGRALMENTE VALIDADO: Infraestrutura, Persistência, Profissões, Comércio, Relacionamentos, Loja e Iluminação Bioluminescente 100% Funcionais!")
		return true
	else:
		push_error("[Boot] ERRO CRÍTICO NOS TESTES DE UNIDADE OU INTEGRAÇÃO!")
		return false


func _setup_services() -> void:
	# 1. InventoryService
	_inventory_service = InventoryServiceScript.new()
	_inventory_service.name = "InventoryService"
	add_child(_inventory_service)
	
	# 2. LightingService
	_lighting_service = LightingServiceScript.new()
	_lighting_service.name = "LightingService"
	add_child(_lighting_service)
	
	# 3. QuestService
	_quest_service = QuestServiceScript.new()
	_quest_service.name = "QuestService"
	add_child(_quest_service)
	
	# 4. ProfessionService (Sprint 8 / TASK-201)
	_profession_service = ProfessionServiceScript.new()
	_profession_service.name = "ProfessionService"
	add_child(_profession_service)
	
	# 5. FactionService (Sprint 12 / TASK-301)
	_faction_service = FactionService.new()
	if ServiceRegistry:
		ServiceRegistry.register_service(&"FactionService", _faction_service)
		print("[Boot] FactionService registrado com sucesso.")
		
	# 6. RelationshipService (Sprint 13 / TASK-302)
	_relationship_service = RelationshipServiceScript.new()
	_relationship_service.name = "RelationshipService"
	add_child(_relationship_service)
	
	# 7. PlayerMarketService (Sprint 15 / TASK-304)
	_player_market_service = PlayerMarketServiceScript.new()
	_player_market_service.name = "PlayerMarketService"
	add_child(_player_market_service)


func _setup_environment_lighting() -> void:
	var canvas_modulate = CanvasModulate.new()
	canvas_modulate.name = "AmbientDarkness"
	canvas_modulate.color = Color(0.25, 0.25, 0.35, 1.0) # Penumbra Azulada
	add_child(canvas_modulate)


func _spawn_test_environment() -> void:
	if not PlayerScene:
		push_error("[Boot] Não foi possível carregar a cena do Player em res://scenes/player/Player.tscn")
		return
	
	var viewport_size = get_viewport_rect().size
	var center_pos = viewport_size / 2.0
	
	# 1. Player
	_player_instance = PlayerScene.instantiate() as CharacterBody2D
	if _player_instance:
		_player_instance.position = center_pos
		add_child(_player_instance)
		print("[Boot] Player 2D instanciado na posição: ", _player_instance.position)
	
	# 2. Baú de Teste
	var chest = Area2D.new()
	chest.set_script(TestChestScript)
	chest.name = "TestChest"
	chest.position = center_pos + Vector2(70, 0)
	add_child(chest)
	
	# 3. Mina de Ferro
	var iron_mine = Area2D.new()
	iron_mine.set_script(IronMineScript)
	iron_mine.name = "IronMine"
	iron_mine.position = center_pos + Vector2(-30, 0)
	add_child(iron_mine)
	
	# 4. Forja de Ferreiro
	var forge = Area2D.new()
	forge.set_script(ForgeNodeScript)
	forge.name = "ForgeNode"
	forge.position = center_pos + Vector2(0, -30)
	add_child(forge)
	
	# 5. Lobo Esfomeado
	var wolf = Area2D.new()
	wolf.set_script(HungryWolfScript)
	wolf.name = "HungryWolf"
	wolf.position = center_pos + Vector2(0, 40)
	add_child(wolf)
	
	# 6. NPC Ferreiro Gorn
	var npc_gorn = Area2D.new()
	npc_gorn.set_script(BlacksmithNPCScript)
	npc_gorn.name = "BlacksmithNPC"
	npc_gorn.position = center_pos + Vector2(30, 0)
	add_child(npc_gorn)
	
	# 7. Flora Bioluminescente 2D (Sprint 16 / POLISH-001)
	var bio_plant = Area2D.new()
	bio_plant.set_script(BioluminescentFloraScript)
	bio_plant.name = "BioluminescentFlora"
	bio_plant.position = center_pos + Vector2(-60, -40)
	add_child(bio_plant)
