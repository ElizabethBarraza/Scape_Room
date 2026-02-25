extends Control

@onready var level2_button = $VBoxContainer/Level2Button
@onready var level3_button = $VBoxContainer/Level3Button
@onready var level4_button = $VBoxContainer/Level4Button

func _ready():
	level2_button.disabled = true
	level3_button.disabled = true
	level4_button.disabled = true

func _on_level_1_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level1.tscn")

func _on_level_2_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level2.tscn")

func _on_level_3_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level3.tscn")
	
func _on_level_4_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level4.tscn")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/menu.tscn")
