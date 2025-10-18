extends StaticBody2D
class_name Npc

@onready var interactionlabel: Label = $Area2D/InteractionLabel
@onready var dialogue_box: Label = $Area2D/CanvasLayer/DialogueBox
@onready var dialogue_text: Label = $Area2D/CanvasLayer/DialogueText
@onready var creeper: Sprite2D = $Area2D/CanvasLayer/creeper

var _character_ref: BaseCharacter = null
var talking = false
var keep_going = false
var showing_text = false
var current_text = ""
var skip_text = false
var index_line = 0

var lines = [
	"POYO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
	"Vai se fuder.",
	"HAAAAY!!!!!!!!!!!!",
	"sai daqui",
	"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
]

func _ready() -> void:
	dialogue_box.visible = false
	dialogue_text.visible = false
	interactionlabel.visible = false
	creeper.visible = false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body is BaseCharacter:
		_character_ref = _body
		interactionlabel.text = "[E]"
		interactionlabel.visible = true
	print(_body)


func _on_area_2d_body_exited(_body: Node2D) -> void:
	_character_ref = null
	interactionlabel.visible = false
	if talking:
		end_dialogue()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and _character_ref != null and not talking:
		start_dialogue()
	elif talking:
		if showing_text and Input.is_action_just_pressed("interact"):
			# Solicita pular a animação
			skip_text = true
		elif keep_going and Input.is_action_just_pressed("interact"):
			next_line()


func start_dialogue():
	talking = true
	interactionlabel.visible = false
	dialogue_box.visible = true
	dialogue_text.visible = true
	creeper.visible = true
	index_line = 0
	next_line()


func next_line():
	if index_line < lines.size():
		keep_going = false
		dialogue_text.text = ""
		current_text = lines[index_line]
		index_line += 1
		await show_text_with_effect(current_text)
	else:
		end_dialogue()


func show_text_with_effect(text: String) -> void:
	showing_text = true
	skip_text = false
	dialogue_text.text = ""
	for letter in text:
		if skip_text:
			dialogue_text.text = text
			break
		dialogue_text.text += letter
		await get_tree().create_timer(0.02).timeout
	showing_text = false
	keep_going = true


func end_dialogue():
	talking = false
	keep_going = false
	showing_text = false
	skip_text = false
	dialogue_box.visible = false
	dialogue_text.visible = false
	creeper.visible = false
