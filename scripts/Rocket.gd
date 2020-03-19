extends Area2D

class_name Rocket

signal exploded

var dir_vector: Vector2 = Vector2.ZERO
const speed: int = 200
const rotation_speed: float = 0.07
const smoke: PackedScene = preload("res://scenes/Smoke.tscn")
onready var smoke_delay: Timer = $Timer

func _ready():
	dir_vector = dir_to_mouse()

func _physics_process(delta: float) -> void:
	move_loop(delta)
	rotation_loop()

	if time_to_smoke():
		$AudioStreamPlayer2D.play()
		add_smoke()

	if Input.is_action_just_pressed("explode_rocket"):
		explode()
		get_tree().set_input_as_handled()

func time_to_smoke() -> bool:
	return smoke_delay.is_stopped()

func move_loop(delta: float) -> void:
	var desired_dir: Vector2 = dir_to_mouse()
	var angle_to_mouse: float = dir_vector.angle_to(desired_dir)
	dir_vector = dir_vector.rotated(angle_to_mouse * rotation_speed).normalized()
	print(dir_vector)
	#dir_vector = (dir_vector + desired_dir * rotation_speed).normalized()
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

func _draw():
	draw_circle_arc_poly(Vector2.ZERO, 70, -50, 50, Color(1, 1, 1, 0.6))

# From Godot docs
func draw_circle_arc_poly(center: Vector2, radius: float, angle_from: float, angle_to: float, color: Color):
	var nb_points: int = 32
	var points_arc: PoolVector2Array = PoolVector2Array()
	points_arc.push_back(center)
	var colors: PoolColorArray = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(deg2rad(angle_point)), sin(deg2rad(angle_point))) * radius)

	draw_polygon(points_arc, colors)
