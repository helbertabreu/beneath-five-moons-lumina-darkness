## test_bioluminescent_lighting.gd
## Suíte de testes unitários para validação da Flora Bioluminescente e Ilhas de Luz (POLISH-001).

class_name TestBioluminescentLighting
extends RefCounted

const BioluminescentFloraScript = preload("res://entities/environment/bioluminescent_flora_node.gd")


## Função principal de execução da suíte de testes do nó bioluminescente
func run_bioluminescent_tests() -> bool:
	print("\n=== INICIANDO TESTE DE ILUMINAÇÃO BIOLUMINESCENTE 2D (POLISH-001) ===")
	
	# 1. Recupera o LightingService registrado globalmente no ServiceRegistry ou instancia um fallback
	var lighting_service: LightingService = null
	var owns_service: bool = false
	
	if ServiceRegistry and ServiceRegistry.has_service(&"LightingService"):
		lighting_service = ServiceRegistry.get_service(&"LightingService") as LightingService
	else:
		lighting_service = LightingService.new()
		lighting_service._ready()
		owns_service = true
	
	# Instancia o nó da flora bioluminescente
	var flora_node = BioluminescentFloraScript.new() as Area2D
	flora_node._ready()
	
	# 2. Valida o estado inicial de Penumbra (0.20)
	if lighting_service.current_context == null or lighting_service.current_context.value != 0.20:
		push_error("[TEST FAIL] O estado inicial de iluminação não é Penumbra (0.20)!")
		flora_node.queue_free()
		if owns_service:
			lighting_service.queue_free()
		return false
	print("[TEST PASSED] Estado inicial de Penumbra (0.20) verificado com sucesso.")
	
	# 3. Simula a entrada de um nó 'Player' na área da flora bioluminescente
	var dummy_player = Node2D.new()
	dummy_player.name = "PlayerDummy"
	dummy_player.add_to_group("Player")
	
	flora_node._on_body_entered(dummy_player)
	
	# 4. Valida se a iluminação do jogador subiu para Luz Plena/Moderada (0.75)
	if lighting_service.current_context.value != 0.75:
		push_error("[TEST FAIL] O nível de iluminação não foi elevado para 0.75 na área bioluminescente!")
		flora_node.queue_free()
		dummy_player.queue_free()
		if owns_service:
			lighting_service.queue_free()
		return false
	print("[TEST PASSED] Elevação de luz para 0.75 ao entrar na ilha bioluminescente validada com sucesso.")
	
	# 5. Simula a saída do jogador da área
	flora_node._on_body_exited(dummy_player)
	
	# 6. Valida o retorno para a Penumbra (0.20)
	if lighting_service.current_context.value != 0.20:
		push_error("[TEST FAIL] A iluminação não retornou para Penumbra (0.20) ao sair da área!")
		flora_node.queue_free()
		dummy_player.queue_free()
		if owns_service:
			lighting_service.queue_free()
		return false
	print("[TEST PASSED] Retorno para a Penumbra do ambiente (0.20) ao sair da ilha bioluminescente verificado.")
	
	# Limpeza dos nós temporários do teste
	flora_node.queue_free()
	dummy_player.queue_free()
	if owns_service:
		lighting_service.queue_free()
	
	print("=== TODOS OS TESTES DE ILUMINAÇÃO BIOLUMINESCENTE (POLISH-001) PASSARAM COM SUCESSO! ===\n")
	return true
