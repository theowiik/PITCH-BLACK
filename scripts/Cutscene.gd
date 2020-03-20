extends CanvasLayer

class_name Cutscene

signal finished

onready var text_label: Label = get_node("CenterContainer/Label")
const delay_time: float = 0.0001
const finished_delay: float = 0.2

func _ready() -> void:
	text_label.text = ""

# Displays a message
func display(text: String) -> void:
	text_label.text = ""

	for i in text.length():
		text_label.text += text[i]
		$TalkPlayer.pitch_scale = rand_range(0.5, 1.5)
		$TalkPlayer.play()
		yield(get_tree().create_timer(delay_time), "timeout")

	yield(get_tree().create_timer(finished_delay), "timeout")
	emit_signal("finished")

func hide() -> void:
	text_label.visible = false

func show() -> void:
	text_label.visible = true
