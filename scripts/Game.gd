extends Node2D

func _ready():
	get_node("Actor").connect("shoot", self, "on_shoot")

func on_shoot(projectile: Projectile) -> void:
	add_child(projectile)
