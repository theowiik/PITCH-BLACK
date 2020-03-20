extends "res://scripts/LevelTemplate.gd"

var triggered: bool = false

func _ready():
	$RocketInfo.visible = GameMeta.scripted_death
	$KnifeInfo.visible = GameMeta.scripted_death

func _on_ScriptedDeathTrigger_body_entered(body) -> void:
	if GameMeta.scripted_death:
		return
	if triggered:
		return
	if not $TriggerDelay.is_stopped():
		return

	triggered = true

	get_parent().get_parent().get_node("Player").controlling = false

	var enemy: Enemy = get_node("Enemy")
	yield(get_tree().create_timer(1), "timeout")
	enemy.indicate_hidden()
	yield(get_tree().create_timer(1.3), "timeout")
	enemy.indicate_hidden()
	yield(get_tree().create_timer(1.3), "timeout")
	enemy.indicate_hidden()
	yield(get_tree().create_timer(1.3), "timeout")

	# Game jam quality code
	get_parent().get_parent().scripted_death()
	yield(get_parent().get_parent(), "cutscene_finished")
	get_enemies()[0].chasing = true

	GameMeta.scripted_death = true
