## boot.gd
## Script anexado à cena principal de Boot (Boot.tscn).
## Executa a validação de inicialização e chama os testes atômicos do Core.

extends Node2D

const TestRunner = preload("res://tests/test_core_infrastructure.gd")


func _ready() -> void:
	print("[Boot] Iniciando Beneath Five Moons / Lumina Darkness...")
	print("[Boot] Engine: Godot 4.7.1 | Perspectiva: Top-Down 2D")
	
	# Aguarda 1 frame para garantir que todos os Autoloads finalizaram o _ready()
	await get_tree().process_frame
	
	_run_bootstrap_tests()


func _run_bootstrap_tests() -> void:
	var runner = TestRunner.new()
	var test_result = runner.run_all_tests()
	
	if test_result:
		print("[Boot] Infraestrutura Validada com Sucesso! Projeto pronto para a Sprint 2.")
	else:
		push_error("[Boot] ERRO CRÍTICO DE INFRAESTRUTURA: Verifique o Output de mensagens.")
