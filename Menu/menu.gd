extends Control

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Management/game_level.tscn")


func _on_credit_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
