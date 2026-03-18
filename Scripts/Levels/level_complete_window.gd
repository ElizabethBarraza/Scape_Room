extends Control

@onready var title_label: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/TitleLabel
@onready var result_label: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ResultLabel
@onready var score_label: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ScoreLabel
@onready var time_label: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/TimeLabel
@onready var incorrect_label: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/IncorrectLabel

@onready var star1: TextureRect = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/StarsBox/Star1
@onready var star2: TextureRect = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/StarsBox/Star2
@onready var star3: TextureRect = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/StarsBox/Star3

@onready var btn_next: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ButtonsBox/BtnNext
@onready var btn_replay: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ButtonsBox/BtnReplay
@onready var btn_menu: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ButtonsBox/BtnMenu

@export var next_level_path: String = ""
@export var main_menu_path: String = "res://Scenes/menu/menu.tscn"
@onready var sfx_gameover = $SfxGameOver
@onready var sfx_victory = $SfxVictory

var star_full: Texture2D = preload("res://Assets/Sprites/StarYellow.png")
var star_empty: Texture2D = preload("res://Assets/Sprites/StarGray.png")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

	btn_next.pressed.connect(_on_btn_next_pressed)
	btn_replay.pressed.connect(_on_btn_replay_pressed)
	btn_menu.pressed.connect(_on_btn_menu_pressed)

func mostrar_resultados(time_text: String, incorrect_attempts: int) -> void:
	show()
	get_tree().paused = true

	time_label.text = "Time: " + time_text
	incorrect_label.text = "Incorrect attempts: " + str(incorrect_attempts)

	var game_over := incorrect_attempts >= 4

	if game_over:
		title_label.text = "GAME OVER"
		result_label.text = "TRY AGAIN"
		score_label.text = "Score: 0 / 1000"
		title_label.modulate = Color(1.0, 0.3, 0.3)
		result_label.modulate = Color(1.0, 0.4, 0.4)
		sfx_gameover.play()

		actualizar_estrellas(0)

		btn_next.visible = false
		btn_replay.visible = true
		btn_menu.visible = true
	else:
		title_label.text = "LEVEL COMPLETE!"

		var score := calcular_score(time_text, incorrect_attempts)
		score_label.text = "Score: " + str(score) + " / 1000"

		var estrellas := calcular_estrellas(incorrect_attempts)
		actualizar_estrellas(estrellas)
		sfx_victory.play()

		if estrellas == 3:
			result_label.text = "EXCELLENT!"
		elif estrellas == 2:
			result_label.text = "GOOD JOB!"
		else:
			result_label.text = "LEVEL COMPLETE!"

		btn_next.visible = true
		btn_replay.visible = true
		btn_menu.visible = true

func calcular_score(time_text: String, incorrect_attempts: int) -> int:
	var parts = time_text.split(":")
	var minutes = int(parts[0])
	var seconds = int(parts[1])
	var total_seconds = minutes * 60 + seconds

	var score = 1000
	score -= incorrect_attempts * 80
	score -= int(total_seconds * 1.5)

	if score < 0:
		score = 0

	return score

func calcular_estrellas(incorrect_attempts: int) -> int:
	if incorrect_attempts <= 1:
		return 3
	elif incorrect_attempts <= 3:
		return 2
	else:
		return 1

func actualizar_estrellas(cantidad: int) -> void:
	var stars = [star1, star2, star3]

	for i in range(3):
		if i < cantidad:
			stars[i].texture = star_full
		else:
			stars[i].texture = star_empty

func _on_btn_next_pressed() -> void:
	get_tree().paused = false
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)

func _on_btn_replay_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_menu_pressed() -> void:
	get_tree().paused = false
	if main_menu_path != "":
		get_tree().change_scene_to_file(main_menu_path)
		
func animar_estrellas(cantidad: int) -> void:
	var stars = [star1, star2, star3]

	for i in range(3):
		stars[i].scale = Vector2(0.2, 0.2)
		stars[i].modulate.a = 0.0

	for i in range(cantidad):
		var tween = create_tween()
		tween.tween_interval(i * 0.18)
		tween.tween_property(stars[i], "modulate:a", 1.0, 0.08)
		tween.tween_property(stars[i], "scale", Vector2(1.2, 1.2), 0.12)
		tween.tween_property(stars[i], "scale", Vector2(1.0, 1.0), 0.08)
