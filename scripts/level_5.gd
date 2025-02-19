extends "res://scripts/level_skeleton.gd"

#-----------CONST
func _ready():
	
	SignalManager.connect_signal("laserCollisionParticles",self,"laser_colliding_with_enemy")
	
	LASER_SPEED = 8;
	REGULAR_ENEMY_SPEED = 25;
	START_POS = Vector2(960,630);
	SHOT_DELAY = 0.2;
	REGULAR_ENEMY_HP  = 2;
	SPACESHIP_MOVEMENT_SPEED = 600;
	SPACESHIP_HP = 10;
	ENEMY_LASER_SPEED = 5;
	REGULAR_ENEMY_JITTER = [-20,20]
	ENEMY_SHOT_DELAY = 3;
	
	#modifing shot delay for level variety
	spaceship.setShotDelay(SHOT_DELAY);
	spaceship.setSpeed(SPACESHIP_MOVEMENT_SPEED);
	spaceship.setHp(SPACESHIP_HP);
	
	for node in enemies.get_children():
		if node.is_in_group("ShootyEnemies"):
			node.set_laser_speed(ENEMY_LASER_SPEED);
			node.set_hp(3);
			node.get_node("ShotDelay").set_wait_time(ENEMY_SHOT_DELAY);
		elif node.is_in_group("BuffyEnemies"):
			node.set_hp(15);
		else: node.set_hp(REGULAR_ENEMY_HP);
	
	new_game()

func _on_reset_level_reset_level():
	get_tree().change_scene_to_file("res://scenes/levels/level_5.tscn");

func _on_open_new_level():
	LevelsUnlocked.make_level_available("Level6Button")



