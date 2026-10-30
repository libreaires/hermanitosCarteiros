# ÚLTIMA ALTERAÇÃO: 16/10
# ALTERAÇÃO: AIRES
# SCRIPT
extends Enemy
class_name Besouro


# MÉTODOS
func _die(): # MÉTODO DO ENEMY
	super._die() # CHAMANDO _die() ORIGINAL
	desativarCollisions() # MÉTODO DO ENEMY
	prepararDeletion() # MÉTODO DO ENEMY
	
