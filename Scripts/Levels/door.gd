extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sfx_door = $SfxDoor

var abierta: bool = false

func _ready() -> void:
	abierta = false
	animated_sprite.stop()
	animated_sprite.animation = "open"
	animated_sprite.frame = 0
	collision.disabled = false

func abrir_puerta() -> void:
	if abierta:
		return

	abierta = true
	sfx_door.play()
	animated_sprite.play("open")

	await animated_sprite.animation_finished

	collision.disabled = true
