extends "res://scripts/level_skeleton.gd"

#-----------CONST
func _ready():
	
	SignalManager.connect_signal("laserCollisionParticles",self,"laser_colliding_with_enemy")
	
	LASER_SPEED = 7;
	REGULAR_ENEMY_SPEED = 8;
	START_POS = Vector2(960,930);
	SHOT_DELAY = 0.425;
	REGULAR_ENEMY_HP  = 3;
	SPACESHIP_MOVEMENT_SPEED = 400;
	SPACESHIP_HP = 8;
	ENEMY_LASER_SPEED = 8;
	REGULAR_ENEMY_JITTER = [-32,32]
	ENEMY_SHOT_DELAY = 1.75;
	HORIZONTAL_MOVING_ENEMIES_SPEED = 7;
	HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER = 0.05
	SPRINT_ENEMIES_SPRINT_MODIFIER = 2.25
	
	#modifing shot delay for level variety
	spaceship.setShotDelay(SHOT_DELAY);
	spaceship.setSpeed(SPACESHIP_MOVEMENT_SPEED);
	spaceship.setHp(SPACESHIP_HP);
	
	for node in enemies.get_children():
		if node.is_in_group("JitterEnemies"):
			node.set_hp(4);
		elif node.is_in_group("ShootyEnemies"):
			node.set_hp(REGULAR_ENEMY_HP)
			node.set_laser_speed(ENEMY_LASER_SPEED);
			node.get_node("ShotDelay").set_wait_time(ENEMY_SHOT_DELAY);
			print(node.get_node("ShotDelay").get_wait_time())
		elif node.is_in_group("MovingEnemies"):
			node.set_hp(5)
			node.set_speed(HORIZONTAL_MOVING_ENEMIES_SPEED);
			node.get_node("MoveDelay").set_wait_time(HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER);
		elif node.is_in_group("BuffyEnemies"):
			node.set_hp(17);
		elif node.is_in_group("SprintEnemies"):
			node.set_hp(5);
		else: node.set_hp(REGULAR_ENEMY_HP);
	print("done giving values")
	new_game()

func _on_reset_level_reset_level():
	get_tree().change_scene_to_file("res://scenes/levels/level_9.tscn");

func _on_open_new_level():
	LevelsUnlocked.make_level_available("Level10Button")
