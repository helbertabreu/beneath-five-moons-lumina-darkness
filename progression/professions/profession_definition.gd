## profession_definition.gd
## Resource de dados estáticos que define os parâmetros e requisitos de uma Profissão.

class_name ProfessionDefinition
extends Resource

## ID único do identificador da profissão (ex: &"profession.blacksmith")
@export var id: StringName = &""

## Nome exibido na interface do usuário (ex: "Ferraria")
@export var display_name: String = ""

## Descrição da utilidade e foco da profissão
@export var description: String = ""

## Nível máximo de maestria/Tier (Padrão: 5 Tiers)
@export var max_tier: int = 5

## XP necessária para avançar cada Tier (Padrão: 100.0)
@export var xp_per_tier: float = 100.0

## Bônus de eficiência percentual concedido por Tier de maestria (ex: 0.10 = +10%)
@export var efficiency_bonus_per_tier: float = 0.10

## IDs das estações de crafting compatíveis com esta profissão
@export var allowed_stations: Array[StringName] = []
