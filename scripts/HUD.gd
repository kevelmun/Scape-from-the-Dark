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
		
func init_fuel_bar(value):
	fuelBar.max_value = value
	fuelBar.value = value
	$FuelPanel/Label.set_text("%d / %d" % [fuelBar.value, fuelBar.max_value])

func increase_fuel_value(value):
	fuelBar.value -= value
	$FuelPanel/Label.set_text("%d / %d" % [fuelBar.value, fuelBar.max_value])

func _on_Player_reduce_fuel(value):
	increase_fuel_value(value)
