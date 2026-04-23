extends Control

@onready var time_label: Label = $Panel/MarginContainer/HBoxContainer/TimeLabel

func set_time(seconds: int) -> void:
	var minutes := seconds / 60
	var secs := seconds % 60
	time_label.text = "%02d:%02d" % [minutes, secs]

func set_warning_mode(active: bool) -> void:
	if active:
		time_label.modulate = Color(1.0, 0.35, 0.35)
	else:
		time_label.modulate = Color(1, 1, 1)
