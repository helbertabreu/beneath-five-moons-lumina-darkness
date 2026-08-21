## survival_component.gd
## Componente desacoplado de sobrevivência responsável por gerenciar as 6 necessidades essenciais:
## Vida, Fome, Fadiga, Energia, Temperatura e Conforto.
##
## Este componente escuta os impulsos do TimeService e emite eventos de atualização via EventBus.

class_name SurvivalComponent
extends Node

# --- CONFIGURAÇÕES DE BALANCEAMENTO (VALORES MÁXIMOS) ---
@export_group("Max Values")
@export var max_health: float = 100.0
@export var max_hunger: float = 100.0
@export var max_fatigue: float = 100.0
@export var max_energy: float = 100.0

# --- TAXAS DE CONSUMO POR MINUTO VIRTUAL ---
@export_group("Decay Rates (Per Game Minute)")
@export var hunger_decay_rate: float = 0.5  # Perde 0.5 de Fome por minuto do jogo
@export var fatigue_growth_rate: float = 0.2 # Ganha 0.2 de Fadiga por minuto do jogo

# --- ESTADO ATUAL DE RUNTIME ---
var health: float = 100.0
var hunger: float = 100.0
var fatigue: float = 0.0
var energy: float = 100.0
var temperature: float = 0.0 # 0.0 = Neutro (-50 Frio Extremo, +50 Calor Extremo)
var comfort: float = 100.0

# Referência local ao TimeService
var _time_service: Node = null


func _ready() -> void:
	health = max_health
	hunger = max_hunger
	fatigue = 0.0
	energy = max_energy
	
	# Aguarda 2 frames para garantir inicialização completa da árvore e dos Autoloads
	await get_tree().process_frame
	await get_tree().process_frame
	_subscribe_to_services()


func _subscribe_to_services() -> void:
	# 1. Tenta obter do ServiceRegistry
	if ServiceRegistry:
		_time_service = ServiceRegistry.get_service(&"TimeService")
	
	# 2. Fallback: Se não encontrou no Registry, tenta acessar o Autoload direto da raiz
	if not _time_service and get_tree().root.has_node("TimeService"):
		_time_service = get_tree().root.get_node("TimeService")
	
	# 3. Conecta o sinal se o serviço for válido
	if _time_service and _time_service.has_signal("minute_passed"):
		if not _time_service.minute_passed.is_connected(_on_minute_passed):
			_time_service.minute_passed.connect(_on_minute_passed)
		print("[SurvivalComponent] Conectado com sucesso ao TimeService.")
	else:
		push_warning("[SurvivalComponent] TimeService não encontrado ou sem sinal 'minute_passed'.")


## Executado a cada minuto de tempo virtual do jogo
func _on_minute_passed(_day: int, _hour: int, _minute: int) -> void:
	consume_hunger(hunger_decay_rate)
	increase_fatigue(fatigue_growth_rate)


## Consome fome e emite notificação via EventBus
func consume_hunger(amount: float) -> void:
	hunger = clampf(hunger - amount, 0.0, max_hunger)
	print("[SurvivalComponent] Fome atualizada: %.1f / %.1f (-%.1f)" % [hunger, max_hunger, amount])
	
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"HungerChanged", {"current": hunger, "max": max_hunger})
		
	if hunger <= 0.0:
		_apply_starvation_damage()


## Incrementa a fadiga física do personagem
func increase_fatigue(amount: float) -> void:
	fatigue = clampf(fatigue + amount, 0.0, max_fatigue)
	
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"FatigueChanged", {"current": fatigue, "max": max_fatigue})


## Aplica dano por fome extrema (Starvation)
func _apply_starvation_damage() -> void:
	health = clampf(health - 1.0, 0.0, max_health)
	print("[SurvivalComponent] AVISO: Jogador sofrendo dano por fome! Vida atual: ", health)
	
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"HealthChanged", {"current": health, "max": max_health})


## Retorna o dicionário serializável com o estado do componente para o Save System
func get_save_data() -> Dictionary:
	return {
		"health": health,
		"hunger": hunger,
		"fatigue": fatigue,
		"energy": energy,
		"temperature": temperature,
		"comfort": comfort
	}


## Restaura o estado do componente a partir de um save
func load_save_data(data: Dictionary) -> void:
	health = data.get("health", max_health)
	hunger = data.get("hunger", max_hunger)
	fatigue = data.get("fatigue", 0.0)
	energy = data.get("energy", max_energy)
	temperature = data.get("temperature", 0.0)
	comfort = data.get("comfort", 100.0)
