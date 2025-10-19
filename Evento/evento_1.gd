extends StaticBody2D
class_name Evento1

@export var character_name: String = "Creeper" # Nome configurável do personagem

@onready var interactionlabel: Label = $Area2D/InteractionLabel
@onready var dialogue_box: Label = $Area2D/CanvasLayer/DialogueBox
@onready var dialogue_text: Label = $Area2D/CanvasLayer/DialogueText
@onready var creeper: Sprite2D = $Area2D/CanvasLayer/creeper
@onready var shadowbox: Sprite2D = $Area2D/CanvasLayer/shadowbox
@onready var name_character: Label = $Area2D/CanvasLayer/NameCharacter

var _character_ref: BaseCharacter = null
var talking = false
var showing_text = false
var skip_text = false
var index_line = 0
var keep_going = false
var current_text = ""

var lines = [
	{"name": "Maria", "text": "..."},
	{"name": "Maria", "text": "Meu pai tá sempre ocupado."},
	{"name": "Maria", "text": "Ele nem me ouviu..."}
	
]

# 🔒 Evento de uso único
var event_finished: bool = false


func _ready() -> void:
	dialogue_box.visible = false
	dialogue_text.visible = false
	name_character.visible = false
	interactionlabel.visible = false
	creeper.visible = false
	shadowbox.visible = false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if event_finished:
		return # já foi executado
	if _body is BaseCharacter:
		_character_ref = _body
		start_dialogue()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if _character_ref == _body:
		_character_ref = null


func _process(_delta: float) -> void:
	# ✅ Agora o botão "interact" controla a progressão das falas
	if talking and Input.is_action_just_pressed("interact"):
		if showing_text:
			skip_text = true
		elif keep_going:
			next_line()


func start_dialogue():
	talking = true
	dialogue_box.visible = true
	dialogue_text.visible = true
	name_character.visible = true
	creeper.visible = true
	shadowbox.visible = true

	name_character.text = character_name
	index_line = 0
	next_line()


func next_line():
	if index_line < lines.size():
		keep_going = false
		dialogue_text.text = ""

		var current_line = lines[index_line]
		index_line += 1

		if current_line.has("name"):
			name_character.text = current_line["name"]

		await show_text_with_effect(current_line["text"])
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
	name_character.visible = false
	creeper.visible = false
	shadowbox.visible = false

	event_finished = true
	$Area2D.monitoring = false
