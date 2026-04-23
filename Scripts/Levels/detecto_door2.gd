extends Area2D

@onready var door = get_parent()

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and door.abierta:
		var nivel = get_tree().current_scene
		if nivel.has_method("completar_nivel"):
			nivel.completar_nivel()
