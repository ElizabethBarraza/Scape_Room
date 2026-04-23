extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	velocity = Vector2.ZERO

	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("idle"):
		animated_sprite.play("idle")

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()
