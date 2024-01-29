extends Node2D

var world_on = true

onready var player = $Player
onready var fadeAnimPlayer = $FadeAnimPlayer
# Variable que controla que la señal para morir no se ejecute repetidas veces
var once = false

func _ready():
	get_tree().paused = false
	
	# Iniciamos todos los elementos del HUD
	$HUD.update_attemps(player.stats.attemps)
	$HUD.initialize_fuel_bar(player.fuel, player.stats.max_fuel_capability)
	
func _process(delta):
	if once: return
	if not world_on and not player.in_safe_area and not player.fire_on:
		once = true
		# TODO: Manejar que acciones que se realizaran cuando el jugador no
		# este en un area con luz
		$Music.stop()
		get_tree().paused = true
		player._death()
			

func _on_DropZone_body_entered(body):
	$Music.stop()
	get_tree().paused = true
	player._death()

# func _on_Player_lost_all_fuel():
# 	_manage_lose_attempt()

func _on_HUD_attempt_timeout():
	$Music.stop()
	get_tree().paused = true
	player._death()

func _on_Player_death_signal():
	_manage_lose_attempt()

func _on_Bulb2_light_bulb_off():
	world_on = false
	
func _on_Bulb2_light_bulb_on():
	world_on = true

func _manage_lose_attempt():
	player.stats.attemps -= 1
	player.stats.max_fuel_capability = 10
	
	# Verificar si quedan intentos
	if player.stats.attemps > 0:
		# TODO: Agregar codigo al perder el intento
		get_tree().reload_current_scene()
	else:
		#TODO: Agregar codigo para el gameover
#		get_tree().paused = not get_tree().paused
		$HUD/GameOver.visible = true 
		print("Valiste")


func _on_Door_player_reached_door(move_to_level):
	fadeAnimPlayer.play("fade_in")
	yield(fadeAnimPlayer, "animation_finished")
	get_tree().change_scene(move_to_level)

