extends CanvasLayer

class_name HUD

func set_rockets(rockets: int) -> void:
	$HBoxContainer/VBoxContainer/Rockets.text = str(rockets)

func set_enemies(discovered: int, total: int) -> void:
	$HBoxContainer/VBoxContainer2/Enemies.text = str(discovered) + "/" + str(total)
