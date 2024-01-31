extends Control


func _ready():
	visible = false;


func _on_PlayAgainButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Levels/Level1.tscn")
	
	
func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/UI/MainMenu.tscn")
