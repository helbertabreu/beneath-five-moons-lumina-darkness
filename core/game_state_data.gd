## GameStateData.gd
## Container serializável de dados do estado do jogo.
##
## Armazena o estado lógico do jogador, do tempo e do mundo,
## permitindo converter todos os dados para Dicionário JSON e vice-versa.

class_name GameStateData
extends RefCounted

## Versão do esquema de dados do Save
const SAVE_VERSION: int = 1

## Dados da Sessão / Cabeçalho
var save_version: int = SAVE_VERSION
var save_timestamp: int = 0
var play_time_seconds: float = 0.0

## Estado do Jogador
var player_id: StringName = &"ent.player.001"
var player_name: String = "Explorador"
var player_origin: StringName = &"origin.orphan"
var health: float = 100.0
var hunger: float = 100.0
var fatigue: float = 0.0
var energy: float = 100.0
var temperature: float = 37.0
var comfort: float = 50.0

## Estado do Tempo
var current_day: int = 1
var current_hour: int = 6
var current_minute: int = 0

## Estado do Inventário (Dicionário de ID_Item -> Quantidade)
var inventory_items: Dictionary = {}

## Estado de Flags de Mundo e Relacionamentos
var world_flags: Dictionary = {}
var reputation_data: Dictionary = {}


## Converte todo o estado para Dicionário compatível com JSON.
func serialize() -> Dictionary:
	return {
		"save_version": save_version,
		"save_timestamp": Time.get_unix_time_from_system(),
		"play_time_seconds": play_time_seconds,
		"player": {
			"player_id": String(player_id),
			"player_name": player_name,
			"player_origin": String(player_origin),
			"health": health,
			"hunger": hunger,
			"fatigue": fatigue,
			"energy": energy,
			"temperature": temperature,
			"comfort": comfort
		},
		"time": {
			"current_day": current_day,
			"current_hour": current_hour,
			"current_minute": current_minute
		},
		"inventory": inventory_items,
		"world_flags": world_flags,
		"reputation": reputation_data
	}


## Reconstrói o estado do jogo a partir de um Dicionário JSON.
func deserialize(data: Dictionary) -> bool:
	if not data.has("save_version"):
		push_error("GameStateData: Arquivo de save inválido (Sem chave save_version).")
		return false
	
	save_version = int(data.get("save_version", 1))
	save_timestamp = int(data.get("save_timestamp", 0))
	play_time_seconds = float(data.get("play_time_seconds", 0.0))
	
	if data.has("player"):
		var p: Dictionary = data["player"]
		player_id = StringName(p.get("player_id", "ent.player.001"))
		player_name = String(p.get("player_name", "Explorador"))
		player_origin = StringName(p.get("player_origin", "origin.orphan"))
		health = float(p.get("health", 100.0))
		hunger = float(p.get("hunger", 100.0))
		fatigue = float(p.get("fatigue", 0.0))
		energy = float(p.get("energy", 100.0))
		temperature = float(p.get("temperature", 37.0))
		comfort = float(p.get("comfort", 50.0))
	
	if data.has("time"):
		var t: Dictionary = data["time"]
		current_day = int(t.get("current_day", 1))
		current_hour = int(t.get("current_hour", 6))
		current_minute = int(t.get("current_minute", 0))
	
	inventory_items = data.get("inventory", {})
	world_flags = data.get("world_flags", {})
	reputation_data = data.get("reputation", {})
	
	return true
