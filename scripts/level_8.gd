extends "res://scripts/level_skeleton.gd"

#-----------CONST
func _ready():
	
	SignalManager.connect_signal("laserCollisionParticles",self,"laser_colliding_with_enemy")
	
	LASER_SPEED = 12;
	REGULAR_ENEMY_SPEED = 11;
	START_POS = Vector2(960,600);
	SHOT_DELAY = 1;
	REGULAR_ENEMY_HP  = 1;
	SPACESHIP_MOVEMENT_SPEED = 600;
	SPACESHIP_HP = 4;
	ENEMY_LASER_SPEED = 12;
	REGULAR_ENEMY_JITTER = [-20,20]
	ENEMY_SHOT_DELAY = 1.75;
	HORIZONTAL_MOVING_ENEMIES_SPEED = 10;
	HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER = 0.05
	
	#modifing shot delay for level variety
	spaceship.setShotDelay(SHOT_DELAY);
	spaceship.setSpeed(SPACESHIP_MOVEMENT_SPEED);
	spaceship.setHp(SPACESHIP_HP);
	
	for node in enemies.get_children():
		node.set_hp(REGULAR_ENEMY_HP);
		if node.is_in_group("ShootyEnemies"):
			node.set_laser_speed(ENEMY_LASER_SPEED);
			node.get_node("ShotDelay").set_wait_time(ENEMY_SHOT_DELAY);
		elif node.is_in_group("MovingEnemies"):
			node.set_speed(HORIZONTAL_MOVING_ENEMIES_SPEED);
			node.get_node("MoveDelay").set_wait_time(HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER);
		elif node.is_in_group("BuffyEnemies"):
			node.set_hp(4);
	
	new_game()

func _on_reset_level_reset_level():
	get_tree().change_scene_to_file("res://scenes/levels/level_8.tscn");

func _on_open_new_level():
	LevelsUnlocked.make_level_available("Level9Button")
