## boot.gd
## Script anexado à cena principal de Boot (Boot.tscn).
## Executa a validação de inicialização e instancia o Player, Baú e o InventoryService.

extends Node2D

const TestRunner = preload("res://tests/test_core_infrastructure.gd")
const PlayerScene = preload("res://scenes/player/Player.tscn")
const TestChestScript = preload("res://entities/interactables/test_chest.gd")
const InventoryServiceScript = preload("res://inventory/inventory_service.gd")

var _player_instance: CharacterBody2D = null
var _inventory_service: Node = null


func _ready() -> void:
	print("[Boot] Iniciando Beneath Five Moons / Lumina Darkness...")
	print("[Boot] Engine: Godot 4.7.1 | Perspectiva: Top-Down 2D")
	
	# Aguarda 1 frame para garantir que todos os Autoloads finalizaram o _ready()
	await get_tree().process_frame
	
	var tests_passed = _run_bootstrap_tests()
	
	if tests_passed:
		_setup_services()
		_spawn_test_environment()
		_run_inventory_test()


func _run_bootstrap_tests() -> bool:
	var runner = TestRunner.new()
	var test_result = runner.run_all_tests()
	
	if test_result:
		print("[Boot] Infraestrutura Validada com Sucesso! Projeto pronto para a Sprint 4.")
		return true
	else:
		push_error("[Boot] ERRO CRÍTICO DE INFRAESTRUTURA: Verifique o Output de mensagens.")
		return false


func _setup_services() -> void:
	# Instancia o InventoryService no Boot caso não exista
	_inventory_service = InventoryServiceScript.new()
	_inventory_service.name = "InventoryService"
	add_child(_inventory_service)


## Instancia o Player 2D e o Baú de Teste no centro da janela
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
	print("[Boot] Baú de Teste instanciado na posição: ", chest.position)


## Teste unitário/integração do InventoryService no Boot
func _run_inventory_test() -> void:
	var iron_ore = ItemDefinition.new()
	iron_ore.id = &"item.material.iron_ore"
	iron_ore.name = "Minério de Ferro"
	iron_ore.is_stackable = true
	iron_ore.max_stack_size = 99
	
	var inv_service = ServiceRegistry.get_service(&"InventoryService") as InventoryService
	if inv_service:
		inv_service.add_item(iron_ore, 5)
		var qty = inv_service.get_total_quantity(&"item.material.iron_ore")
		print("[Boot Test] Quantidade de Minério de Ferro no inventário: ", qty)
