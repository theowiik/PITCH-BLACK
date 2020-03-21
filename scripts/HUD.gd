extends CanvasLayer

class_name HUD

var discovered: int = 0
var total_enemies: int = 0
var rockets: int = 0

func _ready():
	set_visible(false)

func set_visible(s: bool) -> void:
	$HBoxContainer/VBoxContainer/Rockets.visible = s
	$HBoxContainer/VBoxContainer2/Enemies.visible = s

func decrease_discovered() -> void:
	discovered -= 1
	update_enemies()

func decrease_rockets() -> void:
	rockets -= 1
	update_rockets()

func update() -> void:
	update_enemies()
	update_rockets()

func update_rockets() -> void:
	$HBoxContainer/VBoxContainer/Rockets.text = str(rockets) + " rockets"

func update_enemies() -> void:
	$HBoxContainer/VBoxContainer2/Enemies.text = str(discovered) + "/" + str(total_enemies)
