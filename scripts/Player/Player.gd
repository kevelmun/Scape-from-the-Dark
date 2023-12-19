extends KinematicBody2D

# Definir las constantes para el movimiento
const VELOCIDAD = 200
const FUERZA_SALTO = -400
const FUERZA_SALTO_DOBLE = -450
const GRAVEDAD = 22
const MAX_SALTOS = 2
# Estadisticas del jugador
export var fuel = 20

# Definir la velocidad inicial
var velocidad = Vector2()
# Estado del del fuego
var fire_on = false
# Estado del jugador si esta en un lugar seguro
var in_safe_area = false
# Controlador del salto
var n_jump = 0
# Estado aereo
var suelo = true
# Lista para almacenar las interacciones cercanas
var _all_interactions = []

## Señales

# Indica que el jugador ha perdido (value) puntos de combutible
signal reduce_fuel(value)
# Indica que el jugador ha perdido todo su combutible
signal lost_all_fuel()

## Obtener referencias a los nodos

onready var animacion = $AnimationPlayer
onready var sprite = $Sprite
onready var light2d = $Light2D
onready var loseFuelTimer = $LoseFuelTimer

func _physics_process(delta):
	
	# Movimiento horizontal
	if Input.is_action_pressed("button_d") and not Input.is_action_pressed("button_s"):
		sprite.flip_h = false
		velocidad.x = VELOCIDAD
		if is_on_floor():
			light2d.enabled = false
			animacion.play("Walk")
	elif Input.is_action_pressed("button_a") and not Input.is_action_pressed("button_s"):
		sprite.flip_h = true
		velocidad.x = -VELOCIDAD
		if is_on_floor():
			light2d.enabled = false
			animacion.play("Walk")
	else:
		velocidad.x = 0
		if is_on_floor() and not Input.is_action_pressed("button_s") and not Input.is_action_pressed("ui_accept") and not Input.is_action_pressed("button_1"):
			animacion.play("Idle")
			
	# Saltar
	if is_on_floor():
		n_jump = 0
		suelo = true

	if Input.is_action_just_pressed("button_w") && n_jump < MAX_SALTOS:
		suelo = false
		if n_jump == 0:
			animacion.play("Jump")
			velocidad.y = FUERZA_SALTO
			light2d.enabled = false
			n_jump += 1
		elif n_jump == 1:
			animacion.play("Jump_2")
			velocidad.y = FUERZA_SALTO_DOBLE
			light2d.enabled = false
			n_jump += 1
			
	



	# Agacharse
	if Input.is_action_pressed("button_s") and is_on_floor():
		light2d.enabled = false
		animacion.play("Crouch")

	# Gesto
	if Input.is_action_pressed("button_1") and is_on_floor():
		light2d.enabled = false
		animacion.play("Gesture_1")

	# Prender fuego
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if not fire_on:
			animacion.play("Fire_Start")
			fire_on = true
	elif not Input.is_action_pressed("ui_accept"):
		fire_on = false
		light2d.enabled = false

	# Aplicar gravedad
	velocidad.y += GRAVEDAD 
	
	##velocidad.y += GRAVEDAD * delta

	# Mover el personaje
	velocidad = move_and_slide(velocidad, Vector2.UP)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fire_Start" and fire_on:
		light2d.enabled = true
		animacion.play("Fire")
		# Quitamos la cantidad de combustible al encender la chispa
		_lose_fuel(GameStatistics.FUEL_CONSUME_VALUE_FIRE)
		
	# 	# Verificamos si hay velas para encender
	# 	_light_candel()
	# 	# Iniciamos un timer que se ejecuta cada seg. que presionamos el boton
	# 	loseFuelTimer.start(1)
	if anim_name == "Fire" and fire_on:
		loseFuelTimer.stop()
	

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Fire" and fire_on:
		print("CONSUME COMBUSTIBLE")
		# Verificamos si hay velas para encender
		_light_candel()
		# Iniciamos un timer que se ejecuta cada seg. que presionamos el boton
		loseFuelTimer.start(1)

func _on_CandelsDetector_area_entered(area):
	var curr_node = area.get_parent()
	if "Candle" in curr_node.get_name():
		_all_interactions.insert(0, curr_node)

func _on_CandelsDetector_area_exited(area):
	_all_interactions.erase(area.get_parent())

func _on_LoseFuelTimer_timeout():
	if fire_on: _lose_fuel(GameStatistics.FUEL_CONSUME_VALUE_FIRE)	

# Enciende la vela mas cercana si es que la hay
func _light_candel():
	if _all_interactions.size() > 0:
		var curr_interaction = _all_interactions[0]
		if curr_interaction && ! curr_interaction.on:
			curr_interaction.light_candel()
			curr_interaction.update_state_safe_area_player(self, true)

# Maneja la perdida de combustible del jugador
func _lose_fuel(lose_value):
	fuel -= lose_value
	emit_signal("reduce_fuel", lose_value)
	
	# Si ya no hay combustible envia una señal que el jug. perdió
	if fuel <= 0: emit_signal("lost_all_fuel")




