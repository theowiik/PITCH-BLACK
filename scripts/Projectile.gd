extends Area2D

class_name Projectile

var dir_vector = Vector2(1, 1)
const speed = 200;

func _ready():
	var m: Vector2 = get_global_mouse_position()
	dir_vector = Vector2(
					m.x - global_position.x,
					m.y - global_position.y).normalized()

func _physics_process(delta):
	transform = transform.translated(dir_vector * speed * delta)
