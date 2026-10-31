# SCRIPT
extends Area2D
class_name Cipo


# INSPECTOR
@export var impulso_saida: float = -180.0


# ATRIBÚTOS
var solto = false


# GODOT
func _ready() -> void:
	$Linha.visible = false
	$Corda.monitoring = false
	

func interagir(_macaco: Player) -> void:
	if solto:
		return
		
	
	solto = true
	$Linha.visible = true
	$Corda.set_deferred("monitoring", true)
	

func _on_corda_body_entered(body: Node2D) -> void:
	if body is Player:
		body.cipo_atual = self
		
	

func _on_corda_body_exited(body: Node2D) -> void:
	if body is Player and body.cipo_atual == self:
		body.cipo_atual = null
		if body.velocity.y < 0:
			body.velocity.y = impulso_saida
			
		
	
