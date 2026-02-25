extends Node2D

@export var player_scene : PackedScene

func _ready():

	var player = player_scene.instantiate()
	player.position = $PlayerSpawn.position
	add_child(player)
