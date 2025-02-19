extends "res://scripts/regular_enemy.gd"


#-----------CONST
var _SPEED: float

@onready var move_delay = $MoveDelay
@onready var ray_cast_left = $RayCastLEFT
@onready var ray_cast_right = $RayCastRIGHT

func _ready() -> void:
	SignalManager.connect_signal("stopEnemyMove",self,"stop_moving");

func set_speed(speed) -> void:
	_SPEED = speed

func _on_move_delay_timeout() -> void:
	var isLeftSafe = !ray_cast_left.is_colliding();
	var isRightSafe = !ray_cast_right.is_colliding();
	
	if (position.x < 100 || !isLeftSafe): _SPEED = abs(_SPEED)
	if (position.x > 1820 || !isRightSafe): _SPEED = -abs(_SPEED)
	
	if (
		(!isLeftSafe && !isRightSafe) || #if the spaceship will collide to other spaceships from both directions, only move forward
		#this next 2 conditions are for making the spaceship come in from the sides of the screen instead of just from the top
		(position.x < 0 && %Head.position.y + position.y < 0) || 
		(position.x > 1920 && %Head.position.y + position.y < 0)  
		): return
	else: position.x += _SPEED

func stop_moving(args):
	move_delay.stop()
