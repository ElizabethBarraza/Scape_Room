extends Node2D

@export var player_scene : PackedScene
@export var texto_inicial : String = ""   

func _ready():
	var player = player_scene.instantiate()
	player.position = $PlayerSpawn.position
	add_child(player)

	if texto_inicial != "":
		await get_tree().process_frame  # Espera 1 frame para que UI esté lista
		var dialog = $UI/DialogBox
		dialog.mostrar_texto(texto_inicial)
