extends Area2D

@export var quiz_window_path: NodePath
@export var interact_label_path: NodePath

var player_in_area: bool = false

@onready var quiz_window = get_node(quiz_window_path)
@onready var interact_label = get_node(interact_label_path)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_area = true

		var nivel = get_tree().current_scene
		if nivel.has_method("puede_hablar_con_supervisor") and nivel.puede_hablar_con_supervisor():
			interact_label.text = "Press E to talk to the supervisor"
			interact_label.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		interact_label.visible = false

func _process(_delta: float) -> void:
	if not player_in_area:
		return

	if Input.is_action_just_pressed("interact"):
		var nivel = get_tree().current_scene
		if nivel.has_method("puede_hablar_con_supervisor") and nivel.puede_hablar_con_supervisor():
			interact_label.visible = false
			quiz_window.abrir_quiz()
