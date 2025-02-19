extends "res://scripts/regular_enemy.gd"


@export var enemy_laser: PackedScene


#-----------CONST
var ENEMY_LASER_SPEED: float;

@onready var shoot_point = $ShootPoint
@onready var shot_delay = $ShotDelay

signal create_enemy_laser


func _ready() -> void:
	SignalManager.connect_signal("stopEnemyShoot",self,"stop_shooting");

func set_laser_speed(speed):
	ENEMY_LASER_SPEED = speed;


#shooting a laser based on the shot delay
func _on_shot_delay_timeout() -> void:
	if (self.position.y > -1100):
		var newLaser = enemy_laser.instantiate()
		newLaser.position = shoot_point.position + self.position
		newLaser.add_to_group("EnemyLasers")
		create_enemy_laser.emit(newLaser);

func stop_shooting(args) -> void:
	print("stopped shooting")
	var shootyEnemies:= get_tree().get_nodes_in_group("ShootyEnemies")
	for shootyEnemy in shootyEnemies:
		shootyEnemy.shot_delay.stop()
