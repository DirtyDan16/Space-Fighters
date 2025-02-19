extends Area2D

func _on_area_entered(area: Object):
	if area.is_in_group("Lasers"):
		#print("Laser Blocked by enemy!");
		area.queue_free();
