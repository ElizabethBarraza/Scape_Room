extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var detector: Area2D = $DetectorDoor
@onready var name_label: Label = $NameLabel
@onready var sfx_door: AudioStreamPlayer2D = $SfxDoor
#@onready var door_lamp: Sprite2D = $DoorLamp

var abierta: bool = false

func _ready() -> void:
	abierta = false

	animated_sprite.stop()
	animated_sprite.animation = "open"
	animated_sprite.frame = 0

	collision.disabled = false

	name_label.text = "Security Door"
	name_label.visible = false

	# Luz roja al inicio
	#door_lamp.modulate = Color(1.0, 0.2, 0.2, 1.0)

	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		name_label.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		name_label.visible = false

func abrir_puerta() -> void:
	if abierta:
		return

	abierta = true
	name_label.visible = false

	# Luz verde cuando se desbloquea
	#door_lamp.modulate = Color(0.2, 1.0, 0.2, 1.0)

	sfx_door.play()
	animated_sprite.play("open")

	await animated_sprite.animation_finished

	collision.disabled = true
