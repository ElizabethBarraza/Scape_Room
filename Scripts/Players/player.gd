extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var sfx_steps = $SfxSteps

const SPEED = 200
var last_direction = "down"

func _physics_process(delta):
	var input_direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		input_direction.x = 1
		last_direction = "right"
	elif Input.is_action_pressed("move_left"):
		input_direction.x = -1
		last_direction = "left"
	elif Input.is_action_pressed("move_down"):
		input_direction.y = 1
		last_direction = "down"
	elif Input.is_action_pressed("move_up"):
		input_direction.y = -1
		last_direction = "up"

	velocity = input_direction * SPEED
	move_and_slide()

	# Movimiento real después de colisiones
	var real_movement = get_last_motion()

	# Sonido de pasos solo si realmente se está moviendo
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
