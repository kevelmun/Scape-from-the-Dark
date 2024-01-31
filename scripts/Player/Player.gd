extends KinematicBody2D
class_name Player

# Definir las constantes para el movimiento
const VELOCIDAD = 200
const FUERZA_SALTO = -400
const FUERZA_SALTO_DOBLE = -450
const GRAVEDAD = 22
const MAX_SALTOS = 2

# Estadisticas del jugador
var fuel
var stats: PlayerStats
var text_balloon_executed = false 
var can_move = true

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
# Variable de estado de muerte
var death = false
var once_dead = false
# Variable de control de fuego no permitido
var can_use_fire=true


## Señales

# Indica que el jugador ha perdido (value) puntos de combutible
signal reduce_fuel(value)
# Indica que el jugador ha ganado (value) puntos de combutible
signal add_fuel(value)
# Indica que el jugador ha perdido todo su combutible
signal lost_all_fuel()
# Indica si la animacion de muerte termino de reproducirse
signal death_signal()


## Obtener referencias a los nodos

onready var animacion = $AnimationPlayer
onready var animacion_text_balloon = $AnimationPlayer2
onready var sprite_text_balloon = $Sprite2
onready var sprite = $Sprite
onready var light2d = $Light2D
onready var loseFuelTimer = $LoseFuelTimer


onready var text_ballon_was_showed = !GameStatistics.instruction_showed
func _ready():
	stats = PlayerStatitics
	fuel = stats.max_fuel_capability

func _physics_process(delta):
	
	if estadoxd:
		if not text_ballon_was_showed:
			text_balloon_executed = true
			can_move = false # Impide el movimiento durante la animación
			yield(get_tree().create_timer(3), "timeout")
			sprite_text_balloon.visible = true
			animacion_text_balloon.play("TextBalloon")
			return
		
		if can_move == false:
			return	

	# Si ya esta muerto el jugador no se hace nada mas
	if once_dead: return
	# Morir	
	if death:
		once_dead = true
		animacion.play("Death")
		return
	
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
		if (not fire_on) and (fuel > 0):
			animacion.play("Fire_Start")
			fire_on = true
	elif not Input.is_action_pressed("ui_accept"):
		fire_on = false
		light2d.enabled = false
		$SoundsEffects.stop()

	if fuel <= 0 and animacion.is_playing() and can_use_fire:
		animacion.stop()  # Esto interrumpe la animación en curso
		# Aquí puedes también cambiar a una animación de 'idle' o similar si es necesario
		animacion.play("Idle")	
		fire_on = false
		light2d.enabled = false
		can_use_fire = false	
	

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
		lose_fuel(GameStatistics.FUEL_CONSUME_VALUE_FIRE)
	if anim_name == "Fire" and fire_on:
		loseFuelTimer.stop()
	
	if anim_name == "Death":
		emit_signal("death_signal")

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Fire" and fire_on:
		# Verificamos si hay velas para encender
		_light_candel()
		# Iniciamos un timer que se ejecuta cada seg. que presionamos el boton
		loseFuelTimer.start(1)

func _on_CandelsDetector_area_entered(area):
	if area.get_name() == "CandleLightingArea":
		var curr_node = area.get_parent()
		if "Candle" in curr_node.get_name():
			_all_interactions.insert(0, curr_node)

func _on_CandelsDetector_area_exited(area):
	if area.get_name() == "CandleLightingArea":
		_all_interactions.erase(area.get_parent())

func _on_LoseFuelTimer_timeout():
	if fire_on: lose_fuel(GameStatistics.FUEL_CONSUME_VALUE_FIRE)	

# Enciende la vela mas cercana si es que la hay
func _light_candel():
	if _all_interactions.size() > 0:
		var curr_interaction = _all_interactions[0]
		if curr_interaction && ! curr_interaction.on:
			curr_interaction.light_candel()
			self.in_safe_area = true

# Maneja la perdida de combustible del jugador
func lose_fuel(lose_value):
	fuel = fuel - lose_value if (fuel >= 0) else 0
	emit_signal("reduce_fuel", lose_value)
	
	# Si ya no hay combustible envia una señal que el jug. perdió
	if fuel <= 0: emit_signal("lost_all_fuel")

func add_fuel(value):
	var new_fuel_value_inc
	
	if (fuel + value) <= stats.max_fuel_capability:
		new_fuel_value_inc =  value
	else:
		new_fuel_value_inc =  stats.max_fuel_capability - fuel
	
	fuel += new_fuel_value_inc
	emit_signal("add_fuel", new_fuel_value_inc)

func _death():
	if not fire_on:
		death = true

func _on_AnimationPlayer2_animation_finished(anim_name):
	if anim_name == "TextBalloon":
		animacion_text_balloon.play("Idle")
		sprite_text_balloon.visible = false
		can_move = true
