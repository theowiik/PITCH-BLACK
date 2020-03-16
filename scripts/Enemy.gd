extends "res://scripts/Actor.gd"

class_name Enemy

# temp
onready var player: Actor
var detected: bool = false
var chocked: bool = false
var chasing: bool = false

func _ready():
	add_to_group("enemies")
	$Sprite.visible = false

func _physics_process(delta):
	if player == null || not chasing || chocked:
		return

	move_and_slide(global_position.direction_to(player.global_position) * movement_speed)

func reveal() -> void:
	if detected: return
	$RevealText.visible = true
	$RevealTime.start()
	$Sprite.visible = true
	detected = true
	anim_player.play("chocked")
	chocked = true
	chasing = true

func _on_RevealTime_timeout():
	$RevealText.visible = false
	print("hi")
	chocked = false

func take_damage(damage: int) -> void:
	if detected:
		health -= damage
	else:
		health -= damage / 3.0

	if not detected:
		chocked = true

	chasing = true

	if health <= 0:
		queue_free()
