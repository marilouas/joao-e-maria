extends Camera2D

@export_group("Camera Settings")
@export var normal_zoom: Vector2 = Vector2(1.5, 1.5)
@export var zoom_out: Vector2 = Vector2(1, 1)
@export var zoom_speed: float = 2.0

var target_zoom : Vector2

func _ready() -> void:
	target_zoom = normal_zoom
	zoom = normal_zoom

func _process(delta: float) -> void:
	zoom = zoom.lerp(target_zoom, delta * zoom_speed)

func set_ZoomOut(active: bool):
	if active:
		target_zoom = zoom_out
	else:
		target_zoom = normal_zoom
