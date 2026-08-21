## TimeService.gd
## Serviço responsável por gerenciar o relógio lógico e o avanço temporal do mundo.
##
## Converte o delta de tempo real em minutos, horas e dias de jogo.
## Notifica o EventBus e emite sinais locais a cada alteração de minuto virtual.

extends Node

## Sinais locais do serviço temporal
signal minute_passed(day: int, hour: int, minute: int)
signal hour_passed(day: int, hour: int)
signal day_passed(day: int)

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
		print("[TimeService] Registrado com sucesso no ServiceRegistry.")


func _process(delta: float) -> void:
	if is_paused:
		return
	
	_accumulated_time += delta
	
	while _accumulated_time >= seconds_per_game_minute:
		_accumulated_time -= seconds_per_game_minute
		_advance_minute()


## Avança um minuto no relógio lógico, emite sinais locais e notifica o EventBus
func _advance_minute() -> void:
	current_minute += 1
	var new_hour: bool = false
	var new_day: bool = false
	
	if current_minute >= 60:
		current_minute = 0
		current_hour += 1
		new_hour = true
		
		if current_hour >= 24:
			current_hour = 0
			current_day += 1
			new_day = true
	
	# Dispara o sinal local do TimeService
	minute_passed.emit(current_day, current_hour, current_minute)
	
	if new_hour:
		hour_passed.emit(current_day, current_hour)
	if new_day:
		day_passed.emit(current_day)
	
	# Dispara o evento desacoplado no EventBus
	if EventBus:
		if EventBus.has_signal("time_tick_emitted"):
			EventBus.time_tick_emitted.emit(current_day, current_hour, current_minute)
		elif EventBus.has_signal("event_emitted"):
			EventBus.emit_signal("event_emitted", &"TimeTick", {
				"day": current_day,
				"hour": current_hour,
				"minute": current_minute
			})


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
