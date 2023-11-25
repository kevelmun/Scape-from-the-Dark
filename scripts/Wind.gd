extends KinematicBody2D

var candels_list = []	#Lista de velas encendidas
var time_to_blow = 0.0	#Tiempo de espera para apagar la siguiente vela
var min_time = 10.0		#Tiempo mínimo de espera hasta apagar una vela
var max_time = 30.0		#Tiempo máximo de espera hasta apagar una vela
var rnd_index 			#Indice de la vela a apagar

var windTween = Tween.new()	 #Tween para mover la brisa hacia la vela 

func _ready():
	add_child(windTween)
	set_next_blow_time() 

# Función llamada en cada cuadro del juego
func _process(delta):
	time_to_blow -= delta

	# Verifica si es el momento de apagar una vela
	if time_to_blow <= 0.0:
		if candels_list.size() > 0:
			#Selecciona una vela de la lista
			rnd_index= randi() % candels_list.size()
			var target = candels_list[rnd_index].global_position
			
			# Mueve la brisa hacia la vela seleccionada
			move_wind_to_target(target)
			set_next_blow_time()

# Función para apagar una vela
func _blow_a_candle():
	if candels_list.size() > 0:
		var candle = candels_list[rnd_index]
		candle.extinguish_candel()
		candels_list.remove(rnd_index)

# Establece el tiempo para apagar la siguiente vela
func set_next_blow_time():
	candels_list = get_tree().get_nodes_in_group("CandlesOn")
	print(candels_list)
	time_to_blow = rand_range(min_time, max_time)

# Mueve la brisa hacia la posición de la vela
func move_wind_to_target(target):
	var position = target - Vector2(30, 0)
	self.visible = true
	
	windTween.interpolate_property(self, "position", position, target, 3, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	windTween.start()
	yield(windTween, "tween_completed") #espera hasta que la animación termine
	
	#Apaga la vela
	_blow_a_candle()
	
	self.visible = false
