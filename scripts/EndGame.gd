extends Control


func _ready():
	visible = false;


func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://scenes/Levels/Level1.tscn")
	PlayerStatitics.attemps = 4
	PlayerStatitics.max_fuel_capability = 10
	
	
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/UI/MainMenu.tscn")
	get_tree().paused = not get_tree().paused
