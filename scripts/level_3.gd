extends "res://scripts/level_skeleton.gd"

#-----------CONST
func _ready():
	
	SignalManager.connect_signal("laserCollisionParticles",self,"laser_colliding_with_enemy")
	
	LASER_SPEED = 5;
	REGULAR_ENEMY_SPEED = 25;
	START_POS = Vector2(960,930);
	SHOT_DELAY = 0.25;
	REGULAR_ENEMY_HP  = 5;
	REGULAR_ENEMY_JITTER = [-40,40];
	SPACESHIP_MOVEMENT_SPEED = 450;
	
	#modifing shot delay for level variety
	spaceship.setShotDelay(SHOT_DELAY);
	spaceship.setSpeed(SPACESHIP_MOVEMENT_SPEED);
	
	for node in enemies.get_children():
		if node.is_in_group("JitterEnemies"):
			node.set_hp(3);
		elif node.is_in_group("BuffyEnemies"):
			node.set_hp(20);
		else: node.set_hp(REGULAR_ENEMY_HP);
	
	new_game()

func _on_reset_level_reset_level():
	get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn");

func _on_open_new_level():
	LevelsUnlocked.make_level_available("Level4Button")
