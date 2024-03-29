extends Node2D

signal light_bulb_off()
signal light_bulb_on()

onready var light = $Light2D
onready var sprite = $AnimatedSprite
onready var flicker = $flickerTimer
onready var waitFlicker = $waitFlickerTimer

# Acciones al cargar la escena
func _ready():
	for n in 8:
		if n % 2 == 0: off_light_bulb()
		else: on_light_bulb()
		waitFlicker.start(0.2)
		yield(waitFlicker, "timeout")

	on_light_bulb()
	flicker.start(7)
	
func _physics_process(delta):
	pass

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
	# Verificamos el estado del foco y establecemos un valor umbral
	var threshold = 0.2 if light.enabled else 0.5
	var rnd_time;
	
	for n in 5:
		if n % 2 == 0: off_light_bulb()
		else: on_light_bulb()
		waitFlicker.start(0.2)
		yield(waitFlicker, "timeout") # Esperamos 0.2 segundos
	
	print("Valor de umbral: ", threshold)
	_random_bulb_state_by_threshold(threshold)
	
	# Al finalizar, reinicia el temporizador de parpadeo con x seg.
	rnd_time = _get_random_switch_time()
	print("La bombilla empieza a parpadear en: ", rnd_time)
	flicker.start(rnd_time)

# De manera aleatoria cambiamos el estado de la bombilla
func _random_bulb_state_by_threshold(threshold):
	var random_num = randf()	
	print("Num. Aleatorio para apagado: ", random_num)
	
	if random_num <= threshold:
		on_light_bulb()
		emit_signal("light_bulb_on")
	else:
		off_light_bulb()
		emit_signal("light_bulb_off")

func _get_random_switch_time():
	if light.enabled:
		return 5 + randi() % 3 # Entre 5 a 7 seg.
	return 10 + randi() % 6 # Entre 10 a 15 seg.
