extends Control

@onready var line_edit_answer: LineEdit = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/LineEditAnsware
@onready var label_feedback: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/LabelFeedBack
@onready var btn_confirm: Button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/BtnConfirm
@onready var label_title: Label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/LabelTitle
@onready var level = get_tree().current_scene

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	btn_confirm.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	btn_confirm.pressed.connect(_on_btn_confirm_pressed)

func _process(_delta: float) -> void:
	if not visible:
		return

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
		visible = false

	if Input.is_action_just_pressed("ui_accept"):
		_on_btn_confirm_pressed()

func show_password_prompt() -> void:
	visible = true
	get_tree().paused = true
	line_edit_answer.text = ""
	label_feedback.text = ""
	label_title.text = "PASSWORD: _ _ _ _ _ _"
	line_edit_answer.grab_focus()

func _on_btn_confirm_pressed() -> void:
	var answer := line_edit_answer.text.strip_edges().to_upper()

	if answer == "KAIZEN":
		label_feedback.text = "Password accepted. Access granted."
		level.final_password_completed = true
		level.actualizar_lampara()
		get_tree().paused = false
		visible = false

		if level.door and level.door.has_method("abrir_puerta"):
			level.door.abrir_puerta()

		if level.has_method("_open_door_after_password"):
			level._open_door_after_password()
	else:
		label_feedback.text = "Incorrect password. Access denied."
		level.registrar_intento_incorrecto()
