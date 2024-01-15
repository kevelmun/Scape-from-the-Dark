extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

func _input(event):
	if event.is_action_pressed("button_w"):
		print("Pausado")
		visible = false
		get_tree().paused = false
