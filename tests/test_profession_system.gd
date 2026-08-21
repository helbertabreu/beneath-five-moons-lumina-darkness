## test_profession_system.gd
## Suíte de testes unitários automatizada para validação da Engine de Profissões.

extends RefCounted


func run_profession_tests() -> bool:
	print("[ProfessionTest] Iniciando Testes Unitários da Engine de Profissões...")
	var success = true
	
	if not _test_xp_and_tier_up(): success = false
	if not _test_overflow_xp(): success = false
	if not _test_max_tier_cap(): success = false
	if not _test_serialization(): success = false
	
	if success:
		print("[ProfessionTest] [TEST PASSED] Todos os testes da Engine de Profissões passaram com 100% de sucesso!")
	else:
		push_error("[ProfessionTest] [TEST FAILED] Falha nos testes de Profissões.")
		
	return success


## 1. Valida o ganho básico de XP e transição de Tier
func _test_xp_and_tier_up() -> bool:
	var state = ProfessionState.new(&"profession.blacksmith", 5, 100.0)
	var res = state.add_xp(100.0)
	
	if not res["tier_up"] or state.current_tier != 2 or state.current_xp != 0.0:
		push_error("[ProfessionTest] Falha no teste básico de subida de Tier!")
		return false
	return true


## 2. Valida a preservação do excesso de XP (overflow)
func _test_overflow_xp() -> bool:
	var state = ProfessionState.new(&"profession.miner", 5, 100.0)
	var res = state.add_xp(125.0)
	
	if not res["tier_up"] or state.current_tier != 2 or state.current_xp != 25.0:
		push_error("[ProfessionTest] Falha na preservação do overflow de XP!")
		return false
	return true


## 3. Valida a trava de limite no Tier máximo
func _test_max_tier_cap() -> bool:
	var state = ProfessionState.new(&"profession.alchemist", 5, 100.0)
	state.add_xp(500.0) # Deve levar ao Tier 5, 100 XP
	
	var res = state.add_xp(50.0) # Tentativa de extrapolar o limite
	if state.current_tier != 5 or state.current_xp != 100.0:
		push_error("[ProfessionTest] Falha no limite do Tier máximo!")
		return false
	return true


## 4. Valida a serialização e deserialização em Dicionário JSON
func _test_serialization() -> bool:
	var original_state = ProfessionState.new(&"profession.cook", 5, 100.0)
	original_state.add_xp(150.0) # Tier 2, 50 XP
	
	var data = original_state.serialize()
	var restored_state = ProfessionState.new(&"profession.cook", 5, 100.0)
	
	if not restored_state.deserialize(data):
		return false
		
	return restored_state.current_tier == 2 and restored_state.current_xp == 50.0
