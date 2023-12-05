extends Node2D

onready var player = $Player

func _ready():
	# Iniciamos todos los elementos del HUD
	$HUD.update_attemps(GameStatistics.player_attemps)
	$HUD.init_fuel_bar(player.fuel)

func _on_DropZone_body_entered(body):
	_manage_lose_attempt()
	
func _on_Player_lost_all_fuel():
	_manage_lose_attempt()

func _manage_lose_attempt():
	GameStatistics.player_attemps -= 1
	
	# Verificar si quedan intentos
	if GameStatistics.player_attemps > 0:
		get_tree().reload_current_scene()
	else:
		#TODO Agregar codigo para el gameover
		print("Valiste")
		pass



