## hungry_wolf_node.gd
## Inimigo 2D (Lobo Esfomeado) que estende Area2D e reage ao nível de iluminação.
## Quando exposto à Luz Plena, sofre penalidade de defesa e recua.

extends Area2D

var health: float = 40.0
var max_health: float = 40.0
var base_defense_multiplier: float = 1.0

var _visual_rect: ColorRect = null


func _ready() -> void:
	monitorable = true
	monitoring = true
	
	# Colisão do Inimigo (Raio de 20px)
	var col_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 20.0
	col_shape.shape = circle
	add_child(col_shape)
	
	# Visual provisório do Inimigo (Retângulo Vermelho Escuro)
	_visual_rect = ColorRect.new()
	_visual_rect.custom_minimum_size = Vector2(22, 22)
	_visual_rect.position = Vector2(-11, -11)
	_visual_rect.color = Color(0.8, 0.1, 0.1, 1.0) # Vermelho
	add_child(_visual_rect)
	
	print("[Lobo Esfomeado] Inimigo gerado no mapa. HP: %.1f / %.1f" % [health, max_health])


## Contrato IDamageable: Recebe o golpe e aplica multiplicador de luz
func receive_damage(damage_ctx: DamageContext) -> void:
	var final_damage = damage_ctx.amount
	
	# Consulta o serviço de luz para verificar sensibilidade
	var light_service = ServiceRegistry.get_service(&"LightingService") as LightingService
	if light_service and light_service.current_context:
		var light_val = light_service.current_context.value
		if light_val >= 0.70: # Luz Plena
			final_damage *= 2.0 # Recebe o dobro de dano por estar ofuscado
			print("[Lobo Esfomeado] OFUSCADO PELA LUZ! Dano amplificado para 2x!")
			
	health -= final_damage
	print("[Lobo Esfomeado] Recebeu %.1f de dano. HP restante: %.1f / %.1f" % [final_damage, max_health, maxf(0.0, health)])
	
	# Pisca em branco para feedback visual
	if _visual_rect:
		_visual_rect.color = Color(1.0, 1.0, 1.0, 1.0)
		await get_tree().create_timer(0.1).timeout
		_visual_rect.color = Color(0.8, 0.1, 0.1, 1.0)
		
	if health <= 0.0:
		_die()


func _die() -> void:
	print("[Lobo Esfomeado] Inimigo derrotado!")
	if EventBus and EventBus.has_signal("event_emitted"):
		EventBus.emit_signal("event_emitted", &"EnemyDefeated", {"enemy_id": &"enemy.wolf.hungry_wolf", "xp_reward": 50.0})
	queue_free()
