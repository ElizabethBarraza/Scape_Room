extends "res://Scripts/levels/LevelBase.gd"

var cartas_leidas: bool = false
var supervisor_aprobado: bool = false

func marcar_cartas_leidas() -> void:
	cartas_leidas = true
	
	# opcional: cambiar texto de instrucción
	if has_node("UI/InteractLabel"):
		$UI/InteractLabel.text = "Go to the supervisor"

func marcar_supervisor_aprobado() -> void:
	supervisor_aprobado = true
	
	if has_node("Door"):
		$Door.abrir_puerta()
