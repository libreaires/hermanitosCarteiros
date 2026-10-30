extends Camera2D

# QUEST III: a camera segue o macaco que estiver MAIS EMBAIXO.
# Assim quem ficou para tras nunca some da tela, e quem subiu
# continua visivel enquanto estiver no mesmo andar.

func _process(_delta: float) -> void:
	
	var jogadores = get_tree().get_nodes_in_group("jogadores")
	if jogadores.is_empty(): return
	

	# No Godot 2D o eixo Y cresce para BAIXO: "mais embaixo" = maior y.
	var y_mais_baixo = jogadores[0].global_position.y
	for jogador in jogadores:
		y_mais_baixo = max(y_mais_baixo, jogador.global_position.y)
		
	if y_mais_baixo >= -64:
		global_position.y = -64
	else:
		global_position.y = y_mais_baixo
	
