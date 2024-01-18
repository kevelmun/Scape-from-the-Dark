extends Node2D


const MAX_DURATION = 100
# Duracion inicial de la vela 
export var duration = 100

# Variable controlador de encendido
var on = false

onready var lightCandel = $Light2D
onready var sprite = $Sprite
onready var animacion = $AnimationPlayer

# Posicion inicial de la luz de la vela
onready var initial_y = lightCandel.position.y


	

func _ready():
	_candle_burning_out()

func _process(delta):
	if !on:
		_playAnimation("Fire_Off_")
	if on:
		_playAnimation("Fire_On_")


func _playAnimation(baseName: String):
	var size = ""
	
	var new_y = initial_y

	

	if duration > (MAX_DURATION * 0.6):
		lightCandel.energy = 1
		new_y -= 60
		size = "L"
	elif duration > (MAX_DURATION * 0.35):
		lightCandel.energy = 0.9
		new_y -= 40
		size = "M"
	elif duration > (MAX_DURATION * 0.15):
		lightCandel.energy = 0.8
		new_y -= 20
		size = "S"
	else:
		lightCandel.energy = 0.7
		new_y -= 0
		size = "XS"

	animacion.play(baseName + size)


	# Asigna la nueva posición "Y" al Light2D
	lightCandel.position.y = new_y
	$CandleSafeArea.position.y = new_y


func _candle_burning_out():
	# Define el intervalo de tiempo en segundos para reducir la duración
	var interval = 0.5  # Cambia esto según tus necesidades
	
	# Configura un temporizador para llamar a la función cada 'interval' segundos
	var timer = Timer.new()
	timer.wait_time = interval
	timer.one_shot = false
	add_child(timer)
	timer.start()
	
	# Conecta el temporizador a la función que disminuirá la duración solo si la vela está encendida
	timer.connect("timeout", self, "_on_timer_timeout")

# Esta función se ejecutará cada vez que el temporizador alcance su tiempo de espera
func _on_timer_timeout():
	# Verifica si la vela está encendida antes de reducir la duración
	if on:
		# Reduzca la duración y verifique que no sea menor que cero
		duration -= 1
		if duration < 0:
			extinguish_candel()
			animacion.play("Fire_Off_XS")
			duration = 0



func light_candel():
	if duration > 0:
		on = true
		lightCandel.enabled = true
		add_to_group("CandlesOn")	
	

# Apagar vela
func extinguish_candel():
	on = false
	lightCandel.enabled = false
	if self.is_in_group("CandlesOn"):
		remove_from_group("CandlesOn")
	
	for body in $CandleSafeArea.get_overlapping_bodies():
		if body.get_name() == "Player":
			body.in_safe_area = false


# Cambiar el estado de la vela entre prendido y apagado
func switch_candel():
	if !on:
		light_candel()
	else:
		extinguish_candel()


func _on_CandleSafeArea_body_entered(body):
	if body.get_name() == "Player" and on:
		body.in_safe_area = true

func _on_CandleSafeArea_body_exited(body):
	if body.get_name() == "Player" and on:
		body.in_safe_area = false
