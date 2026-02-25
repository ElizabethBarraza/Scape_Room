extends Control

@onready var loading_bar = $LoadingBar

var load_time = 3.0
var elapsed = 0.0

func _process(delta):
	elapsed += delta
	
	var progress = (elapsed / load_time) * 100
	loading_bar.value = progress
	
	if elapsed >= load_time:
		change_to_menu()

func change_to_menu():
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
