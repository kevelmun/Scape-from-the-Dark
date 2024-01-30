extends Area2D

signal player_reached_door(move_to_level, is_final_screen)

export(String, FILE) var NEXT_LEVEL: String = ""

func _on_Door_body_entered(body):
	if body.is_in_group("Player") and NEXT_LEVEL != "":
		var is_final_screen = _is_final_screen(NEXT_LEVEL)
		emit_signal("player_reached_door", NEXT_LEVEL, is_final_screen)

func _is_final_screen(level_path: String) -> bool:
		return "EndGame" in level_path
