## Armazena o estado mutável em tempo de execução do relacionamento de um NPC específico.
## Mantém a afinidade persistente no intervalo de -100.0 a +100.0.

class_name RelationshipState
extends RefCounted

enum Stance {
	HATE,       # -100.0 a -60.1
	DISLIKE,    # -60.0 a -10.1
	NEUTRAL,    # -10.0 a +10.0
	LIKE,       # +10.1 a +35.0
	FRIENDSHIP, # +35.1 a +65.0
	LOVE        # +66.0 a +100.0
}

var npc_id: StringName = &""
var affinity: float = 0.0 # Trava no alcance [-100.0, 100.0]
var trust: float = 0.0
var respect: float = 0.0
var has_talked_today: bool = false
var gifts_given_count: int = 0


func _init(p_npc_id: StringName = &"", p_affinity: float = 0.0) -> void:
	npc_id = p_npc_id
	affinity = clampf(p_affinity, -100.0, 100.0)


## Altera a afinidade garantindo os limites absolutos (-100.0 a +100.0)
func add_affinity(amount: float) -> void:
	affinity = clampf(affinity + amount, -100.0, 100.0)


## Retorna a postura social atual derivada do valor numérico de afinidade
func get_stance() -> Stance:
	if affinity <= -60.1:
		return Stance.HATE
	elif affinity <= -10.1:
		return Stance.DISLIKE
	elif affinity <= 10.0:
		return Stance.NEUTRAL
	elif affinity <= 35.0:
		return Stance.LIKE
	elif affinity <= 65.0:
		return Stance.FRIENDSHIP
	else:
		return Stance.LOVE


## Serializa o estado para persistência (Save Game)
func serialize() -> Dictionary:
	return {
		"npc_id": String(npc_id),
		"affinity": affinity,
		"trust": trust,
		"respect": respect,
		"has_talked_today": has_talked_today,
		"gifts_given_count": gifts_given_count
	}


## Desserializa o estado a partir do Save Game
func deserialize(data: Dictionary) -> void:
	npc_id = StringName(data.get("npc_id", ""))
	affinity = float(data.get("affinity", 0.0))
	trust = float(data.get("trust", 0.0))
	respect = float(data.get("respect", 0.0))
	has_talked_today = bool(data.get("has_talked_today", false))
	gifts_given_count = int(data.get("gifts_given_count", 0))
