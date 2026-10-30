# SCRIPT
extends AnimatedSprite2D
class_name PlayerSprite


# MÉTODOS
func _trigger_animation(velocity: Vector2, direction: int):
	if direction > 0:
		flip_h = false
	else:
		flip_h = true
		
	
	# LÓGICA SPRITE
	if get_parent().caixa_carregada and direction == 0:
		play("caixa")
	elif get_parent().caixa_carregada and direction != 0:
		play("caixa_run")
	elif get_parent().caixa_carregada and not get_parent().is_on_floor():
		play("caixa_jump")
	elif not get_parent().is_on_floor():
		play("jump")
	elif velocity.x != 0:
		play("run")
	elif Input.is_action_pressed($"..".prefixo + "_action"):
		play("caixa")
	else:
		play("idle")
		
	
