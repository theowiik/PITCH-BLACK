extends CanvasLayer

class_name HUD

var discovered: int = 0
var total_enemies: int = 0
var rockets: int = 0

func decrease_discovered() -> void:
	discovered -= 1
	update_enemies()

func decrease_rockets() -> void:
	rockets -= 1
	update_rockets()

func update() -> void:
	update_enemies()
	update_enemies()

func update_rockets() -> void:
	$HBoxContainer/VBoxContainer/Rockets.text = str(rockets)

func update_enemies() -> void:
	$HBoxContainer/VBoxContainer2/Enemies.text = str(discovered) + "/" + str(total_enemies)
