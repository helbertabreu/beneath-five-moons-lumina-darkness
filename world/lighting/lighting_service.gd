## lighting_service.gd
## Serviço responsável por monitorar o estado global de luz e notificar o sistema via EventBus.

class_name LightingService
extends Node

var current_context: LightingContext = null


func _ready() -> void:
	current_context = LightingContext.new(0.20) # Penumbra padrão no início
	
	if ServiceRegistry:
		ServiceRegistry.register_service(&"LightingService", self)
		
	print("[LightingService] Serviço de Iluminação 2D registrado com sucesso. Estado inicial: ", current_context.get_level_name())


## Atualiza o nível de iluminação e dispara evento caso altere
func update_player_light(illumination_value: float) -> void:
	if not current_context:
		current_context = LightingContext.new(illumination_value)
	else:
		current_context.set_value(illumination_value)
		
	print("[LightingService] Nível de Luz do Jogador: %.2f (%s)" % [current_context.value, current_context.get_level_name()])
	
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"LightLevelChanged", {
			"value": current_context.value,
			"level_name": current_context.get_level_name()
		})
