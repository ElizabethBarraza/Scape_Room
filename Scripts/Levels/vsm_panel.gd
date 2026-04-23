extends Panel

@onready var label_title = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/LabelTitle
@onready var label_flow = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/LabelFlow
@onready var btn_close = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/BtnClose

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	btn_close.pressed.connect(_on_btn_close_pressed)

func show_vsm(flow_text: String) -> void:
	label_title.text = "VSM Monitor"
	label_flow.text = flow_text
	show()
	get_tree().paused = true

func _on_btn_close_pressed() -> void:
	hide()
	get_tree().paused = false
