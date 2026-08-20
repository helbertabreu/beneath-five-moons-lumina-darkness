## TimeService.gd
## Serviço responsável por gerenciar o relógio lógico e o avanço temporal do mundo.
##
## Converte o delta de tempo real em minutos, horas e dias de jogo.
## Notifica o EventBus a cada alteração de minuto virtual.

extends Node

## Configurações de escala de tempo (Segundos reais por minuto do jogo)
@export var seconds_per_game_minute: float = 1.0

## Estado do Relógio Lógico
var current_day: int = 1
var current_hour: int = 6
var current_minute: int = 0

var is_paused: bool = false
var _accumulated_time: float = 0.0


func _ready() -> void:
	# Registra este serviço no ServiceRegistry global no Boot
	if ServiceRegistry:
		ServiceRegistry.register_service(&"TimeService", self)


func _process(delta: float) -> void:
	if is_paused:
		return
	
	_accumulated_time += delta
	
	while _accumulated_time >= seconds_per_game_minute:
		_accumulated_time -= seconds_per_game_minute
		_advance_minute()


## Avança um minuto no relógio lógico e emite o evento no EventBus.
func _advance_minute() -> void:
	current_minute += 1
	
	if current_minute >= 60:
		current_minute = 0
		current_hour += 1
		
		if current_hour >= 24:
			current_hour = 0
			current_day += 1
	
	# Dispara o evento desacoplado no EventBus
	if EventBus:
		EventBus.time_tick_emitted.emit(current_day, current_hour, current_minute)


## Pausa o progresso do tempo lógico.
func pause_time() -> void:
	is_paused = true


## Retoma o progresso do tempo lógico.
func resume_time() -> void:
	is_paused = false


## Avança forçadamente uma quantidade de horas (ex: ao dormir).
func advance_hours(hours: int) -> void:
	for i in range(hours * 60):
		_advance_minute()
