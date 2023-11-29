extends Node2D

onready var light = $Light2D
onready var sprite = $AnimatedSprite

onready var flicker = $flickerTimer
onready var timeout = $lightTimeout

# Acciones al cargar la escena
func _ready():
	_random_bulb_state()

# Enciende el bombillo
func on_light_bulb():
	sprite.frame = 1
	light.enabled = true

# Apaga el bombillo
func off_light_bulb():
	sprite.frame = 0
	light.enabled = false


# Realiza un parpadeo de la luz del bombillo 2 veces despues de x seg.
func _on_blinkTimer_timeout():
	# Generamos un tiempo aleator. entre 10 a 15 seg.
	var rnd_time = 10 + randi() % 6
	
	for n in 5:
		if n % 2 == 0:
			off_light_bulb()
		else:
			on_light_bulb()
		yield(get_tree().create_timer(0.2), "timeout") # Detiene este codigo por 0.2 segundos
	
	# Al finalizar, reinicia el temporizador de parpadeo con x seg.
	print(rnd_time)
	flicker.start(rnd_time)
	
	_random_bulb_state()

# De manera aleatoria cambiamos el estado de la bombilla
func _random_bulb_state():
	if randf() >= 0.5: on_light_bulb()
	else: off_light_bulb()
