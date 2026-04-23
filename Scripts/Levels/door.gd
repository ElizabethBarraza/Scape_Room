extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var detector: Area2D = $Detector
@onready var name_label: Label = $NameLabel
@onready var sfx_door = $SfxDoor

var abierta: bool = false

func _ready() -> void:
	abierta = false
	animated_sprite.stop()
	animated_sprite.animation = "open"
	animated_sprite.frame = 0
	collision.disabled = false

	name_label.text = "Security Door"
	name_label.visible = false

	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		name_label.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		name_label.visible = false

func abrir_puerta() -> void:
	if abierta:
		return

	abierta = true
	name_label.visible = false
	sfx_door.play()
	animated_sprite.play("open")

	await animated_sprite.animation_finished

	collision.disabled = true
