extends Node2D

var player_near := false

@export var object_name: String = "Sensor Station"
@export var sprite_red: Texture2D
@export var sprite_yellow: Texture2D
@export var sprite_green: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var interact_label = get_tree().current_scene.get_node("UI/InteractLabel")
@onready var detector: Area2D = $Detector
@onready var name_label: Label = $NameLabel

func _ready() -> void:
	name_label.text = object_name
	name_label.visible = false
	if sprite_red:
		sprite.texture = sprite_red

	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true
		name_label.visible = true
		interact_label.text = "Press E to inspect sensor station"
		interact_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
		name_label.visible = false
		interact_label.visible = false

func set_state_red() -> void:
	if sprite_red:
		sprite.texture = sprite_red

func set_state_yellow() -> void:
	if sprite_yellow:
		sprite.texture = sprite_yellow

func set_state_green() -> void:
	if sprite_green:
		sprite.texture = sprite_green
