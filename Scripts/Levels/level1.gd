extends "res://Scripts/levels/LevelBase.gd"

var cartas_leidas: bool = false
var supervisor_aprobado: bool = false
var incorrect_attempts: int = 0
var start_time_ms: int = 0
var nivel_completado: bool = false

@onready var door_lamp = get_node_or_null("Door/DoorLamp")
@onready var level_complete_window = $UI/LevelCompleteWindow

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

	if supervisor_aprobado:
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

func marcar_supervisor_aprobado() -> void:
	supervisor_aprobado = true
	actualizar_lampara()

	if has_node("UI/InteractLabel"):
		$UI/InteractLabel.text = "The door is now open"

	if has_node("Door"):
		$Door.abrir_puerta()

func completar_nivel() -> void:
	if nivel_completado:
		return

	nivel_completado = true

	var tiempo_final = obtener_tiempo_formateado()
	level_complete_window.mostrar_resultados(tiempo_final, incorrect_attempts)

func obtener_tiempo_formateado() -> String:
	var elapsed_ms = Time.get_ticks_msec() - start_time_ms
	var total_seconds = int(elapsed_ms / 1000)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]
