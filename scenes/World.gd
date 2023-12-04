extends Node2D

onready var player = $Player

func _ready():
	$HUD.update_attemps(GameStatistics.player_attemps)
	$HUD.init_fuel_bar(player.fuel)


func _on_DropZone_body_entered(body):
	GameStatistics.player_attemps -= 1
	if GameStatistics.player_attemps >= 0:
		get_tree().reload_current_scene()
	else:
		#TODO Agregar codigo para el gameover
		pass
