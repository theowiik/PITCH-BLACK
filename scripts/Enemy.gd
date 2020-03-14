extends "res://scripts/Actor.gd"

# temp
onready var player: Actor

func _ready():
	$Sprite.visible = false

func _physics_process(delta):
	if player == null: return
	move_and_slide(global_position.direction_to(player.global_position) * movement_speed)

func reveal() -> void:
	$Sprite.visible = true
