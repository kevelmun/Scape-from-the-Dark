extends Area2D
class_name Powerup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func apply(body): pass

func _on_Powerup_body_entered(body):
	if body.get_name() == "Player":
		apply(body)
		queue_free()
