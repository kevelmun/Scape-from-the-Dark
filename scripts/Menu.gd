extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartGameButton_pressed():
	PlayerStatitics.attemps = 4
	PlayerStatitics.max_fuel_capability = 10
	get_tree().change_scene("res://scenes/Levels/Level1.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
