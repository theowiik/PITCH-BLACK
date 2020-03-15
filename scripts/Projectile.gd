extends Area2D

class_name Projectile

var dir_vector: Vector2 = Vector2(0, 0)
var damage: int = 50
const speed: int = 250;

func _ready():
	var m = get_global_mouse_position()
	dir_vector = global_position.direction_to(m).normalized()

func _physics_process(delta):
	transform = transform.translated(dir_vector * speed * delta)

func _on_Projectile_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
