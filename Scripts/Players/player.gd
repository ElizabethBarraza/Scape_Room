extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 200
var last_direction = "down"

func _physics_process(delta):

	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x = 1
		last_direction = "right"

	elif Input.is_action_pressed("move_left"):
		direction.x = -1
		last_direction = "left"

	elif Input.is_action_pressed("move_down"):
		direction.y = 1
		last_direction = "down"

	elif Input.is_action_pressed("move_up"):
		direction.y = -1
		last_direction = "up"

	velocity = direction * SPEED
	move_and_slide()

	update_animation(direction)

func update_animation(direction):

	if direction == Vector2.ZERO:
		sprite.play("idle_" + last_direction)
	else:
		sprite.play("walk_" + last_direction)

func _ready():
	add_to_group("player")
	sprite.play("idle_down")
