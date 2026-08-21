## i_interactable.gd
## Interface/Contrato base para qualquer objeto, NPC ou recurso interativo no mundo 2D.
##
## Qualquer nó que queira responder à tecla de interação do jogador deve estender ou implementar
## os métodos definidos nesta classe.

class_name IInteractable
extends Node

## Retorna a mensagem contextual que deve ser exibida na UI (ex: "Pressione E para Conversar")
func get_interaction_text() -> String:
	return "Interagir"


## Retorna se o objeto está disponível no momento para ser interagido
func can_interact(_interactor: Node2D) -> bool:
	return true


## Executa a lógica da interação quando acionada pelo jogador
func interact(_interactor: Node2D) -> void:
	push_warning("[IInteractable] O método interact() não foi sobrescrito no nó: ", name)
