extends Area2D

class_name Teleporter

signal teleporter_entered

func _on_Teleporter_body_entered(_body):
	emit_signal("teleporter_entered")
