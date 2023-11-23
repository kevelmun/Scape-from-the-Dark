extends Node2D

var on = false

onready var light_candel = $Light2D
onready var sprite = $AnimatedSprite

func _ready():
	# TODO reemplazar este llamado de func. por extinguish_candel
	# Solo se lo usa para pruebas
	light_candel()

func light_candel():
	on = true
	light_candel.enabled = true
	sprite.frame = 1

func extinguish_candel():
	on = false
	light_candel.enabled = false
	sprite.frame = 0

func switch_candel():
	if !on:
		light_candel()
	else:
		extinguish_candel()
