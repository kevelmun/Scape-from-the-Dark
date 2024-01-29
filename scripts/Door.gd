extends Area2D

signal player_reached_door(move_to_level)

export(String, FILE) var NEXT_LEVEL: String = ""

func _on_Door_body_entered(body):
	if body.is_in_group("Player") and NEXT_LEVEL != "":
		emit_signal("player_reached_door", NEXT_LEVEL)

