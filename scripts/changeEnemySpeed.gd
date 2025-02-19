extends Button

signal changeModifier

func _on_button_down():
	changeModifier.emit(2);
	self.text = "2x enemy speed"

func _on_button_up():
	changeModifier.emit(1);
	self.text = "1x enemy speed"
