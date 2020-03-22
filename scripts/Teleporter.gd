extends Area2D

class_name Teleporter

signal teleporter_entered

var entered: bool = false

func _ready():
	GameMeta.player_can_take_damage = true

func _on_Teleporter_body_entered(_body):
	if entered: return
	entered = true
	GameMeta.player_can_take_damage = false
	emit_signal("teleporter_entered")
