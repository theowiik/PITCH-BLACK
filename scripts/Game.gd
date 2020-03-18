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
	player.connect("died", self, "reset_room")

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
	$Transition.fade_in()
	yield($Transition, "transition_finished")
	get_tree().paused = true

	# Health
	player.health = player.max_health

	# Remove current level
	for n in $Level.get_children():
		n.queue_free()

	# Instance scene
	var level: PackedScene = load(levels[current_level])
	var instance: LevelTemplate = level.instance()
	$Level.call_deferred("add_child", instance)

	# Spawn
	player.global_position = instance.get_spawn()

	# Enemies
	for enemy in instance.get_enemies():
		enemy.player = player
		if not enemy.is_connected("request_path", self, "on_request_path"):
			enemy.connect("request_path", self, "on_request_path")
		if not enemy.is_connected("indicate_walk", self, "add_child"):
			enemy.connect("indicate_walk", self, "add_child")

	# Door
	var teleporter: Teleporter = instance.get_teleporter()
	teleporter.connect("teleporter_entered", self, "next_room")

	# Fade and continue process
	camera.smoothing_enabled = false
	camera.global_position = instance.get_spawn()
	#camera.smoothing_enabled = true
	get_tree().paused = false
	$Transition.fade_out()

func on_request_path(from: Vector2, to: Vector2, who: Enemy) -> void:
	var level: LevelTemplate = $Level.get_child(0)
	var nav: Navigation2D = level.get_navigation()
	who.path = nav.get_simple_path(from, to)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		next_room()
	if event.is_action_pressed("debug2"):
		reset_room()

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
