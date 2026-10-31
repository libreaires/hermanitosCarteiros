@tool
extends CanvasLayer

# Scene objects
@export var Dialogue_symbol: Label:
	set(value):
		Dialogue_symbol = value
		
	

@export var Dialogue_text: Label:
	set(value):
		Dialogue_text = value
		
	

@export var Loading_audio: AudioStreamPlayer2D:
	set(value):
		Loading_audio = value
		
	

@export var Skip: AnimatedSprite2D:
	set(value):
		Skip = value
		
	

@export var speaker: AnimatedSprite2D:
	set(value):
		speaker = value

# Variables
var narrator_symbol: String = ">"
var talking_symbol: String = '"'

# Dialogues
var text_queue = []
var current_dialogue = {}
var speakerTween: Tween
var speakerScale: Vector2

# STATES
enum State {HIDDEN, WRITING, WAITING, QUESTION, AUDIO}
var CURRENT_STATE: State = State.HIDDEN

# State Updater
func update_state(new_state: String):
	if new_state == "HIDDEN":
		CURRENT_STATE = State.HIDDEN
		print("CURRENT_STATE updated to HIDDEN using update_state()")
	elif new_state == "WRITING":
		CURRENT_STATE = State.WRITING
		speaker.play("default")
		print("CURRENT_STATE updated to WRITING using update_state()")
	elif new_state == "WAITING":
		speaker.stop()
		CURRENT_STATE = State.WAITING
		print("CURRENT_STATE updated to WAITING using update_state()")
	elif new_state == "QUESTION":
		CURRENT_STATE = State.QUESTION
		print("CURRENT_STATE updated to QUESTION using update_state()")
	else:
		print("INVALID STATE!")


# GODOT
func _ready() -> void:
	update_state("HIDDEN")
	speakerScale = speaker.scale


func _process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		# Hidden state
		if CURRENT_STATE == State.HIDDEN:
			if !text_queue.is_empty():
				load_dialogue()
			else:
				self.hide()
		else:
			self.show()
		
		# Loaded state
		if CURRENT_STATE == State.WAITING:
			Skip.show()
			wait_for_skip_input()
		else:
			Skip.hide()
			
		
	


# MÉTODOS
func create_new_dialogue(text: String, symbol: String, loading_timeout_seconds: float, style_size: int):
	# creating new dictionary for storing dialogue parameters
	var NEW_DIALOGUE = {
		"text": text,
		"symbol": symbol,
		"loading_timeout_seconds": loading_timeout_seconds,
		"style_size": style_size,
		# Other for later
		# "font_color": font_color
	}
	# add to text_queue
	text_queue.push_back(NEW_DIALOGUE)

# Function for waiting for input (Skip)
func wait_for_skip_input():
	if Input.is_action_just_pressed("p*_next"):
		update_state("HIDDEN")
		
	

# Writing animation
func loading_animation () -> void:
	# setting dialogue
	Dialogue_text.text = current_dialogue.text
	Dialogue_symbol.text = current_dialogue.symbol
	
	# reseting text
	Dialogue_text.visible_ratio = 0
	
	# writing animation
	var writeTween: Tween = create_tween()
	writeTween.tween_property(Dialogue_text, "visible_ratio", 1, current_dialogue.loading_timeout_seconds)
	
	# END
	writeTween.tween_callback(update_state.bind("WAITING"))
	

# Function for showing dialogue
func load_dialogue():
	# getting current dialogue
	current_dialogue = text_queue.pop_front()
	
	# notify
	$New_text_audio.play()
	
	# update state
	update_state("WRITING")
	
	# start writing
	loading_animation()
	
