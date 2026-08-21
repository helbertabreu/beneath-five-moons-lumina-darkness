## profession_state.gd
## Objeto RefCounted que gerencia o estado runtime mutável de uma profissão do jogador.

class_name ProfessionState
extends RefCounted

var profession_id: StringName = &""
var current_tier: int = 1
var current_xp: float = 0.0
var max_tier: int = 5
var xp_per_tier: float = 100.0


func _init(p_id: StringName = &"", p_max_tier: int = 5, p_xp_per_tier: float = 100.0) -> void:
	profession_id = p_id
	max_tier = p_max_tier
	xp_per_tier = p_xp_per_tier


## Adiciona experiência à profissão e gerencia a subida de Tiers.
## Retorna um Dicionário com o resultado { "tier_up": bool, "old_tier": int, "new_tier": int }
func add_xp(amount: float) -> Dictionary:
	var result = {
		"tier_up": false,
		"old_tier": current_tier,
		"new_tier": current_tier
	}
	
	if amount <= 0.0 or (current_tier >= max_tier and current_xp >= xp_per_tier):
		return result
		
	current_xp += amount
	
	while current_xp >= xp_per_tier and current_tier < max_tier:
		current_xp -= xp_per_tier
		current_tier += 1
		result["tier_up"] = true
		
	# Trava de limite no último Tier
	if current_tier >= max_tier and current_xp > xp_per_tier:
		current_xp = xp_per_tier
		
	result["new_tier"] = current_tier
	return result


## Serializa o estado runtime para salvamento em JSON
func serialize() -> Dictionary:
	return {
		"profession_id": String(profession_id),
		"current_tier": current_tier,
		"current_xp": current_xp
	}


## Deserializa o estado runtime recuperado do JSON
func deserialize(data: Dictionary) -> bool:
	if not data.has("profession_id"):
		return false
	profession_id = StringName(data.get("profession_id", ""))
	current_tier = int(data.get("current_tier", 1))
	current_xp = float(data.get("current_xp", 0.0))
	return true
