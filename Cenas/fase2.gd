extends Fase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue.create_new_dialogue("TAPORRA", '"', 0.5, 24)
	dialogue.create_new_dialogue("EU TO COM PREGUIÇA JA VEI", '"', 1, 24)
	dialogue.create_new_dialogue("pão de queijo com requeijao", '"', 0.5, 24)
	dialogue.create_new_dialogue("meus tung tungs!", '"', 1, 24)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
