extends Control


func _ready():
	visible = false;


func _on_BackButton_pressed():
	get_tree().paused = not get_tree().paused
	get_tree().change_scene("res://scenes/UI/MainMenu.tscn")

func _on_RestartButton_pressed():
	PlayerStatitics.attemps = 4
	PlayerStatitics.max_fuel_capability = 10
	get_tree().paused = not get_tree().paused
	get_tree().reload_current_scene()

func _on_QuitButton_pressed():
	get_tree().quit()

 
