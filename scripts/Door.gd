extends Area2D

signal level_passed();

export(String, FILE) var NEXT_LEVEL: String = ""

func _on_Door_body_entered(body):
	if body.is_in_group("Player") and NEXT_LEVEL != "":
		emit_signal("level_passed");
		get_tree().change_scene(NEXT_LEVEL)
