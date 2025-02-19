extends Button



signal start_game

func _on_pressed():
	start_game.emit();
	visible = false;
