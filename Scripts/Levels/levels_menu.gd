extends Control

@onready var level2_button = $VBoxContainer/Level2Button
@onready var level3_button = $VBoxContainer/Level3Button
@onready var buttons = $VBoxContainer.get_children()
@onready var title = $title
var title_original_position

func _ready():
	level2_button.disabled = true
	level3_button.disabled = true
	
	# Guardar posiciones originales
	title_original_position = title.position
	
	# Estado inicial invisible
	title.modulate.a = 0
	
	# Botones invisibles
	for button in buttons:
		button.modulate.a = 0
	
	# Desplazamiento inicial
	title.position.y -= 50
	
	# Crear animación
	var tween = create_tween()
	
	# Animación del título
	tween.tween_property(title, "modulate:a", 1, 0.8)
	tween.parallel().tween_property(title, "position", title_original_position, 0.8)
	
	# Animación progresiva de botones
	for button in buttons:
		tween.tween_property(button, "modulate:a", 1, 0.4)
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)

func _on_level_1_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level1.tscn")

func _on_level_2_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level2.tscn")

func _on_level_3_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level3.tscn")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/menu.tscn")
