extends StaticBody2D

@onready var detector = $Detector
@onready var interact_label = get_tree().current_scene.get_node("UI/InteractLabel")

var player_in_area = false

func _ready():
	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true
		interact_label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		interact_label.visible = false

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		abrir_minijuego()

func abrir_minijuego():
	interact_label.visible = false
	#get_tree().current_scene.get_node("UI/MiniGameWindow").visible = true
	var mini = get_tree().current_scene.get_node("UI/MiniGameWindow")
	mini.abrir_minijuego()
