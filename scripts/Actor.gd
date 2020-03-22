extends KinematicBody2D

class_name Actor

signal died

var max_health: float = 100
var health: float = max_health
var movement_speed: int = 100
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
const death_effect: PackedScene = preload("res://scenes/DeathEffect.tscn")

func take_damage(damage: int) -> void:
	health -= damage

	if health <= 0:
		emit_signal("died")
		queue_free()

func play_anim(vec: Vector2) -> void:
	if vec.x > 0:
		anim_player.play("right")
	elif vec.x < 0:
		anim_player.play("left")
	elif vec.y > 0:
		anim_player.play("down")
	elif vec.y < 0:
		anim_player.play("up")
	else:
		anim_player.play("idle")
