## EventBus.gd
## Barramento central de eventos desacoplados do projeto.
##
## Permite que sistemas de gameplay reajam a fatos ocorridos no mundo (Events)
## sem possuir conhecimento direto das classes emissoras.

extends Node

## Sinais de Eventos Globais de Infraestrutura e Tempo
signal time_tick_emitted(current_day: int, current_hour: int, current_minute: int)

## Sinais de Eventos de Jogador e Sobrevivência
signal player_stat_changed(stat_name: StringName, old_value: float, new_value: float)
signal player_died()

## Sinais de Eventos de Inventário e Recursos
signal item_added(item_id: StringName, quantity: int)
signal item_removed(item_id: StringName, quantity: int)
signal resource_gathered(resource_id: StringName, amount: int)

## Sinais de Eventos do Mundo e Persistência
signal save_started(slot_name: String)
signal save_completed(slot_name: String)
signal load_started(slot_name: String)
signal load_completed(slot_name: String)
signal save_failed(slot_name: String, error_message: String)


## Dispara um sinal genérico ou customizado registrado dinamicamente, caso necessário.
func emit_custom_event(event_name: StringName, payload: Dictionary = {}) -> void:
	if has_user_signal(event_name):
		emit_signal(event_name, payload)
	else:
		push_warning("EventBus: Sinal customizado '%s' não registrado no EventBus." % event_name)
