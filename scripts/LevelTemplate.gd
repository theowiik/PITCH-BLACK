extends Node2D

class_name LevelTemplate

var total_enemies: int = 0
var rockets: int = 3

func _ready():
	total_enemies = get_enemies().size()

func get_rockets() -> int:
	return rockets

func get_teleporter() -> Teleporter:
	var teleporter: Teleporter = $Teleporter
	return teleporter

func get_navigation() -> Navigation2D:
	var nav: Navigation2D = $Navigation2D
	return nav

func get_spawn() -> Vector2:
	var spawn: Vector2 = $Spawn.position
	return spawn

func get_total_enemies() -> int:
	return total_enemies

func get_enemies() -> Array:
	var enemies: Array = []
	for child in get_children():
		if child is Enemy:
			enemies.append(child)
	return enemies

func is_end() -> bool:
	return false
