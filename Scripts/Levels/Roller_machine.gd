extends Node2D

var player_near := false

@export var object_name: String = "Roller Machine"
@export var sprite_fault: Texture2D
@export var sprite_adjusting: Texture2D
@export var sprite_fixed: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var interact_label = get_tree().current_scene.get_node("UI/InteractLabel")
@onready var detector: Area2D = $Detector
@onready var name_label: Label = $NameLabel

func _ready() -> void:
	name_label.text = object_name
	name_label.visible = false

	if sprite_fault != null:
		sprite.texture = sprite_fault

	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true
		name_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
		name_label.visible = false

func set_adjusting_state() -> void:
	if sprite_adjusting != null:
		sprite.texture = sprite_adjusting

func set_fixed_state() -> void:
	if sprite_fixed != null:
		sprite.texture = sprite_fixed
