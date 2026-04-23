extends Node2D

var player_near := false

@export var object_name: String = "Door Panel"

@onready var interact_label = get_tree().current_scene.get_node("UI/InteractLabel")
@onready var detector: Area2D = $Detector
@onready var name_label: Label = $NameLabel
@onready var level = get_tree().current_scene

func _ready() -> void:
	name_label.text = object_name
	name_label.visible = false
	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true
		name_label.visible = true
		interact_label.text = "Press E to use panel"
		interact_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
		name_label.visible = false
		interact_label.visible = false

func _input(event: InputEvent) -> void:
	if player_near and event.is_action_pressed("interact"):
		if level.boss_authorized_access and not level.final_password_completed:
			level.password_panel.show_password_prompt()
		elif not level.boss_authorized_access:
			level.show_dialog("ACCESS DENIED", "Boss authorization required.")
		else:
			level.show_dialog("DOOR PANEL", "Door already unlocked.")
