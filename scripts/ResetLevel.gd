extends Button


signal resetLevel

func _on_pressed():
	resetLevel.emit();
	visible = false;
