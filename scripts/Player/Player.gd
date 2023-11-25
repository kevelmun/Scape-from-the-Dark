extends KinematicBody2D

# Definir las constantes para el movimiento
const VELOCIDAD = 200
const FUERZA_SALTO = -500
const GRAVEDAD = 1200

# Definir la velocidad inicial
var velocidad = Vector2()
# Estado del del fuego
var fire_on = false




# Obtener referencias a los nodos
onready var animacion = $AnimationPlayer
onready var sprite = $Sprite
onready var light2d = $Light2D

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
	if Input.is_action_pressed("button_w") and is_on_floor():
		velocidad.y = FUERZA_SALTO
		light2d.enabled = false
		animacion.play("Jump")

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
	velocidad.y += GRAVEDAD * delta

	# Mover el personaje
	velocidad = move_and_slide(velocidad, Vector2.UP)



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fire_Start" and fire_on:
		light2d.enabled = true
		animacion.play("Fire")
	

