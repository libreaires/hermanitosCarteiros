# SCRIPT
@tool
extends Player # SCRIPTS DO PLAYER ESTÃO EM Scripts/player.gd
class_name Carregador # ISSO É APENAS UM FERRAMENTA PARA DEBUG DA CAIXA


# INSPECTOR
@export var debug: bool = false:
	set(value):
		debug = value
		
	

@export var debugCaixa: Sprite2D:
	set(value):
		debugCaixa = value
		
	

@export var alturaCaixa: float:
	set(value):
		alturaCaixa = value
		
	


# GODOT
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		if $Sprite.animation.contains("caixa") and debug:
			debugCaixa.show()
			debugCaixa.texture = load("res://icon.svg")
			debugCaixa.offset = Vector2(0, -64)
			debugCaixa.position.y = -alturaCaixa
		else:
			debugCaixa.hide()
			
	else:
		debugCaixa.hide()
		super._physics_process(delta)
		
	
