extends Panel

# Ruta correcta según tu árbol:
# DialogBox
#  └ MarginContainer
#     └ HBoxContainer
#        └ VBoxContainer
#           └ LabelText (Label)
@onready var label: Label = $MarginContainer/HBoxContainer/VBoxContainer/LabelText

var mostrando: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	# Para que el texto se vea completo:
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL

func mostrar_texto(texto: String) -> void:
	if label == null:
		push_error("DialogBox: No se encontró LabelText. Revisa la ruta del nodo.")
		return

	label.text = texto
	visible = true
	mostrando = true

	# Pausa el juego, pero este panel sigue funcionando por PROCESS_MODE_ALWAYS
	get_tree().paused = true

	# Asegura que reciba input aunque no tenga focus
	set_process_input(true)
	grab_focus()

func cerrar() -> void:
	visible = false
	mostrando = false
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if not mostrando:
		return

	if event.is_action_pressed("ui_accept") \
	or event.is_action_pressed("ui_cancel") \
	or event.is_action_pressed("interact"):
		cerrar()
		get_viewport().set_input_as_handled()
