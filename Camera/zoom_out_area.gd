extends Area2D

@export var camera : Camera2D

func _ready() -> void:
	body_entered.connect(_active_zoom_camera)
	body_exited.connect(_deactive_zoom_camera)

func _active_zoom_camera(body: Node2D):
	if camera != null:
		if body is BaseCharacter:
			camera.set_ZoomOut(true)

func _deactive_zoom_camera(body: Node2D):
	if camera != null:
		if body is BaseCharacter:
			camera.set_ZoomOut(false)
