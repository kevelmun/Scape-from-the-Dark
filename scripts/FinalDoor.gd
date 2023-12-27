extends Sprite

const FILE_START = "res://scenes/Levels/Level_"

func _ready():
	pass # Replace with function body.


func _on_Hitbox_area_entered(area: Area2D) -> void:
	print("Area entered")
	if area.is_in_group("Player"):
		var next_level = int(get_tree().current_scene.name) + 1
		print(FILE_START + str(next_level) + ".tscn")
		get_tree().change_scene(FILE_START + str(next_level) + ".tscn")
	else:
		print("No hay colision")
