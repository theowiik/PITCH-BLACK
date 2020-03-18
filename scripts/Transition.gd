extends CanvasLayer

class_name Transition

signal transition_finished

onready var anim_player: AnimationPlayer = $AnimationPlayer

func fade_in() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	emit_signal("transition_finished")

func fade_out() -> void:
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	emit_signal("transition_finished")
