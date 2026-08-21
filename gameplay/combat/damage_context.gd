## damage_context.gd
## Objeto de dados que encapsula uma intenção de dano emitida por um atacante.

class_name DamageContext
extends RefCounted

var amount: float = 10.0
var attacker: Node2D = null
var is_critical: bool = false


func _init(p_amount: float = 10.0, p_attacker: Node2D = null, p_is_critical: bool = false) -> void:
	amount = p_amount
	attacker = p_attacker
	is_critical = p_is_critical
