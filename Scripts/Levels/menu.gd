extends Control

@onready var title = $Title
@onready var panel = $Centerpanel
@onready var buttons = $Centerpanel/VBoxContainer.get_children()

var title_original_position
var panel_original_position

func _ready():
	
	# Guardar posiciones originales
	title_original_position = title.position
	panel_original_position = panel.position
	
	# Estado inicial invisible
	title.modulate.a = 0
	panel.modulate.a = 0
	
	# Botones invisibles
	for button in buttons:
		button.modulate.a = 0
	
	# Desplazamiento inicial
	title.position.y -= 50
	panel.position.y += 50
	
	# Crear animación
	var tween = create_tween()
	
	# Animación del título
	tween.tween_property(title, "modulate:a", 1, 0.8)
	tween.parallel().tween_property(title, "position", title_original_position, 0.8)
	
	# Animación del panel
	tween.tween_property(panel, "modulate:a", 1, 0.8)
	tween.parallel().tween_property(panel, "position", panel_original_position, 0.8)
	
	# Animación progresiva de botones
	for button in buttons:
		tween.tween_property(button, "modulate:a", 1, 0.4)
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level1.tscn")


func _on_levels_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/LevelsMenu.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
