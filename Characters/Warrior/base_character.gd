extends CharacterBody2D
class_name BaseCharacter

@export var _move_speed: float = 128.0
@export var _animation: AnimatedSprite2D

var last_direction := "down"  # guarda a última direção para o idle correto

func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = input_vector * _move_speed
	move_and_slide()

	if input_vector == Vector2.ZERO:
		# Personagem parado — mostra o idle da última direção
		match last_direction:
			"up":
				_animation.play("idle_up")
			"down":
				_animation.play("idle_down")
			"left":
				_animation.play("idle_left")
			"right":
				_animation.play("idle_right")
	else:
		# Personagem em movimento
		if abs(input_vector.x) > abs(input_vector.y):
			# Prioriza horizontal em diagonais
			if input_vector.x > 0:
				last_direction = "right"
				_animation.play("move_right")
			else:
				last_direction = "left"
				_animation.play("move_left")
		else:
			# Movimento vertical
			if input_vector.y > 0:
				last_direction = "down"
				_animation.play("move_down")
			else:
				last_direction = "up"
				_animation.play("move_up")
