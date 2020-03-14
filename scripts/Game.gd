extends Node2D

const rocket: PackedScene = preload("res://scenes/Rocket.tscn")
onready var player: Actor = get_node("Actor")
onready var camera: Camera2D = get_node("Camera")

func _ready():
	player.connect("shoot", self, "on_shoot")
	remove_child(camera)
	player.add_child(camera)

func on_shoot(projectile: Projectile) -> void:
	add_child(projectile)

func on_rocket() -> void:
	var instance = rocket.instance()
	player.remove_child(camera)
	instance.add_child(camera)
	add_child(instance)
