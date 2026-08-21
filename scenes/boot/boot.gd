## boot.gd
## Script anexado à cena principal de Boot (Boot.tscn).
## Executa a validação de inicialização e instancia serviços, Player, Baú, Mina de Ferro, Forja e Iluminação.

extends Node2D

const TestRunner = preload("res://tests/test_core_infrastructure.gd")
const PlayerScene = preload("res://scenes/player/Player.tscn")
const TestChestScript = preload("res://entities/interactables/test_chest.gd")
const IronMineScript = preload("res://entities/resources/iron_mine_node.gd")
const ForgeNodeScript = preload("res://entities/interactables/forge_node.gd")
const InventoryServiceScript = preload("res://inventory/inventory_service.gd")
const LightingServiceScript = preload("res://world/lighting/lighting_service.gd")

var _player_instance: CharacterBody2D = null
var _inventory_service: Node = null
var _lighting_service: Node = null


func _ready() -> void:
	print("[Boot] Iniciando Beneath Five Moons / Lumina Darkness...")
	print("[Boot] Engine: Godot 4.7.1 | Perspectiva: Top-Down 2D")
	
	# Aguarda 1 frame para garantir que todos os Autoloads finalizaram o _ready()
	await get_tree().process_frame
	
	var tests_passed = _run_bootstrap_tests()
	
	if tests_passed:
		_setup_services()
		_setup_environment_lighting()
		_spawn_test_environment()


func _run_bootstrap_tests() -> bool:
	var runner = TestRunner.new()
	var test_result = runner.run_all_tests()
	
	if test_result:
		print("[Boot] Infraestrutura Validada com Sucesso! Projeto pronto para a Sprint 5.")
		return true
	else:
		push_error("[Boot] ERRO CRÍTICO DE INFRAESTRUTURA: Verifique o Output de mensagens.")
		return false


func _setup_services() -> void:
	# 1. Instancia o InventoryService
	_inventory_service = InventoryServiceScript.new()
	_inventory_service.name = "InventoryService"
	add_child(_inventory_service)
	
	# 2. Instancia o LightingService
	_lighting_service = LightingServiceScript.new()
	_lighting_service.name = "LightingService"
	add_child(_lighting_service)


## Adiciona Penumbra Ambiental ao mapa de testes usando CanvasModulate
func _setup_environment_lighting() -> void:
	var canvas_modulate = CanvasModulate.new()
	canvas_modulate.name = "AmbientDarkness"
	canvas_modulate.color = Color(0.25, 0.25, 0.35, 1.0) # Penumbra Azulada
	add_child(canvas_modulate)


## Instancia o Player 2D e todos os elementos de teste no ambiente da Vertical Slice
func _spawn_test_environment() -> void:
	if not PlayerScene:
		push_error("[Boot] Não foi possível carregar a cena do Player em res://scenes/player/Player.tscn")
		return
	
	var viewport_size = get_viewport_rect().size
	var center_pos = viewport_size / 2.0
	
	# 1. Instancia o Player
	_player_instance = PlayerScene.instantiate() as CharacterBody2D
	if _player_instance:
		_player_instance.position = center_pos
		add_child(_player_instance)
		print("[Boot] Player 2D instanciado na posição: ", _player_instance.position)
	
	# 2. Instancia o Baú de Teste 30px à direita do jogador
	var chest = Area2D.new()
	chest.set_script(TestChestScript)
	chest.name = "TestChest"
	chest.position = center_pos + Vector2(30, 0)
	add_child(chest)
	
	# 3. Instancia a Mina de Ferro 30px à esquerda do jogador
	var iron_mine = Area2D.new()
	iron_mine.set_script(IronMineScript)
	iron_mine.name = "IronMine"
	iron_mine.position = center_pos + Vector2(-30, 0)
	add_child(iron_mine)
	
	# 4. Instancia a Forja de Ferreiro 30px acima do jogador
	var forge = Area2D.new()
	forge.set_script(ForgeNodeScript)
	forge.name = "ForgeNode"
	forge.position = center_pos + Vector2(0, -30)
	add_child(forge)
