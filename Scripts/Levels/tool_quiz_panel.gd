extends Panel

signal tool_selected(tool_id: String)

@onready var label_title = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/LabelTitle
@onready var label_question = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/LabelQuestion
@onready var label_feedback = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/LabelFeedback

@onready var card_wrench = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/CardsContainer/CardWrench
@onready var card_sensor = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/CardsContainer/CardSensor
@onready var card_conveyor = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/CardsContainer/CardRoller

@onready var level = get_tree().current_scene

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

	card_wrench.pressed.connect(func(): _select_tool("wrench"))
	card_sensor.pressed.connect(func(): _select_tool("calibrator"))
	card_conveyor.pressed.connect(func(): _select_tool("roller"))

func _process(_delta: float) -> void:
	if not visible:
		return

	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		hide()

func abrir_toolbox() -> void:
	label_title.text = "Tool Box"
	label_question.text = "Choose the correct tool."
	label_feedback.text = ""

	_update_cards()
	show()
	get_tree().paused = true

func show_quiz() -> void:
	abrir_toolbox()

func _update_cards() -> void:
	card_wrench.disabled = level.poka_fixed
	card_sensor.disabled = level.sensor_fixed or level.sensor_confirmed
	card_conveyor.disabled = level.machine_fixed or level.machine_adjusted

	card_wrench.modulate = Color(0.5, 0.5, 0.5, 1) if card_wrench.disabled else Color(1, 1, 1, 1)
	card_sensor.modulate = Color(0.5, 0.5, 0.5, 1) if card_sensor.disabled else Color(1, 1, 1, 1)
	card_conveyor.modulate = Color(0.5, 0.5, 0.5, 1) if card_conveyor.disabled else Color(1, 1, 1, 1)

func _select_tool(tool_id: String) -> void:
	tool_selected.emit(tool_id)
	hide()
	get_tree().paused = false
