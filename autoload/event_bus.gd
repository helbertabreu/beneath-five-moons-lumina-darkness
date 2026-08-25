## EventBus.gd
## Barramento central de eventos desacoplados do projeto Beneath Five Moons / Lumina Darkness.
##
## Permite que sistemas de gameplay e componentes de interface (UI/HUD) reajam
## a fatos ocorridos no mundo sem possuir conhecimento direto das classes emissoras.

extends Node

## --- SINAL GENÉRICO DE DESPACHO DINÂMICO (UI / QUESTS) ---
signal event_emitted(event_name: StringName, payload: Dictionary)

## --- SINAIS DE EVENTOS GLOBAIS DE INFRAESTRUTURA E TEMPO ---
signal time_tick_emitted(current_day: int, current_hour: int, current_minute: int)

## --- SINAIS DE EVENTOS DE JOGADOR E SOBREVIVÊNCIA ---
signal player_stat_changed(stat_name: StringName, old_value: float, new_value: float)
signal player_died()

## --- SINAIS DE EVENTOS DE INVENTÁRIO E RECURSOS ---
signal item_added(item_id: StringName, quantity: int)
signal item_removed(item_id: StringName, quantity: int)
signal resource_gathered(resource_id: StringName, amount: int)

## --- SINAIS DE EVENTOS DA INTERFACE (UI / WINDOWS) ---
signal inventory_toggle_requested()
signal inventory_opened()
signal inventory_closed()

## --- SINAIS DE EVENTOS DO MUNDO E PERSISTÊNCIA ---
signal save_started(slot_name: String)
signal save_completed(slot_name: String)
signal load_started(slot_name: String)
signal load_completed(slot_name: String)
signal save_failed(slot_name: String, error_message: String)


## Dispara um evento genérico por nome e dicionário de dados (payload) para ouvintes desacoplados (ex: HUDView).
func emit_event(event_name: StringName, payload: Dictionary = {}) -> void:
	emit_signal(&"event_emitted", event_name, payload)


## Dispara um sinal customizado registrado dinamicamente, caso necessário.
func emit_custom_event(event_name: StringName, payload: Dictionary = {}) -> void:
	if has_user_signal(event_name):
		emit_signal(event_name, payload)
	else:
		emit_event(event_name, payload)


## Solicita globalmente a alternância de visibilidade do inventário.
func request_inventory_toggle() -> void:
	emit_signal(&"inventory_toggle_requested")
