extends "res://scripts/level_skeleton.gd"

#-----------CONST
func _ready():
	
	SignalManager.connect_signal("laserCollisionParticles",self,"laser_colliding_with_enemy")
	
	LASER_SPEED = 5;
	REGULAR_ENEMY_SPEED = 18.5;
	START_POS = Vector2(960,930);
	SHOT_DELAY = 0.3;
	REGULAR_ENEMY_HP  = 4;
	SPACESHIP_MOVEMENT_SPEED = 500;
	SPACESHIP_HP = 7;
	ENEMY_LASER_SPEED = 7;
	REGULAR_ENEMY_JITTER = [-30,30]
	ENEMY_SHOT_DELAY = 1.5;
	HORIZONTAL_MOVING_ENEMIES_SPEED = 8;
	HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER = 0.05
	
	#modifing shot delay for level variety
	spaceship.setShotDelay(SHOT_DELAY);
	spaceship.setSpeed(SPACESHIP_MOVEMENT_SPEED);
	spaceship.setHp(SPACESHIP_HP);
	
	for node in enemies.get_children():
		if node.is_in_group("JitterEnemies") :
			node.set_hp(6);
		elif node.is_in_group("ShootyEnemies"):
			node.set_laser_speed(ENEMY_LASER_SPEED);
			node.get_node("ShotDelay").set_wait_time(ENEMY_SHOT_DELAY);
			node.set_hp(6)
		elif node.is_in_group("MovingEnemies"):
			node.set_speed(HORIZONTAL_MOVING_ENEMIES_SPEED);
			node.get_node("MoveDelay").set_wait_time(HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER);
			node.set_hp(6)
		elif node.is_in_group("BuffyEnemies"):
			node.set_hp(15);
		else: node.set_hp(REGULAR_ENEMY_HP);
	

	new_game()

func _on_reset_level_reset_level():
	get_tree().change_scene_to_file("res://scenes/levels/level_7.tscn");

func _on_open_new_level():
	LevelsUnlocked.make_level_available("Level8Button")
