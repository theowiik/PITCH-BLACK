extends Node2D

const rocket: PackedScene = preload("res://scenes/Rocket.tscn")
onready var player: Actor = get_node("Player")
onready var camera: Camera2D = get_node("Camera")

func _ready() -> void:
	player.connect("shoot", self, "on_shoot")
	player.connect("rocket_added", self, "on_rocket_added")
	remove_child(camera)
	player.add_child(camera)

func on_shoot(projectile: Projectile) -> void:
	add_child(projectile)

func on_rocket_added() -> void:
	set_high_fov()
	var instance = rocket.instance()
	player.remove_child(camera)
	instance.add_child(camera)
	instance.global_position = player.global_position
	instance.connect("exploded", self, "on_rocket_exploded")
	add_child(instance)

func on_rocket_exploded() -> void:
	set_normal_zoom()
	var cam_parent = camera.get_parent()
	if cam_parent != null:
		cam_parent.remove_child(camera)
	player.add_child(camera)
	player.controlling = true

func set_high_fov() -> void:
	camera.zoom = Vector2(2, 2)

func set_normal_zoom() -> void:
	camera.zoom = Vector2(1, 1)
