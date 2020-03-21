extends "res://scripts/LevelTemplate.gd"

func _on_FlashlightPickupArea_body_entered(body):
	$Flashlight.queue_free()
