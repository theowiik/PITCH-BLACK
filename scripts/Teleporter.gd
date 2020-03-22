extends Area2D

class_name Teleporter

signal teleporter_entered

func _ready():
	GameMeta.player_can_take_damage = true

func _on_Teleporter_body_entered(_body):
	GameMeta.player_can_take_damage = false
	emit_signal("teleporter_entered")
