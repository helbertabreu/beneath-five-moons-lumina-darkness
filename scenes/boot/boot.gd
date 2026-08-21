## boot.gd
## Script anexado à cena principal de Boot (Boot.tscn).
## Executa a validação de inicialização e instancia o Player 2D para testes de movimentação.

extends Node2D

const TestRunner = preload("res://tests/test_core_infrastructure.gd")
const PlayerScene = preload("res://scenes/player/Player.tscn")

var _player_instance: CharacterBody2D = null


func _ready() -> void:
	print("[Boot] Iniciando Beneath Five Moons / Lumina Darkness...")
	print("[Boot] Engine: Godot 4.7.1 | Perspectiva: Top-Down 2D")
	
	# Aguarda 1 frame para garantir que todos os Autoloads finalizaram o _ready()
	await get_tree().process_frame
	
	var tests_passed = _run_bootstrap_tests()
	
	if tests_passed:
		_spawn_test_player()


func _run_bootstrap_tests() -> bool:
	var runner = TestRunner.new()
	var test_result = runner.run_all_tests()
	
	if test_result:
		print("[Boot] Infraestrutura Validada com Sucesso! Projeto pronto para a Sprint 2.")
		return true
	else:
		push_error("[Boot] ERRO CRÍTICO DE INFRAESTRUTURA: Verifique o Output de mensagens.")
		return false


## Instancia o Player 2D no centro da janela para testes de movimentação
func _spawn_test_player() -> void:
	if not PlayerScene:
		push_error("[Boot] Não foi possível carregar a cena do Player em res://scenes/player/Player.tscn")
		return
	
	_player_instance = PlayerScene.instantiate() as CharacterBody2D
	if _player_instance:
		# Centraliza a posição do jogador no viewport do jogo (ex: 576, 324 em 1152x648)
		var viewport_size = get_viewport_rect().size
		_player_instance.position = viewport_size / 2.0
		
		add_child(_player_instance)
		print("[Boot] Player 2D instanciado com sucesso na posição: ", _player_instance.position)
