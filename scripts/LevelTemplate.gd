extends Node2D

class_name LevelTemplate

func get_teleporter() -> Teleporter:
	var teleporter: Teleporter = $Teleporter
	return teleporter

func get_navigation() -> Navigation2D:
	var nav: Navigation2D = $Navigation2D
	return nav
