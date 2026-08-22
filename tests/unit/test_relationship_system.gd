## Suíte de testes automatizados para validação do RelationshipService, RelationshipState e doação de presentes.

extends RefCounted

const RelationshipServiceScript = preload("res://social/relationships/relationship_service.gd")
const RelationshipDefinitionScript = preload("res://social/relationships/relationship_definition.gd")
const RelationshipStateScript = preload("res://social/relationships/relationship_state.gd")


func run_relationship_tests() -> bool:
	print("\n--- INICIANDO SUÍTE DE TESTES: RELATIONSHIP SYSTEM (TASK-302) ---")
	
	var service = RelationshipServiceScript.new()
	service._ready()
	
	var def = RelationshipDefinitionScript.new()
	def.npc_id = &"npc.blacksmith.gorn"
	def.display_name = "Ferreiro Gorn"
	def.loved_item_ids = [&"item.material.iron_ingot"]
	def.hated_item_ids = [&"item.junk.trash"]
	
	service.register_npc_definition(def)
	
	# Teste 1: Afinidade Inicial Neutra
	var state = service.get_relationship_state(&"npc.blacksmith.gorn")
	if state.affinity != 0.0 or state.get_stance() != RelationshipStateScript.Stance.NEUTRAL:
		push_error("[TEST FAIL] Afinidade inicial deve ser 0.0 (NEUTRAL). Obteve: %f" % state.affinity)
		return false
	print("[TEST PASS] Estado inicial e Stance NEUTRAL validados.")
	
	# Teste 2: Presentear Item Amado (+20.0)
	var new_aff = service.give_gift(&"npc.blacksmith.gorn", &"item.material.iron_ingot")
	if new_aff != 20.0 or state.get_stance() != RelationshipStateScript.Stance.LIKE:
		push_error("[TEST FAIL] Dar item amado deve elevar afinidade para 20.0 (LIKE). Obteve: %f" % new_aff)
		return false
	print("[TEST PASS] Doação de item amado elevou postura para LIKE.")
	
	# Teste 3: Clamping Superior (+100.0)
	service.modify_affinity(&"npc.blacksmith.gorn", 150.0, "cheat_boost")
	if state.affinity != 100.0 or state.get_stance() != RelationshipStateScript.Stance.LOVE:
		push_error("[TEST FAIL] Clamp máximo falhou. Esperado: 100.0 | Obteve: %f" % state.affinity)
		return false
	print("[TEST PASS] Clamp superior de 100.0 (LOVE) validado com sucesso.")
	
	# Teste 4: Clamping Inferior (-100.0)
	service.modify_affinity(&"npc.blacksmith.gorn", -300.0, "betrayal")
	if state.affinity != -100.0 or state.get_stance() != RelationshipStateScript.Stance.HATE:
		push_error("[TEST FAIL] Clamp mínimo falhou. Esperado: -100.0 | Obteve: %f" % state.affinity)
		return false
	print("[TEST PASS] Clamp inferior de -100.0 (HATE) validado com sucesso.")
	
	# Teste 5: Desconto Comercial por Afinidade
	service.modify_affinity(&"npc.blacksmith.gorn", 170.0, "reset_to_friendship") # Afinidade = 70.0 (LOVE)
	var price_mod = service.get_shop_affinity_modifier(&"npc.blacksmith.gorn")
	if price_mod != 0.85:
		push_error("[TEST FAIL] Modificador de loja para LOVE deve ser 0.85 (-15%). Obteve: %f" % price_mod)
		return false
	print("[TEST PASS] Modificador de desconto comercial (0.85x) para postura LOVE validado.")
	
	# Teste 6: Persistência (Serialize / Deserialize)
	var save_data = service.serialize_all()
	var new_service = RelationshipServiceScript.new()
	new_service.deserialize_all(save_data)
	var loaded_state = new_service.get_relationship_state(&"npc.blacksmith.gorn")
	
	if loaded_state.affinity != 70.0:
		push_error("[TEST FAIL] Falha ao desserializar afinidade do Save. Esperado: 70.0 | Obteve: %f" % loaded_state.affinity)
		return false
	print("[TEST PASS] Persistência do RelationshipService validada com sucesso.")
	
	service.queue_free()
	new_service.queue_free()
	print("[TEST PASSED] TODAS AS ETAPAS DO RELATIONSHIP SYSTEM FORAM APONTADAS COM SUCESSO!\n")
	return true
