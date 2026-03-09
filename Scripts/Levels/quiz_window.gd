extends Panel

@onready var quiz_image: TextureRect = $MarginContainer/VBoxContainer/QuizImage
@onready var question_label: Label = $MarginContainer/VBoxContainer/QuestionLabel
@onready var option_a: Button = $MarginContainer/VBoxContainer/OptionsBox/OptionA
@onready var option_b: Button = $MarginContainer/VBoxContainer/OptionsBox/OptionB
@onready var option_c: Button = $MarginContainer/VBoxContainer/OptionsBox/OptionC
@onready var feedback_label: Label = $MarginContainer/VBoxContainer/FeedbackLabel

var preguntas = [
	{
		"imagen": preload("res://Assets/Sprites/Quiz1.jpeg"),
		"correcta": "Time required for a machine to complete one unit",
		"opciones": [
			"Time required for a machine to complete one unit",
			"Down time or inactivity of a line or machine",
			"Waste or scrap material from production"
		]
	},
	{
		"imagen": preload("res://Assets/Sprites/Quiz2.jpeg"),
		"correcta": "Down time or inactivity of a line or machine",
		"opciones": [
			"Percentage of good products on the first attempt",
			"Down time or inactivity of a line or machine",
			"Production rhythm needed to meet customer demand"
		]
	},
	{
		"imagen": preload("res://Assets/Sprites/Quiz3.jpeg"),
		"correcta": "Waste or scrap material from production",
		"opciones": [
			"Standardized work exact sequence of operations",
			"Waste or scrap material from production",
			"Tooling or clamping device for assembly or testing"
		]
	},
	{
		"imagen": preload("res://Assets/Sprites/Quiz4.jpeg"),
		"correcta": "Yield or percentage of good products on the first attempt",
		"opciones": [
			"Amount of product that passes through a system in a given time",
			"Yield or percentage of good products on the first attempt",
			"Time required for a machine to complete one unit"
		]
	},
	{
		"imagen": preload("res://Assets/Sprites/Quiz5.jpeg"),
		"correcta": "Standardized work exact sequence of operations",
		"opciones": [
			"Standardized work exact sequence of operations",
			"Production rhythm needed to meet customer demand",
			"Down time or inactivity of a line or machine"
		]
	},
	{
		"imagen": preload("res://Assets/Sprites/Quiz6.jpeg"),
		"correcta": "Production rhythm needed to meet customer demand",
		"opciones": [
			"Waste or scrap material from production",
			"Production rhythm needed to meet customer demand",
			"Tooling or clamping device for assembly or testing"
		]
	},
	{
		"imagen": preload("res://Assets/Sprites/Quiz7.jpeg"),
		"correcta": "Amount of product that passes through a system in a given time",
		"opciones": [
			"Amount of product that passes through a system in a given time",
			"Yield or percentage of good products on the first attempt",
			"Standardized work exact sequence of operations"
		]
	},
	{
		"imagen": preload("res://Assets/Sprites/Quiz8.jpeg"),
		"correcta": "Tooling or clamping device for assembly or testing",
		"opciones": [
			"Time required for a machine to complete one unit",
			"Tooling or clamping device for assembly or testing",
			"Production rhythm needed to meet customer demand"
		]
	}
]

var indice_actual: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

	option_a.pressed.connect(_on_option_pressed.bind(option_a))
	option_b.pressed.connect(_on_option_pressed.bind(option_b))
	option_c.pressed.connect(_on_option_pressed.bind(option_c))

func abrir_quiz() -> void:
	indice_actual = 0
	feedback_label.text = ""
	show()
	get_tree().paused = true
	mostrar_pregunta()

func cerrar_quiz() -> void:
	hide()
	get_tree().paused = false

func mostrar_pregunta() -> void:
	var pregunta = preguntas[indice_actual]

	quiz_image.texture = pregunta["imagen"]
	question_label.text = "Select the correct definition"
	feedback_label.text = ""

	var opciones = pregunta["opciones"].duplicate()
	opciones.shuffle()

	option_a.text = opciones[0]
	option_b.text = opciones[1]
	option_c.text = opciones[2]

func _on_option_pressed(button: Button) -> void:
	var pregunta = preguntas[indice_actual]
	var respuesta_correcta = pregunta["correcta"]

	if button.text == respuesta_correcta:
		feedback_label.text = "Correct!"
		await get_tree().create_timer(0.5, true).timeout

		indice_actual += 1

		if indice_actual >= preguntas.size():
			cerrar_quiz()

			var nivel = get_tree().current_scene
			if nivel.has_method("marcar_supervisor_aprobado"):
				nivel.marcar_supervisor_aprobado()
		else:
			mostrar_pregunta()
	else:
		feedback_label.text = "Incorrect. Try again."
