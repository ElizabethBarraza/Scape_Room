extends Panel

@export_multiline var initial_message: String = "⚠ SYSTEM ALERT\n\nThe fabric roll is misaligned.\nInspect the process, identify the deviation, correct the roller alignment, repair the Poka-Yoke panel, confirm the sensor, and stabilize production."

@onready var label_text = $MarginContainer/HBoxContainer/VBoxContainer/LabelText

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if not visible:
		return

	if Input.is_action_just_pressed("interact") \
	or Input.is_action_just_pressed("ui_accept") \
	or Input.is_action_just_pressed("ui_cancel"):
		cerrar()

func mostrar_mensaje(message: String) -> void:
	label_text.text = message
	show()
	get_tree().paused = true

func mostrar_mensaje_inicial() -> void:
	label_text.text = initial_message
	show()
	get_tree().paused = true

func cerrar() -> void:
	hide()
	get_tree().paused = false
