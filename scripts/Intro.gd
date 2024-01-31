extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Fade In")
	yield(get_tree().create_timer(6), "timeout")
	$AnimationPlayer.play("Fade Out")
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene("res://scenes/UI/MainMenu.tscn")
