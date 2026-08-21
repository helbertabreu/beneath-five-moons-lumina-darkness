## Define a configuração estática e ideológica de uma facção, religião ou vilarejo.
##
## Contém metadados visíveis, alinhamento, rivalidades e facções aliadas por padrão.
class_name FactionDefinition
extends Resource

## Enumeração de Posturas de Facção (Stance)
enum Stance {
	HATED,      # 0 a 999 - Hostil / Inimigo atacável
	NEUTRAL,    # 1.000 a 2.999 - Neutro / Desconhecido
	RECOGNIZED, # 3.000 a 5.999 - Reconhecido
	RESPECTED,  # 6.000 a 8.999 - Respeitado / Desconto Comercial
	ALLIED      # 9.000 a 10.000 - Aliado Máximo / Líder
}

## Identificador único da facção (ex: &"faction.alignment_guardians")
@export var faction_id: StringName = &"faction.default"

## Nome visível da facção
@export var display_name: String = "Facção Desconhecida"

## Descrição detalhada e lore
@export_multiline var description: String = ""

## Pontuação inicial padrão de reputação (0.0 a 10000.0)
@export_range(0.0, 10000.0) var default_reputation: float = 0.0

## Dicionário de rivalidades (StringName -> float): Multiplicador de perda/ganho inverso.
## Exemplo: Se ganhar 100 rep com A, perde (100 * rival_multiplier) com a facção B.
@export var rival_factions: Dictionary = {}


## Converte uma pontuação numérica de reputação em um nível de Stance.
static func get_stance_from_reputation(rep_points: float) -> Stance:
	var rep: float = clampf(rep_points, 0.0, 10000.0)
	
	if rep >= 9000.0:
		return Stance.ALLIED
	elif rep >= 6000.0:
		return Stance.RESPECTED
	elif rep >= 3000.0:
		return Stance.RECOGNIZED
	elif rep >= 1000.0:
		return Stance.NEUTRAL
	else:
		return Stance.HATED
