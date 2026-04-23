extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var sfx_steps = $SfxSteps

const SPEED = 200
var last_direction = "down"

func _physics_process(delta):
	var input_direction = Vector2.ZERO

	# Horizontal
	if Input.is_action_pressed("move_right"):
		input_direction.x += 1
	if Input.is_action_pressed("move_left"):
		input_direction.x -= 1

	# Vertical
	if Input.is_action_pressed("move_down"):
		input_direction.y += 1
	if Input.is_action_pressed("move_up"):
		input_direction.y -= 1

	# Normaliza para que diagonal no sea más rápida
	if input_direction != Vector2.ZERO:
		input_direction = input_direction.normalized()

	# Guardar última dirección para animación idle
	if input_direction.x > 0:
		last_direction = "right"
	elif input_direction.x < 0:
		last_direction = "left"
	elif input_direction.y > 0:
		last_direction = "down"
	elif input_direction.y < 0:
		last_direction = "up"

	velocity = input_direction * SPEED
	move_and_slide()

	var real_movement = get_last_motion()

	if real_movement.length() > 0.1:
		if not sfx_steps.playing:
			sfx_steps.play()
	else:
		sfx_steps.stop()

	update_animation(real_movement)

func update_animation(real_movement: Vector2):
	if real_movement.length() <= 0.1:
		sprite.play("idle_" + last_direction)
	else:
		sprite.play("walk_" + last_direction)

func _ready():
	add_to_group("player")
	sprite.play("idle_down")
