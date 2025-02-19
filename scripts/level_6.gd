extends "res://scripts/level_skeleton.gd"

#-----------CONST
func _ready():
	
	SignalManager.connect_signal("laserCollisionParticles",self,"laser_colliding_with_enemy")
	
	LASER_SPEED = 6;
	REGULAR_ENEMY_SPEED = 40;
	START_POS = Vector2(960,930);
	SHOT_DELAY = 0.38;
	REGULAR_ENEMY_HP  = 4;
	SPACESHIP_MOVEMENT_SPEED = 550;
	SPACESHIP_HP = 7;
	ENEMY_LASER_SPEED = 9;
	REGULAR_ENEMY_JITTER = [-40,40]
	ENEMY_SHOT_DELAY = 1.75;
	
	#modifing shot delay for level variety
	spaceship.setShotDelay(SHOT_DELAY);
	spaceship.setSpeed(SPACESHIP_MOVEMENT_SPEED);
	spaceship.setHp(SPACESHIP_HP);
	
	for node in enemies.get_children():
		if node.is_in_group("ShootyEnemies") || node.is_in_group("JitterEnemies") :
			node.set_hp(3);
			if node.is_in_group("ShootyEnemies"):
				node.set_laser_speed(ENEMY_LASER_SPEED);
				node.get_node("ShotDelay").set_wait_time(ENEMY_SHOT_DELAY);

		elif node.is_in_group("BuffyEnemies"):
			node.set_hp(15);
		else: node.set_hp(REGULAR_ENEMY_HP);
	

	new_game()

func _on_reset_level_reset_level():
	get_tree().change_scene_to_file("res://scenes/levels/level_6.tscn");

func _on_open_new_level():
	LevelsUnlocked.make_level_available("Level7Button")
