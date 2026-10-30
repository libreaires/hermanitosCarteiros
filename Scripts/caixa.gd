# ÚLTIMA ALTERAÇÃO: 16/10
# ALTERAÇÃO: AIRES
# LEIA: TODO SPRITE DE CAIXA DEVE SER 32x32 com scale de 0.2!
# SCRIPT
extends RigidBody2D
class_name Caixa


# INSPECTOR
@export var pesada: bool = false

var caixaNum: int = 1


# ATRIBÚTOS
var carregador = null


# GODOT
func _ready() -> void:
	$Sprite.offset = Vector2(0, -32)
	freeze = true
	

func _physics_process(_delta: float) -> void:
	if carregador:
		global_position = carregador.global_position + Vector2(0, -carregador.alturaCaixa * carregador.scale.y)
		
	elif not carregador:
		freeze = false
		
	


# MÉTODOS
func interagir(macaco: Carregador) -> void:
	if carregador or macaco.caixa_carregada:
		print("você já está carregando uma caixa, e a gente ainda não fez a opção de mais de uma caixa pq a gente é burro, desculpa ;-;")
		return
		
	
	if pesada and not macaco.forte:
		print("você naum é forte o suficiente, desculpa ;-;")
		return
		
	
	print("você agora está segurando uma caixa!")
	carregador = macaco
	macaco.caixa_carregada = self
	

func soltar() -> void:
	carregador.caixa_carregada = null
	carregador = null
	freeze = false
	

func entregar() -> void:
	carregador.caixa_carregada = null
	queue_free()
	


func _on_body_entered(body: Node) -> void:
	if body is TileMapLayer and not freeze:
		freeze = true
		
	
