extends Panel

@onready var message_label: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/MessageLabel
@onready var ok_button: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/OkButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	ok_button.pressed.connect(_on_ok_pressed)

func mostrar_codigo(codigo: String) -> void:
	if message_label == null:
		push_error("CodeDialog: no se encontró MessageLabel.")
		return

	message_label.text = "The access code is: " + codigo + "\n\nGo to the wall panel and enter it."
	show()
	get_tree().paused = true

func _on_ok_pressed() -> void:
	hide()
	get_tree().paused = false
