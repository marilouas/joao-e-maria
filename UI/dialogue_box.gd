extends Control

signal dialogue_finished


@export var text_speed: float = 0.03  # tempo entre letras

@onready var name_label: Label = $Panel/name_label
@onready var text_label: Label = $Panel/text_label

var dialogues: Array = []    # lista de falas (dicionários)
var current_index: int = 0   # qual fala está sendo mostrada
var is_typing: bool = false
var skip_typing: bool = false

func _ready() -> void:
	hide()

# ---------------------------------------------------------
# Exemplo de chamada:
# show_dialogue([
#     {"name": "Evelyn", "text": "Oi, tudo bem?"},
#     {"name": "Lucas", "text": "Tudo sim, e você?"},
#     {"name": "Evelyn", "text": "Estou ótima!"}
# ])
# ---------------------------------------------------------
func show_dialogue(dialogue_data: Array) -> void:
	dialogues = dialogue_data
	current_index = 0
	show()
	_show_current_line()

func _show_current_line() -> void:
	if current_index >= dialogues.size():
		hide()
		return

	var line = dialogues[current_index]
	name_label.text = line["name"]
	_start_typing(line["text"])

func _start_typing(text: String) -> void:
	text_label.text = ""
	is_typing = true
	skip_typing = false
	_start_typing_effect(text)

func _start_typing_effect(text: String) -> void:
	var typed_text := ""
	for char in text:
		if skip_typing:
			text_label.text = text
			break
		typed_text += char
		text_label.text = typed_text
		await get_tree().create_timer(text_speed).timeout
	is_typing = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # Ex: tecla Enter ou espaço
		if is_typing:
			skip_typing = true
		else:
			current_index += 1
			_show_current_line()

func _hide_dialogue():
	hide()
	emit_signal("dialogue_finished")
