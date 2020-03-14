extends KinematicBody2D

class_name Actor

const movement_speed: int = 100
const projectile: PackedScene = preload("res://scenes/Projectile.tscn")

signal shoot

func _process(_delta) -> void:
	move_and_slide(get_input_vector() * movement_speed)

# Returns a normalized input vector.
func get_input_vector() -> Vector2:
	var vec = Vector2(0,0)

	if Input.is_action_pressed("up"): vec.y -= 1
	if Input.is_action_pressed("down"): vec.y += 1
	if Input.is_action_pressed("right"): vec.x += 1
	if Input.is_action_pressed("left"): vec.x -= 1

	return vec.normalized()

func _unhandled_input(event) -> void:
	if event.is_action_pressed("shoot"):
		var proj: Projectile = projectile.instance()
		proj.global_position = global_position
		print("wasd")
		emit_signal("shoot", proj)
		get_tree().set_input_as_handled()
