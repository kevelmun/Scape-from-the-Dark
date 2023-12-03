extends Node2D

onready var fuelBar = $TextureProgress
onready var percentage = $Label

func set_fuel_value(value):
	fuelBar.value -= value
	percentage.set_text("%.2f %%" % _calculate_percentage_fuel())

func _calculate_percentage_fuel():
	var curr_percentage = (fuelBar.value / fuelBar.max_value) * 100
	if curr_percentage <= 0:
		return 0
	return curr_percentage
