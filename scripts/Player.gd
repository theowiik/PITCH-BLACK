extends "res://scripts/Actor.gd"

class_name Player

var controlling: bool = true;
const projectile: PackedScene = preload("res://scenes/Projectile.tscn")

signal shoot
signal rocket_added

# Returns a normalized input vector.
func get_input_vector() -> Vector2:
	var vec = Vector2(0,0)

	if Input.is_action_pressed("up"): vec.y -= 1
	if Input.is_action_pressed("down"): vec.y += 1
	if Input.is_action_pressed("right"): vec.x += 1
	if Input.is_action_pressed("left"): vec.x -= 1

	return vec.normalized()

func _physics_process(_delta: float) -> void:
	if not controlling: return

	# Move
	var vel: Vector2 = move_and_slide(get_input_vector() * movement_speed)
	play_anim(vel)

	# Shoot
	if Input.is_action_just_pressed("shoot"):
		var proj: Projectile = projectile.instance()
		proj.global_position = global_position
		emit_signal("shoot", proj)
		get_tree().set_input_as_handled()

	# Rocket
	if Input.is_action_just_pressed("add_rocket"):
		controlling = false
		emit_signal("rocket_added")
		get_tree().set_input_as_handled()
