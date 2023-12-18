extends Node2D

var world_on = true

onready var player = $Player

func _ready():
	# Iniciamos todos los elementos del HUD
	$HUD.update_attemps(GameStatistics.player_attemps)
	$HUD.init_fuel_bar(player.fuel)
	
func _physics_process(delta):
	if not world_on and not player.in_safe_area:
		# TODO: Manejar que acciones que se realizaran cuando el jugador no
		# este en un area con luz
		print("Jugador no se encuentra en el area segura")

func _on_DropZone_body_entered(body):
	_manage_lose_attempt()

func _on_Player_lost_all_fuel():
	_manage_lose_attempt()

func _on_HUD_attempt_timeout():
	_manage_lose_attempt()

func _on_Bulb2_light_bulb_off():
	world_on = false
	
func _on_Bulb2_light_bulb_on():
	world_on = true

func _manage_lose_attempt():
	GameStatistics.player_attemps -= 1
	
	# Verificar si quedan intentos
	if GameStatistics.player_attemps > 0:
		# TODO: Agregar codigo al perder el intento
		get_tree().reload_current_scene()
	else:
		#TODO: Agregar codigo para el gameover
		get_tree().paused = not get_tree().paused
		GameStatistics.player_attemps = 4
		$HUD/GameOver.visible = true 
		print("Valiste")
