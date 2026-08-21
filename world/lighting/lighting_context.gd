## lighting_context.gd
## Objeto de dados (RefCounted) que transporta o estado atual de iluminação recebido por um ator.

class_name LightingContext
extends RefCounted

enum LightLevel {
	ABSOLUTE_DARKNESS, # 0.00 a 0.15
	PENUMBRA,          # 0.15 a 0.35
	MODERATE,          # 0.35 a 0.70
	FULL               # 0.70 a 1.00
}

## Valor bruto de iluminação normalizado (0.0 a 1.0)
var value: float = 0.0

## Nível categorizado de luz
var level: LightLevel = LightLevel.ABSOLUTE_DARKNESS


func _init(p_value: float = 0.0) -> void:
	set_value(p_value)


## Atualiza o valor bruto e recalcula a categoria correspondente
func set_value(p_value: float) -> void:
	value = clampf(p_value, 0.0, 1.0)
	
	if value <= 0.15:
		level = LightLevel.ABSOLUTE_DARKNESS
	elif value <= 0.35:
		level = LightLevel.PENUMBRA
	elif value <= 0.70:
		level = LightLevel.MODERATE
	else:
		level = LightLevel.FULL


## Retorna a representação textual da categoria de luz para logs/UI
func get_level_name() -> String:
	match level:
		LightLevel.ABSOLUTE_DARKNESS:
			return "Escuridão Absoluta"
		LightLevel.PENUMBRA:
			return "Penumbra"
		LightLevel.MODERATE:
			return "Luz Moderada"
		LightLevel.FULL:
			return "Luz Plena"
		_:
			return "Desconhecido"
