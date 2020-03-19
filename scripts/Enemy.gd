extends "res://scripts/Actor.gd"

class_name Enemy

signal request_path
signal indicate_walk
signal discovered

var player: Actor
var detected: bool = false
var chocked: bool = false
var chasing: bool = false
var path := PoolVector2Array();
onready var nav_2d: Navigation2D = $Navigation2D
onready var walk_indicator: PackedScene = preload("res://scenes/Smoke.tscn")

func _ready():
	add_to_group("enemies")
	$Sprite.visible = false

func _physics_process(delta):
	if player == null || not chasing || chocked:
		return

	if $IndicatorTimer.is_stopped():
		var instance = walk_indicator.instance()
		instance.global_position = global_position
		instance.emitting = true
		emit_signal("indicate_walk", instance)
		$IndicatorTimer.start()
		if not detected: $HiddenWalkPlayer.play()

	if $NavigationRate.is_stopped():
		emit_signal("request_path", global_position, player.global_position, self)
		$NavigationRate.start()

	move_along_path(movement_speed * delta)

# From GDQuest
func move_along_path(distance: float) -> void:
	var start: Vector2 = position

	for _i in range(path.size()):
		var distance_to_next := start.distance_to(path[0])

		if distance <= distance_to_next and distance >= 0.0:
			position = start.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			break

		distance -= distance_to_next
		start = path[0]
		path.remove(0)

func reveal() -> void:
	if detected: return
	$RevealText.visible = true
	$RevealTime.start()
	$Sprite.visible = true
	detected = true
	anim_player.play("chocked")
	chocked = true
	chasing = true
	emit_signal("discovered")

func _on_RevealTime_timeout():
	$RevealText.visible = false
	chocked = false

func take_damage(damage: int) -> void:
	if detected:
		health -= damage
	else:
		health -= damage / 3.0

	chasing = true

	if health <= 0:
		var instance = death_effect.instance()
		instance.global_position = global_position
		instance.emitting = true
		add_death_player()
		get_parent().add_child(instance)
		queue_free()

func add_death_player() -> void:
		var d_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		d_player.stream = load("res://assets/sfx/death.wav")
		d_player.play()
		get_parent().add_child(d_player)
		d_player.global_position = global_position

func _on_DetectionArea_body_entered(body):
	if body is Player:
		chasing = true

func _on_DamageArea_body_entered(body):
	body.take_damage(50)
