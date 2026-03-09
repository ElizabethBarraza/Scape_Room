extends "res://Scripts/levels/LevelBase.gd"

var cartas_leidas: bool = false
var supervisor_aprobado: bool = false

func marcar_cartas_leidas() -> void:
	cartas_leidas = true

	if has_node("UI/InteractLabel"):
		$UI/InteractLabel.text = "Go to the supervisor"

func puede_hablar_con_supervisor() -> bool:
	return cartas_leidas and not supervisor_aprobado

func marcar_supervisor_aprobado() -> void:
	supervisor_aprobado = true

	if has_node("UI/InteractLabel"):
		$UI/InteractLabel.text = "The door is now open"

	if has_node("Door"):
		$Door.abrir_puerta()
