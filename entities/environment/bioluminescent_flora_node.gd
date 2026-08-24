## bioluminescent_flora_node.gd
## Entidade ambiental representando uma planta bioluminescente do Setor Escuro.
## Emite uma ilha de luz pulsante que altera o nível de iluminação das entidades que entrarem na sua área.

class_name BioluminescentFloraNode
extends Area2D

## Raio da ilha de luz em pixels
@export var light_radius: float = 80.0

## Intensidade base de iluminação fornecida ao jogador (0.75 = Luz Plena)
@export var illumination_value: float = 0.75

## Velocidade do ciclo de pulsação suave da iluminação
@export var pulse_speed: float = 2.0

## Variação mínima e máxima da energia da luz (para efeito estético de respiração)
@export var min_energy: float = 0.8
@export var max_energy: float = 1.3

var _point_light: PointLight2D = null
var _visual_shape: Polygon2D = null
var _pulse_time: float = 0.0
var _is_player_inside: bool = false


func _ready() -> void:
	monitoring = true
	monitorable = true
	
	# 1. Configura a colisão física da área de detecção
	var col_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = light_radius
	col_shape.shape = circle
	add_child(col_shape)
	
	# 2. Configura o visual da planta (Polígono circular ciano/esmeralda)
	_visual_shape = Polygon2D.new()
	var points: PackedVector2Array = []
	var num_sides = 8
	for i in range(num_sides):
		var angle = i * (PI * 2.0 / num_sides)
		points.append(Vector2(cos(angle), sin(angle)) * 12.0)
	_visual_shape.polygon = points
	_visual_shape.color = Color(0.1, 0.9, 0.7, 0.8) # Ciano bioluminescente
	add_child(_visual_shape)
	
	# 3. Configura o PointLight2D com gradiente radial suave
	_point_light = PointLight2D.new()
	_point_light.color = Color(0.2, 1.0, 0.8, 1.0)
	_point_light.energy = 1.0
	_point_light.texture = _generate_radial_gradient_texture()
	_point_light.texture_scale = light_radius / 32.0
	add_child(_point_light)
	
	# Conecta os sinais de entrada e saída de corpos
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	print("[BioluminescentFloraNode] Flora bioluminescente inicializada no Setor Escuro.")


func _process(delta: float) -> void:
	# Efeito de pulso orgânico suave da luz
	_pulse_time += delta * pulse_speed
	var pulse_factor = (sin(_pulse_time) + 1.0) / 2.0 # Oscila entre 0.0 e 1.0
	if _point_light:
		_point_light.energy = lerpf(min_energy, max_energy, pulse_factor)


## Gera dinamicamente uma textura de gradiente radial para a luz 2D
func _generate_radial_gradient_texture() -> GradientTexture2D:
	var gradient = Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 1.0)) # Centro brilhante
	gradient.set_color(1, Color(1, 1, 1, 0.0)) # Borda suave transparente
	
	var texture = GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(0.5, 0.0)
	texture.width = 64
	texture.height = 64
	return texture


func _on_body_entered(body: Node2D) -> void:
	# Se a entidade for o jogador ou possuir um marcador/grupo de player
	if body.name.begins_with("Player") or body.is_in_group("Player"):
		_is_player_inside = true
		_apply_light_to_player()


func _on_body_exited(body: Node2D) -> void:
	if body.name.begins_with("Player") or body.is_in_group("Player"):
		_is_player_inside = false
		_restore_ambient_light()


## Eleva a luz do jogador ao entrar na ilha bioluminescente
func _apply_light_to_player() -> void:
	var lighting_service = ServiceRegistry.get_service(&"LightingService") as LightingService
	if lighting_service:
		lighting_service.update_player_light(illumination_value)
		print("[BioluminescentFloraNode] Jogador entrou na ilha de luz! Iluminação elevada para: %.2f" % illumination_value)


## Restaura a luz do ambiente (penumbra) ao sair da área
func _restore_ambient_light() -> void:
	var lighting_service = ServiceRegistry.get_service(&"LightingService") as LightingService
	if lighting_service:
		lighting_service.update_player_light(0.20) # Retorna para a Penumbra Padrão
		print("[BioluminescentFloraNode] Jogador saiu da ilha de luz. Retornando para a Penumbra do ambiente.")
