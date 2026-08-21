## dialogue_definition.gd
## Resource de dados que encapsula falas e opções de diálogo de um NPC.

class_name DialogueDefinition
extends Resource

## ID único da conversa
@export var id: StringName = &""

## Nome do locutor
@export var speaker_name: String = ""

## Texto da fala principal
@export var text_content: String = ""

## Opções de resposta do jogador
@export var response_options: Array[String] = []
