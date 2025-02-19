extends Button


var levelScreen: int = 0

func _on_pressed():
	levelScreen+=1
	if (levelScreen % 2 == 0):
		for button in %AllButtons.get_children():
			button.visible = false;
		for button in get_tree().get_nodes_in_group("Levels1-10"):
			button.visible = true;
	if (levelScreen % 2 == 1):
		for button in %AllButtons.get_children():
			button.visible = false;
		for button in get_tree().get_nodes_in_group("Levels11-20"):
			button.visible = true;
