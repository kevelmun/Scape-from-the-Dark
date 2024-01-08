extends Node2D

var world_on = true

onready var player = $Player
# Variable que controla que la señal para morir no se ejecute repetidas veces
var once = false

func _ready():
	# Iniciamos todos los elementos del HUD
	$HUD.update_attemps(GameStatistics.player_attemps)
	$HUD.init_fuel_bar(player.fuel)
	
func _process(delta):
	if not world_on and not player.in_safe_area:
		once = true
		# TODO: Manejar que acciones que se realizaran cuando el jugador no
		# este en un area con luz
		print("Jugador no se encuentra en el area segura")
		player._death()

	# if (world_on and once) or (player.in_safe_area and once):
	# 	once = false
	# 	print("Reseteo de once")

func _on_DropZone_body_entered(body):
	_manage_lose_attempt()

# func _on_Player_lost_all_fuel():
# 	_manage_lose_attempt()

func _on_Player_death_signal():
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
		$HUD/GameOver.visible = true 
		print("Valiste")
