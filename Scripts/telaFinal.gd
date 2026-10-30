@tool # LIVE TOOL
extends Control
class_name Tela


# INSPETOR
@export var camera: Camera2D:
	set(value):
		camera = value
		
	

@export var derrotaTipo: DerrotaTipos:
	set(value):
		derrotaTipo = value
		
	

@export var subText: Label:
	set(value):
		subText = value
		
	

@export var tipo: Tipos:
	set(value):
		tipo = value
		
	

@export var ui: CanvasLayer:
	set(value):
		ui = value
		
	


# ENUMERADORES
enum DerrotaTipos { TEMPO, INIMIGO }
enum Tipos { RETRY, NEXT }

const derrotaTextos = { TEMPO = "As encomendas não chegaram a tempo...", INIMIGO = " perdeu por " }

func _ready() -> void:
	if tipo == Tipos.RETRY:
		if Engine.is_editor_hint():
			hide()
		else:
			process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			get_tree().paused = false
			hide()
			
		
	elif tipo == Tipos.NEXT:
		if not Engine.is_editor_hint():
			pass
			
		
	

func mostrar() -> void:
	get_tree().paused = true
	ui.hide()
	show()
	

func esconder() -> void:
	get_tree().paused = false
	ui.show()
	hide()
	

func _on_jogar_pressed() -> void:
	if tipo == Tipos.NEXT:
		Global.levelAtual += 1
		get_tree().change_scene_to_file("res://Cenas/fase" + str(Global.levelAtual) + ".tscn")
	elif tipo == Tipos.RETRY:
		get_tree().reload_current_scene()
		
	

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")
	
