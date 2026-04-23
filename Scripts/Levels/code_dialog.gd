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

	var nivel = get_tree().current_scene
	if nivel.has_method("hide_objective_ui"):
		nivel.hide_objective_ui()

	message_label.text = "The access code is: " + codigo + "\n\nGo to the wall panel and enter it."
	show()
	get_tree().paused = true

	ok_button.grab_focus()

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_on_ok_pressed()
			get_viewport().set_input_as_handled()

func _on_ok_pressed() -> void:
	hide()
	get_tree().paused = false

	var nivel = get_tree().current_scene
	if nivel.has_method("show_objective_ui"):
		nivel.show_objective_ui()
