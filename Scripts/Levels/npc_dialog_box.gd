extends Panel

@onready var portrait = $MarginContainer/HBoxContainer/Portrait
@onready var label_text = $MarginContainer/HBoxContainer/VBoxContainer/LabelText

var can_close := false

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if not visible:
		return

	if can_close and (
		Input.is_action_just_pressed("interact")
		or Input.is_action_just_pressed("ui_accept")
		or Input.is_action_just_pressed("ui_cancel")
	):
		cerrar()

func mostrar_dialogo(texto: String, retrato: Texture2D = null) -> void:
	label_text.text = texto

	if retrato:
		portrait.texture = retrato

	show()
	get_tree().paused = true

	can_close = false
	await get_tree().process_frame
	can_close = true

func cerrar() -> void:
	hide()
	get_tree().paused = false
