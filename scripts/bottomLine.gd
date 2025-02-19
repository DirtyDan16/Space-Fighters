extends Area2D

signal game_over

func _on_area_entered(area):
	if area.is_in_group("Enemies"): 
		game_over.emit();
		$DeathSfx.play()
