extends Node2D

signal cutscene_finished

const rocket: PackedScene = preload("res://scenes/Rocket.tscn")
onready var player: Actor = get_node("Player")
onready var camera: Camera2D = get_node("Camera")
onready var cutscene: Cutscene = get_node("Cutscene")

var current_level: int = 0
var levels = [
	"res://scenes/levels/Level1.tscn",
	"res://scenes/levels/Level2.tscn",
	"res://scenes/levels/Level3.tscn",
]

func _ready() -> void:
	#intro()
	#yield(self, "cutscene_finished")

	# Signals
	player.connect("shoot", self, "on_shoot")
	player.connect("rocket_added", self, "on_rocket_added")

	# Camera
	remove_child(camera)
	player.add_child(camera)

	# Room
	reset_room()

func intro() -> void:
	cutscene.show()

	cutscene.display("...")
	yield(cutscene, "finished")
	cutscene.display("...")
	yield(cutscene, "finished")
	cutscene.display("it's so dark in here")
	yield(cutscene, "finished")
	cutscene.display("I need to find a flashlight")
	yield(cutscene, "finished")

	cutscene.hide()
	emit_signal("cutscene_finished")

func reset_room() -> void:
	# Remove all nodes
	for child in $Level.get_children():
		child.queue_free()

	# Create nodes
	var nextLevel: PackedScene = load(levels[current_level])
	var instance: Node2D = nextLevel.instance()
	$Level.add_child(instance)

	# Spawn
	var spawn: Vector2 = instance.get_node("Spawn").global_position
	player.global_position = spawn

	# Enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.player = player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		next_room()

func next_room() -> void:
	current_level += 1

	var finished = current_level >= levels.size()

	if finished:
		end_screen()
	else:
		reset_room()

func end_screen() -> void:
	$Cutscene.visible = true

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
	camera.zoom = Vector2(1.5, 1.5)

func set_normal_zoom() -> void:
	camera.zoom = Vector2(1, 1)
