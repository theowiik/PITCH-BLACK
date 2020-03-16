extends "res://scripts/Actor.gd"

class_name Enemy

# temp
onready var player: Actor
var detected: bool = false
var chocked: bool = false
var chasing: bool = false
var path := PoolVector2Array();
onready var nav_2d: Navigation2D = $Navigation2D

func _ready():
	add_to_group("enemies")
	$Sprite.visible = false

func _physics_process(delta):
	if player == null || not chasing || chocked:
		return

	if Input.is_action_just_pressed("debug2"):
		print("yooo")
		path = nav_2d.get_simple_path(global_position, player.global_position)

	# move_and_slide(global_position.direction_to(player.global_position) * movement_speed)
	move_along_path(movement_speed)

# From GDQuest
func move_along_path(distance: float) -> void:
	var start: Vector2 = position
	for i in range(path.size()):
		var distance_to_next := start.distance_to(path[0])

		if distance <= distance_to_next and distance >= 0.0:
			position = start.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			#set_process(false)
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

func _on_RevealTime_timeout():
	$RevealText.visible = false
	print("hi")
	chocked = false

func take_damage(damage: int) -> void:
	if detected:
		health -= damage
	else:
		health -= damage / 3.0

	chasing = true

	if health <= 0:
		queue_free()
