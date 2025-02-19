extends Node2D

@onready var spaceship = $Spaceship
@export var laser_scene: PackedScene;
@onready var enemy_move_timer = $EnemyMoveTimer
@onready var enemies = $Enemies
@onready var reset_level = $GUI/ResetLevel
@onready var go_to_level_selection = $GUI/GoToLevelSelection
@onready var victory_message = $GUI/VictoryMessage
@onready var start_level_button = $GUI/StartLevelButton
@onready var shield_downtime_timer = $ShieldDowntimeTimer
@onready var shield_uptime_timer = $ShieldUptimeTimer
@export var laser_collision_particles: PackedScene



signal openNewLevel

#-----------CONST
var LASER_SPEED: float;
var REGULAR_ENEMY_SPEED: float;
var START_POS: Vector2;
var SHOT_DELAY: float;
var REGULAR_ENEMY_HP: int;
var REGULAR_ENEMY_JITTER: Array;
var SPACESHIP_MOVEMENT_SPEED: int;
var SPACESHIP_HP: int
var ENEMY_LASER_SPEED: float;
var ENEMY_SHOT_DELAY: float;
var HORIZONTAL_MOVING_ENEMIES_SPEED: float;
var HORIZONTAL_MOVING_ENEMIES_DELAY_TIMER: float
var SPRINT_ENEMIES_SPRINT_MODIFIER: float
const GAME_X_BOUNDS: Array = [0,1920]

var game_alive: bool = false;
var enemy_speed_modifier: int = 1;

# Called when the node enters the scene tree for the first time.

func new_game() -> void:
	spaceship.position = START_POS
	game_alive = false;
	spaceship.visible = true
	await get_tree().create_timer(2).timeout;
	start_level_button.visible = true;
	
	
	# ----for tracking names of different enemies and their HP
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		var groupName: Array = enemy.get_groups()
		print("the enemy is:",groupName,"and their hp is:",enemy.get_hp());
	

func _on_start_level_button_start_game() -> void:
	game_start();

func game_start() -> void:
	game_alive = true;
	enemy_move_timer.start();
	
	#if level has an enemy shield mechanic flickering on and off, start it
	if shield_uptime_timer != null:
		#print("shield flickering started!") 
		shield_uptime_timer.start()
	
	#make the shooty spaceship enemies start shooting lasers
	for movingEnemies in get_tree().get_nodes_in_group("MovingEnemies"):
		movingEnemies.get_node("MoveDelay").start();

	#make the shooty spaceship enemies start shooting lasers
	for shootyEnemies in get_tree().get_nodes_in_group("ShootyEnemies"):
		shootyEnemies.get_node("ShotDelay").start();


var flag_for_unlock_level: bool = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if game_alive:
		#check inputs from user on spaceship
		spaceship.inputs(delta);
		#move every existing laser
		var Lasers = get_tree().get_nodes_in_group("Lasers");
		for i in Lasers:
			i.position.y -= LASER_SPEED;
			if i.position.y < 0: i.queue_free();
		var enemyLasers = get_tree().get_nodes_in_group("EnemyLasers")
		for laser in enemyLasers:
			laser.position.y += ENEMY_LASER_SPEED;
			if laser.position.y > laser.LASER_POS_SPAWN + laser.RANGE:
				laser.queue_free();
				laser.remove_from_group("EnemyLasers")

		if get_tree().get_nodes_in_group("Enemies").is_empty(): 
			go_to_level_selection.visible = true;
			victory_message.visible = true;
			if flag_for_unlock_level == true: openNewLevel.emit();
			flag_for_unlock_level = false;

func _on_spaceship_shoot() -> void:
	var laser := laser_scene.instantiate();
	laser.position = Vector2(spaceship.position.x,spaceship.position.y-20);
	add_child(laser)
	laser.add_to_group("Lasers");

func laser_colliding_with_enemy(args) -> void:
	var explosionPos = args[0]
	var particles = laser_collision_particles.instantiate()
	particles.position = explosionPos
	particles.emitting = true
	add_child(particles)

func _on_enemy_move_timer_timeout() -> void:
	var Enemies = get_tree().get_nodes_in_group("Enemies");
	#moving each enemy vertically. for some types of enemies, also do an action depending of the type
	for i in Enemies:
		if i.is_in_group("SprintEnemies") && i.position.y > 0: i.position.y += REGULAR_ENEMY_SPEED*enemy_speed_modifier*SPRINT_ENEMIES_SPRINT_MODIFIER;
		else: i.position.y += REGULAR_ENEMY_SPEED*enemy_speed_modifier;
		if i.is_in_group("JitterEnemies"):
			var isLeftSafe: bool 	= !(i.get_node("RayCastLEFT").is_colliding());
			var isRightSafe: bool = !(i.get_node("RayCastRIGHT").is_colliding());
			var isOutOfLeftBounds: bool = i.position.x < GAME_X_BOUNDS[0]+100
			var isOutOfRightBounds: bool = i.position.x > GAME_X_BOUNDS[1]-100
			#head of the spaceship (front)
			var headPos: float = i.get_node("Head").position.y + i.position.y
			
			#if the spaceship is too high for you to see, don't make it jitter
			if (headPos < 0): continue
			else:
				#jitter based on what's available, if out of screen horizontally, approach the screen
				if (!isLeftSafe || isOutOfLeftBounds):
					i.position.x += REGULAR_ENEMY_JITTER[1]
				elif (!isRightSafe || isOutOfRightBounds):
					i.position.x += REGULAR_ENEMY_JITTER[0]
				else: i.position.x += REGULAR_ENEMY_JITTER.pick_random();

func _on_change_enemy_speed_change_modifier(speed) -> void:
	enemy_speed_modifier = speed;

func _on_enemy_create_enemy_laser(laser) -> void:
	add_child(laser)
	laser.LASER_POS_SPAWN = laser.position.y

func _on_bottom_line_game_over() -> void:
	game_over();

func _on_spaceship_spaceship_dead() -> void:
	game_over();

signal stopEnemyShoot

func game_over() -> void:
	game_alive = false;
	enemy_move_timer.stop();
	reset_level.visible = true; 
	go_to_level_selection.visible = true;
	spaceship.visible = false
	SignalManager.emit_a_signal("stopEnemyShoot",[])
	SignalManager.emit_a_signal("stopEnemyMove",[])

func _on_shield_uptime_timer_timeout():
	shield_downtime_timer.start()
	for Shield in get_tree().get_nodes_in_group("EnemyShields"):
		Shield.visible = false;
		Shield.monitoring = false;

func _on_shield_downtime_timer_timeout():
	shield_uptime_timer.start()
	for Shield in get_tree().get_nodes_in_group("EnemyShields"):
		Shield.visible = true;
		Shield.monitoring = true;
