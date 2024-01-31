extends Control

func _ready():
	visible = false


func _input(event):
	if event.is_action_pressed("pause"):
		print("Pausado")
		visible = not get_tree().paused
		get_tree().paused = not get_tree().paused


func _on_BackButton_pressed():
	get_tree().paused = not get_tree().paused
	get_tree().change_scene("res://scenes/UI/MainMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()

func update_master_vol(bus_indx, vol): #-50 min slider
	AudioServer.set_bus_volume_db(bus_indx,vol)

func _on_HSlider_value_changed(value:float):
	update_master_vol(0, value)
