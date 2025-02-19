extends "res://scripts/level_skeleton.gd"

#-----------CONST
func _ready():
	
	SignalManager.connect_signal("laserCollisionParticles",self,"laser_colliding_with_enemy")
	
	LASER_SPEED = 12;
	REGULAR_ENEMY_SPEED = 10;
	START_POS = Vector2(960,930);
	SHOT_DELAY = 0.25;
	REGULAR_ENEMY_HP  = 5;
	SPACESHIP_MOVEMENT_SPEED = 650;
	SPACESHIP_HP = 10;
	ENEMY_LASER_SPEED = 8;
	REGULAR_ENEMY_JITTER = [-25,25]
	ENEMY_SHOT_DELAY = 1.33;
	HORIZONTAL_MOVING_ENEMIES_SPEED = 9;
	HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER = 0.05
	SPRINT_ENEMIES_SPRINT_MODIFIER = 3
	
	#modifing shot delay for level variety
	spaceship.setShotDelay(SHOT_DELAY);
	spaceship.setSpeed(SPACESHIP_MOVEMENT_SPEED);
	spaceship.setHp(SPACESHIP_HP);
	
	for node in enemies.get_children():
		if node.is_in_group("JitterEnemies"):
			node.set_hp(3);
		elif node.is_in_group("ShootyEnemies"):
			node.set_hp(4)
			node.set_laser_speed(ENEMY_LASER_SPEED);
			node.get_node("ShotDelay").set_wait_time(ENEMY_SHOT_DELAY);
			print(node.get_node("ShotDelay").get_wait_time())
		elif node.is_in_group("MovingEnemies"):
			node.set_hp(4)
			node.set_speed(HORIZONTAL_MOVING_ENEMIES_SPEED);
			node.get_node("MoveDelay").set_wait_time(HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER);
		elif node.is_in_group("BuffyEnemies"):
			node.set_hp(10);
		else: node.set_hp(REGULAR_ENEMY_HP);
	print("done giving values")
	new_game()

func _on_reset_level_reset_level():
	get_tree().change_scene_to_file("res://scenes/levels/level_10.tscn");

func _on_open_new_level():
	LevelsUnlocked.make_level_available("Level11Button")
