# SCRIPT
extends Area2D
class_name Casa


# INSPECTOR
@export var precisa_dos_dois: bool = true
@export var entregue = false
@export var tipoAtual: Tipo = Tipo.DEFAULT


# ATRIBUTES
enum Tipo {
	DEFAULT,
	TREE,
}


# GODOT
func _ready() -> void:
	$Sprite.play("default")
	

func _physics_process(_delta: float) -> void:
	atualizarSprite()
	
	if entregue: # VERIFICANDO SE JÁ FOI ENTREGUE
		return
		
	
	var macacos = []
	for body in get_overlapping_bodies():
		if body is Player:
			macacos.append(body)

	for macaco in macacos:
		if macaco.caixa_carregada != null:
			if precisa_dos_dois and macacos.size() < 2:
				return
			_entregar(macaco)
			return


func _entregar(macaco) -> void:
	entregue = true
	macaco.caixa_carregada.entregar()
	$Sprite.play("entregue")
	get_tree().current_scene.entregar()
	

func atualizarSprite() -> void:
	var spriteNode: AnimatedSprite2D = $Sprite
	if entregue and spriteNode.animation != "entregue":
		spriteNode.play("entregue")
		
	
