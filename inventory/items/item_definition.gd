## item_definition.gd
## Resource estático que define as propriedades fundamentais de um item no jogo.
##
## Representa o modelo estático (dados de conteúdo) imutável.

class_name ItemDefinition
extends Resource

## ID único e estável do item (ex: "item.material.iron_ore")
@export var id: StringName = &""

## Nome visível na interface (Será traduzido no futuro via ID de localização)
@export var name: String = ""

## Descrição detalhada do item
@export_multiline var description: String = ""

## Ícone de exibição no inventário
@export var icon: Texture2D = null

## Categoria do item para filtros (ex: &"Material", &"Weapon", &"Consumable", &"Fuel")
@export var category: StringName = &"Material"

## Indica se o item pode ser acumulado em uma única pilha
@export var is_stackable: bool = true

## Tamanho máximo da pilha (se for empilhável)
@export var max_stack_size: int = 99

## Preço base de comércio para o sistema econômico
@export var base_price: int = 10
