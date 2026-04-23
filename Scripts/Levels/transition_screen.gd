extends Control

@onready var label_title = $VBoxContainer/LabelTitle
@onready var label_description = $VBoxContainer/LabelDescription
@onready var btn_next = $VBoxContainer/BtnNext
@onready var btn_menu = $VBoxContainer/BtnMenu
@onready var color_rect = $ColorRect
@onready var vbox = $VBoxContainer
@onready var sfx_transition = $SfxTransition

var next_level_path: String = "res://Scenes/Levels/level1.tscn"
var menu_path: String = "res://Scenes/Menu/menu.tscn"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	
	sfx_transition.stream = load("res://Assets/Audios/Transition.wav")
	sfx_transition.play()
	
	modulate.a = 0.0
	vbox.position.y += 20

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 5.0, 4.0)
	tween.parallel().tween_property(vbox, "position:y", vbox.position.y - 20, 0.5)
	
	btn_next.pressed.connect(_on_next_pressed)
	btn_menu.pressed.connect(_on_menu_pressed)

func setup_transition(title: String, description: String, next_path: String) -> void:
	label_title.text = title
	label_description.text = description
	next_level_path = next_path

func _on_next_pressed() -> void:
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file(menu_path)
