extends StaticBody2D
class_name Bala

@onready var dialogue_box: Sprite2D = $Area2D/CanvasLayer/DialogueBox
@onready var dialogue_text: Label = $Area2D/CanvasLayer/DialogueText
@onready var blurred_background: Label = $Area2D/CanvasLayer/BlurredBackground
@onready var sprite_2d: Sprite2D = $Area2D/CanvasLayer/Sprite2D
@onready var interaction_label: Label = $InteractionLabel

var _character_ref: BaseCharacter = null
var talking = false
var keep_going = false
var showing_text = false
var current_text = ""
var skip_text = false
var index_line = 0

var lines = [
	"SPRITE!",
	"SPRITE SPRITE!!",
	"SPRITE SPRITE SPRITE!!!",
	"SPRITE SPRITE SPRITE SPRITE SPRITE!!!!",
	"SPRITE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
]

func _ready() -> void:
	dialogue_box.visible = false
	dialogue_text.visible = false
	interaction_label.visible = false
	sprite_2d.visible = false
	blurred_background.visible = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body is BaseCharacter:
		_character_ref = _body
		interaction_label.text = "[E]"
		interaction_label.visible = true
	print(_body)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	_character_ref = null
	interaction_label.visible = false
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
	interaction_label.visible = false
	dialogue_box.visible = true
	dialogue_text.visible = true
	sprite_2d.visible = true
	blurred_background.visible = true
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
	sprite_2d.visible = false
	blurred_background.visible = false
