extends Area2D

class_name Teleporter

signal teleporter_entered

var entered: bool = false

func _on_Teleporter_body_entered(_body):
	if entered: return
	entered = true
	emit_signal("teleporter_entered")
