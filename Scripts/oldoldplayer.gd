# SCRIPT
extends CharacterBody2D
# class_name Player


# INSPECTOR
@export_group("Controles")
@export var prefixo: String = "p1"

@export_group("Locomotion")
@export var speed: float = 240.0
@export var jump_velocity: float = -350.0
@export var run_speed_damping: float = 4.8
@export var desaceleracao: float = 150.0

@export_group("Colaboração")
@export var cabeca_e_plataforma: bool = false
@export var forte: bool = false
@export var velocidade_subida: float = 90.0

@export_group("Stomping Enemies")
@export var min_stomp_degree: float = 35
@export var max_stomp_degree: float = 145
@export var stomp_y_velocity: float = -150

@export_group("Dano")
@export var tempo_atravessando: float = 0.45
@export var tempo_invencivel: float = 1.2
@export var morre_com_passaro: bool = false   # marque só no macaco
@export var cena_derrota: PackedScene          # opcional

var morto = false

# ATRIBÚTOS
var invencivel = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var cipo_atual = null
var caixa_carregada = null
var defaultScale: Vector2
var newTween: Tween


# GODOT
func _ready() -> void:
	defaultScale = $Sprite.scale
	add_to_group("jogadores")
	if cabeca_e_plataforma:
		add_collision_exception_with($Head)
	else:
		if has_node("Head"):
			$Head.queue_free()
			
		
	

func _physics_process(delta: float) -> void:
	if cabeca_e_plataforma and "caixa" in $Sprite.animation and has_node("Head"):
		$Head/Collision.disabled = false
	elif has_node("Head"):
		$Head/Collision.disabled = true
		
	
	if cipo_atual != null:
		if Input.is_action_pressed(prefixo + "_jump"):
			invencibleEdit()
			velocity.y = -velocidade_subida
		else:
			velocity.y = 0
			
	elif not is_on_floor():
		invencibleEdit()	
		velocity.y += gravity * delta
		
	
	if cipo_atual == null:
		if Input.is_action_just_pressed(prefixo + "_jump") and is_on_floor():
			invencibleEdit()
			velocity.y = jump_velocity
			
		
		if Input.is_action_just_released(prefixo + "_jump") and velocity.y < 0:
			velocity.y *= 0.5
			
		
	
	if Input.is_action_just_pressed(prefixo + "_action"):
		invencibleEdit()
		_interagir()
		
	
	var direction = Input.get_axis(prefixo + "_left", prefixo + "_right")
	
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, desaceleracao * delta)
		
	
	$Sprite._trigger_animation(velocity, direction)
	move_and_slide()
	
	if direction:
		if not newTween:
			newTween = create_tween()
			newTween.set_ease(Tween.EASE_IN_OUT)
			newTween.tween_property($Sprite, "skew", direction / 4, 1)
	else:
		if newTween:
			newTween.kill()
			newTween = null
		$Sprite.skew = 0
		
	


# MÉTODOS
func _interagir() -> void:
	print("Overlapping areas found: ", $Area.get_overlapping_areas())
	for area in $Area.get_overlapping_areas():
		if area != caixa_carregada and area.get_parent() and area.get_parent().has_method("interagir") and not velocity.y:
			area.get_parent().interagir(self)
			return
		elif area is Cipo and area.has_method("interagir") and not velocity.y:
			area.interagir(self)
			return
			
		
	
	if caixa_carregada and is_on_floor():
		caixa_carregada.soltar()
		
	
	invencibleEdit()
	

func invencibleEdit() -> void:
	resetScale()
	var newTween = create_tween()
	newTween.set_ease(Tween.EASE_IN_OUT)
	newTween.tween_property($Sprite, "scale", Vector2(defaultScale.x, defaultScale.y - 0.01), 0.1)
	newTween.chain().tween_property($Sprite, "scale", Vector2(defaultScale.x, defaultScale.y + 0.01), 0.1)
	newTween.tween_callback(resetScale)
	

func resetScale() -> void:
	$Sprite.scale = defaultScale
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not (area is Enemy) or invencivel or morto:
		return
		
	if (area is Enemy):
		var angle: float = rad_to_deg(position.angle_to_point((area as Enemy).position))
		if angle > min_stomp_degree and angle < max_stomp_degree:
			(area as Enemy)._die()
			velocity.y = stomp_y_velocity
		elif area is Passaro and morre_com_passaro:
			_morrer()
		else:
			_levar_dano()
			
	
	if area is Espinho:
		_levar_dano()
		return
		
	
func _morrer() -> void:
	if morto:
		return
	morto = true
	invencivel = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	$Area.set_deferred("monitoring", false)
	collision_layer = 0
	collision_mask = 0

	var t = create_tween()
	t.tween_property(self, "rotation_degrees", 180, 0.2)
	t.parallel().tween_property(self, "position:y", position.y - 25, 0.2)
	t.chain().tween_property(self, "position:y", position.y + 500, 1.0)
	await t.finished

	if cena_derrota:
		get_tree().change_scene_to_packed(cena_derrota)
	else:
		get_tree().reload_current_scene()

func _levar_dano():
	invencivel = true
	velocity = Vector2.ZERO
	set_collision_mask_value(5, false)
	var pisca = create_tween().set_loops()
	pisca.tween_property(self, "modulate:a", 0.3, 0.1)
	pisca.tween_property(self, "modulate:a", 1.0, 0.1)
	await get_tree().create_timer(tempo_atravessando).timeout
	set_collision_mask_value(5, true)
	await get_tree().create_timer(tempo_invencivel).timeout
	pisca.kill()
	modulate.a = 1.0
	invencivel = false
	
