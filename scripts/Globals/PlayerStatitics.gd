extends Node

signal update_max_fuel_capability(value)

export (int) var max_fuel_capability = 10 setget _set_max_fuel_cap,  _get_max_fuel_cap
export (int) var attemps = 4 setget _set_attemps, _get_attemps

func _set_max_fuel_cap(value):
	max_fuel_capability = value
	emit_signal("update_max_fuel_capability", max_fuel_capability)

func _get_max_fuel_cap():
	return max_fuel_capability

func _set_attemps(value):
	attemps = value
	
func _get_attemps():
	return attemps
