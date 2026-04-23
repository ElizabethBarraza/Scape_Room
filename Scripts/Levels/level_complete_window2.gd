extends Control

@onready var title_label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/TitleLabel
@onready var result_label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ResultLabel
@onready var score_label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ScoreLabel
@onready var time_label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/TimeLabel
@onready var incorrect_label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/IncorrectLabel

@onready var star1: TextureRect = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/StarsBox/Star1
@onready var star2: TextureRect = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/StarsBox/Star2
@onready var star3: TextureRect = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/StarsBox/Star3

@onready var btn_next: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ButtonsBox/BtnNext
@onready var btn_replay: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ButtonsBox/BtnReplay
@onready var btn_menu: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ButtonsBox/BtnMenu

@export var next_level_path: String = "res://Scenes/Levels/transition_screen_final.tscn"
@export var main_menu_path: String = "res://Scenes/menu/menu.tscn"

@onready var sfx_gameover = $SfxGameOver
@onready var sfx_victory = $SfxVictory

var star_full: Texture2D = preload("res://Assets/Sprites/StarYellow.png")
var star_empty: Texture2D = preload("res://Assets/Sprites/StarGray.png")

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	btn_next.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	btn_replay.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	btn_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	btn_next.pressed.connect(_on_btn_next_pressed)
	btn_replay.pressed.connect(_on_btn_replay_pressed)
	btn_menu.pressed.connect(_on_btn_menu_pressed)

func mostrar_resultados(tiempo_final: String, incorrect_attempts: int, es_game_over: bool) -> void:
	visible = true

	if es_game_over:
		title_label.text = "GAME OVER"
		result_label.text = "TRY AGAIN"
		score_label.text = "Score: 0 / 1000"
		time_label.text = "Time Left: %s" % tiempo_final
		incorrect_label.text = "Incorrect attempts: %d" % incorrect_attempts

		title_label.modulate = Color(1.0, 0.3, 0.3)
		result_label.modulate = Color(1.0, 0.4, 0.4)

		sfx_gameover.play()
		_set_stars(0)

		btn_next.disabled = true
	else:
		title_label.text = "LEVEL COMPLETE!"
		result_label.text = "EXCELLENT!"

		var score := 1000 - (incorrect_attempts * 200)
		if score < 0:
			score = 0

		score_label.text = "Score: %d / 1000" % score
		time_label.text = "Time Left: %s" % tiempo_final
		incorrect_label.text = "Incorrect attempts: %d" % incorrect_attempts

		title_label.modulate = Color(1, 1, 1)
		result_label.modulate = Color(1, 0.9, 0.2)

		sfx_victory.play()

		var stars := 3
		if incorrect_attempts >= 2:
			stars = 1
		elif incorrect_attempts >= 1:
			stars = 2

		_set_stars(stars)

		btn_next.disabled = next_level_path == ""

func _set_stars(count: int) -> void:
	star1.texture = star_full if count >= 1 else star_empty
	star2.texture = star_full if count >= 2 else star_empty
	star3.texture = star_full if count >= 3 else star_empty

func _on_btn_next_pressed() -> void:
	get_tree().paused = false

	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
	else:
		print("No next level path assigned.")

func _on_btn_replay_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_path)
