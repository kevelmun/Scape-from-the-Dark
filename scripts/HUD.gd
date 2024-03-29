extends CanvasLayer

signal attempt_timeout()

export onready var timeCounter = $TimerPanel/Timer
onready var fuelBar = $FuelPanel/TextureProgress

onready var level = 0

func _ready():
	PlayerStatitics.connect("update_max_fuel_capability", self, "update_fuel_capability")
	
func _physics_process(delta):
	_update_timer()

func _on_Timer_timeout():
	emit_signal("attempt_timeout")

# Actualiza el tiempo sobrante acorde al Timer
func _update_timer():
	$TimerPanel/Label.set_text("Tiempo: %d" % timeCounter.time_left)

# Actualiza el numero de intentos sobrantes
func update_attemps(attemps):
	if attemps > 0:
		$Attemps/Label.set_text("Intentos: %d" % attemps)

func initialize_fuel_bar(fuel, max_fuel):
	fuelBar.value = fuel
	fuelBar.max_value = max_fuel
	$FuelPanel/Label.set_text("%d / %d" % [fuelBar.value, fuelBar.max_value])

func _on_Player_reduce_fuel(value):
	fuelBar.value -= value
	$FuelPanel/Label.set_text("%d / %d" % [fuelBar.value, fuelBar.max_value])

func _on_Player_add_fuel(value):
	fuelBar.value += value
	$FuelPanel/Label.set_text("%d / %d" % [fuelBar.value, fuelBar.max_value])

func update_fuel_capability(value):
	fuelBar.max_value = value
	$FuelPanel/Label.set_text("%d / %d" % [fuelBar.value, fuelBar.max_value])

func update_level_info(level):
	var current_level = int(level)
	$LevelPanel/Label.set_text("Nivel #%d" % current_level)
