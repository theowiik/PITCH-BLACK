extends KinematicBody2D

class_name Actor

var health: int = 100
const movement_speed: int = 100

func take_damage(damage: int) -> void:
	health -= damage

	if health <= 0:
		queue_free()
