extends Node2D

onready var fuel_bar = $TextureProgress
onready var percentage = $Label

func set_fuel_value(value):
	fuel_bar.value -= value
	var curr_percentage = (fuel_bar.value / fuel_bar.max_value) * 100
	percentage.set_text("%.2f %%" % curr_percentage)
