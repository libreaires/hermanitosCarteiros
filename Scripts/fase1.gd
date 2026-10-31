extends Fase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue.create_new_dialogue("Todas as encomendas de bananas cairam com esse furacão!", '"', 0.5, 24)
	dialogue.create_new_dialogue("Vamos entregar essas caixas de banana!", '"', 1, 24)
	dialogue.create_new_dialogue("Vamos pipo!", '"', 0.5, 24)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
