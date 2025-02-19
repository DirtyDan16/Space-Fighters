extends "res://scripts/level_skeleton.gd"

#-----------CONST
func _ready():
	
	SignalManager.connect_signal("laserCollisionParticles",self,"laser_colliding_with_enemy")
	
	LASER_SPEED = 4;
	REGULAR_ENEMY_SPEED = 20;
	START_POS = Vector2(960,930);
	SHOT_DELAY = 0.5;
	REGULAR_ENEMY_HP  = 2;
	REGULAR_ENEMY_JITTER = [-10,10];
	
	#modifing shot delay for level variety
	spaceship.setShotDelay(SHOT_DELAY);
	
	for node in enemies.get_children():
		if node.is_in_group("BuffyEnemies"):
			node.set_hp(15);
		else: node.set_hp(REGULAR_ENEMY_HP);
	
	new_game()

func _on_reset_level_reset_level():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn");

func _on_open_new_level():
	LevelsUnlocked.make_level_available("Level2Button")

