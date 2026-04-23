extends "res://Scripts/levels/LevelBase.gd"

var cartas_leidas: bool = false
var supervisor_aprobado: bool = false
var incorrect_attempts: int = 0
var start_time_ms: int = 0
var nivel_completado: bool = false

var codigo_puerta: String = ""
var panel_desbloqueado: bool = false

@onready var door_lamp = get_node_or_null("Door/DoorLamp")
@onready var quiz_window = $UI/QuizWindow
@onready var level_complete_window = $UI/LevelCompleteWindow
@onready var code_dialog = $UI/CodeDialog
@onready var keypad_window = $UI/KeypadWindow


@onready var cards_table = $Mesa
@onready var supervisor = $Supervisor
@onready var wall_panel = $PanelPared
@onready var door = $Door

var lamp_red: Texture2D = preload("res://Assets/Door/lamp.png")
var lamp_yellow: Texture2D = preload("res://Assets/Door/lamp1.png")
var lamp_green: Texture2D = preload("res://Assets/Door/lamp2.png")

func _ready() -> void:
	super._ready()
	start_time_ms = Time.get_ticks_msec()
	actualizar_lampara()
	

func actualizar_lampara() -> void:
	if door_lamp == null:
		return

	if panel_desbloqueado:
		door_lamp.texture = lamp_green
	elif cartas_leidas:
		door_lamp.texture = lamp_yellow
	else:
		door_lamp.texture = lamp_red


func marcar_cartas_leidas() -> void:
	cartas_leidas = true
	actualizar_lampara()


	if has_node("UI/InteractLabel"):
		$UI/InteractLabel.text = "Go to the supervisor"

func puede_hablar_con_supervisor() -> bool:
	return cartas_leidas and not supervisor_aprobado

func registrar_intento_incorrecto() -> void:
	incorrect_attempts += 1
	print("Errores:", incorrect_attempts)

	if incorrect_attempts >= 4:
		game_over()

func marcar_supervisor_aprobado() -> void:
	supervisor_aprobado = true
	

	if has_node("UI/InteractLabel"):
		$UI/InteractLabel.text = "Go to the wall panel"

	generar_codigo_puerta()
	mostrar_codigo_supervisor()

func generar_codigo_puerta() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	codigo_puerta = ""
	for i in range(4):
		codigo_puerta += str(rng.randi_range(0, 9))

	print("Código generado:", codigo_puerta)

func mostrar_codigo_supervisor() -> void:
	if code_dialog != null:
		code_dialog.mostrar_codigo(codigo_puerta)

func desbloquear_puerta_por_codigo() -> void:
	panel_desbloqueado = true
	actualizar_lampara()
	

	if has_node("UI/InteractLabel"):
		$UI/InteractLabel.text = "Door unlocked"

	if has_node("Door"):
		$Door.abrir_puerta()

func show_dialog(message: String) -> void:
	if code_dialog != null:
		code_dialog.mostrar_codigo(message)

func completar_nivel() -> void:
	if nivel_completado:
		return

	nivel_completado = true
	

	var tiempo_final = obtener_tiempo_formateado()
	level_complete_window.mostrar_resultados(tiempo_final, incorrect_attempts, false)

func obtener_tiempo_formateado() -> String:
	var elapsed_ms = Time.get_ticks_msec() - start_time_ms
	var total_seconds = int(elapsed_ms / 1000)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]

func tiempo_actual() -> String:
	var elapsed_ms = Time.get_ticks_msec() - start_time_ms
	var total_seconds = int(elapsed_ms / 1000)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]

func game_over() -> void:
	print("GAME OVER")


	level_complete_window.mostrar_resultados(tiempo_actual(), incorrect_attempts, true)
