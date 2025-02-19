extends Area2D


#---------CONST
var FLY_SPEED: float = 200;
var SHOT_DELAY: float;
var HP: int = 3

@onready var hp_display = $HpDisplay
@onready var invincibility_timer = $InvincibilityTimer
@onready var shield = $Shield
@onready var hit_sfx = $HitSfx
@onready var laser_shoot_sfx = $LaserShootSfx
@export var death_sfx: PackedScene

var canBeHitAgain: bool = true;
var canShootAgain: bool = true;

signal shoot;
signal spaceshipDead;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_display.text = str(HP);

func setHp(health):
	HP = health;
	hp_display.text = str(HP);

func setShotDelay(time):
	SHOT_DELAY = time;

func setSpeed(speed):
	FLY_SPEED = speed

func play_death_sfx() -> void:
	var deathSfx: Object = death_sfx.instantiate()
	deathSfx.play()
	print("ffff")
	get_tree().current_scene.add_child(deathSfx)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func inputs(delta) -> void:
	if (Input.is_action_pressed("fly_left") and position.x >= 50):
		position.x -= FLY_SPEED*delta;
	if (Input.is_action_pressed("fly_right") and position.x <= 1870):
		position.x += FLY_SPEED*delta;
	if (Input.is_action_pressed("shoot") and canShootAgain):
		emit_signal("shoot")
		laser_shoot_sfx.play()
		canShootAgain = false;
		await get_tree().create_timer(SHOT_DELAY).timeout;
		canShootAgain = true;

#when the spaceship got hit, make it lose hp.
func _on_area_entered(area) -> void:
	if !canBeHitAgain:
		return
	if area.is_in_group("BuffyEnemies"):
		HP = 0;
		play_death_sfx()
		hp_display.text = str(HP);
		spaceshipDead.emit()
	if (area.is_in_group("Enemies") or area.is_in_group("BadLasers")) and not area.is_in_group("BuffyEnemies"):
		HP=HP-1
		hp_display.text = str(HP);
		canBeHitAgain = false;
		hit_sfx.play()
		invincibility_timer.start()
		shield.visible = true;
		area.queue_free();
		area.remove_from_group("BadLasers")
		if HP <= 0:
			spaceshipDead.emit()

func _on_invincibility_timer_timeout() -> void:
	shield.visible = false;
	canBeHitAgain = true;
	var checkOverlap = check_area_overlap();
	if checkOverlap == 1:
		HP-=1;
		hp_display.text = str(HP);
		canBeHitAgain = false;
		invincibility_timer.start()
		shield.visible = true;
		if HP <= 0:
			play_death_sfx()
			spaceshipDead.emit()
	elif checkOverlap == 2:
		HP = 0;
		hp_display.text = str(HP);
		play_death_sfx()
		spaceshipDead.emit()

#checks after invincibility frames are over if the spaceship is inside an enemy
func check_area_overlap() -> int:
	var dangers = get_tree().get_nodes_in_group("BadLasers") 
	dangers += get_tree().get_nodes_in_group("Enemies")
	
	for danger in dangers:
		if danger.overlaps_area(self) and danger.is_in_group("BuffyEnemies"):
			return 2;
		elif danger.overlaps_area(self):
			danger.queue_free()
			return 1;
	return 0;
