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
