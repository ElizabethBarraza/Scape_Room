extends Panel

@onready var input_label: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/InputLabel
@onready var feedback_label: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/FeedbackLabel

@onready var btn1: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn1
@onready var btn2: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn2
@onready var btn3: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn3
@onready var btn4: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn4
@onready var btn5: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn5
@onready var btn6: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn6
@onready var btn7: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn7
@onready var btn8: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn8
@onready var btn9: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn9
@onready var btn0: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/Btn0
@onready var btn_clear: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/BtnClear
@onready var btn_enter: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/GridContainer/BtnEnter

var codigo_ingresado: String = ""
var codigo_correcto: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

	btn1.pressed.connect(_on_digit_pressed.bind("1"))
	btn2.pressed.connect(_on_digit_pressed.bind("2"))
	btn3.pressed.connect(_on_digit_pressed.bind("3"))
	btn4.pressed.connect(_on_digit_pressed.bind("4"))
	btn5.pressed.connect(_on_digit_pressed.bind("5"))
	btn6.pressed.connect(_on_digit_pressed.bind("6"))
	btn7.pressed.connect(_on_digit_pressed.bind("7"))
	btn8.pressed.connect(_on_digit_pressed.bind("8"))
	btn9.pressed.connect(_on_digit_pressed.bind("9"))
	btn0.pressed.connect(_on_digit_pressed.bind("0"))

	btn_clear.pressed.connect(_on_clear_pressed)
	btn_enter.pressed.connect(_on_enter_pressed)

func abrir_keypad() -> void:
	codigo_ingresado = ""
	codigo_correcto = false
	input_label.text = "_ _ _ _"
	feedback_label.text = ""
	feedback_label.modulate = Color(1, 1, 1)
	show()
	get_tree().paused = true

func cerrar_keypad() -> void:
	hide()
	get_tree().paused = false

	# Mostrar ayuda solo si cerró sin ingresar el código correcto
	if not codigo_correcto:
		mostrar_mensaje_supervisor()

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		cerrar_keypad()
		get_viewport().set_input_as_handled()

func _on_digit_pressed(digit: String) -> void:
	if codigo_ingresado.length() >= 4:
		return

	codigo_ingresado += digit
	actualizar_input()

func _on_clear_pressed() -> void:
	codigo_ingresado = ""
	actualizar_input()
	feedback_label.text = ""
	feedback_label.modulate = Color(1, 1, 1)

func _on_enter_pressed() -> void:
	var nivel = get_tree().current_scene

	if nivel == null:
		feedback_label.text = "Level not found"
		feedback_label.modulate = Color(1.0, 0.4, 0.4)
		return

	if codigo_ingresado == nivel.codigo_puerta:
		codigo_correcto = true
		feedback_label.text = "Correct code!"
		feedback_label.modulate = Color(0.4, 1.0, 0.4)
		nivel.desbloquear_puerta_por_codigo()
		await get_tree().create_timer(0.4, true).timeout
		cerrar_keypad()
	else:
		feedback_label.text = "Incorrect code"
		feedback_label.modulate = Color(1.0, 0.4, 0.4)
		codigo_ingresado = ""
		actualizar_input()

func actualizar_input() -> void:
	var mostrado := ""

	for i in range(4):
		if i < codigo_ingresado.length():
			mostrado += codigo_ingresado[i] + " "
		else:
			mostrado += "_ "

	input_label.text = mostrado.strip_edges()

func mostrar_mensaje_supervisor() -> void:
	var nivel = get_tree().current_scene

	if nivel == null:
		return

	# Busca un Label llamado HintLabel dentro del nivel actual
	var hint_label = nivel.get_node_or_null("UI/HintLabel")

	if hint_label != null:
		hint_label.text = "Go to the supervisor to repeat the code"
		hint_label.visible = true

		await get_tree().create_timer(8.0, false).timeout

		if is_instance_valid(hint_label):
			hint_label.visible = false
