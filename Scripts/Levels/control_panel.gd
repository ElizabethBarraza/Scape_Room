extends Node2D

@export var object_name: String = "Safety Cone"

@onready var detector: Area2D = $Detector
@onready var name_label: Label = $NameLabel

func _ready() -> void:
	name_label.text = object_name
	name_label.visible = false

	detector.body_entered.connect(_on_detector_body_entered)
	detector.body_exited.connect(_on_detector_body_exited)

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		name_label.visible = true

func _on_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		name_label.visible = false
