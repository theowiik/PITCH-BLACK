extends Node2D

signal cutscene_finished

const rocket: PackedScene = preload("res://scenes/Rocket.tscn")
onready var player: Player = get_node("Player")
onready var camera: Camera2D = get_node("Camera")
onready var cutscene: Cutscene = get_node("Cutscene")
onready var hud: HUD = $HUD

var current_level: int = 0
var levels = [
	"res://scenes/levels/Level0.tscn",
	"res://scenes/levels/Level1.tscn",
	"res://scenes/levels/Level2.tscn",
	"res://scenes/levels/Level3.tscn",
	"res://scenes/levels/Level4.tscn",
	"res://scenes/levels/Level5.tscn",
	"res://scenes/levels/Ending.tscn"
]

func end_screen() -> void:
	get_tree().change_scene("res://scenes/EndScreen.tscn")

func turn_on_flashlight() -> void:
	player.turn_on_flashlight()

func flashlight_picked_up() -> void:
	player.controlling = false
	$Music.stop()
	player.equip_flashlight()

func _ready() -> void:
	randomize()
	$Music.play()
	intro()
	yield(self, "cutscene_finished")

	# Signals
	player.connect("shoot", self, "on_shoot")
	player.connect("rocket_added", self, "on_rocket_added")
	player.connect("died", self, "reset_room")

	# Camera
	remove_child(camera)
	player.add_child(camera)

	# Room
	reset_room()

func ending_reached() -> void:
	player.can_shoot = false
	player.can_shoot_rockets = false
	hud.set_visible(false)

func scripted_death() -> void:
	player.controlling = false

	yield(get_tree().create_timer(2), "timeout")
	cutscene.show()
	cutscene.display("who dis?")
	yield(cutscene, "finished")
	cutscene.hide()
	emit_signal("cutscene_finished")

func intro() -> void:
	$Transition/ColorRect.color = Color(0, 0, 0)
	yield(get_tree().create_timer(3), "timeout")
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
	$RestartPlayer.play()
	get_tree().paused = true

	# Player
	player.health = player.max_health
	player.controlling = true
	player.can_shoot = GameMeta.scripted_death
	player.can_shoot_rockets = GameMeta.scripted_death

	# Camera
	set_normal_zoom()
	var cam_parent = camera.get_parent()
	if cam_parent != null:
		cam_parent.remove_child(camera)
	player.add_child(camera)

	# Remove possibly alive rocket
	for rocket in get_tree().get_nodes_in_group("rockets"):
		rocket.queue_free()

	# Remove current level
	for c in $Level.get_children():
		c.queue_free()

	yield(get_tree().create_timer(0.5), "timeout")

	# Instance scene
	var level: PackedScene = load(levels[current_level])
	var instance: LevelTemplate = level.instance()
	$Level.call_deferred("add_child", instance)

	player.rockets = instance.get_rockets()

	# Spawn
	player.global_position = instance.get_spawn()

	# Enemies
	for enemy in instance.get_enemies():
		enemy.player = player
		if not enemy.is_connected("request_path", self, "on_request_path"):
			enemy.connect("request_path", self, "on_request_path")
		if not enemy.is_connected("indicate_walk", self, "add_child"):
			enemy.connect("indicate_walk", self, "add_child")
		if not enemy.is_connected("discovered", self, "on_discovered"):
			enemy.connect("discovered", self, "on_discovered")

	# Door
	var teleporter: Teleporter = instance.get_teleporter()
	teleporter.connect("teleporter_entered", self, "next_room")

	# HUD
	hud.rockets = instance.get_rockets()
	hud.discovered = 0
	hud.total_enemies = instance.get_total_enemies()
	hud.update()
	hud.set_visible(GameMeta.scripted_death)

	if instance.is_end():
		hud.set_visible(false)
		player.can_shoot = false
		player.can_shoot_rockets = false

	# Fade and continue process
	get_tree().paused = false
	$Transition.fade_out()

func on_discovered() -> void:
	hud.decrease_discovered()

func on_request_path(from: Vector2, to: Vector2, who: Enemy) -> void:
	var level: LevelTemplate = $Level.get_child(0)
	var nav: Navigation2D = level.get_navigation()
	who.path = nav.get_simple_path(from, to)

func next_room() -> void:
	current_level += 1
	reset_room()

func on_shoot(projectile: Projectile) -> void:
	add_child(projectile)

func on_rocket_added() -> void:
	hud.decrease_rockets()
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
