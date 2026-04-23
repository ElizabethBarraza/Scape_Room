extends StaticBody2D

var player_near := false

@export var object_name: String = "Boss"

@onready var interact_label = get_tree().current_scene.get_node("UI/InteractLabel")
@onready var detector: Area2D = $Detector
@onready var name_label: Label = $NameLabel
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	name_label.text = object_name
	name_label.visible = false

	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)


	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("idle"):
		animated_sprite.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true
		name_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
		name_label.visible = false

func _physics_process(_delta: float) -> void:
	pass
