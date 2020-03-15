extends CanvasLayer

onready var text_label: Label = get_node("CenterContainer/Label")
onready var delay_timer: Timer = get_node("Delay")
var current_char: int = 0
var text: String = "heol"

func _ready() -> void:
	text_label.text = ""
	$Delay.start()

func _on_Delay_timeout() -> void:
	append_char()
	current_char += 1

	if current_char < text.length() - 1:
		$Delay.start()

func append_char() -> void:
	text_label.text += text[current_char]
