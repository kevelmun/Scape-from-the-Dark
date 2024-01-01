extends Node2D

signal light_bulb_off()
signal light_bulb_on()
signal time_left_for_flashing(time_left)

onready var light = $Light2D
onready var sprite = $AnimatedSprite
onready var flicker = $flickerTimer
onready var waitFlicker = $waitFlickerTimer

# Acciones al cargar la escena
func _ready():
	on_light_bulb()
	
func _physics_process(delta):
	if flicker.time_left <= 5:
		emit_signal("time_left_for_flashing", flicker.time_left)

# Enciende el bombillo
func on_light_bulb():
	sprite.frame = 1
	light.enabled = true

# Apaga el bombillo
func off_light_bulb():
	sprite.frame = 0
	light.enabled = false

# Realiza un parpadeo de la luz del bombillo 4 veces despues de x seg.
func _on_blinkTimer_timeout():
	# Generamos un tiempo aleator. entre 10 a 15 seg.
	var rnd_time = 10 + randi() % 6
	
	for n in 5:
		if n % 2 == 0:
			off_light_bulb()
		else:
			on_light_bulb()
			
		waitFlicker.start(0.2)
		yield(waitFlicker, "timeout") # Esperamos 0.2 segundos
	
	# Al finalizar, reinicia el temporizador de parpadeo con x seg.
	print("La bombilla empieza a parpadear en: ", rnd_time)
	flicker.start(rnd_time)
	
	_random_bulb_state()

# De manera aleatoria cambiamos el estado de la bombilla
func _random_bulb_state():
	if randf() >= 0.3:
		on_light_bulb()
		emit_signal("light_bulb_on")
	else:
		off_light_bulb()
		# Emitimos una senal de que la bombilla estara apagada temporalmente
		emit_signal("light_bulb_off")
