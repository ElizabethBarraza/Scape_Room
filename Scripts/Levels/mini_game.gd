extends Panel

@onready var card_display: TextureRect = $VBoxContainer/HBoxContainer/CardDisplay
@onready var btn_prev: Button = $VBoxContainer/HBoxContainer/BtnPrev
@onready var btn_next: Button = $VBoxContainer/HBoxContainer/BtnNext
@onready var sfx_card = $SfxCard

var cartas: Array[Texture2D] = [
	preload("res://Assets/Sprites/Card1.jpeg"),
	preload("res://Assets/Sprites/Card2.jpeg"),
	preload("res://Assets/Sprites/Card3.jpeg"),
	preload("res://Assets/Sprites/Card4.jpeg"),
	preload("res://Assets/Sprites/Card5.jpeg"),
	preload("res://Assets/Sprites/Card6.jpeg"),
	preload("res://Assets/Sprites/Card7.jpeg"),
	preload("res://Assets/Sprites/Card8.jpeg"),
]

var indice_actual: int = 0

func _ready() -> void:
	# IMPORTANTE: que funcione aunque el juego esté en pausa
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Conectar botones
	btn_prev.pressed.connect(_on_prev_pressed)
	btn_next.pressed.connect(_on_next_pressed)

	# Configuración visual
	card_display.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	card_display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

	actualizar_carta()


# 🔹 ESTA FUNCIÓN SE LLAMA DESDE mesa.gd
func abrir_minijuego():
	var nivel = get_tree().current_scene
	if nivel.has_method("hide_objective_ui"):
		nivel.hide_objective_ui()

	visible = true
	get_tree().paused = true


# 🔹 Cerrar con ESC
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		cerrar_minijuego()


func _on_prev_pressed() -> void:
	sfx_card.play()
	indice_actual = (indice_actual - 1 + cartas.size()) % cartas.size()
	actualizar_carta()


func _on_next_pressed() -> void:
	sfx_card.play()
	indice_actual = (indice_actual + 1) % cartas.size()
	actualizar_carta()


func actualizar_carta() -> void:
	card_display.modulate.a = 0
	await get_tree().create_timer(0.08, true).timeout
	card_display.texture = cartas[indice_actual]
	card_display.modulate.a = 1
	
func cerrar_minijuego():
	visible = false
	get_tree().paused = false
	
	var nivel = get_tree().current_scene

	# 🔹 VOLVER A MOSTRAR OBJECTIVE
	if nivel.has_method("show_objective_ui"):
		nivel.show_objective_ui()

	# 🔹 LÓGICA DEL NIVEL
	if nivel.has_method("marcar_cartas_leidas"):
		nivel.marcar_cartas_leidas()
