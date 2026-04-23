extends Label

func update_time(remaining_time: float) -> void:
	var total_seconds := int(ceil(remaining_time))
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60

	text = "TIME LEFT: %02d:%02d" % [minutes, seconds]
