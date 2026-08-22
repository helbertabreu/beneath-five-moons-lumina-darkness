## Define as preferências sociais, presentes favoritos e limites de relacionamento de um NPC.
## Permite configurar o comportamento social de forma orientada a dados (Data-Driven).

class_name RelationshipDefinition
extends Resource

## ID único do NPC (ex: &"npc.blacksmith.gorn")
@export var npc_id: StringName = &""

## Nome de exibição do NPC
@export var display_name: String = "NPC"

## Itens amados pelo NPC (Gera +20.0 de afinidade ao presentear)
@export var loved_item_ids: Array = []

## Itens gostados pelo NPC (Gera +10.0 de afinidade ao presentear)
@export var liked_item_ids: Array = []

## Itens odiados pelo NPC (Gera -15.0 de afinidade ao presentear)
@export var hated_item_ids: Array = []

## Ganho de afinidade por conversa diária
@export var daily_talk_affinity_gain: float = 2.0


## Avalia a reação do NPC a um item doado como presente
func evaluate_gift(item_id: StringName) -> float:
	if loved_item_ids.has(item_id):
		return 20.0
	elif liked_item_ids.has(item_id):
		return 10.0
	elif hated_item_ids.has(item_id):
		return -15.0
	return 2.0 # Presente neutro comum
