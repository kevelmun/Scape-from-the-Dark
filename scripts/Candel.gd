extends Node2D

# Cantidad de combustible para encender la vela
var fuel_consumption
var on = false

onready var lightCandel = $Light2D
onready var sprite = $AnimatedSprite

func _init():
	fuel_consumption = 15

func _ready():
	# TODO reemplazar este llamado de func. por extinguish_candel
	extinguish_candel()

# Encender vela
func light_candel():
	on = true
	lightCandel.enabled = true
	sprite.frame = 1
	add_to_group("CandlesOn")

# Apagar vela
func extinguish_candel():
	on = false
	lightCandel.enabled = false
	sprite.frame = 0
	remove_from_group("CandlesOn")

# Cambiar el estado de la vela entre prendido y apagado
func switch_candel():
	if !on:
		light_candel()
	else:
		extinguish_candel()

# Actualiza el estado del jugador para indicar si se encuentra en una area segura o no
func update_state_safe_area_player(body, value):
	if body.get_name() == "Player" and on:
		body.in_safe_area = value
		print("Player in safe area: ", body.in_safe_area)

func _on_CandelArea_body_entered(body):
	update_state_safe_area_player(body, true)

func _on_CandelArea_body_exited(body):
	update_state_safe_area_player(body, false)
