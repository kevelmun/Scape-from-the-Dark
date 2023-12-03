extends CanvasLayer

onready var timeCounter = $TimerPanel/Timer
onready var fuelBar = $FuelPanel/TextureProgress

func _ready():
	pass
	
func _physics_process(delta):
	_update_timer()

# Actualiza el tiempo sobrante acorde al Timer
func _update_timer():
	$TimerPanel/Label.set_text("Tiempo: %d" % timeCounter.time_left)

# Actualiza el numero de intentos sobrantes
func update_attemps(attemps):
	if attemps > 0:
		$Attemps/Label.set_text("Intentos: %d" % attemps)

func update_fuel_value(value):
	fuelBar.value -= value
	$FuelPanel/Label.set_text("%.2f %%" % _calculate_percentage_fuel())

func _calculate_percentage_fuel():
	var curr_percentage = (fuelBar.value / fuelBar.max_value) * 100
	if curr_percentage <= 0:
		return 0
	return curr_percentage
