extends Area2D

class_name Rocket

signal exploded

var dir_vector: Vector2 = Vector2(0, 0)
const speed: int = 200
const rotation_speed: float = 0.07
const smoke: PackedScene = preload("res://scenes/Smoke.tscn")
onready var smoke_delay: Timer = get_node("Timer")

func _physics_process(delta: float) -> void:
	move_loop(delta)
	rotation_loop()

	if time_to_smoke():
		add_smoke()

	if Input.is_action_just_pressed("explode_rocket"):
		explode()
		get_tree().set_input_as_handled()

func time_to_smoke() -> bool:
	return smoke_delay.is_stopped()

func move_loop(delta: float) -> void:
	var desired_dir: Vector2 = dir_to_mouse()
	dir_vector = (dir_vector + desired_dir * rotation_speed).normalized()
	global_position += dir_vector * speed * delta

func rotation_loop() -> void:
	global_rotation = dir_vector.angle()

func add_smoke() -> void:
	smoke_delay.start()
	var s = smoke.instance()
	s.global_position = global_position
	get_parent().add_child(s)
	s.emitting = true

# Returns a normalized vector pointing towards the mouse from the rocket.
func dir_to_mouse() -> Vector2:
	var m = get_global_mouse_position()
	return global_position.direction_to(m).normalized()

func explode() -> void:
	emit_signal("exploded")
	queue_free()

func _on_DetectionArea_body_entered(body):
	body.reveal()

func _on_Rocket_body_entered(body):
	explode()
