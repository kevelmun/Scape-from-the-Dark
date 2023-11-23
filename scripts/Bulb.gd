extends Node2D

onready var light = $Light2D
onready var sprite = $AnimatedSprite

onready var blink = $blinkTimer
onready var timeout = $lightTimeout

# Acciones al cargar la escena
func _ready():
	on_light_bulb()

# Enciende el bombillo
func on_light_bulb():
	sprite.frame = 1
	light.enabled = true

# Apaga el bombillo
func off_light_bulb():
	sprite.frame = 0
	light.enabled = false

# Apaga el bombillo definitivamente cuando el tiempo de vida de este termina
func _on_lightTimeout_timeout():
	off_light_bulb()
	
	# Detenemos el temporizador de parpadeo
	blink.stop()
	print("Se apaga")

# Realiza un parpadeo de la luz del bombillo 2 veces despues de x seg.
func _on_blinkTimer_timeout():
	for n in 2:
		off_light_bulb()
		yield(get_tree().create_timer(0.5), "timeout") # Detiene este codigo por 0.5 segundos
		on_light_bulb()
		print("parpadeo")
	
	# Al finalizar, reinicia el temporizador de parpadeo
	blink.start() 
