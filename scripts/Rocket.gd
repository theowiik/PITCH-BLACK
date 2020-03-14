extends Area2D

class_name Rocket

signal exploded

var dir_vector: Vector2 = Vector2(0, 0)
const speed: int = 200
const rotation_speed: float = 0.1

func _physics_process(delta) -> void:
	var desired_dir: Vector2 = dir_to_mouse()
	dir_vector = (dir_vector + desired_dir * rotation_speed).normalized()
	global_position += dir_vector * speed * delta
	global_rotation = dir_vector.angle()

# Returns a normalized vector pointing towards the mouse from the rocket.
func dir_to_mouse() -> Vector2:
	var m = get_global_mouse_position()
	return global_position.direction_to(m).normalized()

func explode() -> void:
	emit_signal("exploded")
	queue_free()

func _input(event) -> void:
	if event.is_action_pressed("explode_rocket"):
		explode()
		get_tree().set_input_as_handled()

func _on_DetectionArea_body_entered(body):
	body.reveal()
