extends "res://scripts/LevelTemplate.gd"

func _on_FlashlightPickupArea_body_entered(body):
	$Flashlight.queue_free()
	$PickupPlayer.play()
	get_parent().get_parent().flashlight_picked_up()

	yield(get_tree().create_timer(3), "timeout")

	get_parent().get_parent().turn_on_flashlight()

	$SpookPlayer.play()
	var fake_enemy_scene: PackedScene = load("res://scenes/FakeEnemy.tscn")
	for pos in $HiddenEnemies.get_children():
		var instance: Sprite = fake_enemy_scene.instance()
		add_child(instance)
		instance.global_position = pos.global_position

	yield(get_tree().create_timer(2), "timeout")

	get_parent().get_parent().end_screen()
