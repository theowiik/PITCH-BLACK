extends "res://scripts/Actor.gd"

# temp
onready var player: Actor
var detected: bool = false

func _ready():
	$Sprite.visible = false

func _physics_process(delta):
	if player == null: return
	move_and_slide(global_position.direction_to(player.global_position) * movement_speed)

func reveal() -> void:
	if detected: return
	$RevealText.visible = true
	$RevealTime.start()
	$Sprite.visible = true
	detected = true

func _on_RevealTime_timeout():
	$RevealText.visible = false
