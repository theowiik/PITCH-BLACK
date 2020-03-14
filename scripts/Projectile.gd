extends Area2D

class_name Projectile

var dir_vector: Vector2 = Vector2(0, 0)
const speed: int = 200;

func _ready():
	var m = get_global_mouse_position()
	var c_pos = global_position
	dir_vector = Vector2(m.x - c_pos.x, m.y - c_pos.y).normalized()

func _physics_process(delta):
	transform = transform.translated(dir_vector * speed * delta)
