extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if !GameStatistics.instruction_showed:
		get_tree().paused = true
		visible = true
	else:
		visible = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		GameStatistics.instruction_showed = true
		print("Pausado")
		visible = false
		get_tree().paused = false
